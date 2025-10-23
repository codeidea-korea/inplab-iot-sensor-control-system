package com.safeone.dashboard.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.ModifySensorMapper;
import com.safeone.dashboard.dto.GetModifySensorDto;
import com.safeone.dashboard.dto.SensorCountDto;
import com.safeone.dashboard.dto.SensorDto;
import com.safeone.dashboard.service.ModifySensorService;
import com.safeone.dashboard.util.CommonUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Transactional
@Service("modifySensorService")
@RequiredArgsConstructor
public class ModifySensorServiceImpl implements ModifySensorService {

    @Resource(name = "modifySensorMapper")
    private final ModifySensorMapper modifySensorMapper;

    public ObjectNode getSensor(GetModifySensorDto getModifySensorDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getModifySensorDto);
        List<HashMap<String, Object>> list = modifySensorMapper.getSensorList(map);
        int totalCnt = modifySensorMapper.getSensorListTotalCnt(map);
        an = om.valueToTree(list);

        CommonUtils.setCountInfo("list", list.size(), on);
        CommonUtils.setCountInfo("total", totalCnt, on);

        on.put("rows", an);

        return on;
    }

    public ObjectNode getDistinct() {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = new HashMap<>();
        List<HashMap<String, Object>> distinct = modifySensorMapper.getDistinctDistrict(map);
        an = om.valueToTree(distinct);
        on.put("district", an);

        List<HashMap<String, Object>> sensorType = modifySensorMapper.getDistinctSensorType(map);
        an = om.valueToTree(sensorType);
        on.put("sensor_type", an);

        return on;
    }

    @Override
    public int getSimpleTotalCount(Map param) {
        return modifySensorMapper.getSimpleTotalCount(param);
    }

    @Override
    public List<SensorDto> getAll(Map<String, Object> param) {
        return modifySensorMapper.getAll(param);
    }

    @Override
    public SensorCountDto getTotalCountByStatus(){
        return modifySensorMapper.getTotalCountByStatus();
    }
}
