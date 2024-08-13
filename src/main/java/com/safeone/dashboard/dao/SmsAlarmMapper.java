package com.safeone.dashboard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.SmsAlarmListDto;

@Repository
public interface SmsAlarmMapper {
    int selectSmsAlarmListTotal(Map param);
    int selectSmsCountPerDay(String phone);
    List<SmsAlarmListDto> selectSmsAlarmList(Map param);
    boolean insertSmsAlarm(Map param);
    boolean insertSmsLog(Map param);
    int updateSmsAlarm(Map param);
    int deleteSmsAlarm(Map param);

    List<Map> selectAlarmInfo(Map param);
    List<Map> selectRainGaugeInfo(Map param);
}
    