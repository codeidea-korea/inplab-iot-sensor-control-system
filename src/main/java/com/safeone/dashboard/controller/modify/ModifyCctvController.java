package com.safeone.dashboard.controller.modify;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.GetModifyCctvDto;
import com.safeone.dashboard.service.ModifyCctvService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/modify/cctv")
public class ModifyCctvController {

    private final ModifyCctvService modifyCctvService;

    @RequestMapping(value = "/cctv", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getCctv(GetModifyCctvDto getModifyCctvDto) {
        return ResponseEntity.ok(modifyCctvService.getCctv(getModifyCctvDto));
    }

    @GetMapping("/operation")
    public String getOperation(@RequestParam Map<String, Object> param) {
        return modifyCctvService.operation(param);
    }
}
