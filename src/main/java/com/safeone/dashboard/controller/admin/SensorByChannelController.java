package com.safeone.dashboard.controller.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SensorDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.SensorByChannelService;
import com.safeone.dashboard.util.ExcelUtil.FieldDetails;

@Controller
@RequestMapping("/admin/sensorByChannelList")
public class SensorByChannelController extends JqGridAbstract<SensorDto> {
	@Autowired
	private SensorByChannelService sensorByChannelService;

	@Autowired
	private CommonCodeService commonCodeService;
	
	protected SensorByChannelController() {
		super(SensorDto.class);
	}
	
	@Override
	public Map<String, FieldDetails> getColumnDataJson() {

		String assetKindListStr = ":";
		List<Map> assetKindList = commonCodeService.getAssetKindList();

		for (Map ak : assetKindList) {
			assetKindListStr += ";" + (String) ak.get("code") + ":" + (String) ak.get("name");
		}

		String zoneNameListStr = ":";
		List<Map> zoneNameList = commonCodeService.getZoneList();

		for (Map zn : zoneNameList) {
			zoneNameListStr += ";" + (String) zn.get("name") + ":" + (String) zn.get("name");
		}

		Map<String, FieldDetails> result = super.getColumnDataJson();
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
	protected List getList(Map param) {
		if(param.containsKey("ch_collect_date")) {
			String[] dates = ((String)param.get("ch_collect_date")).split(" ~ ");
			if(dates.length > 1) {
				param.put("ch_collect_date_start", dates[0]);
				param.put("ch_collect_date_end", dates[1]);
			}else {
				param.put("ch_collect_date_start", dates[0]);
				param.put("ch_collect_date_end", dates[0]);
			}
		}
		return sensorByChannelService.getList(param);
	}

	@Override
	protected int getTotalCount(Map param) {
		if(param.containsKey("ch_collect_date")) {
			String[] dates = ((String)param.get("ch_collect_date")).split(" ~ ");
			if(dates.length > 1) {
				param.put("ch_collect_date_start", dates[0]);
				param.put("ch_collect_date_end", dates[1]);
			}else {
				param.put("ch_collect_date_start", dates[0]);
				param.put("ch_collect_date_end", dates[0]);
			}
		}
		return sensorByChannelService.getTotalCount(param);
	}

	@Override
	protected String setViewPage() {
		return "";
	}
}
