package com.safeone.dashboard.dao.sensor;

import com.safeone.dashboard.dto.sensor.SmsDetailsDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface SmsDetailsMapper {
    int getTotalCount(Map param);
    List<SmsDetailsDto> getList(Map param);
    Map selectAlarmCountByStatus(Map<String, Object> param);
    boolean insertAlarm(Map param);
    List<Map> selectAlarmHistory(Map<String, Object> param);
}
    