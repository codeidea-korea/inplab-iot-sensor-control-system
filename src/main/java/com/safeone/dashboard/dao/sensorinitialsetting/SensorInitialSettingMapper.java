package com.safeone.dashboard.dao.sensorinitialsetting;

import com.safeone.dashboard.dto.sensorinitialsetting.SensorInitialSettingDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface SensorInitialSettingMapper {
    int selectSensorInitialSettingListTotal(Map param);

    List<SensorInitialSettingDto> selectSensorInitialSettingList(Map param);

    int insertSensorInitialSetting(Map param);

    int updateSensorInitialSetting(Map param);

    int deleteSensorInitialSetting(Map param);
}
    