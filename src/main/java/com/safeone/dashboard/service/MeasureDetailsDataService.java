package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.MeasureDetailsDataMapper;
import com.safeone.dashboard.dto.MeasureDetailsDataDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class MeasureDetailsDataService implements JqGridService<MeasureDetailsDataDto> {

    private final MeasureDetailsDataMapper mapper;

    @Override
    public List<MeasureDetailsDataDto> getList(Map param) {
        return mapper.selectList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insert(param) > 0;
    }

    @Override
    public MeasureDetailsDataDto read(int id) {
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.update(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.delete(param);
    }

//    public List<SensorChartDto> getSensorChartData(Map param) {
//        return mapper.selectSensorChartData(param);
//    }
}
