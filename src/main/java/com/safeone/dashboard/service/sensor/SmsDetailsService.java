package com.safeone.dashboard.service.sensor;

import com.safeone.dashboard.dao.sensor.SmsDetailsMapper;
import com.safeone.dashboard.dto.sensor.SmsDetailsDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class SmsDetailsService implements JqGridService<SmsDetailsDto> {

  private final SmsDetailsMapper mapper;

  @Override
  public List<SmsDetailsDto> getList(Map param) {
    return mapper.getList(param);
  }

  @Override
  public int getTotalCount(Map param) {
    return mapper.getTotalCount(param);
  }

  @Override
  public boolean create(Map param) {
	  return mapper.insertAlarm(param);
  }

  @Override
  public SmsDetailsDto read(int id) {
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