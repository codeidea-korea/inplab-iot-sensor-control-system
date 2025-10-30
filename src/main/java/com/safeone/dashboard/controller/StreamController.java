package com.safeone.dashboard.controller;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.OutputStream;
import java.util.concurrent.CompletionException;
import java.util.concurrent.atomic.AtomicBoolean;

import javax.servlet.http.HttpServletResponse;

import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.ffmpeg.global.avutil;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegFrameRecorder;
import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.FrameGrabber;
import org.bytedeco.javacv.FrameRecorder;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyEmitter;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

import com.github.kokorin.jaffree.ffmpeg.FFmpeg;
import com.github.kokorin.jaffree.ffmpeg.PipeOutput;
import com.safeone.dashboard.config.annotate.NoLoginCheck;

@RestController
@RequestMapping("/video")
public class StreamController {    
    @NoLoginCheck
    @GetMapping(value = "/ts")
    public ResponseBodyEmitter ts(@RequestParam String url, HttpServletResponse response) {
        final ResponseBodyEmitter emitter = new ResponseBodyEmitter();

        // 비동기 작업 시작
        new Thread(() -> {
            FFmpegFrameGrabber grabber = null;
            try {
                response.setContentType("video/mp2t");

                grabber = new FFmpegFrameGrabber(url);
                // grabber 설정...
                grabber.startUnsafe();

                Frame frame;
                while ((frame = grabber.grabImage()) != null) {
                    try {
                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        FFmpegFrameRecorder recorder = new FFmpegFrameRecorder(baos, grabber.getImageWidth(), grabber.getImageHeight());
                        recorder.setFormat("mpegts");
                        recorder.startUnsafe();

                        recorder.record(frame);
                        recorder.stop();
                        recorder.release();

                        byte[] videoBytes = baos.toByteArray();
                        emitter.send(videoBytes, MediaType.valueOf("video/mp2t"));
                    } catch (Exception e) {
                        emitter.completeWithError(e);
                        break;
                    }
                }
            } catch (Exception e) {
                emitter.completeWithError(e);
            } finally {
                try {
                    if (grabber != null) {
                        grabber.stop();
                        grabber.release();
                    }
                } catch (Exception e) {
                    // 로깅 또는 추가 에러 처리
                }
                emitter.complete();
            }
        }).start();

        return emitter;
    }

    @NoLoginCheck
    @GetMapping(value = "/proxy")
    public StreamingResponseBody proxyTs(@RequestParam String url, HttpServletResponse response) throws Exception {
        response.setContentType("video/mp2t"); 
        // response.setContentType("application/octet-stream");
        AtomicBoolean clientConnected = new AtomicBoolean(true);
        return outputStream -> {
            FFmpegFrameGrabber grabber = null;
            FFmpegFrameRecorder recorder = null;
            try {
                grabber = new FFmpegFrameGrabber(url);
                // grabber.setOption("stimeout", "2000000");
                grabber.setImageWidth(720);
                grabber.setImageHeight(480);
                grabber.setOption("buffer_size", "5000000"); // 예: 1MB
                grabber.setOption("rtsp_transport", "tcp");
                grabber.setOption("re", "1");
                grabber.setOption("color_range", "0");
                grabber.setAudioChannels(0);
                grabber.setOption("an", "1");
                grabber.setOption("err_detect", "ignore_err");
                grabber.startUnsafe();

                recorder = new FFmpegFrameRecorder(outputStream, grabber.getImageWidth(), grabber.getImageHeight());
                recorder.setFormat("mpegts");
                recorder.startUnsafe();

                Frame frame;
                while ((frame = grabber.grabImage()) != null && clientConnected.get()) {
                    try {
                        recorder.record(frame); // 필터링된 프레임을 레코더에 기록
                    } catch (Exception e) {
                        clientConnected.set(false);
                        System.out.println("Client connection might have been closed: " + e.getMessage());
                        break; // OutputStream에 쓰기 작업 중 예외가 발생하면 클라이언트 연결이 끊긴 것으로 판단
                    }
                }

            } catch (FFmpegFrameGrabber.Exception e) {
                e.printStackTrace();
            } catch (Exception e) {
                clientConnected.set(false);
                throw new CompletionException(e);
            } finally {
                try {
                    if (grabber != null) grabber.stop();
                } catch(Exception e) {
                    e.printStackTrace();
                }
                try {
                    if (grabber != null) grabber.release();
                } catch(Exception e) {
                    e.printStackTrace();
                }
                try {
                    if (recorder != null) recorder.stop();
                } catch(Exception e) {
                    e.printStackTrace();
                }
                try {
                    if (recorder != null) recorder.release();
                } catch(Exception e) {
                    e.printStackTrace();
                }

                outputStream.flush();
            }
            
        };
    }

