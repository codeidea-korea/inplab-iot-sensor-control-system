package com.safeone.dashboard.dto;

import lombok.Data;

import java.io.Serializable;

@Data
public class SensorChartDto implements Serializable {

    private String sens_no;
    private String sens_nm;
    private String formul_data;
    private String meas_dt;
    private String lvl_max1;
    private String lvl_max2;
    private String lvl_max3;
    private String lvl_max4;


}
