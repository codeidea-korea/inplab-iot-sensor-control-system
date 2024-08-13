package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.DeviceMapper;
import com.safeone.dashboard.dto.DeviceDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class DeviceService implements JqGridService<DeviceDto> {

  private final DeviceMapper mapper;

  @Override
  public List<DeviceDto> getList(Map param) {
    return mapper.selectDeviceList(param);
  }

  @Override
  public int getTotalCount(Map param) {
    return mapper.selectDeviceListTotal(param);
  }

  @Override
  public boolean create(Map param) {
    return mapper.insertDevice(param) > 0;
  }

  @Override
  public DeviceDto read(int id) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'read'");
  }

  @Override
  public boolean update(Map param) {
    return mapper.updateDevice(param) > 0;
  }

  @Override
  public int delete(Map param) {
    return mapper.deleteDevice(param);
  }
}
