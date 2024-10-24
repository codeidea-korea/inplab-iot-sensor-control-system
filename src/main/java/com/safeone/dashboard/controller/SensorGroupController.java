package com.safeone.dashboard.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.gson.Gson;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SensorGroupDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.DashboardService;
import com.safeone.dashboard.service.SensorGroupService;
import com.safeone.dashboard.util.ExcelUtil;
import com.safeone.dashboard.util.ExcelUtil.FieldDetails;

@Controller
@RequestMapping("/sensorGroup")
public class SensorGroupController extends JqGridAbstract<SensorGroupDto> {
	@Autowired
	private SensorGroupService sensorGroupService;

	@Autowired
	private CommonCodeService commonCodeService;

	@Autowired
	private DashboardService dashboardService;

	protected SensorGroupController() {
		super(SensorGroupDto.class);
	}

	@Override
	public Map<String, FieldDetails> getColumnDataJson() {

		String assetKindListStr = ":";
		List<Map> assetKindList = commonCodeService.getAssetKindBySensorList();

		for (Map ak : assetKindList) {
			assetKindListStr += ";" + (String) ak.get("code") + ":" + (String) ak.get("name");
		}

		String zoneNameListStr = ":";
		List<Map> zoneNameList = commonCodeService.getZoneList();

		for (Map zn : zoneNameList) {
			zoneNameListStr += ";" + (String) zn.get("name") + ":" + (String) zn.get("name");
		}

		Map<String, FieldDetails> result = super.getColumnDataJson();
		result.get("ch_collect_date").type = "hidden";
		result.get("status").type = this.getCommonCodeListStr("센서상태");// type
		result.get("asset_kind_id").type = assetKindListStr;// asset_kind
		result.get("zone_name").type = zoneNameListStr;// zone_name

		return result;
	}

	private String getCommonCodeListStr(String cat) {
		String result = ":";
		Map<String, Object> pm = new HashMap<String, Object>();
		pm.put("category", cat);

		List<Map> rList = commonCodeService.getCommonCodeList(pm);
		for (Map m : rList) {
			result += ";" + String.valueOf(m.get("code")) + ":" + String.valueOf(m.get("name"));
		}

		return result;
	}

	@Override
	public void downloadExcel(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, @PathVariable String fileName) {
        String[] asset_ids = (new Gson()).fromJson(param.get("asset_ids").toString(), String[].class);
        param.put("asset_ids", asset_ids);
        param.put("page", "0");
        List<Map> list = dashboardService.selectSensorChartData(param);

        String[] fields = new String[]{"asset_kind_name", "asset_name", "channel_name", "data_time", "start_value", "end_value", "min_value", "max_value", "avg_value"};
        String[] headers = new String[]{"센서종류", "센서명", "채널명", "데이터시간", "시작값", "종료값", "최소값", "최대값", "센서값(평균)"};

        ExcelUtil.downloadExcel(request, response, list, fields, headers, fileName + ".xls");
    }

	@Override
	protected List getList(Map param) {
		param.put("page", "0");
		if(param.containsKey("collect_date")) {
			String[] dates = ((String)param.get("collect_date")).split(" ~ ");
			if(dates.length > 1) {
				param.put("collect_date_start", dates[0]);
				param.put("collect_date_end", dates[1]);
			}else {
				param.put("collect_date_start", dates[0]);  
				param.put("collect_date_end", dates[0]);
			}
		} else if(param.containsKey("install_date")) {
			String[] dates = ((String)param.get("install_date")).split(" ~ ");
			if(dates.length > 1) {
				param.put("install_date_start", dates[0]);
				param.put("install_date_end", dates[1]);
			}else {
				param.put("install_date_start", dates[0]);
				param.put("install_date_end", dates[0]);
			}
		}
		return sensorGroupService.getList(param);
	}

	@Override
	protected int getTotalCount(Map param) {
		if(param.containsKey("collect_date")) {
			String[] dates = ((String)param.get("collect_date")).split(" ~ ");
			if(dates.length > 1) {
				param.put("collect_date_start", dates[0]);
				param.put("collect_date_end", dates[1]);
			}else {
				param.put("collect_date_start", dates[0]);
				param.put("collect_date_end", dates[0]);
			}
		} else if(param.containsKey("install_date")) {
			String[] dates = ((String)param.get("install_date")).split(" ~ ");
			if(dates.length > 1) {
				param.put("install_date_start", dates[0]);
				param.put("install_date_end", dates[1]);
			}else {
				param.put("install_date_start", dates[0]);
				param.put("install_date_end", dates[0]);
			}
		}
		return sensorGroupService.getTotalCount(param);
	}

	@Override
	protected String setViewPage() {
		return "sensorGroup";
	}
}
