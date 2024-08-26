package com.safeone.dashboard.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.CctvMapper;
import com.safeone.dashboard.dto.*;
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
@Service("cctvService")
@RequiredArgsConstructor
public class CctvServiceIml implements CctvService {

    @Resource(name = "cctvMapper")
    private final CctvMapper cctvMapper;

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

    public synchronized ObjectNode insCctv(List<InsAdminAddCctvDto> insAdminAddCctvDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int insCount = 0;
        int passCount = 0;

        for (InsAdminAddCctvDto dto : insAdminAddCctvDtoList) {
            Map<String, Object> newMap = new HashMap<>();
            newMap.put("table_nm", "tb_cctv_info");
            newMap.put("column_nm", "cctv_no");
            ObjectNode generationKeyOn = newGenerationKey(newMap);
            String newCctvNo = generationKeyOn.get("newId").asText();

            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            Map<String, Object> getMap = new HashMap<>();
            map.put("cctv_no", newCctvNo);
            getMap.put("cctv_no", newCctvNo);
            List<HashMap<String, Object>> list = cctvMapper.getCctvList(getMap);
            getMap.clear();
            getMap.put("cctv_nm", map.get("cctv_nm"));
            List<HashMap<String, Object>> list2 = cctvMapper.getCctvList(getMap);

            if (!list.isEmpty()) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                map.put("message", "CCTV_NO 가 " + map.get("cctv_no") + " 인 데이터가 이미 존재합니다.");
                an.add(om.valueToTree(map));
                passCount++;
                continue;
            }

            if (!list2.isEmpty()) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                map.put("message", "CCTV_NM 이 " + map.get("cctv_nm") + " 인 데이터가 이미 존재합니다.");
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

    public ObjectNode getDistrict(GetAdminAddDistrictDto getAdminAddDistrictDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getAdminAddDistrictDto);
        List<HashMap<String, Object>> list = cctvMapper.getDistrictList(map);
        int totalCnt = cctvMapper.getDistrictListTotalCnt(map);
        an = om.valueToTree(list);

        CommonUtils.setCountInfo("list", list.size(), on);
        CommonUtils.setCountInfo("total", totalCnt, on);

        on.put("rows", an);

        return on;
    }

    public ObjectNode getMaintComp(GetAdminAddMaintCompDto getAdminAddDistrictDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getAdminAddDistrictDto);
        List<HashMap<String, Object>> list = cctvMapper.getMaintCompList(map);
        int totalCnt = cctvMapper.getMaintCompListTotalCnt(map);
        an = om.valueToTree(list);

        CommonUtils.setCountInfo("list", list.size(), on);
        CommonUtils.setCountInfo("total", totalCnt, on);

        on.put("rows", an);

        return on;
    }

    public ObjectNode newGenerationKey(Map<String, Object> map) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();

        String newId = "";
        String preCode = "";

        int count = 0;
        int length = 0;

        List<HashMap<String, Object>> list = cctvMapper.getGenerationKey(map);

        if (list.size() == 1) {
            newId = CommonUtils.isNull(list.get(0).get("new_id"));
            length = Integer.parseInt(CommonUtils.isNull(list.get(0).get("length")));
            preCode = CommonUtils.isNull(list.get(0).get("pre_code"));

            if(newId.length() - preCode.length() > length) {
                // id값을 화면에서 미리 만들어서 주기에 사용안함
                if(CommonUtils.isNull(map.get("table_name")).equals("common_code_list")
                        && CommonUtils.isNull(map.get("columne_name")).equals("code_id")) {
                    cctvMapper.nextPreCodeGenerationKey(map);
                    newGenerationKey(map);
                } else {
                    on.put("code", "OVER_NUM");
                    return on;
                }
            }

            count = cctvMapper.incMaxGenerationKey(map);

            on.put("newId", newId);
        } else {
            on.put("code", "EMPTY");
        }

        CommonUtils.setCountInfo("udt", count, on);
        return on;
    }
}
