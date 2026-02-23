package com.safeone.dashboard.service.operationconfigurationsetting;

import com.safeone.dashboard.dao.operationconfigurationsetting.EmergencyContactMapper;
import com.safeone.dashboard.dao.operationconfigurationsetting.SmsManagementMapper;
import com.safeone.dashboard.dto.operationconfigurationsetting.EmergencyContactDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
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
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    public boolean create(Map param) {
        normalizePartnerComp(param);
        emergencyContactMapper.insertEmergencyContact(param);

        Map<String, Object> smsParam = new HashMap<>();
        smsParam.put("district_no", param.get("district_no"));
        smsParam.put("partner_comp_id", "");
        smsParam.put("sms_recv_dept", param.get("partner_comp_id"));
        smsParam.put("sms_chgr_nm", param.get("emerg_chgr_nm"));
        smsParam.put("sms_recv_ph", param.get("emerg_recv_ph"));
        smsParam.put("alarm_lvl_nm", "1차 초과 이상");
        smsParam.put("sms_autosnd_yn", "N");
        try {
            smsManagementMapper.insertSmsManagement(smsParam);
        } catch (DuplicateKeyException e) {
            // Already exists (district_no + phone). Ignore to avoid rolling back emergency contact insert.
            log.info("SMS receiver already exists. district_no={}, sms_recv_ph={}", smsParam.get("district_no"), smsParam.get("sms_recv_ph"));
        } catch (Exception e) {
            // Emergency contact save must not fail because SMS receiver sync failed (schema mismatch, etc.).
            log.warn("Failed to sync SMS receiver after emergency contact insert. district_no={}, sms_recv_ph={}",
                    smsParam.get("district_no"), smsParam.get("sms_recv_ph"), e);
        }

        return true;
    }

    @Override
    public EmergencyContactDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        normalizePartnerComp(param);
        param.put("mgnt_no", Integer.parseInt(param.get("mgnt_no").toString()));
        return emergencyContactMapper.updateEmergencyContact(param) > 0;
    }

    @Override
    public int delete(Map param) {
        param.put("mgnt_no", Integer.parseInt(param.get("mgnt_no").toString()));
        return emergencyContactMapper.deleteEmergencyContact(param);
    }

    private void normalizePartnerComp(Map param) {
        if (param.get("partner_comp_id") == null && param.get("partner_comp_nm") != null) {
            param.put("partner_comp_id", param.get("partner_comp_nm"));
        }
    }
}
