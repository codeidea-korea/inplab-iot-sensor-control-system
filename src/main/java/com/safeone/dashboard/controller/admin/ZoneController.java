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
import com.safeone.dashboard.dto.ZoneDto;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.service.ZoneService;
import com.safeone.dashboard.util.ExcelUtils.FieldDetails;

@Controller
@RequestMapping("/admin/zone")
public class ZoneController extends JqGridAbstract<ZoneDto> {
    @Autowired
    private ZoneService zoneService;
    
	@Autowired
	private CommonCodeService commonCodeService;

    protected ZoneController() {
        super(ZoneDto.class);
    }

	@Override
	public Map<String, FieldDetails> getColumnDataJson() {
		Map<String, FieldDetails> result = super.getColumnDataJson();
		result.get("area_id").type = this.getCommonListStr("area_id");
		result.get("etc1").type = this.getCommonListStr("mapping_id");

		return result;
	}

	private String getCommonListStr(String type) {
		String listStr = ":";
		
		List<Map> list = null;
		if("asset_kind_id".equals(type)) list = commonCodeService.getAssetKindList();
		else if("area_id".equals(type)) list = commonCodeService.getAreaList();
		else if("asset_id".equals(type)) list = commonCodeService.getSensorList();
		else if("zone_id".equals(type)) list = commonCodeService.getZoneList();
		else if("mapping_id".equals(type)) list = commonCodeService.getMappingList();

		for(Map m : list) {
			listStr += ";"+(String)m.get("code")+":"+(String)m.get("name");
		}
		
		return listStr;
	}
    
    @Override
    protected List getList(Map param) {
        return zoneService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        return zoneService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/zone";
    }
    
    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        // todo : 관리자 권한 체크, 삭제에 대한 validate
        return zoneService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	param.put("file1", (String)param.get("serverFileName1"));
    	param.put("file2", (String)param.get("serverFileName2"));
    	
        return zoneService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	param.put("file1", (String)param.get("serverFileName1"));
    	param.put("file2", (String)param.get("serverFileName2"));
    	
    	//기존 데이터 불러오기 
		//int zone_id = Integer.parseInt((String)param.get("zone_id"));
    	//ZoneDto zoneDto = zoneService.read(zone_id);
    	//if ("".equals(param.get("file1")) &&  !"".equals(zoneDto.getFile1()))param.put("file1", zoneDto.getFile1());
    	//if ("".equals(param.get("file2")) &&  !"".equals(zoneDto.getFile2()))param.put("file2", zoneDto.getFile2());
    	
        return zoneService.update(param);
    }
}
