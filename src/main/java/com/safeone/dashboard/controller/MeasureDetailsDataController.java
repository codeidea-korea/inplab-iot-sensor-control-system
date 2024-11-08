package com.safeone.dashboard.controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.MeasureDetailsDataDto;
import com.safeone.dashboard.service.MeasureDetailsDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/measure-details-data")
public class MeasureDetailsDataController extends JqGridAbstract<MeasureDetailsDataDto> {
    @Autowired
    private MeasureDetailsDataService measureDetailsDataService;

    protected MeasureDetailsDataController() {
        super(MeasureDetailsDataDto.class);
    }

    @Override
    protected List getList(Map param) {
        return measureDetailsDataService.getList(param);
    }

    @ResponseBody
    @PostMapping("/save")
    public boolean save(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        JsonArray jArray = ((new JsonParser()).parse(param.get("jsonData").toString())).getAsJsonArray();
        for (JsonElement el : jArray) {
            Map m = (new Gson()).fromJson(el, Map.class);
            if (m.get("is_new") != null && !m.get("is_new").equals("")) {
                measureDetailsDataService.createXYZ(m);
            } else {
                measureDetailsDataService.updateXYZ(m);
            }
        }
        return true;
    }

    @ResponseBody
    @PostMapping("/excel")
    public boolean excel(@RequestBody Map<String, Object> param) {
        measureDetailsDataService.deleteAll(param);

        JsonArray jArray = (new JsonParser())
                .parse(param.get("jsonData").toString())
                .getAsJsonArray();
        for (JsonElement el : jArray) {
            Map m = (new Gson()).fromJson(el, Map.class);
            measureDetailsDataService.save(m, param.get("sensNo").toString());
        }
        return true;
    }

    @ResponseBody
    @PostMapping("/del")
    public boolean del(@RequestParam Map<String, Object> param) {
        JsonArray jArray = (new JsonParser())
                .parse(param.get("jsonData").toString())
                .getAsJsonArray();
        for (JsonElement el : jArray) {
            Map m = (new Gson()).fromJson(el, Map.class);
            measureDetailsDataService.deleteRow(m);
        }
        return true;
    }

    @Override
    protected int getTotalRows(Map param) {
        return measureDetailsDataService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "measure-details-data";
    }
}
