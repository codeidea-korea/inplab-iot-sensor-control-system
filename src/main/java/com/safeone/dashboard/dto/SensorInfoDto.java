package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class SensorInfoDto implements Serializable {

    @FieldLabel(title="센서_no", type="hidden")
    String sens_no;

    @FieldLabel(title="센서 TYPE명")
    String senstype_nm;

    @FieldLabel(title="로거명")
    String logr_nm;

    @FieldLabel(title="로거번호", type="hidden")
    String logr_no;

    @FieldLabel(title="센서 ID")
    String sens_nm;

    @FieldLabel(title="센서타입번호", type="hidden")
    String senstype_no;

    @FieldLabel(title="단면번호")
    String sect_no;

    @FieldLabel(title="센서상태")
    String maint_sts_nm;

    @FieldLabel(title="복합센서", type="hidden")
    String multi_sens_yn;

    @FieldLabel(title="표출우선여부", type="hidden")
    String disp_prior_yn;

    @FieldLabel(title="상대센서종류", type="hidden")
    String multi_senstype_no;

    @FieldLabel(title="상대센서_no", type="hidden")
    String multi_sens_no;

    @FieldLabel(title="미수신기준(분)")
    String nonrecv_limit_min;

    @FieldLabel(title="경보사용여부")
    String alarm_use_yn;

    @FieldLabel(title="문자발송대상여부")
    String sms_snd_yn;

    @FieldLabel(title="화면표시대상여부")
    String sens_disp_yn;

    @FieldLabel(title="설치일자", type = "range")
    String inst_ymd;

    @FieldLabel(title="유지보수상태", type="hidden")
    String maint_sts_cd;

    @FieldLabel(title="경도", type="hidden")
    String sens_lon;

    @FieldLabel(title="위도", type="hidden")
    String sens_lat;

    @FieldLabel(title="제조사명", type="hidden")
    String sens_maker;

    @FieldLabel(title="모델명", type="hidden")
    String model_nm;


}