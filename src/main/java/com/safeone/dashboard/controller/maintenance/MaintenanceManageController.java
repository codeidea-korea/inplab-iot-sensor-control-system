package com.safeone.dashboard.controller.maintenance;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.maintenance.MaintenanceManageDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.maintenance.MaintenanceManageService;
import com.safeone.dashboard.util.ExcelUtils.FieldDetails;


@Controller
@RequestMapping("/maintenance/manage")
public class MaintenanceManageController extends JqGridAbstract<MaintenanceManageDto> {
    @Autowired
    private MaintenanceManageService maintenanceService;

    @Autowired
    private CommonCodeService commonCodeService;

    protected MaintenanceManageController() {
        super(MaintenanceManageDto.class);
    }

    @Override
    public Map<String, FieldDetails> getColumnDataJson() {
        Map<String, FieldDetails> result = super.getColumnDataJson();

        return result;
    }

    @Override
    protected List getList(Map param) {
        if (param.containsKey("reg_day")) {
            String[] dates = ((String) param.get("reg_day")).split(" ~ ");
            if (dates.length > 1) {
                param.put("reg_day_start", dates[0]);
                param.put("reg_day_end", dates[1]);
            } else {
                param.put("reg_day_start", dates[0]);
                param.put("reg_day_end", dates[0]);
            }
        }

        if (param.containsKey("mt_date")) {
            String[] dates = ((String) param.get("mt_date")).split(" ~ ");
            if (dates.length > 1) {
                param.put("mt_date_start", dates[0]);
                param.put("mt_date_end", dates[1]);
            } else {
                param.put("mt_date_start", dates[0]);
                param.put("mt_date_end", dates[0]);
            }
        }
        return maintenanceService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        if (param.containsKey("reg_day")) {
            String[] dates = ((String) param.get("reg_day")).split(" ~ ");
            if (dates.length > 1) {
                param.put("reg_day_start", dates[0]);
                param.put("reg_day_end", dates[1]);
            } else {
                param.put("reg_day_start", dates[0]);
                param.put("reg_day_end", dates[0]);
            }
        }

        if (param.containsKey("mt_date")) {
            String[] dates = ((String) param.get("mt_date")).split(" ~ ");
            if (dates.length > 1) {
                param.put("mt_date_start", dates[0]);
                param.put("mt_date_end", dates[1]);
            } else {
                param.put("mt_date_start", dates[0]);
                param.put("mt_date_end", dates[0]);
            }
        }
        return maintenanceService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "maintenance/manage";
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return maintenanceService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        param.put("file1", (String) param.get("serverFileName"));

        return maintenanceService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        param.put("file1", (String) param.get("serverFileName"));

        return maintenanceService.update(param);
    }

}
