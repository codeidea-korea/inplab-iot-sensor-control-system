package com.safeone.dashboard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.SensorDto;

@Repository
public interface SensorMapper {
	//센서목록
    int selectSensorListTotal(Map param);
    List<SensorDto> selectSensorList(Map param);

    List<SensorDto> getAll(Map<String, Object> param);
}
    