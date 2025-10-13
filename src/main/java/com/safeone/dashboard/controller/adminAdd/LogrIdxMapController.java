package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.LogrIdxMapDto;
import com.safeone.dashboard.service.CommonCodeEditService;
import com.safeone.dashboard.service.LogrIdxMapService;
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
@RequestMapping("/adminAdd/logrIdxMap")
public class LogrIdxMapController extends JqGridAbstract<LogrIdxMapDto> {

    @Autowired
    private CommonCodeEditService commonCodeEditService;
    @Autowired
    private LogrIdxMapService logrIdxMapService;

    protected LogrIdxMapController() {
        super(LogrIdxMapDto.class);
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

        return logrIdxMapService.getList(param);
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

        return logrIdxMapService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/logrIdxMap";
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return logrIdxMapService.delete(param);
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
        sens.put("sensor_seq",sensAbbr.get(0).get("sens_abbr"));
        sens.put("logr_no", param.get("logr_no").toString());
        List<Map> sensNm = commonCodeEditService.getNewSensorSeq(sens);
        param.put("sens_nm", sensNm.get(0).get("new_sensor_seq"));

        return logrIdxMapService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return logrIdxMapService.update(param);
    }


    @PostMapping("/upload")
    public ResponseEntity<String> uploadExcelFile(@RequestParam("file") MultipartFile file) {
        try {
            String message = logrIdxMapService.saveExcelData(file);
            return new ResponseEntity<>(message, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Error processing the file: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @ResponseBody
    @GetMapping("/mapping")
    public ResponseEntity<String> mapping(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        try {
            logrIdxMapService.mapping();
            return new ResponseEntity<>("success", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Error mapping: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
