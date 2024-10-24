package com.safeone.dashboard.controller.admin;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.AreaDto;
import com.safeone.dashboard.service.AreaService;

@Controller
@RequestMapping("/admin/area")
public class AreaController extends JqGridAbstract<AreaDto> {
    @Autowired
    private AreaService areaService;

    @Value("${upload.path}")
    private String upload_path;
    
    protected AreaController() {
        super(AreaDto.class);
    }

    @Override
    protected List getList(Map param) {
        return areaService.getList(param);
    }
    
    @Override
    protected int getTotalRows(Map param) {
        return areaService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/area";
    }
    
    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        // todo : 관리자 권한 체크, 삭제에 대한 validate
        return areaService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	param.put("file1", (String)param.get("serverFileName"));
        return areaService.create(param);
    }
    
    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	param.put("file1", (String)param.get("serverFileName"));
        return areaService.update(param);
    }
    
}
