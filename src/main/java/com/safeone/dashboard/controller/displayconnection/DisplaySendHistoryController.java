package com.safeone.dashboard.controller.displayconnection;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.displayconnection.DisplaySendHistoryDto;
import com.safeone.dashboard.service.displayconnection.DisplaySendHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/display-connection/display-send-history")
public class DisplaySendHistoryController extends JqGridAbstract<DisplaySendHistoryDto> {

    @Autowired
    private DisplaySendHistoryService service;

    protected DisplaySendHistoryController() {
        super(DisplaySendHistoryDto.class);
    }

    @Override
    protected List<DisplaySendHistoryDto> getList(Map param) {
        return service.getList(param);
    }

    @Override
    protected int getTotalCount(Map param) {
        return service.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "";
    }
}
