package com.safeone.dashboard.dto.operationconfigurationsetting;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class UserManagementDto implements Serializable {

    @FieldLabel(title = "사용자 ID")
    private String usr_id;

    @FieldLabel(title = "이름")
    private String usr_nm;

    @FieldLabel(title = "사용여부")
    private String use_yn;

    @FieldLabel(title = "휴대전화")
    private String usr_ph;

    @FieldLabel(title = "이메일")
    private String e_mail;

    @FieldLabel(title = "사용자 구분", type = "hidden")
    private String usr_flag;

    @FieldLabel(title = "사용만료일", type = "hidden")
    private String usr_exp_ymd;

    @FieldLabel(title = "등록일시", type = "hidden")
    private String reg_dt;

    @FieldLabel(title = "수정일시", type = "hidden")
    private String mod_dt;


}