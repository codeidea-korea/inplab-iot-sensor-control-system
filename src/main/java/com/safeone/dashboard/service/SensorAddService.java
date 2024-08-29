package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.*;

import java.util.List;
import java.util.Map;

public interface SensorAddService {

  ObjectNode getSensor(GetAdminAddSensorDto getAdminAddSensorDto);

  ObjectNode getMeasureDetails(GetAdminAddMeasureDetailsDto getAdminAddSensorDto);
}
