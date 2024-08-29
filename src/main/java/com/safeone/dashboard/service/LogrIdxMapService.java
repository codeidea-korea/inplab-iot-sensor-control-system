package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.LogrIdxMapMapper;
import com.safeone.dashboard.dto.LogrIdxMapDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class LogrIdxMapService implements JqGridService<LogrIdxMapDto> {

    private final LogrIdxMapMapper mapper;

    @Autowired
    private CommonCodeEditService commonCodeEditService;

    @Override
    public List<LogrIdxMapDto> getList(Map param) {
        return mapper.selectLogrIdxMapList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectLogrIdxMapListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertLogrIdxMap(param) > 0;
    }

    @Override
    public LogrIdxMapDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateLogrIdxMap(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteLogrIdxMap(param);
    }


    public synchronized String saveExcelData(MultipartFile file) throws Exception {
        int failureCount = 0;  // 실패 카운트 초기화
        int successCount = 0;  // 성공 카운트 초기화
        DataFormatter formatter = new DataFormatter();  // 셀 데이터를 문자열로 변환하는데 사용

        try (InputStream is = file.getInputStream()) {
            Workbook workbook = WorkbookFactory.create(is);
            Sheet sheet = workbook.getSheetAt(0);

            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;


                Map<String, Object> newMap = new HashMap<>();
                newMap.put("table_nm", "tb_logr_idx_map");
                newMap.put("column_nm", "mapping_no");
                ObjectNode generationKeyOn = commonCodeEditService.newGenerationKey(newMap);

                Map<String, Object> logrIdxMap = new HashMap<>();

                logrIdxMap.put("mapping_no", generationKeyOn.get("newId").asText());//관리_no

                List<Map> districtInfoNmAbbr = commonCodeEditService.getDistrictInfoNmAbbr(formatter.formatCellValue(row.getCell(0)));
                logrIdxMap.put("district_no", districtInfoNmAbbr.get(0).get("district_no").toString());//현장_no

                Map<String, Object> newMap2 = new HashMap<>();
                newMap2.put("logr_nm", formatter.formatCellValue(row.getCell(3)));

                List<Map> loggerInfoLogrNo = commonCodeEditService.getLoggerInfoLogrNo(newMap2);
                logrIdxMap.put("logr_no", loggerInfoLogrNo.get(0).get("logr_no").toString());//로거_no

                Map<String, Object> newMap3 = new HashMap<>();
                newMap3.put("logr_no", loggerInfoLogrNo.get(0).get("logr_no").toString());
                newMap3.put("sens_nm", formatter.formatCellValue(row.getCell(2)));

                String sensorInfoNm = commonCodeEditService.getSensorInfoNm(newMap3);
                logrIdxMap.put("sens_no", sensorInfoNm);//센서_no

//                logrIdxMap.put("senstype_nm", formatter.formatCellValue(row.getCell(1)));//현장 TYPE명
//                logrIdxMap.put("sens_nm", formatter.formatCellValue(row.getCell(2)));//센서 ID

                logrIdxMap.put("sens_chnl_nm", formatter.formatCellValue(row.getCell(4)));//체널명
                logrIdxMap.put("logr_idx_no", formatter.formatCellValue(row.getCell(5)));//로거_Idx
                logrIdxMap.put("sect_no", formatter.formatCellValue(row.getCell(6)));//단면번호
//                logrIdxMap.put("logr_chnl_seq", formatter.formatCellValue(row.getCell(9)));//채널seq

//                System.out.println("logrIdxMap: " + logrIdxMap);
                 mapper.insertLogrIdxMap(logrIdxMap);
                successCount++;  // 성공 카운트 증가
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("An error occurred while processing the file: " + e.getMessage(), e);
        }

        // 메시지 생성 및 리턴
        String message = "success: " + successCount + ", fail: " + failureCount;
        return message;
    }


}
