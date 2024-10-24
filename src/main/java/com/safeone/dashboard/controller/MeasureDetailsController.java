package com.safeone.dashboard.controller;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.MeasureDetailsDto;
import com.safeone.dashboard.service.MeasureDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/measure-details")
public class MeasureDetailsController extends JqGridAbstract<MeasureDetailsDto> {
	@Autowired
	private MeasureDetailsService measureDetailsService;

	protected MeasureDetailsController() {
		super(MeasureDetailsDto.class);
	}

	@Override
	protected List getList(Map param) {
		return measureDetailsService.getList(param);
	}

//	@GetMapping("/chart")
//	@ResponseBody
//	public List<SensorChartDto> getChartData(@RequestParam Map<String, Object> param) {
//		System.out.println("param = " + param);
//		return measureDetailsService.getSensorChartData(param);
//	}

	@Override
	protected int getTotalRows(Map param) {
		return measureDetailsService.getTotalCount(param);
	}

	@Override
	protected String setViewPage() {
		return "measure-details";
	}
}
