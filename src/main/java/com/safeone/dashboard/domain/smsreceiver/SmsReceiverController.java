package com.safeone.dashboard.domain.smsreceiver;

import com.safeone.dashboard.domain.smsreceiver.dto.SmsReceiverCreate;
import com.safeone.dashboard.domain.smsreceiver.dto.SmsReceiverUpdate;
import com.safeone.dashboard.domain.smsreceiver.service.SmsReceiverService;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;

@RestController
@RequestMapping("/api/sms-receivers")
@RequiredArgsConstructor
public class SmsReceiverController {

    private final SmsReceiverService smsReceiverService;

    @PostMapping
    public ResponseEntity<?> create(@RequestBody SmsReceiverCreate smsReceiverCreate) {
        try {
            smsReceiverService.create(smsReceiverCreate);
            return ResponseEntity.ok().build();
        } catch (DuplicateKeyException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Collections.singletonMap("message", "동일한 현장/휴대폰 번호가 이미 존재합니다."));
        }
    }

    @PutMapping("/{mgntNo}")
    public ResponseEntity<?> update(@PathVariable String mgntNo, @RequestBody SmsReceiverUpdate smsReceiverUpdate) {
        try {
            smsReceiverUpdate.setMgntNo(mgntNo);
            smsReceiverService.update(smsReceiverUpdate);
            return ResponseEntity.ok().build();
        } catch (DuplicateKeyException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Collections.singletonMap("message", "동일한 현장/휴대폰 번호가 이미 존재합니다."));
        }
    }

    @DeleteMapping("/{mgntNo}")
    public void delete(@PathVariable String mgntNo) {
        smsReceiverService.delete(mgntNo);
    }

}
