package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SensorTypeDto;
import com.safeone.dashboard.service.CommonCodeEditService;
import com.safeone.dashboard.service.SensorTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/adminAdd/sensorType")
public class SensorTypeController extends JqGridAbstract<SensorTypeDto> {

    @Autowired
    private CommonCodeEditService commonCodeEditService;
    @Autowired
    private SensorTypeService sensorTypeService;

    protected SensorTypeController() {
        super(SensorTypeDto.class);
    }

    @Override
    protected List getList(Map param) {
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

        return sensorTypeService.getList(param);
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

        return sensorTypeService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/sensorTypeInfo";
    }

//    @ResponseBody
//    @GetMapping("/del")
//    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
//        return sensorTypeService.delete(param);
//    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        boolean exists = commonCodeEditService.isSensNoExists(param);
        if (exists) {
            return -1; // -1은 삭제 불가 상태를 의미함.
        }
        // 삭제 수행
        return sensorTypeService.delete(param); // 1: 성공, 0: 실패 (삭제할 항목이 없거나 삭제 실패)
    }

    @ResponseBody
    @GetMapping("/add")
    public synchronized boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {

        // 생성
        Map<String, Object> newMap = new HashMap<>();
        newMap.put("table_nm", "tb_sensor_type");
        newMap.put("column_nm", "senstype_no");

        ObjectNode generationKeyOn = commonCodeEditService.newGenerationKey(newMap);
        param.put("senstype_no", generationKeyOn.get("newId").asText());

        return sensorTypeService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return sensorTypeService.update(param);
    }

    @PostMapping("/upload")
    public ResponseEntity<String> uploadExcelFile(@RequestParam("file") MultipartFile file) {
        try {
            String message = sensorTypeService.saveExcelData(file);
            return new ResponseEntity<>(message, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Error processing the file: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @ResponseBody
    @GetMapping("/all-by-sens-type-no")
    public List<SensorTypeDto> getAllSensorTypesBySensTypeNo(@RequestParam Map<String, Object> param) {
        return sensorTypeService.getAllSensorTypesBySensTypeNo(param);
    }

    @ResponseBody
    @GetMapping("/all")
    public List<SensorTypeDto> getAll() {
        return sensorTypeService.getAll();
    }

    @ResponseBody
    @GetMapping("/max-no")
    public String getMaxNo() {
        return sensorTypeService.getMaxNo();
    }

}
