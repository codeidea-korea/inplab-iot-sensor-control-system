package com.safeone.dashboard.controller;

import java.util.HashMap;
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
import com.safeone.dashboard.dto.MaintenanceDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.MaintenanceService;
import com.safeone.dashboard.util.ExcelUtil.FieldDetails;


@Controller
@RequestMapping("/maintenance")
public class MaintenanceController extends JqGridAbstract<MaintenanceDto> {
    @Autowired
    private MaintenanceService maintenanceService;
    
	@Autowired
	private CommonCodeService commonCodeService;
    
    protected MaintenanceController() {
        super(MaintenanceDto.class);
    }

	@Override
	public Map<String, FieldDetails> getColumnDataJson() {
		Map<String, FieldDetails> result = super.getColumnDataJson();
		((FieldDetails)result.get("type")).type = this.getCommonCodeListStr("유지보수종류");//status
		((FieldDetails)result.get("asset_id")).type = this.getCommonListStr("asset_id");
//		((FieldDetails)result.get("area_id")).type = this.getCommonListStr("area_id");
		((FieldDetails)result.get("zone_id")).type = this.getCommonListStr("zone_id");
		
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
	
	private String getCommonCodeListStr(String cat){
		String result = ":";
		Map<String,Object> pm = new HashMap<String,Object>();
		pm.put("category", cat);
		
		List<Map> rList = commonCodeService.getCommonCodeList(pm);
		for(Map m : rList) {
			result += ";"+String.valueOf(m.get("code"))+":"+String.valueOf(m.get("name"));
		}
		
		return result;
	}
    
    @Override
    protected List getList(Map param) {
    	if(param.containsKey("reg_day")) {
        	String[] dates = ((String)param.get("reg_day")).split(" ~ ");
        	if(dates.length > 1) {
        		param.put("reg_day_start", dates[0]);
        		param.put("reg_day_end", dates[1]);
        	}else {
        		param.put("reg_day_start", dates[0]);
        		param.put("reg_day_end", dates[0]);
        	}
    	}
    	
    	if(param.containsKey("mt_date")) {
        	String[] dates = ((String)param.get("mt_date")).split(" ~ ");
        	if(dates.length > 1) {
        		param.put("mt_date_start", dates[0]);
        		param.put("mt_date_end", dates[1]);
        	}else {
        		param.put("mt_date_start", dates[0]);
        		param.put("mt_date_end", dates[0]);
        	}
    	}
    	return maintenanceService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
    	if(param.containsKey("reg_day")) {
        	String[] dates = ((String)param.get("reg_day")).split(" ~ ");
        	if(dates.length > 1) {
        		param.put("reg_day_start", dates[0]);
        		param.put("reg_day_end", dates[1]);
        	}else {
        		param.put("reg_day_start", dates[0]);
        		param.put("reg_day_end", dates[0]);
        	}
    	}
    	
    	if(param.containsKey("mt_date")) {
        	String[] dates = ((String)param.get("mt_date")).split(" ~ ");
        	if(dates.length > 1) {
        		param.put("mt_date_start", dates[0]);
        		param.put("mt_date_end", dates[1]);
        	}else {
        		param.put("mt_date_start", dates[0]);
        		param.put("mt_date_end", dates[0]);
        	}
    	}
        return maintenanceService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "maintenance";
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return maintenanceService.delete(param);
    }
    
    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		param.put("file1", (String)param.get("serverFileName"));
	
		return maintenanceService.create(param);
    }
    
    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
		param.put("file1", (String)param.get("serverFileName"));
	
        return maintenanceService.update(param);
    }
    
}
