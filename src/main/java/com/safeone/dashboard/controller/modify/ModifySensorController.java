package com.safeone.dashboard.controller.modify;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.GetModifySensorDto;
import com.safeone.dashboard.dto.SensorDto;
import com.safeone.dashboard.service.ModifySensorService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/modify/sensor")
public class ModifySensorController {

    private final ModifySensorService service;

    @RequestMapping(value = "/sensor", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getSensor(GetModifySensorDto getModifyCctvDto) {
        return ResponseEntity.ok(service.getSensor(getModifyCctvDto));
    }

    @RequestMapping(value = "/distinct", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getDistinct() {
        return ResponseEntity.ok(service.getDistinct());
    }


    @GetMapping("/count")
    public int count(Map param) {
        return service.getSimpleTotalCount(param);
    }

    @GetMapping("/all")
    @ResponseBody
    public List<SensorDto> getAll(@RequestParam  Map<String, Object> param) {
        return service.getAll(param);
    }
}
