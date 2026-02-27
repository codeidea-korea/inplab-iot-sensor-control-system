package com.safeone.dashboard.scheduler;

import com.safeone.dashboard.dao.CctvMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.core.env.Environment;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class CctvRtspStatusScheduler {
    private final CctvMapper cctvMapper;
    private final Environment env;

    private static final long DELAY_MS = 5 * 60 * 1000; // 5분
    private static final int CONNECT_TIMEOUT_MS = 1500;

    @Scheduled(fixedDelay = DELAY_MS)
    public void updateRtspConnStatus() {
        if ("true".equalsIgnoreCase(env.getProperty("dev"))) {
            return;
        }

        List<HashMap<String, Object>> list = cctvMapper.getCctvRtspCheckList(new HashMap<>());
        for (Map<String, Object> row : list) {
            String cctvNo = str(row.get("cctv_no"));
            String ip = str(row.get("cctv_ip"));
            String portStr = str(row.get("rtsp_port"));
            String id = str(row.get("cctv_conn_id"));
            String pwd = str(row.get("cctv_conn_pwd"));

            String connYn = isReachable(ip, portStr, id, pwd) ? "Y" : "N";
            Map<String, Object> param = new HashMap<>();
            param.put("cctv_no", cctvNo);
            param.put("rtsp_conn_yn", connYn);
            cctvMapper.udtRtspConnStatus(param);
        }
    }

    private boolean isReachable(String ip, String portStr, String id, String pwd) {
        if (isBlank(ip) || isBlank(portStr) || isBlank(id) || isBlank(pwd)) return false;

        int port;
        try {
            port = Integer.parseInt(portStr);
        } catch (NumberFormatException e) {
            return false;
        }

        try (Socket socket = new Socket()) {
            socket.connect(new InetSocketAddress(ip, port), CONNECT_TIMEOUT_MS);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private static String str(Object value) {
        return value == null ? "" : String.valueOf(value).trim();
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
