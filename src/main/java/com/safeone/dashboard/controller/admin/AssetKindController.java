package com.safeone.dashboard.controller.admin;

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
import com.safeone.dashboard.dto.AssetKindDto;
import com.safeone.dashboard.dto.UserDto;
import com.safeone.dashboard.service.AssetKindService;

@Controller
@RequestMapping("/admin/assetKind")
public class AssetKindController extends JqGridAbstract<AssetKindDto> {
    @Autowired
    private AssetKindService assetKindService;

    protected AssetKindController() {
        super(AssetKindDto.class);
    }

    // @Override
    // public Map<String, FieldDetails> getColumnDataJson() {
    //     // TODO Auto-generated method stub
    //     Map<String, FieldDetails> result = super.getColumnDataJson();
    //     ((FieldDetails)result.get("etc1")).type = "0:테스트;1:테스트1;2:테스트2";
        
    //     return result;
    // }

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
    	
        return assetKindService.getList(param);
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
    	
        return assetKindService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/assetKind";
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return assetKindService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	HttpSession session = request.getSession();
//        param.put("mod_user", ((UserDto) session.getAttribute("login")).getUser_id());
        return assetKindService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	HttpSession session = request.getSession();
//        param.put("mod_user", ((UserDto) session.getAttribute("login")).getUser_id());
        return assetKindService.update(param);
    }
}
