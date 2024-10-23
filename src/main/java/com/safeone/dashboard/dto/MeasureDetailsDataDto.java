package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class MeasureDetailsDataDto implements Serializable {

    @FieldLabel(title = "계측일시", type = "editable")
    private String meas_dt;

    @FieldLabel(title = "Raw Data", type = "editable")
    private String raw_data;

    @FieldLabel(title = "보정(Deg)", type = "editable")
    private String formul_data;

    @FieldLabel(title = "Raw Data(X)", type = "editable")
    private String raw_data_x;

    @FieldLabel(title = "X 보정(Deg)", type = "editable")
    private String formul_data_x;

    @FieldLabel(title = "Raw Data(Y)", type = "editable")
    private String raw_data_y;

    @FieldLabel(title = "Y 보정(Deg)", type = "editable")
    private String formul_data_y;

    @FieldLabel(title = "Raw Data(Z)", type = "editable")
    private String raw_data_z;

    @FieldLabel(title = "Z 보정(Deg)", type = "editable")
    private String formul_data_z;

    @FieldLabel(title = "sens_chnl_id", type = "hidden")
    private String sens_chnl_id;

    @FieldLabel(title = "sens_no", type = "hidden")
    private String sens_no;

    @FieldLabel(title = "is_new", type = "hidden")
    private boolean is_new;
}
