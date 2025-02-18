package com.safeone.dashboard.dao;

import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface NewDashboardMapper {

    List<Map<String, Object>> getSensors(Map<String, Object> map);

    int getSensorsCount(Map<String, Object> map);

    List<Map<String, Object>> getSensorTypes();
}
