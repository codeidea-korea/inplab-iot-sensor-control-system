package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.SensorTypeMapper;
import com.safeone.dashboard.dto.SensorTypeDto;
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
public class SensorTypeService implements JqGridService<SensorTypeDto> {

    private final SensorTypeMapper mapper;

    @Autowired
    private CommonCodeEditService commonCodeEditService;

    @Override
    public List<SensorTypeDto> getList(Map param) {
        return mapper.selectSensorTypeList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectSensorTypeListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertSensorType(param) > 0;
    }

    @Override
    public SensorTypeDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateSensorType(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteSensorType(param);
    }

    public synchronized String saveExcelData(MultipartFile file) throws Exception {
        int successCount = 0;  // 성공 카운트 초기화
        DataFormatter formatter = new DataFormatter();  // 셀 데이터를 문자열로 변환하는데 사용

        try (InputStream is = file.getInputStream()) {
            Workbook workbook = WorkbookFactory.create(is);
            Sheet sheet = workbook.getSheetAt(0);

            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;  // 헤더 행 건너뛰기


                Map<String, Object> loggerType = new HashMap<>();

                Map<String, Object> newMap = new HashMap<>();
                newMap.put("table_nm", "tb_sensor_type");
                newMap.put("column_nm", "senstype_no");
                ObjectNode generationKeyOn = commonCodeEditService.newGenerationKey(newMap);
                loggerType.put("senstype_no", generationKeyOn.get("newId").asText());

                List<Map> siteInfo = commonCodeEditService.getSiteInfo();

                loggerType.put("site_no", siteInfo.get(0).get("code"));
                loggerType.put("sens_tp_nm", formatter.formatCellValue(row.getCell(0)));
                loggerType.put("sens_abbr", formatter.formatCellValue(row.getCell(1)));
                loggerType.put("basic_formul", formatter.formatCellValue(row.getCell(2)));
                loggerType.put("sens_chnl_cnt", formatter.formatCellValue(row.getCell(3)));
                loggerType.put("logr_idx_str", formatter.formatCellValue(row.getCell(4)));
                loggerType.put("logr_idx_end", formatter.formatCellValue(row.getCell(5)));

//                System.out.println("loggerType: " + loggerType);
                 mapper.insertSensorType(loggerType);
                successCount++;  // 성공 카운트 증가
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("An error occurred while processing the file: " + e.getMessage(), e);
        }

        // 메시지 생성 및 리턴
        String message = "success: " + successCount ;
        return message;
    }

}
