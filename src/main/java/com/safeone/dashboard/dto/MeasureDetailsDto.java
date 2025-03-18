package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class MeasureDetailsDto implements Serializable {

    @FieldLabel(title = "현장명", width = 150)
    private String district_nm;

    @FieldLabel(title = "센서타입", width = 150)
    private String sens_tp_nm;

    @FieldLabel(title = "센서명", width = 150)
    private String sens_nm;

    @FieldLabel(title = "최종계측일시", width = 300)
    private String init_apply_dt;

    @FieldLabel(title = "단면")
    private String sect_no;

    @FieldLabel(title = "센서상태", width = 150)
    private String maint_sts_cd;

    @FieldLabel(title = "통신상태", type = "hidden")
    private String networ_status;

    @FieldLabel(title = "채널명", type = "hidden")
    private String sens_chnl_nm;

    @FieldLabel(title = "측정값(보정값)", type = "hidden")
    private String formul_data;

    @FieldLabel(title = "경보상태", type = "hidden")
    private String emer_status;

//    @FieldLabel(title = "초기치설정일시", type = "hidden")
//    private String init_apply_dt;

    @FieldLabel(title = "센서_no", type = "hidden")
    private String sens_no;

    @FieldLabel(title = "채널_id", type = "hidden")
    private String sens_chnl_id;

    @FieldLabel(title = "senstype_no", type = "hidden")
    private String senstype_no;
}
