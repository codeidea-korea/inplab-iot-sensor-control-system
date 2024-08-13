package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.DashboardMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DashboardService {
    private final DashboardMapper dashboardMapper;

    public List<Map> selectDashboardData(Map param) {
        return dashboardMapper.selectDashboardData(param);
    }

    public List<Map> selectMarkerList(Map param) {
        return dashboardMapper.selectMarkerList(param);
    }

    public List<Map> selectAssetAlarm(Map param) {
        return dashboardMapper.selectAssetAlarm(param);
    }

    public List<Map> selectAreaInfo(Map param) {
        return dashboardMapper.selectAreaInfo(param);
    }

    public List<Map> selectAlarm(Map param) {
        return dashboardMapper.selectAlarm(param);
    }

    public Map selectSensorCountByStatus(Map param) { return dashboardMapper.selectSensorCountByStatus(param); }

    public List<Map> selectSensorChartData(Map param) {
        return dashboardMapper.selectSensorChartData(param);
    }

    public Map selectCCTVCountByStatus(Map param) { return dashboardMapper.selectCCTVCountByStatus(param); }

    public List<Map> selectSystemCountByStatus(Map param) { return dashboardMapper.selectSystemCountByStatus(param);
    }

    public Map selectDeviceCount(Map param) { return dashboardMapper.selectDeviceCount(param);
    }

    public List<Map> selectDetailSystemCountByStatus(Map param) {
        return dashboardMapper.selectDetailSystemCountByStatus(param);
    }

    public List<Map> selectMaintenanceInfo(Map param) {
        return dashboardMapper.selectMaintenanceInfo(param);
    }

    public List<Map> selectSensorChartRealData(Map param) {
        return dashboardMapper.selectSensorChartRealData(param);
    }
}
