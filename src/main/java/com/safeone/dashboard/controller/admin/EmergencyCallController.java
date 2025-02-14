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
import com.safeone.dashboard.dto.EmergencyCallDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.EmergencyCallService;
import com.safeone.dashboard.util.ExcelUtils.FieldDetails;

@Controller
@RequestMapping("/admin/emergencyCall")
public class EmergencyCallController extends JqGridAbstract<EmergencyCallDto> {
    @Autowired
    private EmergencyCallService userService;

	@Autowired
	private CommonCodeService commonCodeService;
    
    protected EmergencyCallController() {
        super(EmergencyCallDto.class);
    }
    
	@Override
	public Map<String, FieldDetails> getColumnDataJson() {
		Map<String, FieldDetails> result = super.getColumnDataJson();
		((FieldDetails)result.get("area_id")).type = this.getCommonListStr("area_id");
		
		return result;
	}
	
	private String getCommonListStr(String type) {
		String listStr = ":";
		
		List<Map> list = null;
		if("asset_kind_id".equals(type)) list = commonCodeService.getAssetKindList();
		else if("area_id".equals(type)) list = commonCodeService.getAreaList();
		else if("asset_id".equals(type)) list = commonCodeService.getSensorList();
		else if("zone_id".equals(type)) list = commonCodeService.getZoneList();
		
		for(Map m : list) {
			listStr += ";"+(String)m.get("code")+":"+(String)m.get("name");
		}
		
		return listStr;
	}

    @Override
    protected List getList(Map param) {
        return userService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        return userService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/emergencyCall";
    }
    
    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        // todo : 관리자 권한 체크, 삭제에 대한 validate
        return userService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return userService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return userService.update(param);
    }
}
