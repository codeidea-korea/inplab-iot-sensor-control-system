package com.safeone.dashboard.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.CalcDto;
import com.safeone.dashboard.service.CalcService;
import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.util.ExcelUtils.FieldDetails;

@Controller
@RequestMapping("/calc")
public class CalcController extends JqGridAbstract<CalcDto> {
    @Autowired
    private CalcService calcService;

    @Autowired
    private CommonCodeService commonCodeService;
    
    protected CalcController() {
        super(CalcDto.class);
    }

	@Override
	public Map<String, FieldDetails> getColumnDataJson() {
		String assetKindListStr = ":";
		List<Map> assetKindList = commonCodeService.getAssetKindList();
		
		for(Map ak : assetKindList) {
			assetKindListStr += ";"+(String)ak.get("name")+":"+(String)ak.get("name");
		}

        String zoneNameListStr = ":";
        List<Map> zoneNameList = commonCodeService.getZoneList();
        for (Map zn : zoneNameList) {
            zoneNameListStr += ";" + (String) zn.get("name") + ":" + (String) zn.get("name");
        }
		Map<String, FieldDetails> result = super.getColumnDataJson();
		((FieldDetails)result.get("asset_kind_name")).type = assetKindListStr;
        ((FieldDetails) result.get("zone_name")).type = zoneNameListStr;// zone_name
		return result;
	}

    @Override
    protected List getList(Map param) {
        return calcService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        return calcService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "calc";
    }

    @ResponseBody
    @PostMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	JsonArray jArray = ((new JsonParser()).parse(param.get("jsonData").toString())).getAsJsonArray();
    	for(JsonElement el : jArray) {
    		Map m = (new Gson()).fromJson(el, Map.class);
    		
    		calcService.update(m);
    	}
    	return true;
    }
    
    @ResponseBody
    @PostMapping("/init")
    public boolean init(HttpServletRequest request, @RequestParam Map<String, Object> param) {
    	calcService.initCalc();
    	return true;
    }
    
}
