package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.*;
import com.safeone.dashboard.service.CctvService;
import com.safeone.dashboard.service.SensorAddService;
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
@RequestMapping("/adminAdd/sensor")
public class AddSensorController {

    private final SensorAddService sensorAddService;

    @RequestMapping(value = "/sensor", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getSensor(GetAdminAddSensorDto getAdminAddSensorDto) {
        return ResponseEntity.ok(sensorAddService.getSensor(getAdminAddSensorDto));
    }

    @RequestMapping(value = "/measureDetails", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getMeasureDetails(GetAdminAddMeasureDetailsDto getAdminAddSensorDto) {
        return ResponseEntity.ok(sensorAddService.getMeasureDetails(getAdminAddSensorDto));
    }

    @RequestMapping(value = "/actUdtIns", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.POST })
    public ResponseEntity<ObjectNode> actUdtIns(@RequestBody InsAdminAddMeasureDetailsDto getAdminAddSensorDto) {
        return ResponseEntity.ok(sensorAddService.actUdtIns(getAdminAddSensorDto));
    }
}
