package com.safeone.dashboard.domain.district.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UpdatePosition {

    private String districtNo;
    private String distLat;
    private String distLon;

}
