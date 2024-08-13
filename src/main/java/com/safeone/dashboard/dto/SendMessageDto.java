package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;
import lombok.ToString;

import java.util.List;

@Data
public class SendMessageDto {

    @FieldLabel(title = "전송 목록")
    List<SmsAlarmListDto> sendList;

    @FieldLabel(title = "전송 메세지")
    String sendMessage;

}
