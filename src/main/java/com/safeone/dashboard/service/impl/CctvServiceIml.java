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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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

    public ObjectNode insCctv(InsAdminAddCctvDto insAdminAddCctvDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int insCount = 0;
        int passCount = 0;
        /*
        for (InsCodeDTO dto : insCodeDTOList) {
            CommonUtil.dtoSetInsInfo(dto, jwtTokenProvider);
            Map<String, Object> map = CommonUtil.dtoToMap(dto);
            List<HashMap<String, Object>> list = commonDAO.getCodeList(map);

            if (!list.isEmpty()) {
                map.put("message", messageSource.getMessage("common.msg.01", null, Locale.getDefault()));
                an.add(om.valueToTree(map));
                passCount++;
                continue;
            }

            insCount += commonDAO.insCode(map);
        }

        CommonUtil.setCountInfo("ins", insCount, on);
        CommonUtil.setCountInfo("pass", passCount, on);
        */
        on.put("pass_list", an);

        return on;
    }

    public ObjectNode udtCctv(List<UdtAdminAddCctvDto> udtAdminAddCctvDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int count = 0;
        /*
        for (UdtCodeDTO dto : udtCodeDTOList) {
            CommonUtil.dtoSetUdtInfo(dto, jwtTokenProvider);
            Map<String, Object> map = CommonUtil.dtoToMap(dto);
            count += commonDAO.udtCode(map);
        }

        CommonUtil.setCountInfo("udt", count, on);
        */
        return on;
    }

    public ObjectNode delCctv(DelAdminAddCctvDto delAdminAddCctvDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int count = 0;
        /*
        for (DelCodeDTO dto : delCodeDTOList) {
            Map<String, Object> map = CommonUtil.dtoToMap(dto);
            count += commonDAO.delCode(map);
        }

        CommonUtil.setCountInfo("del", count, on);
        */
        return on;
    }
}
