package com.safeone.dashboard.controller.modify;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.*;
import com.safeone.dashboard.service.CctvService;
import com.safeone.dashboard.service.ModifyCctvService;
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
@RequestMapping("/modify/cctv")
public class ModifyCctvController {

    private final ModifyCctvService modifyCctvService;

    @RequestMapping(value = "/cctv", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getCctv(GetModifyCctvDto getModifyCctvDto) {
        return ResponseEntity.ok(modifyCctvService.getCctv(getModifyCctvDto));
    }
}
