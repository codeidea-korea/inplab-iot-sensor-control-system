package com.safeone.dashboard.service.sensor;

import com.safeone.dashboard.dao.sensor.SensorMapper;
import com.safeone.dashboard.dto.sensor.SensorDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class SensorService implements JqGridService<SensorDto> {

  private final SensorMapper mapper;

  @Override
  public List<SensorDto> getList(Map param) {
    return mapper.getList(param);
  }

  @Override
  public int getTotalCount(Map param) {
    return mapper.getTotalCount(param);
  }

  @Override
  public boolean create(Map param) {
    throw new UnsupportedOperationException("Unimplemented method 'create'");
  }

  @Override
  public SensorDto read(int id) {
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

}
