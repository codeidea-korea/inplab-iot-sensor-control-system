package com.safeone.dashboard.controller.displayconnection;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.displayconnection.DisplayGroupDto;
import com.safeone.dashboard.dto.displayconnection.DisplaySendManagementDto;
import com.safeone.dashboard.service.displayconnection.DisplaySendManagementService;
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
@RequestMapping("/display-connection/display-send-management")
public class DisplaySendManagementController extends JqGridAbstract<DisplaySendManagementDto> {

    @Autowired
    private DisplaySendManagementService service;

    protected DisplaySendManagementController() {
        super(DisplaySendManagementDto.class);
    }

    @Override
    protected List<DisplaySendManagementDto> getList(Map param) {
        if (param.get("img_grp_nm") == null || param.get("dispbd_evnt_flag") == null) {
            return null;
        }
        return service.getList(param);
    }

    @Override
    protected int getTotalCount(Map param) {
        return service.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "display-connection/display-send-management";
    }

    @ResponseBody
    @GetMapping("/group")
    public List<DisplayGroupDto> group(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return service.group(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return service.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return service.update(param);
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return service.delete(param);
    }
}
