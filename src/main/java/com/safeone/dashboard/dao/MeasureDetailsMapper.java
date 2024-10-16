package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.MeasureDetailsDto;
import com.safeone.dashboard.dto.SensorChartDto;
import com.safeone.dashboard.dto.SensorGroupingDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface MeasureDetailsMapper {
    int selectListTotal(Map param);

    List<MeasureDetailsDto> selectList(Map param);

    int insert(Map param);

    int update(Map param);

    int delete(Map param);

//    List<SensorChartDto> selectSensorChartData(Map param);
}
    