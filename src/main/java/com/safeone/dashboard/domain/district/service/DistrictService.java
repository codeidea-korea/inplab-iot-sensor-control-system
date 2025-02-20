package com.safeone.dashboard.domain.district.service;

import com.safeone.dashboard.domain.district.dto.District;
import com.safeone.dashboard.domain.district.dto.UpdatePosition;

import java.util.List;

public interface DistrictService {
    int updatePosition(UpdatePosition updatePosition);

    List<District> getAll();
}
