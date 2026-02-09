package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.LoggerInfoDto;
import com.safeone.dashboard.service.CommonCodeEditService;
import com.safeone.dashboard.service.LoggerInfoService;
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
@RequestMapping("/adminAdd/loggerInfo")
public class LoggerInfoController extends JqGridAbstract<LoggerInfoDto> {

    @Autowired
    private CommonCodeEditService commonCodeEditService;
    @Autowired
    private LoggerInfoService loggerInfoService;

    protected LoggerInfoController() {
        super(LoggerInfoDto.class);
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

        return loggerInfoService.getList(param);
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

        return loggerInfoService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/loggerInfo";
    }

//    @ResponseBody
//    @GetMapping("/del")
//    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
//        return loggerInfoService.delete(param);
//    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        boolean exists = commonCodeEditService.isSensorByLoggerNoExists(param);
        if (exists) {
            return -1; // -1은 삭제 불가 상태를 의미함.
        }
        // 삭제 수행
        return loggerInfoService.delete(param); // 1: 성공, 0: 실패 (삭제할 항목이 없거나 삭제 실패)
    }

    @ResponseBody
    @GetMapping("/add")
    public synchronized boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {

//        Map<String, Object> newMapLogrNm = new HashMap<>();
//        newMapLogrNm.put("district_no", param.get("district_no").toString());
//        List<Map> distAbbr = commonCodeEditService.getDistrictInfoDistAbbr(newMapLogrNm);

        List<Map> distAbbr = commonCodeEditService.getDistrictInfoDistAbbr(Collections.singletonMap("district_no", param.get("district_no").toString()));

        Map<String, Object> newMap = new HashMap<>();
        newMap.put("table_nm", "tb_logger_info");
        newMap.put("column_nm", "logr_no");
        String logr_nm_type;
        if (param.containsKey("logr_flag") && param.get("logr_flag").toString().equals("G")) {
            newMap.put("pre_type", "GNSS");
        }

        ObjectNode generationKeyOn = commonCodeEditService.newGenerationKey(newMap);

        String newId = generationKeyOn.get("newId").asText();
        String newIdNo = newId.replaceAll("^[A-Za-z]", "");

        String prefix = "G".equals(param.get("logr_flag").toString()) ? "GNS" : "LOG";
        logr_nm_type = distAbbr.get(0).get("dist_abbr") + prefix + newIdNo;

        param.put("logr_no", newId);
        param.put("logr_nm", logr_nm_type);

        return loggerInfoService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return loggerInfoService.update(param);
    }


    @PostMapping("/upload")
    public ResponseEntity<String> uploadExcelFile(@RequestParam("file") MultipartFile file) {
        try {
            String message = loggerInfoService.saveExcelData(file);
            return new ResponseEntity<>(message, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Error processing the file: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


}
