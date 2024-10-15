package com.safeone.dashboard.service.sensorinitialsetting;

import com.safeone.dashboard.dao.sensorinitialsetting.SensorInitialSettingMapper;
import com.safeone.dashboard.dto.sensorinitialsetting.SensorInitialSettingDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class SensorInitialSettingService implements JqGridService<SensorInitialSettingDto> {

    private final SensorInitialSettingMapper mapper;

    @Override
    public List<SensorInitialSettingDto> getList(Map param) {
        return mapper.selectSensorInitialSettingList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectSensorInitialSettingListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertSensorInitialSetting(param) > 0;
    }

    @Override
    public SensorInitialSettingDto read(int id) {
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateSensorInitialSetting(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteSensorInitialSetting(param);
    }
}
