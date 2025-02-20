package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.SensorChartDto;
import com.safeone.dashboard.dto.SensorGroupingDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface SensorGroupingMapper {
    int selectListTotal(Map<String, Object> param);

    List<SensorGroupingDto> selectList(Map<String, Object> param);

    int insert(Map<String, Object> param);

    int update(Map<String, Object> param);

    int delete(Map<String, Object> param);

    List<SensorChartDto> selectSensorChartData(Map<String, Object> param);
}
    