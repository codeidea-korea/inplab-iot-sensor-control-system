package com.safeone.dashboard.domain.smsreceiver.repository;

import com.safeone.dashboard.domain.smsreceiver.dto.SmsReceiverCreate;
import com.safeone.dashboard.domain.smsreceiver.dto.SmsReceiverUpdate;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SmsReceiverMapper {
    void create(SmsReceiverCreate smsReceiverCreate);

    void update(SmsReceiverUpdate smsReceiverUpdate);

    void delete(String mgntNo);
}
