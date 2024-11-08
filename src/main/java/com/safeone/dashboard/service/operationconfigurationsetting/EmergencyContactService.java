package com.safeone.dashboard.service.operationconfigurationsetting;

import com.safeone.dashboard.dao.operationconfigurationsetting.EmergencyContactMapper;
import com.safeone.dashboard.dao.operationconfigurationsetting.SmsManagementMapper;
import com.safeone.dashboard.dto.operationconfigurationsetting.EmergencyContactDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class EmergencyContactService implements JqGridService<EmergencyContactDto> {

    private final EmergencyContactMapper emergencyContactMapper;
    private final SmsManagementMapper smsManagementMapper;

    @Override
    public List<EmergencyContactDto> getList(Map param) {
        return emergencyContactMapper.selectEmergencyContactList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return emergencyContactMapper.selectEmergencyContactListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        emergencyContactMapper.insertEmergencyContact(param);

        Map<String, Object> smsParam = new HashMap<>();
        smsParam.put("district_no", param.get("district_no"));
        smsParam.put("partner_comp_id", param.get("partner_comp_id"));
        smsParam.put("sms_recv_dept", "-");
        smsParam.put("sms_chgr_nm", param.get("emerg_chgr_nm"));
        smsParam.put("sms_recv_ph", param.get("emerg_recv_ph"));
        smsParam.put("alarm_lvl_nm", "1차 초과 이상");
        smsParam.put("sms_autosnd_yn", "N");
        smsManagementMapper.insertSmsManagement(smsParam);

        return true;
    }

    @Override
    public EmergencyContactDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        param.put("mgnt_no", Integer.parseInt(param.get("mgnt_no").toString()));
        return emergencyContactMapper.updateEmergencyContact(param) > 0;
    }

    @Override
    public int delete(Map param) {
        param.put("mgnt_no", Integer.parseInt(param.get("mgnt_no").toString()));
        return emergencyContactMapper.deleteEmergencyContact(param);
    }
}
