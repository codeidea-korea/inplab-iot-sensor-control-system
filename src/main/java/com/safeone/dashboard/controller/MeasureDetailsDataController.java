package com.safeone.dashboard.controller;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.MeasureDetailsDataDto;
import com.safeone.dashboard.service.MeasureDetailsDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/measure-details-data")
public class MeasureDetailsDataController extends JqGridAbstract<MeasureDetailsDataDto> {
	@Autowired
	private MeasureDetailsDataService measureDetailsDataService;

	protected MeasureDetailsDataController() {
		super(MeasureDetailsDataDto.class);
	}

	@Override
	protected List getList(Map param) {
		return measureDetailsDataService.getList(param);
	}

//	@GetMapping("/chart")
//	@ResponseBody
//	public List<SensorChartDto> getChartData(@RequestParam Map<String, Object> param) {
//		System.out.println("param = " + param);
//		return measureDetailsDataService.getSensorChartData(param);
//	}

	@Override
	protected int getTotalRows(Map param) {
		return measureDetailsDataService.getTotalCount(param);
	}

	@Override
	protected String setViewPage() {
		return "measure-details-data";
	}
}
