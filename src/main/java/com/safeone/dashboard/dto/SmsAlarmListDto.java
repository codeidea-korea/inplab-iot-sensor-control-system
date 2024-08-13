package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class SmsAlarmListDto implements Serializable {
    @FieldLabel(title="ID", type="hidden")
    String id;

    @FieldLabel(title="이름", width = 350)
    String username;
    
    @FieldLabel(title="휴대폰번호", width=350)
    String phone;

    @FieldLabel(title="임계치 단계", type = "hidden")
    String threshold_id;
    
    @FieldLabel(title="임계치 단계", width=350)
    String threshold;

    @FieldLabel(title="필터링 전송 여부", type="hidden")
    String filter_flag;
    
    @FieldLabel(title="자동 전송 여부", width=350)
    String auto_send_flag;
    
    @FieldLabel(title="마지막 발송일시", type="hidden")
    String send_date;
}