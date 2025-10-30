package com.safeone.dashboard.config.component;

import java.io.InputStream;
import java.net.URI;
import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.util.MultiValueMap;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.BinaryWebSocketHandler;
import org.springframework.web.util.UriComponentsBuilder;

/**
 * CCTV RTSP 스트리밍 핸들러
 * WebSocket으로 브라우저와 연결되어 ffmpeg로 MJPEG 스트림을 전송함.
 */
public class VideoStreamingHandler extends BinaryWebSocketHandler {
    private final Map<String, StreamThread> streamThreads = new ConcurrentHashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        URI uri = session.getUri();
        MultiValueMap<String, String> parameters = UriComponentsBuilder.fromUri(uri).build().getQueryParams();
        String url = parameters.getFirst("url");

        StreamThread streamThread = new StreamThread(session, url);
        streamThreads.put(session.getId(), streamThread);
        streamThread.start();

        System.out.println("✅ Stream started for session: " + session.getId() + " → " + url);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        StreamThread streamThread = streamThreads.remove(session.getId());
        if (streamThread != null) {
            streamThread.interrupt();
            System.out.println("⚠️ Stream closed for session: " + session.getId());
        }
    }

    private static class StreamThread extends Thread {
        private final WebSocketSession session;
        private final String rtspUrl;

        public StreamThread(WebSocketSession session, String rtspUrl) {
            this.session = session;
            this.rtspUrl = rtspUrl;
        }

        @Override
        public void run() {
            Process process = null;
            try {
                // ffmpeg 실행 명령
                ProcessBuilder pb = new ProcessBuilder(
                        "ffmpeg",
                        "-rtsp_transport", "tcp",
                        "-i", rtspUrl,
                        "-f", "mjpeg",
                        "-q:v", "5",
                        "pipe:1"
                );
                pb.redirectErrorStream(true); // 표준 에러를 합쳐 로그 확인 가능하게

                process = pb.start();
                InputStream in = process.getInputStream();

                byte[] buffer = new byte[4096];
                int len;
                while ((len = in.read(buffer)) != -1 && session.isOpen()) {
                    // 브라우저로 MJPEG 바이너리 프레임 전송
                    session.sendMessage(new BinaryMessage(Arrays.copyOf(buffer, len)));
                }

                System.out.println("🧩 Stream thread ended normally for session: " + session.getId());
            } catch (Exception e) {
                System.err.println("❌ Stream error: " + e.getMessage());
            } finally {
                if (process != null) {
                    process.destroy();
                }
                if (session.isOpen()) {
                    try {
                        session.close();
                    } catch (Exception ignore) {}
                }
            }
        }
    }
}