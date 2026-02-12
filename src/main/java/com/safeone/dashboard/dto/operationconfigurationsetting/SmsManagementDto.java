package com.safeone.dashboard.dto.operationconfigurationsetting;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class SmsManagementDto implements Serializable {
    @FieldLabel(title = "관리_no", type = "hidden")
    private int mgnt_no;

    @FieldLabel(title = "현장명")
    private String district_nm;

    @FieldLabel(title = "현장_no", type = "hidden")
    private String district_no;

    @FieldLabel(title = "소속 기관")
    private String partner_comp_nm;

    @FieldLabel(title = "소속 기관", type = "hidden")
    private String partner_comp_id;

    @FieldLabel(title = "이름")
    private String sms_chgr_nm;

    @FieldLabel(title = "휴대폰 번호")
    private String sms_recv_ph;

    @FieldLabel(title = "경보단계")
    private String alarm_lvl_nm;

    @FieldLabel(title = "상태", type = "hidden")
    private String sms_status;

    @FieldLabel(title = "자동 전송 여부")
    private String sms_autosnd_yn;

    @FieldLabel(title = "등록일시", type = "hidden")
    private String reg_dt;

    @FieldLabel(title = "수정일시", type = "hidden")
    private String mod_dt;








}