package com.safeone.dashboard.controller.admin;

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
import com.safeone.dashboard.dto.LoginLogDto;
import com.safeone.dashboard.service.LoginLogService;

@Controller
@RequestMapping("/admin/loginLog")
public class LoginLogController extends JqGridAbstract<LoginLogDto> {
    @Autowired
    private LoginLogService loginLogService;

    protected LoginLogController() {
        super(LoginLogDto.class);
    }

    @Override
    protected List getList(Map param) {
        if(param.containsKey("login_date")) {
            String[] dates = ((String)param.get("login_date")).split(" ~ ");
            if(dates.length > 1) {
                param.put("login_date_start", dates[0]);
                param.put("login_date_end", dates[1]);
            }else {
                param.put("login_date_start", dates[0]);
                param.put("login_date_end", dates[0]);
            }
        }
        return loginLogService.getList(param);
    }

    @Override
    protected int getTotalCount(Map param) {
        if(param.containsKey("login_date")) {
            String[] dates = ((String)param.get("login_date")).split(" ~ ");
            if(dates.length > 1) {
                param.put("login_date_start", dates[0]);
                param.put("login_date_end", dates[1]);
            }else {
                param.put("login_date_start", dates[0]);
                param.put("login_date_end", dates[0]);
            }
        }
        return loginLogService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/loginLog";
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        // todo : 관리자 권한 체크, 삭제에 대한 validate
        return loginLogService.delete(param);
    }

}
