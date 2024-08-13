package com.safeone.dashboard.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.AssetListDto;
import com.safeone.dashboard.dto.DataLogerDto;
import com.safeone.dashboard.dto.DataMeasureDto;

@Controller

public class DataLogerController {
   
    
    @RequestMapping("/admin/dataLoger")
    protected String setViewPage(){
        return "admin/dataLoger";
    }
}