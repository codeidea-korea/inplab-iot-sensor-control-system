package com.safeone.dashboard.controller.modify;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.GetModifySensorDto;
import com.safeone.dashboard.service.ModifySensorService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/modify/sensor")
public class ModifySensorController {

    private final ModifySensorService modifyCctvService;

    @RequestMapping(value = "/sensor", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getSensor(GetModifySensorDto getModifyCctvDto) {
        return ResponseEntity.ok(modifyCctvService.getSensor(getModifyCctvDto));
    }

    @RequestMapping(value = "/distinct", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getDistinct() {
        return ResponseEntity.ok(modifyCctvService.getDistinct());
    }


    @GetMapping("/count")
    public int count(Map param) {
        return modifyCctvService.getSimpleTotalCount(param);
    }
}
