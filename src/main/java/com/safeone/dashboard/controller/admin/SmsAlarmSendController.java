package com.safeone.dashboard.controller.admin;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SendMessageDto;
import com.safeone.dashboard.dto.SmsAlarmListDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.SmsAlarmListService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/admin/smsAlarmList")
public class SmsAlarmSendController extends JqGridAbstract<SmsAlarmListDto> {
	@Autowired
	private SmsAlarmListService smsAlarmListService;

	@Autowired
	private CommonCodeService commonCodeService;

	protected SmsAlarmSendController() {
		super(SmsAlarmListDto.class);
	}

	@Override
	protected List getList(Map param) {

		return smsAlarmListService.getList(param);
	}

	@Override
	protected int getTotalRows(Map param) {

		return smsAlarmListService.getTotalCount(param);
	}

	@Override
	protected String setViewPage() {
		return "";
	}

	@PostMapping(value = "/send", consumes = "application/json")
	public ResponseEntity<String> send(@RequestBody SendMessageDto param) {
		smsAlarmListService.send(param);
		return ResponseEntity.ok("SUCCESS");
	}
}
