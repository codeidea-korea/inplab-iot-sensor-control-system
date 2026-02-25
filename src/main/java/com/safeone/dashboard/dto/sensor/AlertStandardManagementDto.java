package com.safeone.dashboard.dto.sensor;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class AlertStandardManagementDto implements Serializable {

    @FieldLabel(title = "현장명")
    private String district_nm;

    @FieldLabel(title = "센서타입명")
    private String sens_tp_nm;

    @FieldLabel(title = "district_no", type = "hidden")
    private String district_no;

    @FieldLabel(title = "센서명")
    private String sens_nm;

    @FieldLabel(title = "sens_no", type = "hidden")
    private String sens_no;

    @FieldLabel(title = "채널명")
    private String sens_chnl_nm;

    @FieldLabel(title = "sens_chnl_id", type = "hidden")
    private String sens_chnl_id;

    @FieldLabel(title = "1차 최소", type="editable")
    private String min1;

    @FieldLabel(title = "1차 최대", type="editable")
    private String max1;

    @FieldLabel(title = "2차 최소", type="editable")
    private String min2;

    @FieldLabel(title = "2차 최대", type="editable")
    private String max2;

    @FieldLabel(title = "3차 최소", type="editable")
    private String min3;

    @FieldLabel(title = "3차 최대", type="editable")
    private String max3;

    @FieldLabel(title = "4차 최소", type="editable")
    private String min4;

    @FieldLabel(title = "4차 최대", type="editable")
    private String max4;

    @FieldLabel(title = "적용 일시", type="datetime")
    private String lvl_apply_dt;


}
