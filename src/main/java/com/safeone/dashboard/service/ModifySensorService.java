package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.GetModifySensorDto;

import java.util.Map;

public interface ModifySensorService {

  ObjectNode getSensor(GetModifySensorDto getModifyCctvDto);

  ObjectNode getDistinct();

    int getSimpleTotalCount(Map param);
}
