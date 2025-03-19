package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.NewDashboardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
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

    public List<Map<String, Object>> getAssetTypes() {
        List<Map<String, Object>> assetTypes = new ArrayList<>();
        assetTypes.addAll(mapper.getSensorTypes());
        return assetTypes;
    }

    public int getSensorsCount(Map<String, Object> map) {
        return mapper.getSensorsCount(map);
    }

    public int getCctvsCount(Map<String, Object> map) {
        return mapper.getCctvsCount(map);
    }

    public List<Map<String, Object>> getCctvs(Map<String, Object> map) {
        return mapper.getCctvs(map);
    }
}
