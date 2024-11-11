package com.safeone.dashboard.dto;

import lombok.Data;

import java.io.Serializable;

@Data
public class MeasureDataDto implements Serializable {

    private String mgnt_no;
    private String raw_data;
    private String over;
    private String meas_dt;
    private String formul_data;


}