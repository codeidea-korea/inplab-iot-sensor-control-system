package com.safeone.dashboard.controller.maintenance;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.maintenance.MaintenanceDetailsDto;
import com.safeone.dashboard.service.maintenance.MaintenanceDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/maintenance/details")
public class MaintenanceDetailsController extends JqGridAbstract<MaintenanceDetailsDto> {
    @Autowired
    private MaintenanceDetailsService maintenanceDetailsService;

    protected MaintenanceDetailsController() {
        super(MaintenanceDetailsDto.class);
    }

    @Override
    protected List<MaintenanceDetailsDto> getList(Map param) {
        setParam(param);
        return maintenanceDetailsService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        setParam(param);
        return maintenanceDetailsService.getTotalCount(param);
    }

    private void setParam(Map param) {
        if (param.containsKey("maint_accpt_ymd")) {
            String[] dates = ((String) param.get("maint_accpt_ymd")).split(" ~ ");
            if (dates.length > 1) {
                param.put("maint_accpt_ymd_start", dates[0].replace("-", ""));
                param.put("maint_accpt_ymd_end", dates[1].replace("-", ""));
            } else {
                dates[0] = dates[0].replace(" ", "");
                param.put("maint_accpt_ymd_start", dates[0]);
                param.put("maint_accpt_ymd_end", dates[0]);
            }
        }

        if (param.containsKey("maint_str_ymd")) {
            String[] dates = ((String) param.get("maint_str_ymd")).split(" ~ ");
            if (dates.length > 1) {
                param.put("maint_str_ymd_start", dates[0].replace("-", ""));
                param.put("maint_str_ymd_end", dates[1].replace("-", ""));
            } else {
                dates[0] = dates[0].replace(" ", "");
                param.put("maint_str_ymd_start", dates[0]);
                param.put("maint_str_ymd_end", dates[0]);
            }
        }

        if (param.containsKey("maint_end_ymd")) {
            String[] dates = ((String) param.get("maint_end_ymd")).split(" ~ ");
            if (dates.length > 1) {
                param.put("maint_end_ymd_start", dates[0].replace("-", ""));
                param.put("maint_end_ymd_end", dates[1].replace("-", ""));
            } else {
                dates[0] = dates[0].replace(" ", "");
                param.put("maint_end_ymd_start", dates[0]);
                param.put("maint_end_ymd_end", dates[0]);
            }
        }

        if (param.containsKey("reg_dt")) {
            String[] dates = ((String) param.get("reg_dt")).split(" ~ ");
            if (dates.length > 1) {
                param.put("reg_dt_start", dates[0]);
                param.put("reg_dt_end", dates[1]);
            } else {
                param.put("reg_dt_start", dates[0]);
                param.put("reg_dt_end", dates[0]);
            }
        }
    }

    @Override
    protected String setViewPage() {
        return "maintenance/details";
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return maintenanceDetailsService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        param.put("file1", (String) param.get("serverFileName"));

        return maintenanceDetailsService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        param.put("file1", (String) param.get("serverFileName"));

        return maintenanceDetailsService.update(param);
    }

}
