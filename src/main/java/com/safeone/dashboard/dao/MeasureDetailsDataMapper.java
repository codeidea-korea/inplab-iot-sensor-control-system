package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.MeasureDetailsDataDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface MeasureDetailsDataMapper {
    int selectListTotal(Map param);

    List<MeasureDetailsDataDto> selectList(Map param);

    int insert(Map param);

    int update(Map param);

    int delete(Map param);

//    List<SensorChartDto> selectSensorChartData(Map param);
}
    