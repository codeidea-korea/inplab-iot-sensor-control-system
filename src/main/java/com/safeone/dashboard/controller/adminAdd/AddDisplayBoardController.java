package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.DelAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.GetAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.InsAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.UdtAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.displayconnection.DisplayBoardDto;
import com.safeone.dashboard.service.DisplayBoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/adminAdd/displayBoard")
public class AddDisplayBoardController {

    private final DisplayBoardService displayBoardService;

    @RequestMapping(value = "/displayBoard", produces = MediaType.APPLICATION_JSON_VALUE, method = {RequestMethod.GET})
    public ResponseEntity<ObjectNode> getDisplayBoard(GetAdminAddDisplayBoardDto getAdminAddDisplayBoardDto) {
        return ResponseEntity.ok(displayBoardService.getDisplayBoard(getAdminAddDisplayBoardDto));
    }

    @RequestMapping(value = "/displayBoard", produces = MediaType.APPLICATION_JSON_VALUE, method = {RequestMethod.POST})
    public ResponseEntity<ObjectNode> insDisplayBoard(@RequestBody List<InsAdminAddDisplayBoardDto> insAdminAddDisplayBoardDtoList) {
        return ResponseEntity.ok(displayBoardService.insDisplayBoard(insAdminAddDisplayBoardDtoList));
    }

    @RequestMapping(value = "/displayBoard", produces = MediaType.APPLICATION_JSON_VALUE, method = {RequestMethod.PUT})
    public ResponseEntity<ObjectNode> udtDisplayBoard(@RequestBody List<UdtAdminAddDisplayBoardDto> udtAdminAddDisplayBoardDtoList) {
        return ResponseEntity.ok(displayBoardService.udtDisplayBoard(udtAdminAddDisplayBoardDtoList));
    }

    @RequestMapping(value = "/displayBoard", produces = MediaType.APPLICATION_JSON_VALUE, method = {RequestMethod.DELETE})
    public ResponseEntity<ObjectNode> delDisplayBoard(@RequestBody List<DelAdminAddDisplayBoardDto> delAdminAddDisplayBoardDtoList) {
        return ResponseEntity.ok(displayBoardService.delDisplayBoard(delAdminAddDisplayBoardDtoList));
    }

    @GetMapping(value = "/all-by-district")
    public List<DisplayBoardDto> all(@RequestParam Map<String, Object> param) {
        return displayBoardService.all(param);
    }

    @PostMapping(value = "/send-history", produces = MediaType.APPLICATION_JSON_VALUE)
    public int sendHistory(@RequestBody Map<String, Object> param) {
        return displayBoardService.sendHistory(param);
    }


}
