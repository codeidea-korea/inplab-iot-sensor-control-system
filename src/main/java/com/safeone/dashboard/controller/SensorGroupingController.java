package com.safeone.dashboard.controller;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SensorChartDto;
import com.safeone.dashboard.dto.SensorGroupingDto;
import com.safeone.dashboard.service.SensorGroupingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/sensor-grouping")
public class SensorGroupingController extends JqGridAbstract<SensorGroupingDto> {

    @Autowired
    private SensorGroupingService sensorGroupingService;

    protected SensorGroupingController() {
        super(SensorGroupingDto.class);
    }

    @Override
    protected List<SensorGroupingDto> getList(Map<String, Object> param) {
        setParam(param);
        return sensorGroupingService.getList(param);
    }

    @Override
    protected int getTotalRows(Map<String, Object> param) {
        setParam(param);
        return sensorGroupingService.getTotalCount(param);
    }

    private void setParam(Map<String, Object> param) {
        if (param.containsKey("last_apply_dt")) {
            String[] dates = ((String) param.get("last_apply_dt")).split(" ~ ");
            if (dates.length > 1) {
                param.put("last_apply_dt_start", dates[0]);
                param.put("last_apply_dt_end", dates[1]);
            } else {
                param.put("last_apply_dt_start", dates[0]);
                param.put("last_apply_dt_end", dates[0]);
            }
        }
    }

    @GetMapping("/chart")
    @ResponseBody
    public List<SensorChartDto> getChartData(@RequestParam Map<String, Object> param) {
        return sensorGroupingService.getSensorChartData(param);
    }

    @Override
    protected String setViewPage() {
        return "sensor-grouping";
    }
}
