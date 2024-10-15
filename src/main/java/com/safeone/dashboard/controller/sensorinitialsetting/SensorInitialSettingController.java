package com.safeone.dashboard.controller.sensorinitialsetting;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.sensorinitialsetting.SensorInitialSettingDto;
import com.safeone.dashboard.service.sensorinitialsetting.SensorInitialSettingService;
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
@RequestMapping("/sensor-initial-setting")
public class SensorInitialSettingController extends JqGridAbstract<SensorInitialSettingDto> {
    @Autowired
    private SensorInitialSettingService sensorInitialSettingService;

    protected SensorInitialSettingController() {
        super(SensorInitialSettingDto.class);
    }

    @Override
    protected List<SensorInitialSettingDto> getList(Map param) {
        setParam(param);
        return sensorInitialSettingService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        setParam(param);
        return sensorInitialSettingService.getTotalCount(param);
    }

    private void setParam(Map param) {
        if (param.containsKey("init_apply_dt")) {
            String[] dates = ((String) param.get("init_apply_dt")).split(" ~ ");
            if (dates.length > 1) {
                param.put("init_apply_dt_start", dates[0].replace("-", ""));
                param.put("init_apply_dt_end", dates[1].replace("-", ""));
            } else {
                dates[0] = dates[0].replace(" ", "");
                param.put("init_apply_dt_start", dates[0]);
                param.put("init_apply_dt_end", dates[0]);
            }
        }
    }

    @Override
    protected String setViewPage() {
        return "sensor-initial-setting/sensor-initial-setting";
    }

    @ResponseBody
    @PostMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return sensorInitialSettingService.delete(param);
    }

    @ResponseBody
    @PostMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return sensorInitialSettingService.create(param);
    }

    @ResponseBody
    @PostMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return sensorInitialSettingService.update(param);
    }

}
