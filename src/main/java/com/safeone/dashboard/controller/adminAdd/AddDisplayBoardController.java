package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.DelAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.GetAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.InsAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.UdtAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.displayconnection.DisplayBoardDto;
import com.safeone.dashboard.service.DisplayBoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
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
    public ResponseEntity<ObjectNode> delDisplayBoard(@RequestBody Object requestBody) {
        List<DelAdminAddDisplayBoardDto> delAdminAddDisplayBoardDtoList = new ArrayList<>();
        if (requestBody instanceof List<?>) {
            for (Object item : (List<?>) requestBody) {
                if (item instanceof Map<?, ?>) {
                    Object dispbdNo = ((Map<?, ?>) item).get("dispbd_no");
                    if (dispbdNo != null) {
                        delAdminAddDisplayBoardDtoList.add(DelAdminAddDisplayBoardDto.builder()
                                .dispbd_no(String.valueOf(dispbdNo))
                                .build());
                    }
                }
            }
        } else if (requestBody instanceof Map<?, ?>) {
            Object dispbdNo = ((Map<?, ?>) requestBody).get("dispbd_no");
            if (dispbdNo != null) {
                delAdminAddDisplayBoardDtoList.add(DelAdminAddDisplayBoardDto.builder()
                        .dispbd_no(String.valueOf(dispbdNo))
                        .build());
            }
        }
        return ResponseEntity.ok(displayBoardService.delDisplayBoard(delAdminAddDisplayBoardDtoList));
    }

    @GetMapping(value = "/max-dispbd-no", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> getMaxDispbdNo() {
        return ResponseEntity.ok(displayBoardService.getMaxDispbdNo());
    }

    @GetMapping(value = "/all-by-district")
    public List<DisplayBoardDto> all(@RequestParam Map<String, Object> param) {
        return displayBoardService.all(param);
    }

    @PostMapping(value = "/send-history", produces = MediaType.APPLICATION_JSON_VALUE)
    public int sendHistory(@RequestBody Map<String, Object> param) {
        return displayBoardService.sendHistory(param);
    }

    @PostMapping(value = "/send-test", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> sendTest(@RequestBody Map<String, Object> param) {
        return displayBoardService.sendTest(param);
    }

    @GetMapping(value = "/sim-image")
    public ResponseEntity<byte[]> simulatorImage(@RequestParam Map<String, Object> param) {
        Map<String, Object> image = displayBoardService.getSimulatorImageData(param);
        return toImageResponse(image);
    }

    @GetMapping(value = "/sim-image/{mgntNo}.jpg")
    public ResponseEntity<byte[]> simulatorImageByMgntNo(@PathVariable("mgntNo") String mgntNo) {
        Map<String, Object> image = displayBoardService.getSimulatorImageDataByMgntNo(mgntNo);
        return toImageResponse(image);
    }

    private ResponseEntity<byte[]> toImageResponse(Map<String, Object> image) {
        if (image == null || image.get("bytes") == null) {
            return ResponseEntity.notFound().build();
        }

        String contentType = String.valueOf(image.getOrDefault("contentType", "image/jpeg"));
        byte[] bytes = (byte[]) image.get("bytes");
        return ResponseEntity.ok()
                .header(HttpHeaders.CACHE_CONTROL, "no-store")
                .contentType(MediaType.parseMediaType(contentType))
                .body(bytes);
    }


}
