package com.safeone.dashboard.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SensorDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.SensorService;
import com.safeone.dashboard.util.ExcelUtil.FieldDetails;

@Controller
@RequestMapping("/sensorList")
public class SensorController extends JqGridAbstract<SensorDto> {
	@Autowired
	private SensorService sensorService;

	@Autowired
	private CommonCodeService commonCodeService;

	protected SensorController() {
		super(SensorDto.class);
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
		((FieldDetails) result.get("ch_collect_date")).type = "hidden";
		((FieldDetails) result.get("status")).type = this.getCommonCodeListStr("센서상태");// type
		((FieldDetails) result.get("asset_kind_id")).type = assetKindListStr;// asset_kind
		((FieldDetails) result.get("zone_name")).type = zoneNameListStr;// zone_name

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
	protected List getList(Map param) {
		if (param.containsKey("collect_date")) {
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
		return sensorService.getList(param);
	}

	@Override
	protected int getTotalRows(Map param) {
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
		return sensorService.getTotalCount(param);
	}

	@Override
	protected String setViewPage() {
		return "sensorList";
	}
}
