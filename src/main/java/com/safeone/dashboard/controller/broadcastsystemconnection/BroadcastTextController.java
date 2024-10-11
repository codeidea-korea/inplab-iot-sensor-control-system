package com.safeone.dashboard.controller.broadcastsystemconnection;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.broadcastsystemconnection.BroadcastTextDto;
import com.safeone.dashboard.service.broadcastsystemconnection.BroadcastTextService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return broadcastTextService.delete(param);
    }

    @ResponseBody
    @GetMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        param.put("file1", (String) param.get("serverFileName"));

        return broadcastTextService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        param.put("file1", (String) param.get("serverFileName"));

        return broadcastTextService.update(param);
    }

}
