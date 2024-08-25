package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dto.*;
import com.safeone.dashboard.service.CctvService;
import com.safeone.dashboard.service.ExcelService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/adminAdd/excel")
public class AddExcelController {

    private final ExcelService excelService;

    @RequestMapping(value = "/down", produces = MediaType.APPLICATION_JSON_VALUE, method = { RequestMethod.GET, RequestMethod.POST })
    public void excelDown(@RequestBody ExcelDto excelDto, HttpServletRequest request, HttpServletResponse response) throws Exception {
        excelService.excelDown(excelDto, request, response);
    }
}
