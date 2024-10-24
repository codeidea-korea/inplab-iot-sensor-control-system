package com.safeone.dashboard.controller.sensor;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.sensor.SensorDto;
import com.safeone.dashboard.service.sensor.SensorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
//@RequestMapping("/sensor/sensor")
public class SensorController extends JqGridAbstract<SensorDto> {

    @Autowired
    private SensorService sensorService;

    protected SensorController() {
        super(SensorDto.class);
    }

    @Override
    protected List getList(Map param) {
        return sensorService.getList(param);
    }

    @Override
    protected int getTotalCount(Map param) {
        return sensorService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "sensor/sensor";
    }
}
