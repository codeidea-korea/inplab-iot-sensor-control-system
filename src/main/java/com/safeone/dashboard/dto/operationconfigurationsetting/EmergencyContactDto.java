package com.safeone.dashboard.dto.operationconfigurationsetting;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class EmergencyContactDto implements Serializable {

    @FieldLabel(title = "관리_no", type = "hidden")
    private int mgnt_no;

    @FieldLabel(title = "현장_id", type = "hidden")
    private String district_no;

    @FieldLabel(title = "관리 현장")
    private String district_nm;

    @FieldLabel(title = "소속 기관")
    private String partner_comp_nm;

    @FieldLabel(title = "이름")
    private String emerg_chgr_nm;

    @FieldLabel(title = "역할")
    private String emerg_chgr_role;

    @FieldLabel(title = "연락처 1(휴대폰)")
    private String emerg_recv_ph;

    @FieldLabel(title = "연락처 2(일반 전화)")
    private String emerg_tel;

    @FieldLabel(title = "이메일")
    private String e_mail;

    @FieldLabel(title = "등록일시", type = "hidden")
    private String reg_dt;

    @FieldLabel(title = "수정일시", type = "hidden")
    private String mod_dt;


}