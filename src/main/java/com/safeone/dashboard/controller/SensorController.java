package com.safeone.dashboard.controller;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SensorDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.SensorService;
import com.safeone.dashboard.util.ExcelUtils.FieldDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
		Map<String, FieldDetails> result = super.getColumnDataJson();
		((FieldDetails) result.get("ch_collect_date")).type = "hidden";

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
