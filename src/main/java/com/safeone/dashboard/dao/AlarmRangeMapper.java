package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.AlarmRangeDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface AlarmRangeMapper {
    int selectAlarmRangeListTotal(Map param);
    List<AlarmRangeDto> selectAlarmRangeList(Map param);
    int updateAlarmRange(Map param);
}
    