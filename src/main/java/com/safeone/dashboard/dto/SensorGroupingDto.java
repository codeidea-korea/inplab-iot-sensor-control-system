package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class SensorGroupingDto implements Serializable {

    @FieldLabel(title = "센서타입명")
    private String sens_tp_nm;

    @FieldLabel(title = "센서명")
    private String sens_nm;

    @FieldLabel(title = "최종계측일", type = "range")
    private String last_apply_dt;

    @FieldLabel(title = "센서상태", type = "selectable")
    private String maint_sts_cd;

    @FieldLabel(title = "현장명", type = "hidden")
    private String district_nm;

    @FieldLabel(title = "채널명", type = "hidden")
    private String sens_chnl_nm;

    @FieldLabel(title = "측정값(보정값)", type = "hidden")
    private String formul_data;

    @FieldLabel(title = "경보상태", type = "hidden")
    private String emer_status;

    @FieldLabel(title = "초기치설정일시", type = "hidden")
    private String init_apply_dt;

    @FieldLabel(title = "센서_no", type = "hidden")
    private String sens_no;

    @FieldLabel(title = "채널_id", type = "hidden")
    private String sens_chnl_id;
}
