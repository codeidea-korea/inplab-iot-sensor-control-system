package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.SensorGroupingMapper;
import com.safeone.dashboard.dto.SensorChartDto;
import com.safeone.dashboard.dto.SensorGroupingDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SensorGroupingService implements JqGridService<SensorGroupingDto> {

    private final SensorGroupingMapper mapper;

    @Override
    public List<SensorGroupingDto> getList(Map<String, Object> param) {
        return mapper.selectList(param);
    }

    @Override
    public int getTotalCount(Map<String, Object> param) {
        return mapper.selectListTotal(param);
    }

    @Override
    public boolean create(Map<String, Object> param) {
        return mapper.insert(param) > 0;
    }

    @Override
    public SensorGroupingDto read(int id) {
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map<String, Object> param) {
        return mapper.update(param) > 0;
    }

    @Override
    public int delete(Map<String, Object> param) {
        return mapper.delete(param);
    }

    public List<SensorChartDto> getSensorChartData(Map<String, Object> param) {
        return mapper.selectSensorChartData(param);
    }
}
