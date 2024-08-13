package com.safeone.dashboard.controller.admin;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.AssetKindDto;
import com.safeone.dashboard.dto.DeviceDto;
import com.safeone.dashboard.dto.UserDto;
import com.safeone.dashboard.service.AssetKindService;
import com.safeone.dashboard.service.DeviceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/device")
public class DeviceController extends JqGridAbstract<DeviceDto> {
    @Autowired
    private DeviceService deviceService;

    protected DeviceController() {
        super(DeviceDto.class);
    }
    @Override
    protected List getList(Map param) {
    	if(param.containsKey("mod_date")) {
        	String[] dates = ((String)param.get("mod_date")).split(" ~ ");
        	if(dates.length > 1) {
        		param.put("mod_date_start", dates[0]);
        		param.put("mod_date_end", dates[1]);
        	}else {
        		param.put("mod_date_start", dates[0]);
        		param.put("mod_date_end", dates[0]);
        	}
    	}
    	
        return deviceService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
    	if(param.containsKey("mod_date")) {
        	String[] dates = ((String)param.get("mod_date")).split(" ~ ");
        	if(dates.length > 1) {
        		param.put("mod_date_start", dates[0]);
        		param.put("mod_date_end", dates[1]);
        	}else {
        		param.put("mod_date_start", dates[0]);
        		param.put("mod_date_end", dates[0]);
        	}
    	}
    	
        return deviceService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/device";
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return deviceService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	HttpSession session = request.getSession();
        param.put("mod_user", ((UserDto) session.getAttribute("login")).getUser_id());
        return deviceService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	HttpSession session = request.getSession();
        param.put("mod_user", ((UserDto) session.getAttribute("login")).getUser_id());
        return deviceService.update(param);
    }
}
