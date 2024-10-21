package com.safeone.dashboard.dao.sensor;

import com.safeone.dashboard.dto.sensor.AlertStandardManagementDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface AlertStandardManagementMapper {
    int getTotalCount(Map param);
    List<AlertStandardManagementDto> getList(Map param);
    Map selectAlarmCountByStatus(Map<String, Object> param);
    boolean insertAlarm(Map param);
    List<Map> selectAlarmHistory(Map<String, Object> param);

    int updateAlertStandardManagement(Map param);
}
    