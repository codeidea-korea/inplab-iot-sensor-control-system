package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class MeasureDetailsDataDto implements Serializable {

    @FieldLabel(title = "계측일시")
    private String meas_dt;

    @FieldLabel(title = "Raw Data")
    private String raw_data;

    @FieldLabel(title = "보정(Deg)")
    private String cor_data;

    @FieldLabel(title = "Raw Data(X)")
    private String raw_data_x;

    @FieldLabel(title = "X 보정(Deg)")
    private String cor_data_x;

    @FieldLabel(title = "Raw Data(Y)")
    private String raw_data_y;

    @FieldLabel(title = "Y 보정(Deg)")
    private String cor_data_y;

    @FieldLabel(title = "Raw Data(Z)")
    private String raw_data_z;

    @FieldLabel(title = "Z 보정(Deg)")
    private String cor_data_z;

}
