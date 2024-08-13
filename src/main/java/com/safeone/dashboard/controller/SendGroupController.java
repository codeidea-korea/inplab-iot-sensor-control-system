package com.safeone.dashboard.controller;

import com.google.gson.Gson;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SendGroupDto;
import com.safeone.dashboard.dto.SensorGroupDto;
import com.safeone.dashboard.dto.UserDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.DashboardService;
import com.safeone.dashboard.service.SendGroupService;
import com.safeone.dashboard.service.SensorGroupService;
import com.safeone.dashboard.util.ExcelUtil;
import com.safeone.dashboard.util.ExcelUtil.FieldDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/sendGroup")
public class SendGroupController extends JqGridAbstract<SendGroupDto> {

	@Autowired
	private SendGroupService service;

	protected SendGroupController() {
		super(SendGroupDto.class);
	}

	@Override
	protected List<SendGroupDto> getList(Map param) {
		return service.getList(param);
	}

	@Override
	protected int getTotalRows(Map param) {
		return service.getTotalCount(param);
	}

	@Override
	protected String setViewPage() {
		return "admin/sendGroup";
	}

	@ResponseBody
	@GetMapping("/add")
	public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		return service.create(param);
	}

	@ResponseBody
	@GetMapping("/mod")
	public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		return service.update(param);
	}

	@ResponseBody
	@GetMapping("/del")
	public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		return service.delete(param);
	}
}
