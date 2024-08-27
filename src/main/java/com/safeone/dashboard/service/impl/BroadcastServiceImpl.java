package com.safeone.dashboard.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.BroadcastMapper;
import com.safeone.dashboard.dto.*;
import com.safeone.dashboard.service.BroadcastService;
import com.safeone.dashboard.service.CctvService;
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
@Service("broadcastService")
@RequiredArgsConstructor
public class BroadcastServiceImpl implements BroadcastService {

    private final CctvService cctvService;

    @Resource(name = "broadcastMapper")
    private final BroadcastMapper broadcastMapper;

    public ObjectNode getBroadcast(GetAdminAddBroadcastDto getAdminAddBroadcastDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getAdminAddBroadcastDto);
        List<HashMap<String, Object>> list = broadcastMapper.getBroadcastList(map);
        int totalCnt = broadcastMapper.getBroadcastListTotalCnt(map);
        an = om.valueToTree(list);

        CommonUtils.setCountInfo("list", list.size(), on);
        CommonUtils.setCountInfo("total", totalCnt, on);

        on.put("rows", an);

        return on;
    }

    public synchronized ObjectNode insBroadcast(List<InsAdminAddBroadcastDto> insAdminAddBroadcastDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int insCount = 0;
        int passCount = 0;

        for (InsAdminAddBroadcastDto dto : insAdminAddBroadcastDtoList) {
            Map<String, Object> newMap = new HashMap<>();
            newMap.put("table_nm", "tb_broadcast_info");
            newMap.put("column_nm", "brdcast_no");
            ObjectNode generationKeyOn = cctvService.newGenerationKey(newMap);
            String newBroadcastNo = generationKeyOn.get("newId").asText();

            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            Map<String, Object> getMap = new HashMap<>();
            map.put("brdcast_no", newBroadcastNo);
            getMap.put("brdcast_no", newBroadcastNo);
            List<HashMap<String, Object>> list = broadcastMapper.getBroadcastList(getMap);
            getMap.clear();
            getMap.put("brdcast_nm", map.get("brdcast_nm"));
            List<HashMap<String, Object>> list2 = broadcastMapper.getBroadcastList(getMap);

            if (!list.isEmpty()) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                map.put("message", "방송장비 아이디가 " + map.get("brdcast_no") + " 인 데이터가 이미 존재합니다.");
                an.add(om.valueToTree(map));
                passCount++;
                continue;
            }

            if (!list2.isEmpty()) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                map.put("message", "방송장비명이 " + map.get("brdcast_nm") + " 인 데이터가 이미 존재합니다.");
                an.add(om.valueToTree(map));
                passCount++;
                continue;
            }

            insCount += broadcastMapper.insBroadcast(map);
        }

        CommonUtils.setCountInfo("ins", insCount, on);
        CommonUtils.setCountInfo("pass", passCount, on);

        on.put("pass_list", an);

        return on;
    }

    public ObjectNode udtBroadcast(List<UdtAdminAddBroadcastDto> udtAdminAddBroadcastDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int count = 0;

        for (UdtAdminAddBroadcastDto dto : udtAdminAddBroadcastDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            count += broadcastMapper.udtBroadcast(map);
        }

        CommonUtils.setCountInfo("udt", count, on);

        return on;
    }

    public ObjectNode delBroadcast(List<DelAdminAddBroadcastDto> delAdminAddBroadcastDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int count = 0;

        for (DelAdminAddBroadcastDto dto : delAdminAddBroadcastDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            count += broadcastMapper.delBroadcast(map);
        }

        CommonUtils.setCountInfo("del", count, on);

        return on;
    }
}
