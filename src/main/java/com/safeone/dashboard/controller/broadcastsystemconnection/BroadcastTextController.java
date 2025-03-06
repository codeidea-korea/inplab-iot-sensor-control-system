package com.safeone.dashboard.controller.broadcastsystemconnection;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.broadcastsystemconnection.BroadcastInfoDto;
import com.safeone.dashboard.dto.broadcastsystemconnection.BroadcastTextDto;
import com.safeone.dashboard.service.broadcastsystemconnection.BroadcastTextService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/broadcast-text")
public class BroadcastTextController extends JqGridAbstract<BroadcastTextDto> {
    @Autowired
    private BroadcastTextService broadcastTextService;

    protected BroadcastTextController() {
        super(BroadcastTextDto.class);
    }

    @ResponseBody
    @GetMapping("/broadcast-info")
    public List<BroadcastInfoDto> getAllBroadCastInfo() {
        return broadcastTextService.getAllBroadCastInfo();
    }

    @Override
    protected List<BroadcastTextDto> getList(Map param) {
        setParam(param);
        return broadcastTextService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        setParam(param);
        return broadcastTextService.getTotalCount(param);
    }

    private void setParam(Map param) {
    }

    @Override
    protected String setViewPage() {
        return "";
    }

    @ResponseBody
    @PostMapping("/save")
    public boolean save(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        JsonArray jArray = ((new JsonParser()).parse(param.get("jsonData").toString())).getAsJsonArray();
        for(JsonElement el : jArray) {
            Map m = (new Gson()).fromJson(el, Map.class);
            String mgnt_no = (String)m.get("mgnt_no");
            if (mgnt_no == null || mgnt_no.isEmpty()) {
                broadcastTextService.create(m);
            } else {
                broadcastTextService.update(m);
            }
        }
        return true;
    }

    @ResponseBody
    @PostMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return broadcastTextService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return broadcastTextService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return broadcastTextService.update(param);
    }

}
