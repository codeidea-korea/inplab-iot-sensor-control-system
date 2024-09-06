package com.safeone.dashboard.dao;

import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface CommonCodeEditMapper {
    List<Map> getGenerationKey(Map param);

    int incMaxGenerationKey(Map param);

    int nextPreCodeGenerationKey(Map param);

    List<Map> selectCommonCodeEditList(Map param);

    List<Map> selectDistrictInfoNmAbbr(String district_nm);

    List<Map> selectSensorAbbr(Map param);

    List<Map> selectNewSensorSeq(Map param);

    List<Map> selectDistrictInfoDistAbbr(Map param);

    String selectSensorInfoNm(Map param);

    List<Map> selectMaintcompInfoList(Map param);

    List<Map> selectLoggerInfoLogrNo(Map param);

    List<Map> selectSensorTypeSenstypeNo(Map param);

    List<Map> selectDistrictInfoList();

    List<Map> selectLoggerInfo();

    List<Map> selectSensorType();

    List<Map> selectSiteInfo();

    List<Map> selectSiteInfoLogo();

    boolean isLoggerNoExists(Map param);

    boolean isSensNoExists(Map param);

    boolean isLogrIdxNoExists(Map param);

}
    