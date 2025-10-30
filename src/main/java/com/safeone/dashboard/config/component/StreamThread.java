//package com.safeone.dashboard.config.component;
//
//import java.awt.image.BufferedImage;
//import java.io.ByteArrayOutputStream;
//
//import javax.imageio.ImageIO;
//
//import org.bytedeco.ffmpeg.global.avcodec;
//import org.bytedeco.javacv.FFmpegFrameGrabber;
//import org.bytedeco.javacv.FFmpegLogCallback;
//import org.bytedeco.javacv.Frame;
//import org.bytedeco.javacv.Java2DFrameConverter;
//import org.springframework.web.socket.BinaryMessage;
//import org.springframework.web.socket.WebSocketSession;
//
//public class StreamThread extends Thread {
//    private final WebSocketSession session;
//    private final String url;
//    private final Java2DFrameConverter converter = new Java2DFrameConverter();
//
//    public StreamThread(WebSocketSession session, String url) {
//        this.session = session;
//        this.url = url;
//    }
//
//    @Override
//    public void run() {
//        FFmpegLogCallback.set();
//
//        FFmpegFrameGrabber grabber = new FFmpegFrameGrabber(url);
//
//        try {
//            // grabber.setOption("rtsp_transport", "tcp");
//            grabber.setAudioChannels(0);
//            // grabber.setOption("stimeout", "5000000");
//            grabber.setVideoCodec(avcodec.AV_CODEC_ID_H264);
//            // grabber.setVideoCodecName("copy");
//            // grabber.setPixelFormat(avutil.AV_PIX_FMT_YUVJ420P);
//            grabber.setFormat("rtsp");
//            grabber.setVideoCodec(avcodec.AV_CODEC_ID_MPEG4);
//            grabber.setImageWidth(1920 / 2);
//            grabber.setImageHeight(1080 / 2);
//            grabber.setMaxDelay(100);
//            grabber.setOption("bufsize", "1024k");
//            grabber.setOption("an", "1");
//            grabber.startUnsafe();
//
//            int skipNextFrame = 0;
//
//            System.out.println("stream start !!!!!!!!!!!!!!!!!!!!!!! \n");
//
//            while (session.isOpen() && !Thread.currentThread().isInterrupted()) {
//                Frame frame = grabber.grab();
//                if (frame == null) {
//                    System.out.println("Grabber no frame !!!!!!!!!!!!!!!!!!!!!!! \n");
//                    break;
//                }
//                BufferedImage bufferedImage = converter.getBufferedImage(frame);
//
//                if (bufferedImage != null) {
//                    if (skipNextFrame >= 2) {
//                        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
//                        ImageIO.write(bufferedImage, "jpg", byteArrayOutputStream);
//                        try {
//                            session.sendMessage(new BinaryMessage(byteArrayOutputStream.toByteArray()));
//                        } catch(Exception e) {
//
//                        }
//                        skipNextFrame = 0;
//                    }
//
//                    skipNextFrame++;
//                }
//            }
//
//            System.out.println("Grabber stop !!!!!!!!!!!!!!!!!!!!!!! \n");
//            grabber.close();
//            grabber.releaseUnsafe();
//            converter.close();
//        } catch(Exception e) {
//            e.printStackTrace();
//        }
//
//        // try (FFmpegFrameGrabber grabber = new FFmpegFrameGrabber(url)) {
//        //     grabber.start();
//
//        //     while (session.isOpen() && !Thread.currentThread().isInterrupted()) {
//        //         Frame frame = grabber.grab();
//        //         if (frame == null) {
//        //             System.out.println("Grabber no frame !!!!!!!!!!!!!!!!!!!!!!! \n");
//        //             break;
//        //         }
//
//        //         BufferedImage bufferedImage = converter.getBufferedImage(frame);
//        //         if (bufferedImage != null) {
//        //             ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
//        //             ImageIO.write(bufferedImage, "jpg", byteArrayOutputStream);
//        //             byte[] imageBytes = byteArrayOutputStream.toByteArray();
//
//        //             session.sendMessage(new BinaryMessage(imageBytes));
//        //             byteArrayOutputStream.close();  // 메모리 관리를 위해 스트림을 닫습니다.
//        //         }
//
//        //         // 프레임 레이트를 조절하기 위한 지연
//        //         Thread.sleep(40);  // 대략 25fps. 필요에 따라 조절 가능
//        //     }
//        // } catch (Exception e) {
//        //     System.out.println("Exception in streaming thread: " + e.getMessage());
//        //     // 예외 처리 로직 추가
//        // }
//    }
//}

package com.safeone.dashboard.config.component;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import javax.imageio.ImageIO;

import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegLogCallback;
import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.Java2DFrameConverter;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.WebSocketSession;
import org.bytedeco.ffmpeg.global.avutil;

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

        // 🔹 URLDecoder로 인코딩된 RTSP URL 복원 (ws://...?url=rtsp%3A%2F%2F... 대응)
        String url = URLDecoder.decode(rawUrl, StandardCharsets.UTF_8);
        System.out.println("[StreamThread] Decoded RTSP URL: " + url);

        try (FFmpegFrameGrabber grabber = new FFmpegFrameGrabber(url)) {
            // 안정적인 RTSP 연결 옵션
            grabber.setOption("rtsp_transport", "tcp");
            grabber.setOption("stimeout", "5000000"); // 5초 타임아웃
            grabber.setOption("bufsize", "1024k");
            grabber.setOption("fflags", "nobuffer");
            grabber.setOption("flags", "low_delay");
            grabber.setOption("an", "1"); // 오디오 비활성화
            grabber.setOption("max_delay", "0");

            grabber.setVideoCodec(avcodec.AV_CODEC_ID_H264); // 🔹 실제 스트림 코덱에 맞춤
            grabber.setImageWidth(960);
            grabber.setImageHeight(540);
            grabber.setPixelFormat(avutil.AV_PIX_FMT_YUV420P);

            grabber.start(); // ✅ 안전한 start()
            System.out.println("[StreamThread] Stream started successfully.");

            int frameCount = 0;

            while (session.isOpen() && !Thread.currentThread().isInterrupted()) {
                Frame frame = grabber.grabImage();
                if (frame == null) {
                    System.out.println("[StreamThread] No frame received.");
                    continue;
                }

                BufferedImage image = converter.getBufferedImage(frame);
                if (image != null) {
                    frameCount++;
                    // FPS 줄이기 (매 2~3프레임마다 송출)
                    if (frameCount % 3 == 0) {
                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        ImageIO.write(image, "jpeg", baos);
                        baos.flush();
                        session.sendMessage(new BinaryMessage(baos.toByteArray()));
                        baos.close();
                    }
                }

                // CPU 과부하 방지용 sleep (프레임레이트 조정)
                Thread.sleep(33); // 약 30fps
            }

            grabber.stop();
            converter.close();
            System.out.println("[StreamThread] Stream stopped normally.");

        } catch (Exception e) {
            System.err.println("[StreamThread] Exception: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
