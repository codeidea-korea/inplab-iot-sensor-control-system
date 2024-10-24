package com.safeone.dashboard.controller.operationconfigurationsetting;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.operationconfigurationsetting.UserManagementDto;
import com.safeone.dashboard.service.operationconfigurationsetting.UserManagementService;
import com.safeone.dashboard.util.CommonUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

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
    protected int getTotalCount(Map param) {
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
    @PostMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return userManagementService.delete(param);
    }

    @ResponseBody
    @PostMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        param.put("usr_pwd", CommonUtils.encrypt(param.get("usr_pwd").toString()));
        param.put("usr_pwd_confm", CommonUtils.encrypt(param.get("usr_pwd").toString()));
        return userManagementService.create(param);
    }

    @ResponseBody
    @PostMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        if (param.get("usr_pwd") != null && !param.get("usr_pwd").toString().isEmpty()) {
            param.put("usr_pwd", CommonUtils.encrypt(param.get("usr_pwd").toString()));
        }
        return userManagementService.update(param);
    }
}
