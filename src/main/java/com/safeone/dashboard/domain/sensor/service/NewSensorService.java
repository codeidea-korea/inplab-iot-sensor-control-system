package com.safeone.dashboard.domain.sensor.service;

import com.safeone.dashboard.domain.sensor.dto.UpdateCctvPosition;
import com.safeone.dashboard.domain.sensor.dto.UpdatePosition;

public interface NewSensorService {
    int updatePosition(UpdatePosition updatePosition);

    int updateCctvPosition(UpdateCctvPosition updatePosition);
}
