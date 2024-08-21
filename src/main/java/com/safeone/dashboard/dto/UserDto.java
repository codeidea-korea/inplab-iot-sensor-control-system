package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class UserDto implements Serializable {
    @FieldLabel(title = "사용자 ID")
    String usr_id;

    @FieldLabel(title = "사용자명")
    String usr_nm;

    @FieldLabel(title = "사용자 비밀번호")
    String usr_pwd;

    @FieldLabel(title = "사용자 비밀번호 확인")
    String usr_pwd_confm;

    @FieldLabel(title = "사용여부", type = "hidden")
    String use_yn;

    @FieldLabel(title = "사용자 연락처")
    String usr_ph;

    @FieldLabel(title = "이메일")
    String e_mail;

//    @FieldLabel(title = "사용자 구분")
//    String usr_flag_nm;

    @FieldLabel(title = "사용자 구분")
    String usr_flag;

    @FieldLabel(title = "사용자 구분", type = "hidden")
    String usr_flag_hid;

    @FieldLabel(title = "사용만료일")
    String usr_exp_ymd;

//    @FieldLabel(title = "등록일자", type = "range")
    @FieldLabel(title = "등록일자")
    String reg_dt;

    @FieldLabel(title = "수정일자")
    String mod_dt;

}