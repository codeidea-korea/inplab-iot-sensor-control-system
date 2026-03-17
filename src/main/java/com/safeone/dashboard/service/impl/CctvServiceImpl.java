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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Slf4j
@Transactional
@Service("cctvService")
@RequiredArgsConstructor
public class CctvServiceImpl implements CctvService {

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
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            String newCctvNo = map.get("cctv_no") == null ? "" : map.get("cctv_no").toString().trim();
            if (newCctvNo.isEmpty()) {
                newCctvNo = getNextCctvNo();
            }

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

            /* etc1, etc3 setting */
            map = setEtc(map);

            insCount += cctvMapper.insCctv(map);
        }

        CommonUtils.setCountInfo("ins", insCount, on);
        CommonUtils.setCountInfo("pass", passCount, on);

        on.put("pass_list", an);

        return on;
    }

    public Map<String, Object> setEtc(Map<String, Object> map) {
        String etc1 = "rtsp://" + map.get("cctv_conn_id") + ":" + map.get("cctv_conn_pwd") + "@" + map.get("cctv_ip") + ":" + map.get("rtsp_port") + "/profile2/media.smp";
        String etc3 = "http://" + map.get("cctv_ip") + ":" + map.get("web_port");

        map.put("etc1", etc1);
        map.put("etc3", etc3);

        return map;
    }

    public ObjectNode udtCctv(List<UdtAdminAddCctvDto> udtAdminAddCctvDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int count = 0;

        for (UdtAdminAddCctvDto dto : udtAdminAddCctvDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);

            /* etc1, etc3 setting */
            map = setEtc(map);

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

    @Override
    public String getNextCctvNo() {
        String maxNo = cctvMapper.getMaxNo();
        if (maxNo == null || maxNo.trim().isEmpty()) {
            return "CCTV01";
        }
        Matcher matcher = Pattern.compile("^(.*?)(\\d+)$").matcher(maxNo.trim());
        if (!matcher.matches()) {
            return maxNo.trim() + "01";
        }
        String prefix = matcher.group(1);
        String numericPart = matcher.group(2);
        int number = Integer.parseInt(numericPart) + 1;
        return prefix + String.format("%0" + numericPart.length() + "d", number);
    }
}
