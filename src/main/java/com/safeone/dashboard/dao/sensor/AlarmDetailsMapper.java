package com.safeone.dashboard.dao.sensor;

import com.safeone.dashboard.dto.sensor.AlarmDetailsDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface AlarmDetailsMapper {
    int getTotalCount(Map param);
    List<AlarmDetailsDto> getList(Map param);
    Map selectAlarmCountByStatus(Map<String, Object> param);
    boolean insertAlarm(Map param);
    List<Map> selectAlarmHistory(Map<String, Object> param);
}
    