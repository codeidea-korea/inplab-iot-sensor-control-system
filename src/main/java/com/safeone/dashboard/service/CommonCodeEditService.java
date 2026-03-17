package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.CommonCodeEditMapper;
import com.safeone.dashboard.dto.SensorTypeDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class CommonCodeEditService {
    private final CommonCodeEditMapper mapper;

    public List<Map> getCommonCodeEditList(Map param) {
        return mapper.selectCommonCodeEditList(param);
    }

    public List<Map> getMaintcompInfoList(Map param) {
        return mapper.selectMaintcompInfoList(param);
    }

    public List<Map> getDistrictInfoNmAbbr(String district_nm) {
        return mapper.selectDistrictInfoNmAbbr(district_nm);
    }

    public List<Map> getSensorAbbr(Map param) {
        return mapper.selectSensorAbbr(param);
    }

    public SensorTypeDto selectSensorTypeInfo(String param) {
        return mapper.selectSensorTypeInfo(param);
    }

    public List<Map> getNewSensorSeq(Map param) {
        return mapper.selectNewSensorSeq(param);
    }

    public List<Map> getDistrictInfoDistAbbr(Map param) {
        return mapper.selectDistrictInfoDistAbbr(param);
    }

    public String getSensorInfoNm(Map param) {
        return mapper.selectSensorInfoNm(param);
    }

    public List<Map> getDistrictInfoList() {
        return mapper.selectDistrictInfoList();
    }


    public List<Map> getLoggerInfo() {
        return mapper.selectLoggerInfo();
    }

    public List<Map> getSensorType() {
        return mapper.selectSensorType();
    }

    public List<Map> getSiteInfo() {
        return mapper.selectSiteInfo();
    }

    public List<Map> selectSiteInfoLogo() {
        return mapper.selectSiteInfoLogo();
    }

    public List<Map> getLoggerInfoLogrNo(Map param) {
        return mapper.selectLoggerInfoLogrNo(param);
    }


    public List<Map> getSensorTypeSenstypeNo(Map param) {
        return mapper.selectSensorTypeSenstypeNo(param);
    }
    public boolean isLoggerNoExists(Map param) {
        return mapper.isLoggerNoExists(param);
    }

    public boolean isSensNoExists(Map param) {
        return mapper.isSensNoExists(param);
    }

    public boolean isLogrIdxNoExists(Map param) {
        return mapper.isLogrIdxNoExists(param);
    }

    public boolean isSensorByLoggerNoExists(Map param) {
        return mapper.isSensorByLoggerNoExists(param);
    }

    public List<Map> getSectList() {
        return mapper.selectSectList(); 
    }

    public List<Map> getNetErrList() {
        return mapper.selectNetErrList();
    }

    public List<Map> getAlarmLvlList(){ return mapper.selectAralmLvlList();}

}
