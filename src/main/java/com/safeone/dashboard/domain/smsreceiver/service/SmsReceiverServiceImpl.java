package com.safeone.dashboard.domain.smsreceiver.service;

import com.safeone.dashboard.domain.smsreceiver.dto.SmsReceiverCreate;
import com.safeone.dashboard.domain.smsreceiver.dto.SmsReceiverUpdate;
import com.safeone.dashboard.domain.smsreceiver.repository.SmsReceiverMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class SmsReceiverServiceImpl implements SmsReceiverService {

    private final SmsReceiverMapper smsReceiverMapper;

    @Override
    public void create(SmsReceiverCreate smsReceiverCreate) {
        smsReceiverMapper.create(smsReceiverCreate);
    }

    @Override
    public void update(SmsReceiverUpdate smsReceiverUpdate) {
        smsReceiverMapper.update(smsReceiverUpdate);
    }

    @Override
    public void delete(String mgntNo) {
        smsReceiverMapper.delete(mgntNo);
    }
}
