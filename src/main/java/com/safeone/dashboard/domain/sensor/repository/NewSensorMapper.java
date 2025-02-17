package com.safeone.dashboard.domain.sensor.repository;

import com.safeone.dashboard.domain.sensor.dto.UpdatePosition;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface NewSensorMapper {
    int updatePosition(UpdatePosition updatePosition);
}
