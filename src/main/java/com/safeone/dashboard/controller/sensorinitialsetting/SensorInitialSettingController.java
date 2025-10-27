package com.safeone.dashboard.controller.sensorinitialsetting;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.sensorinitialsetting.SensorInitialSettingDto;
import com.safeone.dashboard.service.ModifySensorService;
import com.safeone.dashboard.service.SensorService;
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

    @Autowired
    private ModifySensorService modifySensorService;

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

        if (param.containsKey("last_apply_dt")) {
            String[] dates = ((String) param.get("last_apply_dt")).split(" ~ ");
            if (dates.length > 1) {
                param.put("last_apply_dt_start", dates[0].replace("-", ""));
                param.put("last_apply_dt_end", dates[1].replace("-", ""));
            } else {
                dates[0] = dates[0].replace(" ", "");
                param.put("last_apply_dt_start", dates[0]);
                param.put("last_apply_dt_end", dates[0]);
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
        JsonArray jArray = ((new JsonParser()).parse(param.get("jsonData").toString())).getAsJsonArray();
        for(JsonElement el : jArray) {
            Map m = (new Gson()).fromJson(el, Map.class);

            /* 센서 신규 등록으로 인해 보정값이 0인 데이터일 경우, 해당 센서의 최신 실데이터의 (tb_measure_details) 계측값을 보정값으로 설정 */
            String formulData = m.get("formul_data").toString();
            if (formulData.equals("0")) {
                /* tb_measure_details > sens_no / order by reg_dt / limit 1 로 뽑은 formul_data를 m에 엎기 */
                Map measureFormulData = modifySensorService.getMeasureDetails(m);
                if (measureFormulData != null) {
                    m.put("formul_data", measureFormulData.get("formul_data"));
                }
            }
            /* 빈 값으로 설정할 경우, 해당 센서의 보정값을 0으로 초기화할 수 있도록 설정 */
            else if (formulData.equals("")) {
                m.put("formul_data", "0");
            }

            sensorInitialSettingService.update(m);
        }
        return true;
    }
}
