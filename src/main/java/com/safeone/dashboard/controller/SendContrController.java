package com.safeone.dashboard.controller;

import com.google.gson.Gson;
import com.safeone.dashboard.dto.SendContrDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.SendContrService;
import com.safeone.dashboard.service.SendGroupService;
import com.safeone.dashboard.util.ExcelUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/sendContr")
@Slf4j
public class SendContrController {


	@Autowired
	private SendGroupService sendGroupService;

	@Autowired
	private CommonCodeService commonCodeService;

	@Autowired
	private SendContrService service;

	@GetMapping(value = { "/", "" })
	public String main(Model model) {
		Map param = new HashMap();
        param.put("use_yn", "Y");

        model.addAttribute("columns", (new Gson()).toJson(ExcelUtil.getPojoFieldNamesAndLabels(SendContrDto.class)));
		model.addAttribute("sendGroups", sendGroupService.getList(param));
		model.addAttribute("types", getCommonCodeList("표시효과"));
		model.addAttribute("assetList", service.assetList(param));
		model.addAttribute("log", service.getSendLog());
		return "admin/sendContr";
	}


	@ResponseBody
	@GetMapping("/list")
	public List<SendContrDto> list(@RequestParam Map<String, Object> param) {
		log.info("{}", param);
		List<SendContrDto> list = service.getList(param);

		return list;
	}


	@ResponseBody
	@GetMapping("/add")
	public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {

		param.put("url_path", request.getRequestURL().append("/common/dp/").toString().replace(request.getServletPath(), ""));

		return service.create(param);
	}

	@ResponseBody
	@GetMapping("/mod")
	public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		return service.update(param);
	}

	@ResponseBody
	@GetMapping("/del")
	public boolean delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		return service.delete(param);
	}

	@ResponseBody
	@GetMapping("/send")
	public HashMap send(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		return service.send(param);
	}

	private String getCommonCodeListStr(String cat){
		StringBuilder result = new StringBuilder();
		Map<String,Object> pm = new HashMap<String,Object>();
		pm.put("category", cat);

		List<Map> rList = commonCodeService.getCommonCodeList(pm);
		for(Map m : rList) {
			result.append(m.get("code")).append(":").append(m.get("name"));
		}

		return result.toString();
	}

	private List<Map> getCommonCodeList (String cat){
		Map<String,Object> pm = new HashMap<String,Object>();
		pm.put("category", cat);

		return commonCodeService.getCommonCodeList(pm);
	}
}
