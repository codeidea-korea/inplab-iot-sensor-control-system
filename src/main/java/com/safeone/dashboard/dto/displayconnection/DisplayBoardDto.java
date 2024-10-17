package com.safeone.dashboard.dto.displayconnection;

import lombok.Data;

import java.io.Serializable;

@Data
public class DisplayBoardDto implements Serializable {
    private String dispbd_no;
    private String dispbd_nm;
    private String district_no;
    private String del_yn;
    private String dispbd_ip;
    private String dispbd_port;
    private String dispbd_conn_id;
    private String dispbd_conn_pwd;
    private String inst_ymd;
    private String maint_sts_cd;
    private String dispbd_lon;
    private String dispbd_lat;
    private String dispbd_maker;
    private String model_nm;
    private String reg_dt;
    private String mod_dt;
}