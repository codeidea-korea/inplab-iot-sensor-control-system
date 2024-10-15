package com.safeone.dashboard.controller.broadcastsystemconnection;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.broadcastsystemconnection.BroadcastHistoryDto;
import com.safeone.dashboard.dto.broadcastsystemconnection.BroadcastTextDto;
import com.safeone.dashboard.service.broadcastsystemconnection.BroadcastHistoryService;
import com.safeone.dashboard.service.broadcastsystemconnection.BroadcastTextService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/broadcast-history")
public class BroadcastHistoryController extends JqGridAbstract<BroadcastHistoryDto> {
    @Autowired
    private BroadcastHistoryService broadcastHistoryService;

    protected BroadcastHistoryController() {
        super(BroadcastHistoryDto.class);
    }

    @Override
    protected List<BroadcastHistoryDto> getList(Map param) {
        setParam(param);
        return broadcastHistoryService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        setParam(param);
        return broadcastHistoryService.getTotalCount(param);
    }

    private void setParam(Map param) {
        if (param.containsKey("send_dt")) {
            String[] dates = ((String) param.get("send_dt")).split(" ~ ");
            if (dates.length > 1) {
                param.put("send_dt_start", dates[0]);
                param.put("send_dt_end", dates[1]);
            } else {
                param.put("send_dt_start", dates[0]);
                param.put("send_dt_end", dates[0]);
            }
        }
    }

    @Override
    protected String setViewPage() {
        return "";
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return broadcastHistoryService.delete(param);
    }

    @ResponseBody
    @PostMapping("/add")
    public boolean insert(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return broadcastHistoryService.create(param);
    }

    @ResponseBody
    @GetMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return broadcastHistoryService.update(param);
    }

}
