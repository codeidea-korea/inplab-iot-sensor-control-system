package com.safeone.dashboard.controller.displayconnection;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.displayconnection.DisplayImgManagementDto;
import com.safeone.dashboard.service.displayconnection.DisplayImgManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Collections;
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
	public ResponseEntity<?> insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		return createImage(param);
	}

	@ResponseBody
	@PostMapping("/add-json")
	public ResponseEntity<?> insertJson(HttpServletRequest request, @RequestBody Map<String, Object> param) {
		return createImage(param);
	}

	@ResponseBody
	@PostMapping("/add-group")
	public boolean createGroup(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		return service.createGroup(param);
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

	private ResponseEntity<?> createImage(Map<String, Object> param) {
		try {
			return ResponseEntity.ok(service.create(param));
		} catch (IllegalArgumentException e) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST)
					.body(Collections.singletonMap("message", e.getMessage()));
		} catch (DataIntegrityViolationException e) {
			return ResponseEntity.status(HttpStatus.CONFLICT)
					.body(Collections.singletonMap("message", "이미지 저장 중 제약조건 오류가 발생했습니다. 파일명/그룹 중복 여부를 확인해주세요."));
		}
	}
}
