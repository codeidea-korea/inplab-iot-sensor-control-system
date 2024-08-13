package com.safeone.dashboard.scheduler;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.data.redis.core.ListOperations;
import org.springframework.stereotype.Component;

import com.safeone.dashboard.service.DashboardService;
import com.safeone.dashboard.service.DashboardWebsocketService;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class DashboardScheduler {
    @Resource(name = "redisTemplate") 
    private ListOperations<String, Object> listOpCollect;

    private final DashboardService dashboardService;    
    private final DashboardWebsocketService dashboardWebsocketService;    
    private static String lastCollectTime = null;

    // @Scheduled(fixedDelayString = "1000")
    public void dashboardScheduler() {
        Map param = new HashMap();
        param.put("cdate", lastCollectTime);
        List<Map> result = dashboardService.selectDashboardData(param);

        for (Map row: result) {
            try {
                lastCollectTime = row.get("_cdate").toString();

                dashboardWebsocketService.sendMessageToAll(row);
            } catch(Exception e) {
                e.printStackTrace();
            }
        }        
    }
}
