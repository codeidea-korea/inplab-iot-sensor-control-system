package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.*;

import java.util.List;
import java.util.Map;

public interface ModifyCctvService {

  ObjectNode getCctv(GetModifyCctvDto getModifyCctvDto);

    String operation(Map<String, Object> param);

    String getPresetList(Map<String, Object> param);

    String changePreset(Map<String, Object> param);
}
