package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.CommonCodeEditMapper;
import com.safeone.dashboard.util.CommonUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class CommonCodeEditService {
    private final CommonCodeEditMapper mapper;

    public List<Map> getCommonCodeEditList(Map param) {
        return mapper.selectCommonCodeEditList(param);
    }

    public List<Map> getMaintcompInfoList(Map param) {
        return mapper.selectMaintcompInfoList(param);
    }

    public List<Map> getDistrictInfoNmAbbr(String district_nm) {
        return mapper.selectDistrictInfoNmAbbr(district_nm);
    }

    public List<Map> getSensorAbbr(Map param) {
        return mapper.selectSensorAbbr(param);
    }

    public List<Map> getNewSensorSeq(Map param) {
        return mapper.selectNewSensorSeq(param);
    }

    public List<Map> getDistrictInfoDistAbbr(Map param) {
        return mapper.selectDistrictInfoDistAbbr(param);
    }

    public String getSensorInfoNm(Map param) {
        return mapper.selectSensorInfoNm(param);
    }

    public List<Map> getDistrictInfoList() {
        return mapper.selectDistrictInfoList();
    }


    public List<Map> getLoggerInfo() {
        return mapper.selectLoggerInfo();
    }

    public List<Map> getSensorType() {
        return mapper.selectSensorType();
    }

    public List<Map> getSiteInfo() {
        return mapper.selectSiteInfo();
    }

    public List<Map> selectSiteInfoLogo() {
        return mapper.selectSiteInfoLogo();
    }


    public List<Map> getNewGenerationKey(Map param) {
        return mapper.getGenerationKey(param);
    }

    public List<Map> getLoggerInfoLogrNo(Map param) {
        return mapper.selectLoggerInfoLogrNo(param);
    }


    public List<Map> getSensorTypeSenstypeNo(Map param) {
        return mapper.selectSensorTypeSenstypeNo(param);
    }

    public ObjectNode newGenerationKey(Map<String, Object> map) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();

        String newId = "";
        String preCode = "";

        int count = 0;
        int length = 0;

        List<Map> list = mapper.getGenerationKey(map);

        if (list.size() == 1) {
            newId = CommonUtils.isNull(list.get(0).get("new_id"));
            length = Integer.parseInt(CommonUtils.isNull(list.get(0).get("length")));
            preCode = CommonUtils.isNull(list.get(0).get("pre_code"));

            if (newId.length() - preCode.length() > length) {
                // id값을 화면에서 미리 만들어서 주기에 사용안함
                if (CommonUtils.isNull(map.get("table_name")).equals("common_code_list")
                        && CommonUtils.isNull(map.get("columne_name")).equals("code_id")) {
                    mapper.nextPreCodeGenerationKey(map);
                    newGenerationKey(map);
                } else {
                    on.put("code", "OVER_NUM");
                    return on;
                }
            }

            count = mapper.incMaxGenerationKey(map);

            on.put("newId", newId);
        } else {
            on.put("code", "EMPTY");
        }

        CommonUtils.setCountInfo("udt", count, on);
        return on;
    }

    public boolean isLoggerNoExists(Map param) {
        return mapper.isLoggerNoExists(param);
    }

    public boolean isSensNoExists(Map param) {
        return mapper.isSensNoExists(param);
    }

    public boolean isLogrIdxNoExists(Map param) {
        return mapper.isLogrIdxNoExists(param);
    }


}
