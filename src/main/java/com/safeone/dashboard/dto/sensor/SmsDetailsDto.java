package com.safeone.dashboard.dto.sensor;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class SmsDetailsDto implements Serializable {

    @FieldLabel(title = "전송일시", width = 150)
    private String sms_trans_dt;

    @FieldLabel(title = "수신자", width = 150)
    private String sms_recv_chgr;

    @FieldLabel(title = "전화번호", width = 150)
    private String sms_recv_ph;

    @FieldLabel(title = "현장명", width = 150)
    private String district_nm;

    @FieldLabel(title = "전송결과", width = 150)
    private String sms_rslt_yn;

    @FieldLabel(title = "문자내역", width = 150, type = "hidden")
    private String sms_msg_dtls;
}