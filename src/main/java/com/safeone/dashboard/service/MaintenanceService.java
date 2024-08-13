package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.MaintenanceMapper;
import com.safeone.dashboard.dto.MaintenanceDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class MaintenanceService implements JqGridService<MaintenanceDto> {

  private final MaintenanceMapper mapper;

  @Override
  public List<MaintenanceDto> getList(Map param) {
    return mapper.selectMaintenanceList(param);
  }

  @Override
  public int getTotalCount(Map param) {
    return mapper.selectMaintenanceListTotal(param);
  }

  @Override
  public boolean create(Map param) {
    return mapper.insertMaintenance(param) > 0;
  }

  @Override
  public MaintenanceDto read(int id) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'read'");
  }

  @Override
  public boolean update(Map param) {
    return mapper.updateMaintenance(param) > 0;
  }

  @Override
  public int delete(Map param) {
    return mapper.deleteMaintenance(param);
  }
}
