package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.AlarmListMapper;
import com.safeone.dashboard.dto.AlarmListDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class AlarmListService {

  private final AlarmListMapper mapper;

  public List<AlarmListDto> getList(Map param) {
    return mapper.selectAlarmList(param);
  }

  public int getTotalCount(Map param) {
    return mapper.selectAlarmListTotal(param);
  }

  public boolean create(Map param) {
    // if (param.get("alarm_title").equals("") || param.isEmpty()) {
    //   return false;
    // }
	  return mapper.insertAlarm(param);
  }

  public AlarmListDto read(int id) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'read'");
  }

  public boolean update(Map param) {
	  throw new UnsupportedOperationException("Unimplemented method 'update'");
  }

  public int delete(Map param) {
	  throw new UnsupportedOperationException("Unimplemented method 'delete'");
  }

  public Map selectAlarmCountByStatus(Map<String, Object> param) {
      return mapper.selectAlarmCountByStatus(param);
    }

  public List<Map> selectAlarmHistory(Map<String, Object> param) {
    return mapper.selectAlarmHistory(param);
  }

  public List<Map<String, Object>> getListByLevel(Map<String, Object> param) {
    return mapper.selectListByLevel(param);
  }
}
