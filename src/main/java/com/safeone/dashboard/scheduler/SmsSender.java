package com.safeone.dashboard.scheduler;

import com.safeone.dashboard.service.SmsSenderService;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class SmsSender {

    private final SmsSenderService service;
    private static final int SMS_SEND_TERM_MINUTE = 5;

    // 5분마다 실행
    @Scheduled(fixedRate = 1000 * 60 * SMS_SEND_TERM_MINUTE)
//    @Scheduled(fixedRate = 4000)
    public void logMessage() {
        service.run();
    }

}
