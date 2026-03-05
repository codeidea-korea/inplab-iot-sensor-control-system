package com.safeone.dashboard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.GetModifySensorDto;
import org.springframework.stereotype.Repository;

@Repository
public interface DashboardMapper {
    List<Map> selectDashboardData(Map param);

    List<Map> selectAssetAlarm(Map param);

    List<Map> selectAreaInfo(Map param);

    Map selectCCTVCountByStatus(Map param);

    Map selectDeviceCount(Map param);

    Map selectSensorCountByStatus(Map param);

    List<Map> getAlarmHistory(Map param);

    List<Map> getAlarmMessage(Map param);

    void updateViewFlag(Integer mgntNo);

    List<HashMap<String, Object>> getSensorList(Map<String, Object> map);
}
