package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.GetModifySensorDto;
import com.safeone.dashboard.dto.SensorCountDto;
import com.safeone.dashboard.dto.SensorDto;

import java.util.List;
import java.util.Map;

public interface ModifySensorService {

  ObjectNode getSensor(GetModifySensorDto getModifyCctvDto);

  ObjectNode getDistinct();

    int getSimpleTotalCount(Map param);

    List<SensorDto> getAll(Map<String, Object> param);

    SensorCountDto getTotalCountByStatus();
}
