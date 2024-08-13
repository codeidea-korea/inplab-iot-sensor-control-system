package com.safeone.dashboard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface DashboardMapper {
    List<Map> selectDashboardData(Map param);
    
    List<Map> selectAlarm(Map param);

    List<Map> selectAssetAlarm(Map param);

    List<Map> selectMarkerList(Map param);

    List<Map> selectSensorChartData(Map param);

    List<Map> selectAreaInfo(Map param);

    Map selectCCTVCountByStatus(Map param);

    List<Map> selectSystemCountByStatus(Map param);

    Map selectDeviceCount(Map param);

    Map selectSensorCountByStatus(Map param);

    List<Map> selectDetailSystemCountByStatus(Map param);

    List<Map> selectMaintenanceInfo(Map param);

    List<Map> selectSensorChartRealData(Map param);
}
