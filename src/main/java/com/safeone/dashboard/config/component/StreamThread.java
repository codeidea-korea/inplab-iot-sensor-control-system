package com.safeone.dashboard.config.component;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import javax.imageio.ImageIO;

import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegLogCallback;
import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.Java2DFrameConverter;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.WebSocketSession;

public class StreamThread extends Thread {
    private final WebSocketSession session;
    private final String rawUrl;
    private final Java2DFrameConverter converter = new Java2DFrameConverter();
    private volatile boolean running = true;
    private volatile FFmpegFrameGrabber grabber;

    public StreamThread(WebSocketSession session, String url) {
        this.session = session;
        this.rawUrl = url;
    }

    public void shutdown() {
        running = false;
        interrupt();

        FFmpegFrameGrabber localGrabber = this.grabber;
        if (localGrabber != null) {
            try {
                localGrabber.stop();
            } catch (Exception ignored) {
            }
            try {
                localGrabber.release();
            } catch (Exception ignored) {
            }
        }
    }

    @Override
    public void run() {
        FFmpegLogCallback.set();
        String url;

        try {
            url = URLDecoder.decode(rawUrl, StandardCharsets.UTF_8.name());
        } catch (Exception e) {
            throw new RuntimeException("URL decoding failed", e);
        }

        try (FFmpegFrameGrabber localGrabber = new FFmpegFrameGrabber(url)) {
            this.grabber = localGrabber;

            localGrabber.setOption("rtsp_transport", "tcp");
            localGrabber.setOption("stimeout", "8000000");
            localGrabber.setOption("fflags", "nobuffer");
            localGrabber.setOption("flags", "low_delay");
            localGrabber.setOption("an", "1");
            localGrabber.setOption("rw_timeout", "8000000");

            localGrabber.start();

            // 초기 RTSP 버퍼 드레인 - 버퍼된 과거 프레임 제거
            long drainStart = System.currentTimeMillis();
            while (running && session.isOpen() && System.currentTimeMillis() - drainStart < 2000) {
                long t = System.currentTimeMillis();
                Frame drainFrame = localGrabber.grabImage();
                long elapsed = System.currentTimeMillis() - t;

                if (drainFrame == null) break;
                if (elapsed > 30) break;
            }

            long lastSendTime = 0;
            final long MIN_FRAME_INTERVAL = 100;

            while (running && session.isOpen() && !Thread.currentThread().isInterrupted()) {
                Frame frame = localGrabber.grabImage();

                if (frame == null) {
                    Thread.sleep(10);
                    continue;
                }

                long now = System.currentTimeMillis();
                if (now - lastSendTime < MIN_FRAME_INTERVAL) {
                    continue;
                }

                BufferedImage image = converter.getBufferedImage(frame);
                if (image != null) {
                    try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                        ImageIO.write(image, "jpeg", baos);
                        baos.flush();
                        session.sendMessage(new BinaryMessage(baos.toByteArray()));
                        lastSendTime = System.currentTimeMillis();
                    }
                }
            }
        } catch (InterruptedException ie) {
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            this.grabber = null;
            try {
                converter.close();
            } catch (Exception ignored) {
            }
        }
    }
}
