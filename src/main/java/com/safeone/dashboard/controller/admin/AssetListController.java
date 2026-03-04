package com.safeone.dashboard.controller.admin;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.safeone.dashboard.dto.EquipmentDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.safeone.dashboard.service.AssetListService;

@Controller
@RequestMapping("/admin/assetList")
public class AssetListController {
    @Autowired
    private AssetListService assetListService;

    @ResponseBody
    @GetMapping("/getEquipmentList")
    public List<EquipmentDto> getEquipmentList(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return assetListService.getEquipmentList(param);
    }
}
