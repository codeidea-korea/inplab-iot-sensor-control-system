package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.EmergencyCallMapper;
import com.safeone.dashboard.dto.EmergencyCallDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmergencyCallService implements JqGridService<EmergencyCallDto> {

  private final EmergencyCallMapper mapper;

  @Override
  public List<EmergencyCallDto> getList(Map param) {
    return mapper.selectEmergencyCallList(param);
  }

  @Override
  public int getTotalCount(Map param) {
    return mapper.selectEmergencyCallListTotal(param);
  }

  @Override
  public boolean create(Map param) {
    return mapper.insertEmergencyCall(param) > 0;
  }

  @Override
  public EmergencyCallDto read(int id) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'read'");
  }

  @Override
  public boolean update(Map param) {
    return mapper.updateEmergencyCall(param) > 0;
  }

  @Override
  public int delete(Map param) {
    return mapper.deleteEmergencyCall(param);
  }
}
