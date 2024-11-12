package com.safeone.dashboard.dto;

import lombok.Data;

import java.io.Serializable;

@Data
public class SensInfoDto implements Serializable {

    private String sens_no;
    private String sens_nm;
    private String senstype_no;
    private String sens_tp_nm;
    private boolean over;

}