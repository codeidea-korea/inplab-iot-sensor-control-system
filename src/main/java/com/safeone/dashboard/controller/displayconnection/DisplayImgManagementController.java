package com.safeone.dashboard.controller.displayconnection;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.displayconnection.DisplayImgManagementDto;
import com.safeone.dashboard.service.displayconnection.DisplayImgManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/display-connection/display-img-management")
public class DisplayImgManagementController extends JqGridAbstract<DisplayImgManagementDto> {

	@Autowired
	private DisplayImgManagementService service;

	protected DisplayImgManagementController() {
		super(DisplayImgManagementDto.class);
	}

	@Override
	protected List<DisplayImgManagementDto> getList(Map param) {
		return service.getList(param);
	}

	@Override
	protected int getTotalRows(Map param) {
		return service.getTotalCount(param);
	}

	@Override
	protected String setViewPage() {
		return "display-connection/display-img-management";
	}

	@ResponseBody
	@PostMapping("/add")
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
