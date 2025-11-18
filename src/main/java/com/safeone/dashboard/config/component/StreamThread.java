package com.safeone.dashboard.config.component;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import javax.imageio.ImageIO;

import org.bytedeco.ffmpeg.global.avutil;
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

    public StreamThread(WebSocketSession session, String url) {
        this.session = session;
        this.rawUrl = url;
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

        System.out.println("[StreamThread] Start stream for: " + url);

        try (FFmpegFrameGrabber grabber = new FFmpegFrameGrabber(url)) {
            grabber.setOption("rtsp_transport", "tcp");
            grabber.setOption("stimeout", "8000000"); // 8초 타임아웃
            grabber.setOption("fflags", "nobuffer");
            grabber.setOption("flags", "low_delay");
            grabber.setOption("an", "1"); // 오디오 비활성화
            grabber.setOption("rw_timeout", "8000000");

            // grabber.setVideoCodec(avcodec.AV_CODEC_ID_H264);
            // grabber.setPixelFormat(avutil.AV_PIX_FMT_YUV420P);

            System.out.println("[StreamThread] Trying to connect...");
            grabber.start();
            System.out.println("[StreamThread] Stream started successfully: "
                    + grabber.getImageWidth() + "x" + grabber.getImageHeight());

            int frameCount = 0;
            int emptyFrameCount = 0;

            while (session.isOpen() && !Thread.currentThread().isInterrupted()) {
                Frame frame = grabber.grabImage();

                if (frame == null) {
                    emptyFrameCount++;
                    if (emptyFrameCount % 60 == 0) {
                        System.out.println("[StreamThread] No frame received (" + emptyFrameCount + " frames skipped)");
                    }
                    continue;
                }

                BufferedImage image = converter.getBufferedImage(frame);
                if (image != null) {
                    frameCount++;
                    if (frameCount % 30 == 0) {
                        System.out.println("[StreamThread] Sending frame #" + frameCount);
                    }

                    try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                        ImageIO.write(image, "jpeg", baos);
                        baos.flush();
                        session.sendMessage(new BinaryMessage(baos.toByteArray()));
                    }
                }

                // CPU 과부하 방지
                Thread.sleep(33); // 약 30fps
            }

            grabber.stop();
            converter.close();
            System.out.println("[StreamThread] Stream stopped normally.");

        } catch (org.bytedeco.javacv.FrameGrabber.Exception e) {
            System.err.println("[StreamThread] FFmpeg grabber error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("[StreamThread] Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}