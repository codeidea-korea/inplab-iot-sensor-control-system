package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.DelAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.GetAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.InsAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.UdtAdminAddDisplayBoardDto;
import com.safeone.dashboard.service.DisplayBoardService;
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
@RequestMapping("/adminAdd/displayBoard")
public class AddDisplayBoardController {

    private final DisplayBoardService DisplayBoardvService;

    @RequestMapping(value = "/displayBoard", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getDisplayBoard(GetAdminAddDisplayBoardDto getAdminAddDisplayBoardDto) {
        return ResponseEntity.ok(DisplayBoardvService.getDisplayBoard(getAdminAddDisplayBoardDto));
    }

    @RequestMapping(value = "/displayBoard", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.POST })
    public ResponseEntity<ObjectNode> insDisplayBoard(@RequestBody List<InsAdminAddDisplayBoardDto> insAdminAddDisplayBoardDtoList) {
        return ResponseEntity.ok(DisplayBoardvService.insDisplayBoard(insAdminAddDisplayBoardDtoList));
    }

    @RequestMapping(value = "/displayBoard", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.PUT })
    public ResponseEntity<ObjectNode> udtDisplayBoard(@RequestBody List<UdtAdminAddDisplayBoardDto> udtAdminAddDisplayBoardDtoList) {
        return ResponseEntity.ok(DisplayBoardvService.udtDisplayBoard(udtAdminAddDisplayBoardDtoList));
    }

    @RequestMapping(value = "/displayBoard", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.DELETE })
    public ResponseEntity<ObjectNode> delDisplayBoard(@RequestBody List<DelAdminAddDisplayBoardDto> delAdminAddDisplayBoardDtoList) {
        return ResponseEntity.ok(DisplayBoardvService.delDisplayBoard(delAdminAddDisplayBoardDtoList));
    }
}
