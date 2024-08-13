package com.safeone.dashboard.dao;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.AlarmListDto;

import java.util.List;
import java.util.Map;

@Repository
public interface AlarmListMapper {
    int selectAlarmListTotal(Map param);
    List<AlarmListDto> selectAlarmList(Map param);
    Map selectAlarmCountByStatus(Map<String, Object> param);
    boolean insertAlarm(Map param);
    List<Map> selectAlarmHistory(Map<String, Object> param);
}
    