package com.safeone.dashboard.service.operationconfigurationsetting;

import com.safeone.dashboard.dao.operationconfigurationsetting.SmsManagementMapper;
import com.safeone.dashboard.dto.operationconfigurationsetting.SmsManagementDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class SmsManagementService implements JqGridService<SmsManagementDto> {

    private final SmsManagementMapper mapper;

    @Override
    public List<SmsManagementDto> getList(Map param) {
        return mapper.selectSmsManagementList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectSmsManagementListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertSmsManagement(param) > 0;
    }

    @Override
    public SmsManagementDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        param.put("mgnt_no", Integer.parseInt(param.get("mgnt_no").toString()));
        return mapper.updateSmsManagement(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteSmsManagement(param);
    }
}
