package com.safeone.dashboard.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EquipmentDto {
    private String equipment_nm;
    private String district_nm;
    private String inst_ymd;
    private String sens_status;
    private double formul_data;
}
