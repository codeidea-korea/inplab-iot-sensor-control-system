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
        int start = Integer.parseInt((String) param.get("logr_idx_str"));
        int end = Integer.parseInt((String) param.get("logr_idx_end"));
        if (start < 0 || end < 0 || start > 256 || end > 256) {
            throw new IllegalArgumentException("범위는 0 ~ 256 사이여야 합니다.");
        }

        if (start > end) {
            throw new IllegalArgumentException("logr_idx_str 값은 logr_idx_end 값보다 클 수 없습니다.");
        }

        HashMap<String, Object> map = new HashMap<>();
        map.put("start", start);
        map.put("end", end);

        int count = mapper.checkOverlap(map);
        if (count > 0) {
            throw new IllegalArgumentException("값이 중복되었습니다.");
        }

        return mapper.insertSensorType(param) > 0;
    }

    @Override
    public SensorTypeDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        int start = Integer.parseInt((String) param.get("logr_idx_str"));
        int end = Integer.parseInt((String) param.get("logr_idx_end"));

        if (start < 0 || end < 0 || start > 256 || end > 256) {
            throw new IllegalArgumentException("범위는 0 ~ 256 사이여야 합니다.");
        }

        if (start > end) {
            throw new IllegalArgumentException("logr_idx_str 값은 logr_idx_end 값보다 클 수 없습니다.");
        }

        HashMap<String, Object> map = new HashMap<>();
        map.put("start", start);
        map.put("end", end);
        // 업데이트 시에는 자기 자신(senstype_no)을 제외하고 중복 체크를 해야 합니다.
        if (param.get("senstype_no") != null) {
            map.put("senstype_no", param.get("senstype_no"));
        }

        int count = mapper.checkOverlap(map);
        if (count > 0) {
            throw new IllegalArgumentException("로거 idx 범위는 중복 되어서는 안됩니다");
        }

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


                Map<String, Object> sensorType = new HashMap<>();

                Map<String, Object> newMap = new HashMap<>();
                newMap.put("table_nm", "tb_sensor_type");
                newMap.put("column_nm", "senstype_no");
                ObjectNode generationKeyOn = commonCodeEditService.newGenerationKey(newMap);
                sensorType.put("senstype_no", generationKeyOn.get("newId").asText());

                List<Map> siteInfo = commonCodeEditService.getSiteInfo();

                String logrFlag;

                if ("GNSS".equals(formatter.formatCellValue(row.getCell(0)))) {
                    logrFlag = "G";
                } else if ("강우량계".equals(formatter.formatCellValue(row.getCell(0)))) {
                    logrFlag = "R";
                } else {
                    logrFlag = "L";
                }


                sensorType.put("site_no", siteInfo.get(0).get("code"));
                sensorType.put("sens_tp_nm", formatter.formatCellValue(row.getCell(0)));
                sensorType.put("sens_abbr", formatter.formatCellValue(row.getCell(1)));
                sensorType.put("basic_formul", formatter.formatCellValue(row.getCell(2)));
                sensorType.put("sens_chnl_cnt", formatter.formatCellValue(row.getCell(3)));
                sensorType.put("logr_idx_str", formatter.formatCellValue(row.getCell(4)));
                sensorType.put("logr_idx_end", formatter.formatCellValue(row.getCell(5)));
                sensorType.put("logr_flag", logrFlag);

//                System.out.println("sensorType: " + sensorType);
                 mapper.insertSensorType(sensorType);
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

    public List<SensorTypeDto> getAllSensorTypesBySensTypeNo(Map<String, Object> param) {
        return mapper.getAllSensorTypesBySensTypeNo(param);
    }

    public List<SensorTypeDto> getAll() {
        return mapper.getAll();
    }

    public String getMaxNo() {
        return mapper.getMaxNo();
    }
}
