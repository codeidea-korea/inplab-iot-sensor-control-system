package com.safeone.dashboard.dao.operationconfigurationsetting;

import com.safeone.dashboard.dto.operationconfigurationsetting.EmergencyContactDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface EmergencyContactMapper {
    int selectEmergencyContactListTotal(Map param);

    List<EmergencyContactDto> selectEmergencyContactList(Map param);

    int insertEmergencyContact(Map param);

    int updateEmergencyContact(Map param);

    int deleteEmergencyContact(Map param);
}
    