package com.safeone.dashboard.config.component;

import java.net.URI;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.util.MultiValueMap;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.BinaryWebSocketHandler;
import org.springframework.web.util.UriComponentsBuilder;

/**
 * CCTV RTSP 스트리밍 핸들러
 * WebSocket으로 브라우저와 연결되어 JavaCV로 RTSP 스트림을 JPEG 프레임으로 전송함.
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
}