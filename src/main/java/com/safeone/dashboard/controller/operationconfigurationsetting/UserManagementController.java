package com.safeone.dashboard.controller.operationconfigurationsetting;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.maintenance.MaintenanceDetailsDto;
import com.safeone.dashboard.dto.operationconfigurationsetting.UserManagementDto;
import com.safeone.dashboard.service.maintenance.MaintenanceDetailsService;
import com.safeone.dashboard.service.operationconfigurationsetting.UserManagementService;
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
@RequestMapping("/operation-configuration-setting/user-management")
public class UserManagementController extends JqGridAbstract<UserManagementDto> {
    @Autowired
    private UserManagementService userManagementService;

    protected UserManagementController() {
        super(UserManagementDto.class);
    }

    @Override
    protected List<UserManagementDto> getList(Map param) {
        setParam(param);
        return userManagementService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        setParam(param);
        return userManagementService.getTotalCount(param);
    }

    private void setParam(Map param) {
    }

    @Override
    protected String setViewPage() {
        return "operation-configuration-setting/user-management";
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return userManagementService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        param.put("file1", (String) param.get("serverFileName"));

        return userManagementService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        param.put("file1", (String) param.get("serverFileName"));

        return userManagementService.update(param);
    }

}