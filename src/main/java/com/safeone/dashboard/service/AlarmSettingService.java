package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.AlarmSettingMapper;
import com.safeone.dashboard.dto.AlarmSettingDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class AlarmSettingService implements JqGridService<AlarmSettingDto> {

  private final AlarmSettingMapper mapper;

  @Override
  public List<AlarmSettingDto> getList(Map param) {
    return mapper.selectAlarmSettingList(param);
  }

  @Override
  public int getTotalCount(Map param) {
    return mapper.selectAlarmSettingListTotal(param);
  }

  @Override
  public boolean create(Map param) {
	  throw new UnsupportedOperationException("Unimplemented method 'create'");
  }

  @Override
  public AlarmSettingDto read(int id) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'read'");
  }

  @Override
  public boolean update(Map param) {
    return mapper.updateAlarmSetting(param) > 0;
  }

  @Override
  public int delete(Map param) {
	  throw new UnsupportedOperationException("Unimplemented method 'delete'");
  }
}
