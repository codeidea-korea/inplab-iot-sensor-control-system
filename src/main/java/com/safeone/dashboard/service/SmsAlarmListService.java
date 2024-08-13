package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.SmsAlarmMapper;
import com.safeone.dashboard.dto.SendMessageDto;
import com.safeone.dashboard.dto.SmsAlarmListDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class SmsAlarmListService implements JqGridService<SmsAlarmListDto> {
    private final SmsAlarmMapper mapper;
    private final SmsService smsService;

    @Override
    public List<SmsAlarmListDto> getList(Map param) {
        return mapper.selectSmsAlarmList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectSmsAlarmListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        throw new UnsupportedOperationException("Unimplemented method 'create'");//return false;
    }

    @Override
    public SmsAlarmListDto read(int id) {
        throw new UnsupportedOperationException("Unimplemented method 'read'");//return null;
    }

    @Override
    public boolean update(Map param) {
        throw new UnsupportedOperationException("Unimplemented method 'update'");//return false;
    }

    @Override
    public int delete(Map param) {
        throw new UnsupportedOperationException("Unimplemented method 'delete'");//return 0;
    }

    public void send(SendMessageDto param) {
        for (SmsAlarmListDto sms: param.getSendList()) {
            smsService.send(sms.getPhone().replaceAll("\\D", ""), param.getSendMessage());
        }
    }
}