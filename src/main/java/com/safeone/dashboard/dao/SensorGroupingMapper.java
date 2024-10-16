package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.SensorChartDto;
import com.safeone.dashboard.dto.SensorGroupingDto;
import com.safeone.dashboard.dto.sensorinitialsetting.SensorInitialSettingDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface SensorGroupingMapper {
    int selectListTotal(Map param);

    List<SensorGroupingDto> selectList(Map param);

    int insert(Map param);

    int update(Map param);

    int delete(Map param);

    List<SensorChartDto> selectSensorChartData(Map param);
}
    