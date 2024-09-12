package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.GetModifyCctvDto;
import com.safeone.dashboard.dto.GetModifySensorDto;

public interface ModifySensorService {

  ObjectNode getSensor(GetModifySensorDto getModifyCctvDto);

  ObjectNode getDistinct();
}
