package com.safeone.dashboard.controller.sensor;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.sensor.AlertStandardManagementDto;
import com.safeone.dashboard.service.sensor.AlertStandardManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/sensor/alert-standard-management")
public class AlertStandardManagementController extends JqGridAbstract<AlertStandardManagementDto> {
    @Autowired
    private AlertStandardManagementService alertStandardManagementService;

    protected AlertStandardManagementController() {
        super(AlertStandardManagementDto.class);
    }

    @Override
    protected List getList(Map param) {
        setParam(param);
        return alertStandardManagementService.getList(param);
    }

    @Override
    protected int getTotalCount(Map param) {
        setParam(param);
        return alertStandardManagementService.getTotalCount(param);
    }

    private void setParam(Map param) {
        if (param.containsKey("lvl_apply_dt")) {
            String[] dates = ((String) param.get("lvl_apply_dt")).split(" ~ ");
            if (dates.length > 1) {
                param.put("lvl_apply_dt_start", dates[0]);
                param.put("lvl_apply_dt_end", dates[1]);
            } else {
                param.put("lvl_apply_dt_start", dates[0]);
                param.put("lvl_apply_dt_end", dates[0]);
            }
        }
    }

    @ResponseBody
    @PostMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        JsonArray jArray = ((new JsonParser()).parse(param.get("jsonData").toString())).getAsJsonArray();
        for(JsonElement el : jArray) {
            Map m = (new Gson()).fromJson(el, Map.class);
            alertStandardManagementService.updateAlertStandardManagement(m);
        }
        return true;
    }

    @Override
    protected String setViewPage() {
        return "sensor/alert-standard-management";
    }
}
