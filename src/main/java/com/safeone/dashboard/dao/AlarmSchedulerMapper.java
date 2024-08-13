package com.safeone.dashboard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface AlarmSchedulerMapper {
    List<Map> selectCommDelayAlarm(String comm_delay);
    List<Map> selectThresholdAlarm(Map param);
    Map selectCCTVAlarm();
    void updateDefaultStatus();
    void updateViewFlag();
}
    