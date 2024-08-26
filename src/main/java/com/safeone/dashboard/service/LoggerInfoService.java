package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.LoggerInfoMapper;
import com.safeone.dashboard.dto.LoggerInfoDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class LoggerInfoService implements JqGridService<LoggerInfoDto> {

    private final LoggerInfoMapper mapper;

    @Autowired
    private CommonCodeEditService commonCodeEditService;

    @Override
    public List<LoggerInfoDto> getList(Map param) {
        return mapper.selectLoggerInfoList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectLoggerInfoListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertLoggerInfo(param) > 0;
    }

    @Override
    public LoggerInfoDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateLoggerInfo(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteLoggerInfo(param);
    }


    public synchronized String saveExcelData(MultipartFile file) throws Exception {
        int failureCount = 0;  // 실패 카운트 초기화
        int successCount = 0;  // 성공 카운트 초기화
        DataFormatter formatter = new DataFormatter();  // 셀 데이터를 문자열로 변환하는데 사용

        try (InputStream is = file.getInputStream()) {
            Workbook workbook = WorkbookFactory.create(is);
            Sheet sheet = workbook.getSheetAt(0);

            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;  // 헤더 행 건너뛰기

                // district 값 검증
                String districtValue = formatter.formatCellValue(row.getCell(1));
                if (districtValue == null || districtValue.isEmpty()) {
                    failureCount++;
                    continue;  // 빈 값이면 해당 행 건너뛰기
                }

                // district 정보 가져오기
                List<Map> district = commonCodeEditService.getDistrictInfoNmAbbr(districtValue);

                // district 정보가 없으면 실패 카운트 증가하고 건너뛰기
                if (district == null || district.isEmpty()) {
                    failureCount++;
                    continue;
                }

                Map<String, Object> loggerInfo = new HashMap<>();
                String logr_nm_type;

                Map<String, Object> newMap = new HashMap<>();
                newMap.put("table_nm", "tb_logger_info");
                newMap.put("column_nm", "logr_no");

                // GNSS 값 검증 및 처리
                String typeValue = formatter.formatCellValue(row.getCell(0));
                if ("GNSS".equals(typeValue)) {
                    newMap.put("pre_type", typeValue);
                }

                ObjectNode generationKeyOn = commonCodeEditService.newGenerationKey(newMap);

                String newId = generationKeyOn.get("newId").asText();
                String newIdNo = newId.replaceAll("^[A-Za-z]", "");

                String prefix = "GNSS".equals(typeValue) ? "GNS" : "LOG";
                logr_nm_type = district.get(0).get("dist_abbr") + prefix + newIdNo;

                loggerInfo.put("logr_no", newId);
                loggerInfo.put("logr_nm", logr_nm_type);

                loggerInfo.put("district_no", district.get(0).get("district_no"));
                loggerInfo.put("inst_ymd", formatter.formatCellValue(row.getCell(2)));  // 날짜 셀
                loggerInfo.put("logr_MAC", formatter.formatCellValue(row.getCell(3)));
                loggerInfo.put("logr_ip", formatter.formatCellValue(row.getCell(4)));
                loggerInfo.put("logr_port", formatter.formatCellValue(row.getCell(5)));  // 숫자 셀
                loggerInfo.put("logr_svr_ip", formatter.formatCellValue(row.getCell(6)));
                loggerInfo.put("logr_svr_port", formatter.formatCellValue(row.getCell(7)));  // 숫자 셀
                loggerInfo.put("logr_maker", formatter.formatCellValue(row.getCell(8)));
                loggerInfo.put("model_nm", formatter.formatCellValue(row.getCell(9)));

//                System.out.println("loggerInfo: " + loggerInfo);
                 mapper.insertLoggerInfo(loggerInfo);
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
