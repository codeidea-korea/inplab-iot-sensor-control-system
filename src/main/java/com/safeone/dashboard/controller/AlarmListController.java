package com.safeone.dashboard.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.AlarmListDto;
import com.safeone.dashboard.service.AlarmListService;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.util.ExcelUtil.FieldDetails;

@Controller
@RequestMapping("/alarmList")
public class AlarmListController extends JqGridAbstract<AlarmListDto> {
    @Autowired
    private AlarmListService alarmListService;

    @Autowired
    private CommonCodeService commonCodeService;

    protected AlarmListController() {
        super(AlarmListDto.class);
    }

    @Override
    public Map<String, FieldDetails> getColumnDataJson() {
        String alarmKindListStr = ":";
        String assetKindListStr = ":";

        List<Map> alarmKindList = commonCodeService.getAlarmKindList();
        for (Map ak : alarmKindList) {
            alarmKindListStr += ";" + ak.get("code") + ":" + ak.get("name");
        }

        List<Map> assetKindList = commonCodeService.getAssetKindBySensorList();
        for (Map ak : assetKindList) {
            assetKindListStr += ";" + ak.get("name") + ":" + ak.get("name");
        }

        String zoneIdListStr = ":";
        List<Map> zoneIdList = commonCodeService.getZoneList();

        for (Map zn : zoneIdList) {
            zoneIdListStr += ";" + zn.get("code") + ":" + zn.get("name");
        }

        Map<String, FieldDetails> result = super.getColumnDataJson();
        result.get("risk_level").type = this.getCommonCodeListStr("위험레벨");//risk_level
//        result.get("alarm_kind_id").type = alarmKindListStr;
//        result.get("asset_kind_name").type = assetKindListStr;
        result.get("zone_id").type = zoneIdListStr;

        return result;
    }

    private String getCommonCodeListStr(String cat) {
        String result = ":";
        Map<String, Object> pm = new HashMap<String, Object>();
        pm.put("category", cat);

        List<Map> rList = commonCodeService.getCommonCodeList(pm);
        for (Map m : rList) {
            result += ";" + m.get("code") + ":" + m.get("name");
        }

        return result;
    }

    @Override
    protected List getList(Map param) {
        if (param.containsKey("reg_day")) {
            String[] dates = ((String) param.get("reg_day")).split(" ~ ");
            if (dates.length > 1) {
                param.put("reg_date_start", dates[0]);
                param.put("reg_date_end", dates[1]);
            } else {
                param.put("reg_date_start", dates[0]);
                param.put("reg_date_end", dates[0]);
            }
        }
        return alarmListService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        if (param.containsKey("reg_day")) {
            String[] dates = ((String) param.get("reg_day")).split(" ~ ");
            if (dates.length > 1) {
                param.put("reg_date_start", dates[0]);
                param.put("reg_date_end", dates[1]);
            } else {
                param.put("reg_date_start", dates[0]);
                param.put("reg_date_end", dates[0]);
            }
        }
        return alarmListService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "alarmList";
    }


    @ResponseBody
    @GetMapping(value = "/alarmCount", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getAlarmCountByStatus(@RequestParam Map<String, Object> param) {
        return alarmListService.selectAlarmCountByStatus(param);

    }

    @ResponseBody
    @GetMapping(value = "/alarmHistory", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getAlarmHistory(@RequestParam Map<String, Object> param) {
        return alarmListService.selectAlarmHistory(param);
    }
}
