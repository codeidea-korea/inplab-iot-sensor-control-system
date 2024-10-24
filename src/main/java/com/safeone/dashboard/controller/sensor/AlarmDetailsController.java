package com.safeone.dashboard.controller.sensor;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.AlarmListDto;
import com.safeone.dashboard.dto.sensor.AlarmDetailsDto;
import com.safeone.dashboard.service.AlarmListService;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.sensor.AlarmDetailsService;
import com.safeone.dashboard.util.ExcelUtil.FieldDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/sensor/alarm-details")
public class AlarmDetailsController extends JqGridAbstract<AlarmDetailsDto> {
    @Autowired
    private AlarmDetailsService alarmDetailsService;

    protected AlarmDetailsController() {
        super(AlarmDetailsDto.class);
    }

    @Override
    protected List getList(Map param) {
        if (param.containsKey("reg_day")) {
            String[] dates = ((String) param.get("reg_day")).split(" ~ ");
            if (dates.length > 1) {
                param.put("reg_date_start", dates[0]);
                param.put("reg_date_end", dates[1]);
            } else {
                param.put("reg_date_start", dates[0]);
                param.put("reg_date_end", dates[0]);
            }
        }
        return alarmDetailsService.getList(param);
    }

    @Override
    protected int getTotalCount(Map param) {
        if (param.containsKey("reg_day")) {
            String[] dates = ((String) param.get("reg_day")).split(" ~ ");
            if (dates.length > 1) {
                param.put("reg_date_start", dates[0]);
                param.put("reg_date_end", dates[1]);
            } else {
                param.put("reg_date_start", dates[0]);
                param.put("reg_date_end", dates[0]);
            }
        }
        return alarmDetailsService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "sensor/alarm-details";
    }


    @ResponseBody
    @GetMapping(value = "/alarmCount", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getAlarmCountByStatus(@RequestParam Map<String, Object> param) {
        return alarmDetailsService.selectAlarmCountByStatus(param);

    }

    @ResponseBody
    @GetMapping(value = "/alarmHistory", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getAlarmHistory(@RequestParam Map<String, Object> param) {
        return alarmDetailsService.selectAlarmHistory(param);
    }
}
