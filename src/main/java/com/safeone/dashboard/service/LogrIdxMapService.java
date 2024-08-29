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
                if (row.getRowNum() == 0) continue;  // 헤더 행 건너뛰기

                List<Map> senstypeNo = commonCodeEditService.getNewSensorSeq(Collections.singletonMap("sens_tp_nm", formatter.formatCellValue(row.getCell(0))));
                List<Map> logrNo = commonCodeEditService.getNewSensorSeq(Collections.singletonMap("logr_nm", formatter.formatCellValue(row.getCell(2))));
                List<Map> sensAbbr = commonCodeEditService.getSensorAbbr(Collections.singletonMap("senstype_no", senstypeNo));

                Map<String, Object> newMap = new HashMap<>();
                newMap.put("table_nm", "tb_sensor_info");
                newMap.put("column_nm", "sens_no");
                ObjectNode generationKeyOn = commonCodeEditService.newGenerationKey(newMap);

                Map<String, Object> sens = new HashMap<>();
                sens.put("sensor_seq",sensAbbr);
                sens.put("logr_no", logrNo);
                List<Map> sensNm = commonCodeEditService.getNewSensorSeq(sens);

                Map<String, Object> logrIdxMap = new HashMap<>();

                logrIdxMap.put("sens_no", generationKeyOn.get("newId").asText());
                logrIdxMap.put("senstype_no", senstypeNo); //센서타입명으로 0번 formatter.formatCellValue(row.getCell(0))
                logrIdxMap.put("sens_nm", sensNm);
                logrIdxMap.put("logr_no", logrNo); // 로거명으로 2번 formatter.formatCellValue(row.getCell(2))
                logrIdxMap.put("sect_no", formatter.formatCellValue(row.getCell(3)));
                logrIdxMap.put("maint_sts_cd", formatter.formatCellValue(row.getCell(4)));
                logrIdxMap.put("logrnonrecv_limit_min_lon", formatter.formatCellValue(row.getCell(5)));
                logrIdxMap.put("alarm_use_yn", formatter.formatCellValue(row.getCell(6)));
                logrIdxMap.put("sms_snd_yn", formatter.formatCellValue(row.getCell(7)));
                logrIdxMap.put("sens_disp_yn", formatter.formatCellValue(row.getCell(8)));
                logrIdxMap.put("inst_ymd", formatter.formatCellValue(row.getCell(9)));

//                System.out.println("logrIdxMap: " + logrIdxMap);
                // mapper.insertLogrIdxMap(logrIdxMap);
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
