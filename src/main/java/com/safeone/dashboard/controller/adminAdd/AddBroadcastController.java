package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.*;
import com.safeone.dashboard.service.BroadcastService;
import com.safeone.dashboard.service.CctvService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/adminAdd/broadcast")
public class AddBroadcastController {

    private final BroadcastService broadcastvService;

    @RequestMapping(value = "/broardcast", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getBroadcast(GetAdminAddBroadcastDto getAdminAddBroadcastDto) {
        return ResponseEntity.ok(broadcastvService.getBroadcast(getAdminAddBroadcastDto));
    }

    @RequestMapping(value = "/broardcast", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.POST })
    public ResponseEntity<ObjectNode> insBroadcast(@RequestBody List<InsAdminAddBroadcastDto> insAdminAddBroadcastDtoList) {
        return ResponseEntity.ok(broadcastvService.insBroadcast(insAdminAddBroadcastDtoList));
    }

    @RequestMapping(value = "/broardcast", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.PUT })
    public ResponseEntity<ObjectNode> udtBroadcast(@RequestBody List<UdtAdminAddBroadcastDto> udtAdminAddBroadcastDtoList) {
        return ResponseEntity.ok(broadcastvService.udtBroadcast(udtAdminAddBroadcastDtoList));
    }

    @RequestMapping(value = "/broardcast", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.DELETE })
    public ResponseEntity<ObjectNode> delBroadcast(@RequestBody List<DelAdminAddBroadcastDto> delAdminAddBroadcastDtoList) {
        return ResponseEntity.ok(broadcastvService.delBroadcast(delAdminAddBroadcastDtoList));
    }
}
