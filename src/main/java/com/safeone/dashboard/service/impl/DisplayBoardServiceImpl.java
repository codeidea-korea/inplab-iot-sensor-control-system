package com.safeone.dashboard.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.DisplayBoardMapper;
import com.safeone.dashboard.dto.DelAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.GetAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.InsAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.UdtAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.displayconnection.DisplayBoardDto;
import com.safeone.dashboard.service.DisplayBoardService;
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
@Service("displayBoardService")
@RequiredArgsConstructor
public class DisplayBoardServiceImpl implements DisplayBoardService {

    @Resource(name = "displayBoardMapper")
    private final DisplayBoardMapper displayBoardMapper;

    public ObjectNode getDisplayBoard(GetAdminAddDisplayBoardDto getAdminAddDisplayBoardDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getAdminAddDisplayBoardDto);
        List<HashMap<String, Object>> list = displayBoardMapper.getDisplayBoardList(map);
        int totalCnt = displayBoardMapper.getDisplayBoardListTotalCnt(map);
        an = om.valueToTree(list);

        CommonUtils.setCountInfo("list", list.size(), on);
        CommonUtils.setCountInfo("total", totalCnt, on);

        on.put("rows", an);

        return on;
    }

    public synchronized ObjectNode insDisplayBoard(List<InsAdminAddDisplayBoardDto> insAdminAddDisplayBoardDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int insCount = 0;
        int passCount = 0;

        for (InsAdminAddDisplayBoardDto dto : insAdminAddDisplayBoardDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            String dispbdNo = map.get("dispbd_no") == null ? "" : map.get("dispbd_no").toString();
            if (dispbdNo.isBlank()) {
                map.put("dispbd_no", getNextDisplayBoardNo());
            }
            Map<String, Object> getMap = new HashMap<>();
            getMap.put("dispbd_no", map.get("dispbd_no"));
            List<HashMap<String, Object>> list = displayBoardMapper.getDisplayBoardList(getMap);
            getMap.clear();
            getMap.put("dispbd_nm", map.get("dispbd_nm"));
            List<HashMap<String, Object>> list2 = displayBoardMapper.getDisplayBoardList(getMap);

            if (!list.isEmpty()) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                map.put("message", "전광판 아이디가 " + map.get("dispbd_no") + " 인 데이터가 이미 존재합니다.");
                an.add(om.valueToTree(map));
                passCount++;
                continue;
            }

            if (!list2.isEmpty()) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                map.put("message", "전광판명이 " + map.get("dispbd_nm") + " 인 데이터가 이미 존재합니다.");
                an.add(om.valueToTree(map));
                passCount++;
                continue;
            }

            insCount += displayBoardMapper.insDisplayBoard(map);
        }

        CommonUtils.setCountInfo("ins", insCount, on);
        CommonUtils.setCountInfo("pass", passCount, on);

        on.put("pass_list", an);

        return on;
    }

    private String getNextDisplayBoardNo() {
        String maxNo = displayBoardMapper.getMaxDispbdNo();
        if (maxNo == null || maxNo.isBlank()) {
            return "P01";
        }
        String prefix = maxNo.substring(0, 1);
        int number = Integer.parseInt(maxNo.substring(1)) + 1;
        return prefix + String.format("%02d", number);
    }

    public ObjectNode udtDisplayBoard(List<UdtAdminAddDisplayBoardDto> udtAdminAddDisplayBoardDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int count = 0;

        for (UdtAdminAddDisplayBoardDto dto : udtAdminAddDisplayBoardDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            count += displayBoardMapper.udtDisplayBoard(map);
        }

        CommonUtils.setCountInfo("udt", count, on);

        return on;
    }

    public ObjectNode delDisplayBoard(List<DelAdminAddDisplayBoardDto> delAdminAddDisplayBoardDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int count = 0;

        for (DelAdminAddDisplayBoardDto dto : delAdminAddDisplayBoardDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            count += displayBoardMapper.delDisplayBoard(map);
        }

        CommonUtils.setCountInfo("del", count, on);

        return on;
    }

    @Override
    public List<DisplayBoardDto> all(Map<String, Object> param) {
        return displayBoardMapper.all(param);
    }

    @Override
    public int sendHistory(Map<String, Object> param) {
        log.warn("display-send-management send API stores history only. interface module integration is pending. param={}", param);
        if (param.get("dispbd_evnt_flag").equals("2") || Integer.parseInt(param.get("dispbd_evnt_flag").toString()) == 2) {
            param.put("dispbd_autosnd_yn", "Y");
        } else {
            param.put("dispbd_autosnd_yn", "N");
        }
        return displayBoardMapper.sendHistory(param);
    }

    @Override
    public String getMaxDispbdNo() {
        String maxNo = displayBoardMapper.getMaxDispbdNo();
        if (maxNo == null || maxNo.isBlank()) {
            return "P00";
        }
        return maxNo;
    }
}
