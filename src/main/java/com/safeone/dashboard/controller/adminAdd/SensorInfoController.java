package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SensorInfoDto;
import com.safeone.dashboard.service.*;
import com.safeone.dashboard.service.sensor.AlertStandardManagementService;
import com.safeone.dashboard.service.sensorinitialsetting.SensorInitialSettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/adminAdd/sensorInfo")
public class SensorInfoController extends JqGridAbstract<SensorInfoDto> {

    @Autowired
    private CommonCodeEditService commonCodeEditService;
    @Autowired
    private SensorInfoService sensorInfoService;
    @Autowired
    private AlertStandardManagementService alertStandardManagementService;
    @Autowired
    private SensorInitialSettingService sensorInitialSettingService;

    @Autowired
    private LogrIdxMapService logrIdxMapService;
    @Autowired
    private DistrictInfoService districtInfoService;

    protected SensorInfoController() {
        super(SensorInfoDto.class);
    }

    @Override
    protected List<SensorInfoDto> getList(Map<String, Object> param) {
        if (param.containsKey("mod_dt")) {
            String[] dates = ((String) param.get("mod_dt")).split(" ~ ");
            if (dates.length > 1) {
                param.put("mod_dt_start", dates[0]);
                param.put("mod_dt_end", dates[1]);
            } else {
                param.put("mod_dt_start", dates[0]);
                param.put("mod_dt_end", dates[0]);
            }
        }
        if (param.containsKey("inst_ymd")) {
            String[] dates = ((String) param.get("inst_ymd")).split(" ~ ");
            if (dates.length > 1) {
                param.put("inst_ymd_start", dates[0]);
                param.put("inst_ymd_end", dates[1]);
            } else {
                param.put("inst_ymd_start", dates[0]);
                param.put("inst_ymd_end", dates[0]);
            }
        }

        return sensorInfoService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        if (param.containsKey("mod_dt")) {
            String[] dates = ((String) param.get("mod_dt")).split(" ~ ");
            if (dates.length > 1) {
                param.put("mod_dt_start", dates[0]);
                param.put("mod_dt_end", dates[1]);
            } else {
                param.put("mod_dt_start", dates[0]);
                param.put("mod_dt_end", dates[0]);
            }
        }

        return sensorInfoService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/sensorInfo";
    }

    @ResponseBody
    @GetMapping("/all-by-district-no-and-senstype-no")
    public List<SensorInfoDto> getAllSensorInfo(@RequestParam Map<String, Object> param) {
        return sensorInfoService.getAllSensorInfo(param);
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        boolean exists = commonCodeEditService.isLogrIdxNoExists(param);
        if (!exists) {
            logrIdxMapService.delete(param);
//            return -1; // -1은 삭제 불가 상태를 의미함.
        }

        // 삭제 수행
        return sensorInfoService.delete(param); // 1: 성공, 0: 실패 (삭제할 항목이 없거나 삭제 실패)
    }

    @ResponseBody
    @GetMapping("/add")
    public synchronized boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {


        List<Map> sensAbbr = commonCodeEditService.getSensorAbbr(Collections.singletonMap("senstype_no", param.get("senstype_no").toString()));

        Map<String, Object> newMap = new HashMap<>();
        newMap.put("table_nm", "tb_sensor_info");
        newMap.put("column_nm", "sens_no");
        ObjectNode generationKeyOn = commonCodeEditService.newGenerationKey(newMap);
        param.put("sens_no", generationKeyOn.get("newId").asText());

        Map<String, Object> sens = new HashMap<>();
        sens.put("sensor_seq", sensAbbr.get(0).get("sens_abbr"));
        sens.put("logr_no", param.get("logr_no").toString());
        List<Map> sensNm = commonCodeEditService.getNewSensorSeq(sens);
        param.put("sens_nm", sensNm.get(0).get("new_sensor_seq"));

        //로거 인덱스 관련
        Map<String, Object> newMap2 = new HashMap<>();
        newMap2.put("table_nm", "tb_logr_idx_map");
        newMap2.put("column_nm", "mapping_no");
        ObjectNode generationKeyOn2 = commonCodeEditService.newGenerationKey(newMap2);
        param.put("mapping_no", generationKeyOn2.get("newId").asText());
        String district_no = districtInfoService.getDistrictInfoIdByEtc1(param.get("logr_no").toString());
        param.put("district_no", district_no);

        logrIdxMapService.create(param);

        alertStandardManagementService.create(param);
        sensorInitialSettingService.create(param);

        return sensorInfoService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return sensorInfoService.update(param);
    }


    @PostMapping("/upload")
    public ResponseEntity<String> uploadExcelFile(@RequestParam("file") MultipartFile file) {
        try {
            String message = sensorInfoService.saveExcelData(file);
            return new ResponseEntity<>(message, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Error processing the file: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


}
