package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.AlarmRangeMapper;
import com.safeone.dashboard.dto.AlarmRangeDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class AlarmRangeService implements JqGridService<AlarmRangeDto> {

    private final AlarmRangeMapper mapper;

    @Override
    public List<AlarmRangeDto> getList(Map param) {
        return mapper.selectAlarmRangeList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectAlarmRangeListTotal(param);
    }

    @Override
    public boolean create(Map param) {
    	throw new UnsupportedOperationException("Unimplemented method 'create'");
    }

    @Override
    public AlarmRangeDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateAlarmRange(param) > 0;
    }

    @Override
    public int delete(Map param) {
    	throw new UnsupportedOperationException("Unimplemented method 'delete'");
    }

}
