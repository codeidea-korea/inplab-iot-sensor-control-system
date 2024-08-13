package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.SmsAlarmMapper;
import com.safeone.dashboard.dto.SmsAlarmListDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class SmsAlarmService implements JqGridService<SmsAlarmListDto> {
    private final SmsAlarmMapper mapper;

    @Override
    public List<SmsAlarmListDto> getList(Map param) {
      return mapper.selectSmsAlarmList(param);
    }    

    @Override
    public int getTotalCount(Map param) {
      return mapper.selectSmsAlarmListTotal(param);
    }

    public int selectSmsCountPerDay(String phone) {
      return mapper.selectSmsCountPerDay(phone);
    }

    @Override
    public boolean create(Map param) {
      return mapper.insertSmsAlarm(param);
    }

    @Override
    public SmsAlarmListDto read(int id) {
      // TODO Auto-generated method stub
      throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
      return mapper.updateSmsAlarm(param) > 0;
    }

    @Override
    public int delete(Map param) {
      return mapper.deleteSmsAlarm(param);
    }

    public List<Map> selectAlarmInfo(Map param) {
      return mapper.selectAlarmInfo(param);
    }

    public Map selectRainGaugeInfo(Map param) {
      try {
          return mapper.selectRainGaugeInfo(param).get(0);
      } catch(Exception e) {
          return null;
      }
    }
}
