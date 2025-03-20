package com.safeone.dashboard.domain.sensor.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UpdateCctvPosition {

    private String cctvNo;
    private String cctvLat;
    private String cctvLon;

}
