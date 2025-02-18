package com.safeone.dashboard.controller;

import com.safeone.dashboard.service.NewDashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/new-dashboard")
@RequiredArgsConstructor
public class NewDashboardController {

    private final NewDashboardService newDashboardService;

    @GetMapping("/asset/count")
    public int getAssetCount(@RequestParam Map<String, Object> map) {
        int count = 0;
        count += newDashboardService.getSensorsCount(map);
        return count;
    }

    @GetMapping("/asset/all")
    public Map<String, Object> getAssetAll(@RequestParam Map<String, Object> map) {
        Map<String, Object> result = new HashMap<>();
        result.put("sensors", newDashboardService.getSensors(map));
        return result;
    }

}
