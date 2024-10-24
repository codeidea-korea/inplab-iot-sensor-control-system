package com.safeone.dashboard.dao.sensor;

import com.safeone.dashboard.dto.sensor.SensorDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface SensorMapper {
    int getTotalCount(Map param);
    List<SensorDto> getList(Map param);
}
    