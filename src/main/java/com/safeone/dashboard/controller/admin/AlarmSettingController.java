package com.safeone.dashboard.controller.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.AlarmSettingDto;
import com.safeone.dashboard.dto.UserDto;
import com.safeone.dashboard.service.AlarmSettingService;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.util.ExcelUtil.FieldDetails;

@Controller
@RequestMapping("/admin/alarmSetting")
public class AlarmSettingController extends JqGridAbstract<AlarmSettingDto> {
    @Autowired
    private AlarmSettingService alarmSettingService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    protected AlarmSettingController() {
        super(AlarmSettingDto.class);
    }

	@Override
	public Map<String, FieldDetails> getColumnDataJson() {
		
		String assetKindListStr = ":";
		List<Map> assetKindList = commonCodeService.getAssetKindList();
		
		for(Map ak : assetKindList) {
			assetKindListStr += ";"+(String)ak.get("code")+":"+(String)ak.get("name");
		}
		
		Map<String, FieldDetails> result = super.getColumnDataJson();
//		((FieldDetails)result.get("risk_level")).type = this.getCommonCodeListStr("위험레벨");//risk_level
		// ((FieldDetails)result.get("category")).type = this.getCommonCodeListStr("알람카테고리");//category
		// ((FieldDetails)result.get("type")).type = this.getCommonCodeListStr("알람종류타입");//type
		((FieldDetails)result.get("asset_kind_id")).type = assetKindListStr;//asset_kind
		
		return result;
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
        return alarmSettingService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        return alarmSettingService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/alarmSetting";
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	
        HttpSession session = request.getSession();
        param.put("mod_user", ((UserDto) session.getAttribute("login")).getUser_id());
        return alarmSettingService.update(param);
    }
}
