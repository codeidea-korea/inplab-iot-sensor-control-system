package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.*;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface SmsSenderMapper {

    List<AlertStandardDto> getAlertStandards();

    MeasureDataDto getMeasuredData(Map<String, Object> param);

    List<SmsTargetDto> getSmsTargetList(Map<String, Object> param);

    void saveAlarmDetails(Map<String, Object> param);

    int getMaxMgntNoFromAlarmDetails();

    void saveSmsDetails(Map<String, Object> param);

    DistrictInfoDto getDistrictInfo(Map<String, Object> param);

    SensInfoDto getSensInfo(String sensNo);
}
    