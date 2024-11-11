package com.safeone.dashboard.scheduler;

import com.safeone.dashboard.service.SmsSenderService;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class SmsSender {

    private final SmsSenderService service;

//    @Scheduled(fixedRate = 1000 * 60 * 60) // 5초마다 실행
    public void logMessage() {
        service.run();
    }

}
