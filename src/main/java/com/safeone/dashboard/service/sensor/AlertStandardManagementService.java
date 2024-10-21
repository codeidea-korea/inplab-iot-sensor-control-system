package com.safeone.dashboard.service.sensor;

import com.safeone.dashboard.dao.sensor.AlertStandardManagementMapper;
import com.safeone.dashboard.dto.sensor.AlertStandardManagementDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class AlertStandardManagementService implements JqGridService<AlertStandardManagementDto> {

  private final AlertStandardManagementMapper mapper;

  @Override
  public List<AlertStandardManagementDto> getList(Map param) {
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
  public AlertStandardManagementDto read(int id) {
    throw new UnsupportedOperationException("Unimplemented method 'read'");
  }

  @Override
  public boolean update(Map param) {
    throw new UnsupportedOperationException("Unimplemented method 'update'");
  }

  public int updateAlertStandardManagement(Map param) {
    return mapper.updateAlertStandardManagement(param);
  }

  @Override
  public int delete(Map param) {
	  throw new UnsupportedOperationException("Unimplemented method 'delete'");
  }
}
