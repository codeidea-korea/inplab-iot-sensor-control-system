package com.safeone.dashboard.domain.smsreceiver;

import com.safeone.dashboard.domain.smsreceiver.dto.SmsReceiverCreate;
import com.safeone.dashboard.domain.smsreceiver.dto.SmsReceiverUpdate;
import com.safeone.dashboard.domain.smsreceiver.service.SmsReceiverService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sms-receivers")
@RequiredArgsConstructor
public class SmsReceiverController {

    private final SmsReceiverService smsReceiverService;

    @PostMapping
    public void create(@RequestBody SmsReceiverCreate smsReceiverCreate) {
        smsReceiverService.create(smsReceiverCreate);
    }

    @PutMapping("/{mgntNo}")
    public void update(@PathVariable String mgntNo, @RequestBody SmsReceiverUpdate smsReceiverUpdate) {
        smsReceiverUpdate.setMgntNo(mgntNo);
        smsReceiverService.update(smsReceiverUpdate);
    }

    @DeleteMapping("/{mgntNo}")
    public void delete(@PathVariable String mgntNo) {
        smsReceiverService.delete(mgntNo);
    }

}
