package com.safeone.dashboard.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
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
@RequestMapping("/alarmDataByLevel")
public class AlarmDataByLevelController extends JqGridAbstract<AlarmListDto> {
    @Autowired
    private AlarmListService service;

	@Autowired
	private CommonCodeService commonCodeService;

    protected AlarmDataByLevelController() {
        super(AlarmListDto.class);
    }

	@Override
	public Map<String, FieldDetails> getColumnDataJson() {
		String alarmKindListStr = ":";
		String assetKindListStr = ":";

		List<Map> alarmKindList = commonCodeService.getAlarmKindList();
		for (Map ak : alarmKindList) {
			alarmKindListStr += ";" + (String) ak.get("code") + ":" + (String) ak.get("name");
		}

		List<Map> assetKindList = commonCodeService.getAssetKindBySensorList();
		for (Map ak : assetKindList) {
			assetKindListStr += ";" + (String) ak.get("name") + ":" + (String) ak.get("name");
		}

		String zoneIdListStr = ":";
		List<Map> zoneIdList = commonCodeService.getZoneList();

		for (Map zn : zoneIdList) {
			zoneIdListStr += ";" + (String) zn.get("code") + ":" + (String) zn.get("name");
		}

		Map<String, FieldDetails> result = super.getColumnDataJson();
		((FieldDetails) result.get("risk_level")).type = this.getCommonCodeListStr("위험레벨");//risk_level
		((FieldDetails) result.get("alarm_kind_id")).type = alarmKindListStr;
		((FieldDetails) result.get("asset_kind_name")).type = assetKindListStr;
		((FieldDetails) result.get("zone_id")).type = zoneIdListStr;

		return result;
	}

	private String getCommonCodeListStr(String cat){
		StringBuilder result = new StringBuilder(":");
		Map<String,Object> pm = new HashMap<>();
		pm.put("category", cat);

		List<Map> rList = commonCodeService.getCommonCodeList(pm);
		for(Map m : rList) {
			result.append(";").append(m.get("code")).append(":").append(m.get("name"));
		}

		return result.toString();
	}

    @Override
    protected List getList(Map param) {
		if(param.containsKey("reg_day")) {
			String[] dates = ((String)param.get("reg_day")).split(" ~ ");
			if(dates.length > 1) {
				param.put("reg_date_start", dates[0]);
				param.put("reg_date_end", dates[1]);
			}else {
				param.put("reg_date_start", dates[0]);
				param.put("reg_date_end", dates[0]);
			}
		}
		return service.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
		if(param.containsKey("reg_day")) {
			String[] dates = ((String)param.get("reg_day")).split(" ~ ");
			if(dates.length > 1) {
				param.put("reg_date_start", dates[0]);
				param.put("reg_date_end", dates[1]);
			}else {
				param.put("reg_date_start", dates[0]);
				param.put("reg_date_end", dates[0]);
			}
		}
		return service.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
//        return "alarmDataByLevel";
        return "";
    }

	@ResponseBody
	@GetMapping("/li")
	public List newchartData(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		return getList(param);
	}
}
