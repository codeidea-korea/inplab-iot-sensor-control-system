package com.safeone.dashboard.controller;

import com.safeone.dashboard.dto.SensorTypeDto;
import com.safeone.dashboard.service.SensorTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/sensor-type")
public class SensoTypeController {

	private final SensorTypeService sensorTypeService;

	@GetMapping("")
	public List<SensorTypeDto> getSensorTypeList() {
		return sensorTypeService.getList(null);
	}

}
