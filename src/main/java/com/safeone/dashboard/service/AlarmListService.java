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
public class AlarmListService implements JqGridService<AlarmListDto> {

  private final AlarmListMapper mapper;

  @Override
  public List<AlarmListDto> getList(Map param) {
    return mapper.selectAlarmList(param);
  }

  @Override
  public int getTotalCount(Map param) {
    return mapper.selectAlarmListTotal(param);
  }

  @Override
  public boolean create(Map param) {
    // if (param.get("alarm_title").equals("") || param.isEmpty()) {
    //   return false;
    // }
	  return mapper.insertAlarm(param);
  }

  @Override
  public AlarmListDto read(int id) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'read'");
  }

  @Override
  public boolean update(Map param) {
	  throw new UnsupportedOperationException("Unimplemented method 'update'");
  }

  @Override
  public int delete(Map param) {
	  throw new UnsupportedOperationException("Unimplemented method 'delete'");
  }

  public Map selectAlarmCountByStatus(Map<String, Object> param) {
      return mapper.selectAlarmCountByStatus(param);
    }

  public List<Map> selectAlarmHistory(Map<String, Object> param) {
    return mapper.selectAlarmHistory(param);
  }
}
