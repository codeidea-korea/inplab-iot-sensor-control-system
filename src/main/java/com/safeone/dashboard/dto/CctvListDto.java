package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class CctvListDto implements Serializable {

    @FieldLabel(title="현장 NO", type="hidden")
    String district_no;
	
	@FieldLabel(title="현장명", width = 120)
    String district_nm;

    @FieldLabel(title="CCTV NO", type="hidden")
    String cctv_no;

    @FieldLabel(title="CCTV명", width = 180)
    String cctv_nm;

    @FieldLabel(title="협력업체 ID", type="hidden")
    String partner_comp_id;

    @FieldLabel(title="계측사", width = 180)
    String partner_comp_nm;

    @FieldLabel(title="담당자", width = 100)
    String partner_comp_user_nm;

    @FieldLabel(title="전화번호", width = 180)
    String partner_comp_user_phone;

    @FieldLabel(title="유지보수 CD", type="hidden")
    String maint_sts_cd;

    @FieldLabel(title="유지보수명", type="hidden")
    String maint_sts_nm;

    @FieldLabel(title="설치일", type="hidden")
    String inst_ymd;

    @FieldLabel(title="모델명", type="hidden")
    String model_nm;

    @FieldLabel(title="제조사", type="hidden")
    String cctv_maker;

    @FieldLabel(title="IP", type="hidden")
    String cctv_ip;

    @FieldLabel(title="WEB PORT", type="hidden")
    String web_port;

    @FieldLabel(title="RTSP PORT", type="hidden")
    String rtsp_port;

    @FieldLabel(title="CCTV ID", type="hidden")
    String cctv_conn_id;

    @FieldLabel(title="CCTV PW", type="hidden")
    String cctv_conn_pwd;

    @FieldLabel(title="RELAY명", type="hidden")
    String relay_nm;

    @FieldLabel(title="RELAY IP", type="hidden")
    String relay_ip;

    @FieldLabel(title="RELAY PORT", type="hidden")
    String relay_port;

    @FieldLabel(title="위도", type="hidden")
    String cctv_lat;

    @FieldLabel(title="경도", type="hidden")
    String cctv_lon;

    @FieldLabel(title="관리센터", type="hidden")
    String admin_center;

    @FieldLabel(title="etc1", type="hidden")
    String etc1;

    @FieldLabel(title="etc2", type="hidden")
    String etc2;

    @FieldLabel(title="etc3", type="hidden")
    String etc3;
}