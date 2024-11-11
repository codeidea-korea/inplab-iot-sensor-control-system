package com.safeone.dashboard.dto;

import lombok.Data;

import java.io.Serializable;

@Data
public class SmsTargetDto implements Serializable {

    private String mgnt_no;
    private String alarm_lvl_nm;
    private String district_no;
    private String sms_recv_ph;
    private String sms_chgr_nm;


}