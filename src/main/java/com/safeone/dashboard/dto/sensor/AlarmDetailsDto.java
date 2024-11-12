package com.safeone.dashboard.dto.sensor;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class AlarmDetailsDto implements Serializable {

    @FieldLabel(title = "발생일시")
    private String meas_dt;

    @FieldLabel(title = "현장명")
    private String district_nm;

    @FieldLabel(title = "채널명")
    private String sens_chnl_id;

    @FieldLabel(title = "알림상태")
    private String alarm_lvl_cd;

    @FieldLabel(title = "계측값")
    private String formul_data;

    // ?
    @FieldLabel(title = "관리기준 범위")
    private String standard;

    @FieldLabel(title = "센서상태")
    private String maint_sts_cd;

    @FieldLabel(title = "통신상태")
    private String net_err_yn;

    @FieldLabel(title = "문자(성공/대상)(명)")
    private String sms_cnt;

    @FieldLabel(title = "max1", type = "hidden")
    private String max1;

    @FieldLabel(title = "min1", type = "hidden")
    private String min1;

    @FieldLabel(title = "max2", type = "hidden")
    private String max2;

    @FieldLabel(title = "min2", type = "hidden")
    private String min2;

    @FieldLabel(title = "max3", type = "hidden")
    private String max3;

    @FieldLabel(title = "min3", type = "hidden")
    private String min3;

    @FieldLabel(title = "max4", type = "hidden")
    private String max4;

    @FieldLabel(title = "min4", type = "hidden")
    private String min4;
}