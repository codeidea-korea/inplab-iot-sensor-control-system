package com.safeone.dashboard.dto;

import lombok.Data;

import java.io.Serializable;

@Data
public class SensorChartDto implements Serializable {

    private String sens_no;
    private String sens_nm;
    private String max_data;
    private String min_data;
    private String sens_chnl_id;
    private String formul_data;
    private String meas_dt;
    private String lvl_min1;
    private String lvl_min2;
    private String lvl_min3;
    private String lvl_min4;
    private String lvl_max1;
    private String lvl_max2;
    private String lvl_max3;
    private String lvl_max4;
    private String senstype_no;

}
