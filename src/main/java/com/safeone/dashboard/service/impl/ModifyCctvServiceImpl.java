package com.safeone.dashboard.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.CctvListMapper;
import com.safeone.dashboard.dao.CctvMapper;
import com.safeone.dashboard.dto.*;
import com.safeone.dashboard.service.CctvListService;
import com.safeone.dashboard.service.CctvService;
import com.safeone.dashboard.service.ModifyCctvService;
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
@Service("modifyCctvService")
@RequiredArgsConstructor
public class ModifyCctvServiceImpl implements ModifyCctvService {

    @Resource(name = "cctvListMapper")
    private final CctvListMapper cctvListMapper;

    public ObjectNode getCctv(GetModifyCctvDto getModifyCctvDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getModifyCctvDto);
        List<CctvListDto> list = cctvListMapper.selectCctvList(map);
        int totalCnt = cctvListMapper.selectCctvListTotal(map);
        an = om.valueToTree(list);

        CommonUtils.setCountInfo("list", list.size(), on);
        CommonUtils.setCountInfo("total", totalCnt, on);

        on.put("rows", an);

        return on;
    }
}
