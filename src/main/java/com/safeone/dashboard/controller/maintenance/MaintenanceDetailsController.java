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
        return maintenanceDetailsService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        return maintenanceDetailsService.getTotalCount(param);
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
