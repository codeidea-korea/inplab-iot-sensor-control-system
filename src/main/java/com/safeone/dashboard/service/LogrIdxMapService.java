package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.LogrIdxMapMapper;
import com.safeone.dashboard.dto.LogrIdxMapDto;
import com.safeone.dashboard.dto.SensorTypeDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.jasper.tagplugins.jstl.core.ForEach;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class LogrIdxMapService implements JqGridService<LogrIdxMapDto> {

    private final LogrIdxMapMapper mapper;

    @Autowired
    private CommonCodeEditService commonCodeEditService;

    @Autowired
    private SensorTypeService sensorTypeService;

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

    public void mapping(Map<String, Object> param) throws Exception {
        List<LogrIdxMapDto> logrList = mapper.selectLogrIdxMapList(param);
        List<SensorTypeDto> sensorTypeList = sensorTypeService.getList(null);

        // 1) 타입별 range/채널/약어 맵 구성
        class Range {
            int start; int end; int ch; String abbr;
            Range(int s, int e, int ch, String abbr) { this.start = s; this.end = e; this.ch = ch; this.abbr = abbr; }
        }
        Map<String, Range> typeRange = new HashMap<>(); // senstype_no -> range

        for (SensorTypeDto st : sensorTypeList) {
            String typeNo = st.getSenstype_no();
            String sStr = nullToEmpty(st.getLogr_idx_str());
            String eStr = nullToEmpty(st.getLogr_idx_end());
            int ch = parseIntOr(st.getSens_chnl_cnt(), 0);
            String abbr = nullToEmpty(st.getSens_abbr());

            Integer start = sStr.isEmpty() ? null : parseIntOr(sStr, 0);
            Integer end   = eStr.isEmpty() ? null : parseIntOr(eStr, 0);
            if (start != null && end != null) {
                typeRange.put(typeNo, new Range(start, end, ch, abbr));
            }
        }

        // 2) 정렬: 로거 → 센서 타입 → 센서 번호 → 채널 순서
        logrList.sort(Comparator
                .comparing(LogrIdxMapDto::getLogr_no, Comparator.nullsLast(String::compareTo))
                .thenComparing(LogrIdxMapDto::getSenstype_no, Comparator.nullsLast(String::compareTo))
                .thenComparing(LogrIdxMapDto::getSens_no, Comparator.nullsLast(String::compareTo))
                .thenComparing(d -> parseIntOr(String.valueOf(d.getLogr_chnl_seq()), 0))
        );

        // ★ 3) used 제거, 로거+타입별 커서로 초기화에서부터 부여
        Map<String, Integer> nextIdxByLogrAndType = new HashMap<>();

        for (LogrIdxMapDto logr : logrList) {
            String logrNo = nullToEmpty(logr.getLogr_no());
            String typeNo = logr.getSenstype_no();
            if (isEmpty(logrNo)) {
                log.warn("로거 정보가 없는 매핑은 자동 인덱스 대상에서 제외합니다. sens_no={}, ch_seq={}",
                        logr.getSens_no(), logr.getLogr_chnl_seq());
                continue;
            }
            if (isEmpty(typeNo) || !typeRange.containsKey(typeNo)) {
                // 타입 범위가 없으면 스킵(또는 예외)
                continue;
            }

            Range r = typeRange.get(typeNo);
            String cursorKey = logrNo + "|" + typeNo;
            // 로거+타입별 커서를 range.start에서 시작
            int next = nextIdxByLogrAndType.getOrDefault(cursorKey, r.start);

            if (next > r.end) {
                throw new IllegalStateException(String.format(
                        "타입 %s(%s)의 인덱스 범위를 초과했습니다. start=%03d end=%03d",
                        typeNo, r.abbr, r.start, r.end
                ));
            }

            // 3자리 0패딩 저장
            logr.setLogr_idx_no(zpad3(next));

            // 다음 커서로 이동
            nextIdxByLogrAndType.put(cursorKey, next + 1);

            // TODO: DB 반영
            mapper.updateLogrIdx(logr);
        }
    }

    /* mapping helper */
    private static String nullToEmpty(String s) { return s == null ? "" : s.trim(); }
    private static boolean isEmpty(String s) { return s == null || s.trim().isEmpty(); }
    private static int parseIntOr(String s, int def) {
        try { return Integer.parseInt(nullToEmpty(s)); } catch (Exception e) { return def; }
    }
    private static String zpad3(int n) { return String.format("%03d", n); }
    private static Integer parseIntSafe(String s) {
        try { return Integer.valueOf(nullToEmpty(s)); } catch (Exception e) { return null; }
    }
}
