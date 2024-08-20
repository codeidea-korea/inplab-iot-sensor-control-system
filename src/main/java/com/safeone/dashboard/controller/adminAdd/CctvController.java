package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.DelAdminAddCctvDto;
import com.safeone.dashboard.dto.GetAdminAddCctvDto;
import com.safeone.dashboard.dto.InsAdminAddCctvDto;
import com.safeone.dashboard.dto.UdtAdminAddCctvDto;
import com.safeone.dashboard.service.CctvService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

import javax.servlet.http.HttpServletRequest;
import java.nio.charset.StandardCharsets;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/adminAdd/cctv")
@Tag(name = "cctv-controller", description = "관리자 전용 > 장치 관리 > cctv 관리")
public class CctvController {

    private final CctvService cctvService;

    private final ObjectMapper objectMapper;

    @Operation(summary = "cctv 불러오기", description = "")
    @RequestMapping(value = "/cctv", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET })
    public ResponseEntity<ObjectNode> getCctv(GetAdminAddCctvDto getAdminAddCctvDto) {
        return ResponseEntity.ok(cctvService.getCctv(getAdminAddCctvDto));
    }

    @Operation(summary = "cctv 등록하기", description = "")
    @RequestMapping(value = "/cctv", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.POST })
    public ResponseEntity<ObjectNode> insCctv(InsAdminAddCctvDto insAdminAddCctvDto) {
        return ResponseEntity.ok(cctvService.insCctv(insAdminAddCctvDto));
    }

    @Operation(summary = "cctv 수정하기", description = "")
    @RequestMapping(value = "/cctv", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.PUT })
    public ResponseEntity<ObjectNode> udtUserList(@RequestBody List<UdtAdminAddCctvDto> udtAdminAddCctvDtoList) {
        return ResponseEntity.ok(cctvService.udtCctv(udtAdminAddCctvDtoList));
    }

    @Operation(summary = "cctv 삭제하기", description = "")
    @RequestMapping(value = "/cctv", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.DELETE })
    public ResponseEntity<ObjectNode> delUserList(@RequestBody DelAdminAddCctvDto delAdminAddCctvDto) {
        return ResponseEntity.ok(cctvService.delCctv(delAdminAddCctvDto));
    }
}
