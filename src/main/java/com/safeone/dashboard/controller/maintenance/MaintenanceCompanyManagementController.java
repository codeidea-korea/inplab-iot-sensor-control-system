package com.safeone.dashboard.controller.maintenance;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.maintenance.MaintenanceCompanyManagementDto;
import com.safeone.dashboard.service.maintenance.MaintenanceCompanyManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/maintenance/company-management")
public class MaintenanceCompanyManagementController extends JqGridAbstract<MaintenanceCompanyManagementDto> {
    @Autowired
    private MaintenanceCompanyManagementService maintenanceCompanyManagementService;

    protected MaintenanceCompanyManagementController() {
        super(MaintenanceCompanyManagementDto.class);
    }

    @Override
    protected List<MaintenanceCompanyManagementDto> getList(Map param) {
        setParam(param);
        return maintenanceCompanyManagementService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        setParam(param);
        return maintenanceCompanyManagementService.getTotalCount(param);
    }

    private void setParam(Map param) {
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
    }

    @ResponseBody
    @GetMapping("/all")
    public List<MaintenanceCompanyManagementDto> getAll() {
        return maintenanceCompanyManagementService.getAll();
    }

    @Override
    protected String setViewPage() {
        return "maintenance/company-management";
    }

    @ResponseBody
    @PostMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return maintenanceCompanyManagementService.delete(param);
    }

    @ResponseBody
    @PostMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return maintenanceCompanyManagementService.create(param);
    }

    @ResponseBody
    @PostMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        System.out.println("partner_type_flag : " +  param.get("partner_type_flag"));
        return maintenanceCompanyManagementService.update(param);
    }

}
