package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.CommonCodeMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class CommonCodeService{
    private final CommonCodeMapper mapper;

    public List<Map> getCommonCodeList(Map param) {
        return mapper.selectCommonCodeList(param);
    }
    
    public List<Map> getAssetKindList() {
        return mapper.selectAssetKindList();
    }

    public List<Map> getAssetKindBySensorList() {
        return mapper.selectAssetKindBySensorList();
    }

    public List<Map> getAreaList() {
        return mapper.selectAreaList();
    }
    
    public List<Map> getSensorList() {
        return mapper.selectSensorList();
    }
    
    public List<Map> getZoneList() {
        return mapper.selectZoneList();
    }

    public List<Map> getAlarmKindList() { return mapper.selectAlarmKindList();
    }

    public List<Map> getSensorListByZone(Map param) {
        return mapper.selectSensorListByZone(param);
    }

    public List<Map> getMappingList() { return mapper.selectMappingList();
    }
}
