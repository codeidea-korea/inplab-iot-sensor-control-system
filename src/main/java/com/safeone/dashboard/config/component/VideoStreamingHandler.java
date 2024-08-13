package com.safeone.dashboard.config.component;

import java.net.URI;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.util.MultiValueMap;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.web.util.UriComponentsBuilder;

public class VideoStreamingHandler extends TextWebSocketHandler {
    private final Map<String, StreamThread> streamThreads = new ConcurrentHashMap<>();

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        StreamThread streamThread = streamThreads.remove(session.getId());
        if (streamThread != null) {
            streamThread.interrupt();
            System.out.println("Stream closed for session: " + session.getId());
        }
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        if (payload.contains("close")) {
            StreamThread streamThread = streamThreads.remove(session.getId());
            if (streamThread != null) {
                streamThread.interrupt();
                System.out.println("Close stream event received for session: " + session.getId());
            }
            session.close(CloseStatus.NORMAL);            
        }
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        URI uri = session.getUri();
        MultiValueMap<String, String> parameters = UriComponentsBuilder.fromUri(uri).build().getQueryParams();
        String url = parameters.getFirst("url");

        StreamThread streamThread = new StreamThread(session, url);
        streamThreads.put(session.getId(), streamThread);
        streamThread.start();

        System.out.println("Stream started for session: " + session.getId());
    }
}