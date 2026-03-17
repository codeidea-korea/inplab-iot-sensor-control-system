package com.safeone.dashboard.controller.adminAdd;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.LoggerInfoDto;
import com.safeone.dashboard.service.CommonCodeEditService;
import com.safeone.dashboard.service.LoggerInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
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
    @GetMapping("/next-no")
    public String getNextLoggerNo(@RequestParam(value = "gnss", defaultValue = "false") boolean gnss) {
        return loggerInfoService.getNextLoggerNo(gnss);
    }

    @ResponseBody
    @GetMapping("/add")
    public synchronized Map<String, Object> insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        Map<String, Object> response = new HashMap<>();
        String logrNm = param.get("logr_nm") == null ? "" : param.get("logr_nm").toString().trim();
        param.put("logr_nm", logrNm);

        if (logrNm.isEmpty()) {
            response.put("success", false);
            response.put("code", "INVALID_LOGR_NM");
            response.put("message", "로거명을 입력해주세요.");
            return response;
        }

        if (loggerInfoService.getLoggerInfoNmChk(param) > 0) {
            response.put("success", false);
            response.put("code", "DUPLICATE_LOGR_NM");
            response.put("message", "로거명이 중복됩니다.");
            return response;
        }

        boolean gnss = param.containsKey("logr_flag") && "G".equals(param.get("logr_flag").toString());
        String newId = loggerInfoService.getNextLoggerNo(gnss);
        param.put("logr_no", newId);

        try {
            boolean createResult = loggerInfoService.create(param);
            response.put("success", createResult);
            response.put("message", createResult ? "저장되었습니다." : "저장에 실패했습니다.");
            return response;
        } catch (DuplicateKeyException e) {
            response.put("success", false);
            response.put("code", "DUPLICATE_LOGR_NM");
            response.put("message", "로거명이 중복됩니다.");
            return response;
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "오류가 발생했습니다.");
            return response;
        }
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
