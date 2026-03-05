package com.safeone.dashboard.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.safeone.dashboard.service.AlarmListService;

@Controller
@RequestMapping("/alarmDataByLevel")
public class AlarmDataByLevelController {
    @Autowired
    private AlarmListService service;

	@ResponseBody
	@GetMapping("/list_by_level")
	public List<Map<String, Object>> getListByLevel(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		return service.getListByLevel(param);
	}
}
