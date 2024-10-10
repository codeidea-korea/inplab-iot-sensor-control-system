package com.safeone.dashboard.service.operationconfigurationsetting;

import com.safeone.dashboard.dao.operationconfigurationsetting.EmergencyContactMapper;
import com.safeone.dashboard.dto.operationconfigurationsetting.EmergencyContactDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmergencyContactService implements JqGridService<EmergencyContactDto> {

    private final EmergencyContactMapper mapper;

    @Override
    public List<EmergencyContactDto> getList(Map param) {
        return mapper.selectEmergencyContactList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectEmergencyContactListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertEmergencyContact(param) > 0;
    }

    @Override
    public EmergencyContactDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateEmergencyContact(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteEmergencyContact(param);
    }
}
