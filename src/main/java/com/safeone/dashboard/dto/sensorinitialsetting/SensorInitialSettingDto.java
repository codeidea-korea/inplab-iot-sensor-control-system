package com.safeone.dashboard.dto.sensorinitialsetting;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class SensorInitialSettingDto implements Serializable {

    @FieldLabel(title = "현장명")
    private String district_nm;

    @FieldLabel(title = "센서타입명")
    private String sens_tp_nm;

    @FieldLabel(title = "센서명")
    private String sens_nm;

    @FieldLabel(title = "채널명")
    private String sens_chnl_nm;

    @FieldLabel(title = "측정값(보정값)")
    private String formul_data;

    @FieldLabel(title = "경보상태")
    private String d;

    @FieldLabel(title = "최종계측일시")
    private String b;

    @FieldLabel(title = "초기치설정일시", type = "range")
    private String init_apply_dt;


}