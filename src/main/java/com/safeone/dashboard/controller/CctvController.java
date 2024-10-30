package com.safeone.dashboard.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.CctvListDto;
import com.safeone.dashboard.service.CctvListService;
import com.safeone.dashboard.service.CommonCodeService;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/cctv")
public class CctvController extends JqGridAbstract<CctvListDto> {
    @Autowired
    private CctvListService cctvListService;

    @Autowired
    private CommonCodeService commonCodeService;

    protected CctvController() {
        super(CctvListDto.class);
    }

    @Override
    protected List getList(Map param) {
        return cctvListService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        return cctvListService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "cctv";
    }

    @GetMapping("/count")
    @ResponseBody
    public int count(Map param) {
        return cctvListService.getTotalCount(param);
    }

}
