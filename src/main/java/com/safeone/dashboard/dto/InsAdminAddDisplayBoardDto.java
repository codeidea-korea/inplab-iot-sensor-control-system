package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Schema
@Getter
@Setter
public class InsAdminAddDisplayBoardDto {

    @Schema(example = "brdcast-01", description = "전광판명")
    private String dispbd_nm;

    @Schema(example = "D01", description = "현장아이디")
    private String district_no;

    @Schema(example = "123.123.123.123", description = "전광판 ip")
    private String dispbd_ip;

    @Schema(example = "9000", description = "전광판 port")
    private String dispbd_port;

    @Schema(example = "admin", description = "접속 id")
    private String dispbd_conn_id;

    @Schema(example = "admin123", description = "접속 pwd")
    private String dispbd_conn_pwd;

    @Schema(example = "20240101", description = "설치일자")
    private String inst_ymd;

    @Schema(example = "MTN001", description = "유지보수상태_cd  0.정상/1.망실/2.점검/3망실(철거)")
    private String maint_sts_cd;

    @Schema(example = "127.123123123", description = "위도")
    private String dispbd_lat;

    @Schema(example = "36.123123123", description = "경도")
    private String dispbd_lon;

    @Schema(example = "BR-001", description = "모델명")
    private String model_nm;

    @Schema(example = "브로드테크", description = "제조사명")
    private String dispbd_maker;
}
