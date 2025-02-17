package com.safeone.dashboard.domain.sensor.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UpdatePosition {

    private String sensNo;
    private String sensLat;
    private String sensLon;

}
