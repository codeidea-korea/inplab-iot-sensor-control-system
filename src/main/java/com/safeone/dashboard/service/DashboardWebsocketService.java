package com.safeone.dashboard.service;

import java.util.ArrayList;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
@ServerEndpoint(value="/dashboard")
public class DashboardWebsocketService {
    
    private static ArrayList<Session> sessionList = new ArrayList<Session>();

    @OnMessage
	public void onMessage(String msg, Session session) throws Exception{
		// 클라이언트로 부터 메세지가 들어온경우
	}
	
	@OnOpen
	public void onOpen(Session session) {

		if (session != null) {
            String sessionId = session.getId();
            
            System.out.println("client is connected. sessionId == [" + sessionId + "]");
            sessionList.add(session);
            
            // 웹소켓 연결 성립되어 있는 모든 사용자에게 메시지 전송
            // sendMessageToAll(“***** [USER-“ + sessionId + “] is connected. *****”);
        }
	}
	
	@OnClose
	public void onClose(Session session) {
		if (session != null) {
            String sessionId = session.getId();
            System.out.println("client is disconnected. sessionId == [" + sessionId + "]");

            sessionList.remove(session);
            
            // 웹소켓 연결 성립되어 있는 모든 사용자에게 메시지 전송
            // sendMessageToAll(“***** [USER-“ + sessionId + “] is disconnected. *****”);
        }
	}

    public boolean sendMessageToAll(Object message) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            return sendMessageToAll(mapper.writeValueAsString(message));
        } catch (JsonProcessingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return false;
        }
    }

	public boolean sendMessageToAll(String message) {
        if (sessionList == null) {
            return false;
        }

        int sessionCount = sessionList.size();
        if (sessionCount < 1) {
            return false;
        }

        Session singleSession = null;

        for (int i = 0; i < sessionCount; i++) {
            singleSession = sessionList.get(i);
            if (singleSession == null) {
                continue;
            }

            if (!singleSession.isOpen()) {
                continue;
            }

            sessionList.get(i).getAsyncRemote().sendText(message);
        }

        return true;
    }
}
