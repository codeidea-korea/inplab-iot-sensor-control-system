package com.safeone.dashboard.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.CctvMapper;
import com.safeone.dashboard.dto.DelAdminAddCctvDto;
import com.safeone.dashboard.dto.GetAdminAddCctvDto;
import com.safeone.dashboard.dto.InsAdminAddCctvDto;
import com.safeone.dashboard.dto.UdtAdminAddCctvDto;
import com.safeone.dashboard.service.CctvService;
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
@Service("cctvService")
@RequiredArgsConstructor
public class CctvServiceIml implements CctvService {

    @Resource(name = "cctvMapper")
    private final CctvMapper cctvMapper;

    //private final JwtTokenProvider jwtTokenProvider;

    public ObjectNode getCctv(GetAdminAddCctvDto getAdminAddCctvDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getAdminAddCctvDto);
        List<HashMap<String, Object>> list = cctvMapper.getCctvList(map);
        int totalCnt = cctvMapper.getCctvListTotalCnt(map);
        an = om.valueToTree(list);

        CommonUtils.setCountInfo("list", list.size(), on);
        CommonUtils.setCountInfo("total", totalCnt, on);

        on.put("rows", an);

        return on;
    }

    public ObjectNode insCctv(List<InsAdminAddCctvDto> insAdminAddCctvDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int insCount = 0;
        int passCount = 0;

        for (InsAdminAddCctvDto dto : insAdminAddCctvDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            List<HashMap<String, Object>> list = cctvMapper.getCctvList(map);

            if (!list.isEmpty()) {
                map.put("message", "CCTV_NO 가 " + map.get("cctv_no") + " 인 데이터가 이미 존재합니다.");
                an.add(om.valueToTree(map));
                passCount++;
                continue;
            }

            insCount += cctvMapper.insCctv(map);
        }

        CommonUtils.setCountInfo("ins", insCount, on);
        CommonUtils.setCountInfo("pass", passCount, on);

        on.put("pass_list", an);

        return on;
    }

    public ObjectNode udtCctv(List<UdtAdminAddCctvDto> udtAdminAddCctvDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int count = 0;

        for (UdtAdminAddCctvDto dto : udtAdminAddCctvDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            count += cctvMapper.udtCctv(map);
        }

        CommonUtils.setCountInfo("udt", count, on);

        return on;
    }

    public ObjectNode delCctv(List<DelAdminAddCctvDto> delAdminAddCctvDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int count = 0;

        for (DelAdminAddCctvDto dto : delAdminAddCctvDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            count += cctvMapper.delCctv(map);
        }

        CommonUtils.setCountInfo("del", count, on);

        return on;
    }
}
