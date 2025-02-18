package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.NewDashboardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
@RequiredArgsConstructor
public class NewDashboardService {

    private final NewDashboardMapper mapper;

    public List<Map<String, Object>> getSensors(Map<String, Object> map) {
        return mapper.getSensors(map);
    }

    public List<Map<String, Object>> getSensorTypes() {
        return mapper.getSensorTypes();
    }

    public int getSensorsCount(Map<String, Object> map) {
        return mapper.getSensorsCount(map);
    }
}
