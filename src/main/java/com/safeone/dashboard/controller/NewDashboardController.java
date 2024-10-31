package com.safeone.dashboard.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/new-dashboard")
public class NewDashboardController {


    @GetMapping("/asset/count")
    public int getAssetCount(Map<String, Object> map) {
        return 0;
    }

}
