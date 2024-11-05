package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.*;
import com.safeone.dashboard.service.CctvService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/adminAdd/cctv")
public class AddCctvController {

    private final CctvService cctvService;

    @RequestMapping(value = "/cctv", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getCctv(GetAdminAddCctvDto getAdminAddCctvDto) {
        return ResponseEntity.ok(cctvService.getCctv(getAdminAddCctvDto));
    }

    @RequestMapping(value = "/cctv", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.POST })
    public ResponseEntity<ObjectNode> insCctv(@RequestBody List<InsAdminAddCctvDto> insAdminAddCctvDtoList) {
        return ResponseEntity.ok(cctvService.insCctv(insAdminAddCctvDtoList));
    }

    @RequestMapping(value = "/cctv", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.PUT })
    public ResponseEntity<ObjectNode> udtUserList(@RequestBody List<UdtAdminAddCctvDto> udtAdminAddCctvDtoList) {
        return ResponseEntity.ok(cctvService.udtCctv(udtAdminAddCctvDtoList));
    }

    @RequestMapping(value = "/cctv", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.DELETE })
    public ResponseEntity<ObjectNode> delUserList(@RequestBody List<DelAdminAddCctvDto> delAdminAddCctvDtoList) {
        return ResponseEntity.ok(cctvService.delCctv(delAdminAddCctvDtoList));
    }

    @RequestMapping(value = "/district", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getDistrict(GetAdminAddDistrictDto getAdminAddDistrictDto) {
        return ResponseEntity.ok(cctvService.getDistrict(getAdminAddDistrictDto));
    }

    @RequestMapping(value = "/maintComp", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getMaintComp(GetAdminAddMaintCompDto getAdminAddDistrictDto) {
        return ResponseEntity.ok(cctvService.getMaintComp(getAdminAddDistrictDto));
    }

    @GetMapping(value = "/max-no")
    public String newGenerationKey() {
        return cctvService.getMaxNo();
    }
}
