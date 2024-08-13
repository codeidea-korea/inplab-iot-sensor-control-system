package com.safeone.dashboard.dao;

import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface CommonCodeMapper {
    List<Map> selectCommonCodeList(Map param);
    List<Map> selectAssetKindList();
    List<Map> selectAreaList();
    List<Map> selectSensorList();
    List<Map> selectZoneList();
    List<Map> selectAlarmKindList();
    List<Map> selectAssetKindBySensorList();
    List<Map> selectSensorListByZone(Map param);
    List<Map> selectMappingList();
}
    