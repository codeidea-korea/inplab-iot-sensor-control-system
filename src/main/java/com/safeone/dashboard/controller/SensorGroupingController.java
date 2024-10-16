package com.safeone.dashboard.controller;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SensorChartDto;
import com.safeone.dashboard.dto.SensorGroupingDto;
import com.safeone.dashboard.service.SensorGroupingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/sensor-grouping")
public class SensorGroupingController extends JqGridAbstract<SensorGroupingDto> {
	@Autowired
	private SensorGroupingService sensorGroupingService;

	protected SensorGroupingController() {
		super(SensorGroupingDto.class);
	}

	@Override
	protected List getList(Map param) {
		return sensorGroupingService.getList(param);
	}

	@GetMapping("/chart")
	@ResponseBody
	public List<SensorChartDto> getChartData(@RequestParam Map<String, Object> param) {
		System.out.println("param = " + param);
		return sensorGroupingService.getSensorChartData(param);
	}

	@Override
	protected int getTotalRows(Map param) {
		return sensorGroupingService.getTotalCount(param);
	}

	@Override
	protected String setViewPage() {
		return "sensor-grouping";
	}
}
