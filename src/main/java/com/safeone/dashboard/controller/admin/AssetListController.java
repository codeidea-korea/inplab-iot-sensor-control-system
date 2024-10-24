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
import com.safeone.dashboard.dto.AssetListDto;
import com.safeone.dashboard.dto.UserDto;
import com.safeone.dashboard.service.AssetListService;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.util.ExcelUtil.FieldDetails;

@Controller
@RequestMapping("/admin/assetList")
public class AssetListController extends JqGridAbstract<AssetListDto> {
    @Autowired
    private AssetListService assetListService;
	
    @Autowired
    private CommonCodeService commonCodeService;
    
    protected AssetListController() {
        super(AssetListDto.class);
    }
    
	@Override
	public Map<String, FieldDetails> getColumnDataJson() {
		Map<String, FieldDetails> result = super.getColumnDataJson();
		((FieldDetails)result.get("status")).type = this.getCommonCodeListStr("센서상태");//status
		((FieldDetails)result.get("asset_kind_id")).type = this.getCommonListStr("asset_kind_id");
//		((FieldDetails)result.get("area_id")).type = this.getCommonListStr("area_id");
		((FieldDetails)result.get("zone_id")).type = this.getCommonListStr("zone_id");
		
		return result;
	}

	private String getCommonListStr(String type) {
		String listStr = ":";
		
		List<Map> list = null;
		if("asset_kind_id".equals(type)) list = commonCodeService.getAssetKindList();
//		else if("area_id".equals(type)) list = commonCodeService.getAreaList();
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
        if (param.containsKey("collect_date")) {
            String[] dates = ((String)param.get("collect_date")).split(" ~ ");
            if(dates.length > 1) {
                param.put("collect_date_start", dates[0]);
                param.put("collect_date_end", dates[1]);
            }else {
                param.put("collect_date_start", dates[0]);
                param.put("collect_date_end", dates[0]);
            }
        } else if(param.containsKey("install_date")) {
            String[] dates = ((String)param.get("install_date")).split(" ~ ");
            if(dates.length > 1) {
                param.put("install_date_start", dates[0]);
                param.put("install_date_end", dates[1]);
            }else {
                param.put("install_date_start", dates[0]);
                param.put("install_date_end", dates[0]);
            }
        }
        return assetListService.getList(param);
    }
    
    @Override
    protected int getTotalRows(Map param) {
        if(param.containsKey("collect_date")) {
            String[] dates = ((String)param.get("collect_date")).split(" ~ ");
            if(dates.length > 1) {
                param.put("collect_date_start", dates[0]);
                param.put("collect_date_end", dates[1]);
            }else {
                param.put("collect_date_start", dates[0]);
                param.put("collect_date_end", dates[0]);
            }
        } else if(param.containsKey("install_date")) {
            String[] dates = ((String)param.get("install_date")).split(" ~ ");
            if(dates.length > 1) {
                param.put("install_date_start", dates[0]);
                param.put("install_date_end", dates[1]);
            }else {
                param.put("install_date_start", dates[0]);
                param.put("install_date_end", dates[0]);
            }
        }
        return assetListService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/assetList";
    }
    
    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        // todo : 관리자 권한 체크, 삭제에 대한 validate
        return assetListService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	
    	HttpSession session = request.getSession();
//        param.put("mod_user", ((UserDto) session.getAttribute("login")).getUser_id());
        return assetListService.create(param);
    }
    
    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	
    	HttpSession session = request.getSession();
//        param.put("mod_user", ((UserDto) session.getAttribute("login")).getUser_id());
        return assetListService.update(param);
    }
}
