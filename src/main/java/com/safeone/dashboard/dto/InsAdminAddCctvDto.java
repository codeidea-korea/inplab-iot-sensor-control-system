package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Schema
@Getter
@Setter
public class InsAdminAddCctvDto {

    @Schema(example = "JC1CCTV-01", description = "cctv명")
    private String cctv_nm;

    @Schema(example = "D01", description = "현장명")
    private String district_no;

    @Schema(example = "JIT-P4271RH", description = "모델명")
    private String model_nm;

    @Schema(example = "제일정보통신", description = "제조사")
    private String cctv_maker;

    @Schema(example = "20230901", description = "설치일자")
    private String inst_ymd;

    @Schema(example = "13db17u06137-cctv.iptime.org", description = "cctv ip")
    private String cctv_ip;

    @Schema(example = "9000", description = "웹포트")
    private String web_port;

    @Schema(example = "5540", description = "rtsp포트")
    private String rtsp_port;

    @Schema(example = "admin", description = "cctv 접속 아이디")
    private String cctv_conn_id;

    @Schema(example = "dpsg1606!", description = "cctv 접속 비밀번호")
    private String cctv_conn_pwd;

    @Schema(example = "이월(relay01)", description = "릴레이명")
    private String relay_nm;

    @Schema(example = "123.123.123.123", description = " 릴레이 ip")
    private String relay_ip;

    @Schema(example = "5119", description = "릴레이 포트")
    private String relay_port;

    @Schema(example = "MTN001", description = "유지보수상태_cd  0.정상/1.망실/2.점검/3망실(철거)")
    private String maint_sts_cd;

    @Schema(example = "36.123123123", description = "경도")
    private String cctv_lon;

    @Schema(example = "127.123123123", description = "위도")
    private String cctv_lat;

    @Schema(example = "진척관리사무소", description = "관리사무소")
    private String admin_center;

    @Schema(example = "C01", description = "계측사아이디")
    private String partner_comp_id;

    @Schema(example = "홍길동", description = "계측사담당자명")
    private String partner_comp_user_nm;

    @Schema(example = "010-1234-5678", description = "계측사담당자연락처")
    private String partner_comp_user_phone;
}
