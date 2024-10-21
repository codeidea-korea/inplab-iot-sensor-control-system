package com.safeone.dashboard.controller.sensor;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.sensor.SmsDetailsDto;
import com.safeone.dashboard.service.sensor.SmsDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/sensor/sms-details")
public class SmsDetailsController extends JqGridAbstract<SmsDetailsDto> {
    @Autowired
    private SmsDetailsService smsDetailsService;

    protected SmsDetailsController() {
        super(SmsDetailsDto.class);
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
        return smsDetailsService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
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
        return smsDetailsService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "";
    }


    @ResponseBody
    @GetMapping(value = "/alarmCount", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getAlarmCountByStatus(@RequestParam Map<String, Object> param) {
        return smsDetailsService.selectAlarmCountByStatus(param);

    }

    @ResponseBody
    @GetMapping(value = "/alarmHistory", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getAlarmHistory(@RequestParam Map<String, Object> param) {
        return smsDetailsService.selectAlarmHistory(param);
    }
}
