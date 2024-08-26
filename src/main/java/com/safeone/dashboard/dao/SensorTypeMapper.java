package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.SensorTypeDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface SensorTypeMapper {
    int selectSensorTypeListTotal(Map param);
    List<SensorTypeDto> selectSensorTypeList(Map param);
    int insertSensorType(Map param);
    int updateSensorType(Map param);
    int deleteSensorType(Map param);
}
    