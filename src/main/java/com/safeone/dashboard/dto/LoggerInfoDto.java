package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class LoggerInfoDto implements Serializable {

    @FieldLabel(title="ID")
    String logr_no;

    @FieldLabel(title="로거명")
    String logr_nm;

    @FieldLabel(title="현장 NO", type="hidden")
    String district_no;

    @FieldLabel(title="로거 구분", type="hidden")
    String logr_flag;

    @FieldLabel(title="현장명")
    String district_nm;

    @FieldLabel(title="설치일자")
    String inst_ymd;

    @FieldLabel(title="MAC")
    String logr_MAC;

    @FieldLabel(title="IP")
    String logr_ip;

    @FieldLabel(title="로거 Port")
    String logr_port;

    @FieldLabel(title="서버 IP")
    String logr_svr_ip;

    @FieldLabel(title="서버 Port")
    String logr_svr_port;

    @FieldLabel(title="설치상태", type="hidden")
    String maint_sts_cd;

    @FieldLabel(title="위도", type="hidden")
    String logr_lon;

    @FieldLabel(title="경도", type="hidden")
    String logr_lat;

    @FieldLabel(title="모델명")
    String model_nm;

    @FieldLabel(title="제조사명")
    String logr_maker;


}