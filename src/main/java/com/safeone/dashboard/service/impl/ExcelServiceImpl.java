package com.safeone.dashboard.service.impl;

import com.safeone.dashboard.dto.*;
import com.safeone.dashboard.service.ExcelService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Slf4j
@Transactional
@Service("excelService")
@RequiredArgsConstructor
public class ExcelServiceImpl implements ExcelService {

    public void excelDown(ExcelDto excelDto, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Sheet1");
        sheet.setDefaultColumnWidth(28);

        // 헤더
        XSSFCellStyle headerXssfCellStyle = (XSSFCellStyle) workbook.createCellStyle();

        XSSFFont headerXSSFFont = (XSSFFont) workbook.createFont();
        headerXSSFFont.setColor(new XSSFColor());
        headerXssfCellStyle.setFont(headerXSSFFont);
        headerXssfCellStyle.setBorderLeft(BorderStyle.THIN);
        headerXssfCellStyle.setBorderRight(BorderStyle.THIN);
        headerXssfCellStyle.setBorderTop(BorderStyle.THIN);
        headerXssfCellStyle.setBorderBottom(BorderStyle.THIN);
        headerXssfCellStyle.setFillForegroundColor(new XSSFColor(java.awt.Color.WHITE));
        headerXssfCellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        // 바디
        XSSFCellStyle bodyXssfCellStyle = (XSSFCellStyle) workbook.createCellStyle();

        bodyXssfCellStyle.setBorderLeft(BorderStyle.THIN);
        bodyXssfCellStyle.setBorderRight(BorderStyle.THIN);
        bodyXssfCellStyle.setBorderTop(BorderStyle.THIN);
        bodyXssfCellStyle.setBorderBottom(BorderStyle.THIN);

        int rowCount = 0;
        int headerCount = 0;
        Row headerRow = sheet.createRow(rowCount++);
        for (String header : excelDto.getHeader()) {
            Cell headerCell = headerRow.createCell(headerCount++);
            headerCell.setCellValue(header);
            headerCell.setCellStyle(headerXssfCellStyle);
        }

        for (List<String> row : excelDto.getRows()) {
            Row bodyRow = sheet.createRow(rowCount++);
            int cellCount = 0;
            for (String cell : row) {
                Cell bodyCell = bodyRow.createCell(cellCount++);
                bodyCell.setCellValue(cell);
                bodyCell.setCellStyle(bodyXssfCellStyle);
            }
        }

        String fileName = excelDto.getFile_name() + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + ".xlsx";

        // 브라우저별로 파일명을 다르게 인코딩하여 설정
        String encodedFilename = java.net.URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
        String userAgent = request.getHeader("User-Agent");

        if (userAgent.contains("MSIE") || userAgent.contains("Trident") || userAgent.contains("Edge")) {
            // IE 및 Edge 브라우저용
            response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFilename + "\"");
        } else if (userAgent.contains("Firefox")) {
            // Firefox 브라우저용
            response.setHeader("Content-Disposition", "attachment; filename*=\"UTF-8''" + encodedFilename + "\"");
        } else {
            // Chrome, Safari, Opera, 기타 브라우저용
            response.setHeader("Content-Disposition", "attachment; filename=\"" + java.net.URLDecoder.decode(encodedFilename, "UTF-8") + "\"");
        }
        // Content-Type 설정
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");

        try (OutputStream os = response.getOutputStream()) {
            workbook.write(os);
            os.flush();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

}