    @NoLoginCheck
    @GetMapping(value = "/proxy2")
    public ResponseEntity<StreamingResponseBody> livestreamproxy2(@RequestParam String url) throws Exception {
        return ResponseEntity.ok()
            .header("Connection", "keep-alive")
            .contentType(MediaType.valueOf("video/mp2t"))
            .body(os -> {
                try (BufferedOutputStream bufferedOs = new BufferedOutputStream(os)) {
                    // getFFMpegOutput(url, bufferedOs);
                    getFFMpegOutputWithJavaCV(url, bufferedOs);
                }
                // getFFMpegOutput(url, os);
            });
    }

    private static void getFFMpegOutputWithJavaCV(String rtspUrl, OutputStream os) {
        FFmpegFrameGrabber grabber = null;
        FFmpegFrameRecorder recorder = null;
        avutil.av_log_set_level(16);
        System.out.println("FrameGrabber start !!!!!!!!!!!!!!!!!!!!");
        try {
            grabber = new FFmpegFrameGrabber(rtspUrl);
            grabber.setOption("rtsp_transport", "tcp");
            // grabber.setVideoBitrate(10000000);
            // grabber.setVideoCodecName("copy");   
            grabber.setOption("buffer_size", "15000000"); // 예: 1MB
            grabber.setOption("re", "10");
            grabber.setVideoCodec(avcodec.AV_CODEC_ID_H264);
            grabber.setPixelFormat(avutil.AV_PIX_FMT_YUV420P);
            grabber.setAudioChannels(0); // Disable audio
            grabber.setImageWidth(1920 / 2);
            grabber.setImageHeight(1080 / 2);
            // FrameGrabber.ImageMode imageMode = FrameGrabber.ImageMode.COLOR;
            // grabber.setImageMode(imageMode);
            grabber.startUnsafe();
            
            System.out.println("FrameRecorder start !!!!!!!!!!!!!!!!!!!!");
            recorder = new FFmpegFrameRecorder(os, grabber.getImageWidth(), grabber.getImageHeight());
            recorder.setAudioCodec(0);
            recorder.setInterleaved(true);
            recorder.setVideoOption("preset", "ultrafast");
            recorder.setVideoOption("tune", "zerolatency");
            // recorder.setVideoBitrate(grabber.getVideoBitrate());
            recorder.setPixelFormat(avutil.AV_PIX_FMT_YUV420P);
            recorder.setFormat("mpegts");
            // recorder.setMaxDelay(100);            
            recorder.startUnsafe();
            
            Frame frame;
            while ((frame = grabber.grab()) != null) {
                recorder.record(frame);
            }

        } catch (FrameGrabber.Exception e) {
            System.out.println("FrameGrabber.Exception !!!!!!!!!!!!!!!!!!!!");
            e.printStackTrace();
        } catch (FrameRecorder.Exception e) {
            System.out.println("FrameRecorder.Exception !!!!!!!!!!!!!!!!!!!!");
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            try {
                recorder.stop();
            } catch (org.bytedeco.javacv.FFmpegFrameRecorder.Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            try {
                grabber.stop();
            } catch (org.bytedeco.javacv.FFmpegFrameGrabber.Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            try {
                grabber.release();
            } catch (org.bytedeco.javacv.FFmpegFrameGrabber.Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            try {
                recorder.release();
            } catch (org.bytedeco.javacv.FFmpegFrameRecorder.Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }            
        
    }

    private static void getFFMpegOutput(String url, OutputStream os) {
        FFmpeg.atPath()
            // .addArgument("-re")
            .addArgument("-y")
            .addArguments("-correct_ts_overflow", "0")
            .addArguments("-rtsp_transport", "tcp")
            .addArguments("-i", url)
            .addArguments("-vcodec", "libx264")
            .addArguments("-pix_fmt", "yuvj420p")
            .addArgument("-an")
            .addArguments("-min_delay", "0")
            .addArguments("-max_delay", "10")
            .addArguments("-movflags", "faststart")
            .addArguments("-b:v", "4M")
            .addOutput(PipeOutput.pumpTo(os).setFormat("mjpeg"))
            .addArgument("-nostdin")
            .setOverwriteOutput(true)
            .execute();
    }    
}
