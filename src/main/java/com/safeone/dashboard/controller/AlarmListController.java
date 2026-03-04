package com.safeone.dashboard.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.safeone.dashboard.service.AlarmListService;

@Controller
@RequestMapping("/alarmList")
public class AlarmListController {
    @Autowired
    private AlarmListService alarmListService;


    @ResponseBody
    @GetMapping(value = "/alarmCount", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getAlarmCountByStatus(@RequestParam Map<String, Object> param) {
        return alarmListService.selectAlarmCountByStatus(param);

    }

    @ResponseBody
    @GetMapping(value = "/alarmHistory", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getAlarmHistory(@RequestParam Map<String, Object> param) {
        return alarmListService.selectAlarmHistory(param);
    }
}
