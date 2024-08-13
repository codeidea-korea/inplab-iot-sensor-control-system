package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.AlarmSchedulerMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class AlarmSchedulerService {
    private final AlarmSchedulerMapper mapper;
    public List<Map> selectCommDelayAlarm(String comm_delay) {
        return mapper.selectCommDelayAlarm(comm_delay);
    }
    public List<Map> selectThresholdAlarm(Map param) {
        return mapper.selectThresholdAlarm(param);
    }
    public Map selectCCTVAlarm() {
        return mapper.selectCCTVAlarm();
    }

    public void defaultStatusSensor() {
        mapper.updateDefaultStatus();
    }

    public void updateViewFlag() {
        mapper.updateViewFlag();
    }
}
