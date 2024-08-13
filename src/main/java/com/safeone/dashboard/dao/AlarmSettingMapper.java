package com.safeone.dashboard.dao;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.AlarmSettingDto;

import java.util.List;
import java.util.Map;

@Repository
public interface AlarmSettingMapper {
    int selectAlarmSettingListTotal(Map param);
    List<AlarmSettingDto> selectAlarmSettingList(Map param);
    int updateAlarmSetting(Map param);
}
    