package com.safeone.dashboard.dto.operationconfigurationsetting;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class SmsManagementDto implements Serializable {
    @FieldLabel(title = "관리_no", type = "hidden")
    private int mgnt_no;

    @FieldLabel(title = "현장_no", type = "hidden")
    private String district_no;

    @FieldLabel(title = "소속 기관")
    private String sms_recv_dept;

    @FieldLabel(title = "이름")
    private String sms_chgr_nm;

    @FieldLabel(title = "휴대폰 번호")
    private String sms_recv_ph;

    @FieldLabel(title = "경보단계", type = "selectable")
    private String alarm_lvl_nm;

    @FieldLabel(title = "상태")
    private String sms_status;

    @FieldLabel(title = "자동 전송 여부")
    private String sms_autosnd_yn;

    @FieldLabel(title = "등록일시", type = "hidden")
    private String reg_dt;

    @FieldLabel(title = "수정일시", type = "hidden")
    private String mod_dt;








}