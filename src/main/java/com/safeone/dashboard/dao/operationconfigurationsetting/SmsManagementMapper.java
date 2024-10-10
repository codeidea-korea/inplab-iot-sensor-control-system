package com.safeone.dashboard.dao.operationconfigurationsetting;

import com.safeone.dashboard.dto.operationconfigurationsetting.SmsManagementDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface SmsManagementMapper {
    int selectSmsManagementListTotal(Map param);

    List<SmsManagementDto> selectSmsManagementList(Map param);

    int insertSmsManagement(Map param);

    int updateSmsManagement(Map param);

    int deleteSmsManagement(Map param);
}
    