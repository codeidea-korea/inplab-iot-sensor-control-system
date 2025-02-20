package com.safeone.dashboard.controller.operationconfigurationsetting;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.operationconfigurationsetting.SmsManagementDto;
import com.safeone.dashboard.service.operationconfigurationsetting.SmsManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/operation-configuration-setting/sms-management")
public class SmsManagementController extends JqGridAbstract<SmsManagementDto> {

    @Autowired
    private SmsManagementService smsManagementService;

    protected SmsManagementController() {
        super(SmsManagementDto.class);
    }

    @Override
    protected List<SmsManagementDto> getList(Map<String, Object> param) {
        setParam(param);
        return smsManagementService.getList(param);
    }

    @Override
    protected int getTotalRows(Map<String, Object> param) {
        setParam(param);
        return smsManagementService.getTotalCount(param);
    }

    private void setParam(Map<String, Object> param) {
    }

    @Override
    protected String setViewPage() {
        return "operation-configuration-setting/sms-management";
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(@RequestParam Map<String, Object> param) {
        return smsManagementService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(@RequestParam Map<String, Object> param) {
        param.put("file1", param.get("serverFileName"));

        return smsManagementService.create(param);
    }

    @ResponseBody
    @PostMapping("/mod")
    public boolean update(@RequestParam Map<String, Object> param) {
        JsonArray jArray = ((new JsonParser()).parse(param.get("jsonData").toString())).getAsJsonArray();
        for (JsonElement el : jArray) {
            Map<String, Object> m = (new Gson()).fromJson(el, Map.class);
            smsManagementService.update(m);
        }
        return true;
    }

}
