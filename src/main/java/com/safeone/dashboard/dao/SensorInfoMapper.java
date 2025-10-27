package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.SensorInfoDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface SensorInfoMapper {
    int selectSensorInfoListTotal(Map param);
    List<SensorInfoDto> selectSensorInfoList(Map param);
    int insertSensorInfo(Map param);
    void insertSensorChnl(Map param);
    int updateSensorInfo(Map param);
    int deleteSensorInfo(Map param);
    List<SensorInfoDto> getAllSensorInfo(Map<String, Object> param);
    Integer getMaxLogrIdxNo(String senstypeNo);
}
    