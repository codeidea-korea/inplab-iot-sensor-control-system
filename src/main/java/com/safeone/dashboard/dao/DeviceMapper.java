package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.DeviceDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface DeviceMapper {
    int selectDeviceListTotal(Map param);
    List<DeviceDto> selectDeviceList(Map param);
    int insertDevice(Map param);
    int updateDevice(Map param);
    int deleteDevice(Map param);
}
    