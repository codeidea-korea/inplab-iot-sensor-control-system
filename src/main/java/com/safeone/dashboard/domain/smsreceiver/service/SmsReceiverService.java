package com.safeone.dashboard.domain.smsreceiver.service;

import com.safeone.dashboard.domain.smsreceiver.dto.SmsReceiverCreate;
import com.safeone.dashboard.domain.smsreceiver.dto.SmsReceiverUpdate;

public interface SmsReceiverService {
    void create(SmsReceiverCreate smsReceiverCreate);

    void update(SmsReceiverUpdate smsReceiverUpdate);

    void delete(String mgntNo);
}
