package com.safeone.dashboard.dto;

import lombok.Data;

import java.io.Serializable;

@Data
public class AlertStandardDto implements Serializable {

    private String district_no;
    private String sens_no;
    private String sens_chnl_id;
    private String max1;
    private String max2;
    private String max3;
    private String max4;


    private String over;
    private String raw_data;
    private String meas_dt;
    private String formul_data;

    public void setAdditionalData(MeasureDataDto data) {
        this.over = data.getOver();
        this.raw_data = data.getRaw_data();
        this.meas_dt = data.getMeas_dt();
        this.formul_data = data.getFormul_data();
    }

}