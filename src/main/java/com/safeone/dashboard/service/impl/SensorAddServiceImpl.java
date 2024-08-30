package com.safeone.dashboard.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.CctvMapper;
import com.safeone.dashboard.dao.SensorAddMapper;
import com.safeone.dashboard.dto.*;
import com.safeone.dashboard.service.CctvService;
import com.safeone.dashboard.service.SensorAddService;
import com.safeone.dashboard.util.CommonUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Transactional
@Service("sensorAddService")
@RequiredArgsConstructor
public class SensorAddServiceImpl implements SensorAddService {

    @Resource(name = "sensorAddMapper")
    private final SensorAddMapper sensorAddMapper;

    public ObjectNode getSensor(GetAdminAddSensorDto getAdminAddSensorDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getAdminAddSensorDto);
        List<HashMap<String, Object>> list = sensorAddMapper.getSensorList(map);
        int totalCnt = sensorAddMapper.getSensorListTotalCnt(map);
        an = om.valueToTree(list);

        CommonUtils.setCountInfo("list", list.size(), on);
        CommonUtils.setCountInfo("total", totalCnt, on);

        on.put("rows", an);

        return on;
    }

    public ObjectNode getMeasureDetails(GetAdminAddMeasureDetailsDto getAdminAddSensorDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getAdminAddSensorDto);
        List<HashMap<String, Object>> list = sensorAddMapper.getMeasureDetailsList(map);
        int totalCnt = sensorAddMapper.getMeasureDetailsListTotalCnt(map);
        an = om.valueToTree(list);

        CommonUtils.setCountInfo("list", list.size(), on);
        CommonUtils.setCountInfo("total", totalCnt, on);

        on.put("rows", an);

        return on;
    }

    public ObjectNode actUdtIns(InsAdminAddMeasureDetailsDto getAdminAddSensorDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getAdminAddSensorDto);
        List<HashMap<String, Object>> insArr = getAdminAddSensorDto.getIns_arr();
        List<String> delArr = getAdminAddSensorDto.getDel_arr();

        int insCount = 0;
        int delCount = 0;

        for (HashMap<String, Object> insMap : insArr) {
            insCount += sensorAddMapper.insMeasureDetails(insMap);
        }

        for (String mgntNo : delArr) {
            map.put("mgnt_no", mgntNo);
            delCount += sensorAddMapper.delMeasureDetails(map);
        }

        CommonUtils.setCountInfo("ins", insCount, on);
        CommonUtils.setCountInfo("del", delCount, on);

        return on;
    }
}
