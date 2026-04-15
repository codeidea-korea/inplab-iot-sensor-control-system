package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.SensorInfoMapper;
import com.safeone.dashboard.dto.SensorInfoDto;
import com.safeone.dashboard.dto.SensorTypeDto;
import com.safeone.dashboard.service.sensor.AlertStandardManagementService;
import com.safeone.dashboard.service.sensorinitialsetting.SensorInitialSettingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.text.SimpleDateFormat;
import java.io.InputStream;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.IntStream;

@Service
@RequiredArgsConstructor
@Slf4j
public class SensorInfoService implements JqGridService<SensorInfoDto> {

    private final SensorInfoMapper mapper;

    @Autowired
    private CommonCodeEditService commonCodeEditService;

    @Autowired
    private LogrIdxMapService logrIdxMapService;

    @Autowired
    private DistrictInfoService districtInfoService;

    @Autowired
    private SensorInitialSettingService sensorInitialSettingService;

    @Autowired
    private AlertStandardManagementService alertStandardManagementService;

    @Override
    public List<SensorInfoDto> getList(Map param) {
        return mapper.selectSensorInfoList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectSensorInfoListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertSensorInfo(param) > 0;
    }

    public void chnlCreate(Map param) {
        mapper.insertSensorChnl(param);
    }

    @Override
    public SensorInfoDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateSensorInfo(param) > 0;
    }

    @Override
    @Transactional
    public int delete(Map param) {
        return deleteCascadeBySensNo(param);
    }

    @Transactional
    public int deleteCascadeBySensNo(Map param) {
        mapper.deleteSensorInitBySensNo(param);
        mapper.deleteAlarmInfoBySensNo(param);
        mapper.deleteSensorChnlBySensNo(param);
        mapper.deleteLogrIdxMapBySensNo(param);
        return mapper.deleteSensorInfo(param);
    }



    /* 센서 채널 관련 MAP */
    private static final Map<Integer, String> CH_ID_MAP;
    static {
        Map<Integer, String> m = new HashMap<>();
        m.put(1, "X");
        m.put(2, "Y");
        m.put(3, "Z");
        CH_ID_MAP = Collections.unmodifiableMap(m); // 불변화
    }

    private String mapChannelId(int ch) {
        return CH_ID_MAP.getOrDefault(ch, String.valueOf(ch));
    }

    @Transactional(rollbackFor = Exception.class)
    public synchronized String saveExcelData(MultipartFile file) throws Exception {
        int failureCount = 0;  // 실패 카운트 초기화
        int successCount = 0;  // 성공 카운트 초기화
        List<String> duplicateKeys = new ArrayList<>(); // 중복 키 저장 리스트
        DataFormatter formatter = new DataFormatter();

        String currentSensNo = getNextSensNo();
        int currentMappingNo = logrIdxMapService.getNextMappingNo();

        try (InputStream is = file.getInputStream()) {
            Workbook workbook = WorkbookFactory.create(is);
            Sheet sheet = workbook.getSheetAt(0);

            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;

                // Check if the row is effectively empty (based on essential columns)
                if (row == null) continue;
                String cell0 = formatter.formatCellValue(row.getCell(1)); // 센서타입명
                String cell1 = formatter.formatCellValue(row.getCell(2)); // 로거명
                if ((cell0 == null || cell0.trim().isEmpty()) && (cell1 == null || cell1.trim().isEmpty())) {
                    continue; // Skip empty row
                }

                // 공통 정보 조회
                List<Map> senstypeNo = commonCodeEditService.getSensorTypeSenstypeNo(Collections.singletonMap("sens_tp_nm", cell0));
                List<Map> logrNo = commonCodeEditService.getLoggerInfoLogrNo(Collections.singletonMap("logr_nm", cell1));
                List<Map> sensAbbr = commonCodeEditService.getSensorAbbr(Collections.singletonMap("senstype_no", senstypeNo.get(0).get("senstype_no")));

                // 센서 ID 처리 (엑셀 3번째 컬럼)
                String excelSensNm = formatter.formatCellValue(row.getCell(4));
                String finalSensNm;

                if (excelSensNm != null && !excelSensNm.trim().isEmpty()) {
                    finalSensNm = excelSensNm.trim();
                } else {
                    Map<String, Object> sens = new HashMap<>();
                    sens.put("sensor_seq", sensAbbr.get(0).get("sens_abbr"));
                    sens.put("logr_no", logrNo.get(0).get("logr_no"));
                    List<Map> sensNmList = commonCodeEditService.getNewSensorSeq(sens);
                    finalSensNm = (String) sensNmList.get(0).get("new_sensor_seq");
                }

                // ==========================================
                // 1. 공통 데이터 세팅 (Insert / Update 공용)
                // ==========================================
                Map<String, Object> maintSts = new HashMap<>();
                maintSts.put("code_grp_nm", "유지보수상태");
                maintSts.put("code_nm", formatter.formatCellValue(row.getCell(7)));
                List<Map> maintStsCd = commonCodeEditService.getCommonCodeEditList(maintSts);

                Map<String, Object> sensorInfo = new HashMap<>();
                sensorInfo.put("senstype_no", senstypeNo.get(0).get("senstype_no"));
                sensorInfo.put("sens_nm", finalSensNm);
                sensorInfo.put("logr_no", logrNo.get(0).get("logr_no"));
                sensorInfo.put("sect_no", formatter.formatCellValue(row.getCell(6)));
                sensorInfo.put("maint_sts_cd", maintStsCd.get(0).get("code"));
                sensorInfo.put("nonrecv_limit_min", formatter.formatCellValue(row.getCell(12)));
                sensorInfo.put("alarm_use_yn", formatter.formatCellValue(row.getCell(13)));
                sensorInfo.put("sms_snd_yn", formatter.formatCellValue(row.getCell(14)));
                sensorInfo.put("sens_disp_yn", formatter.formatCellValue(row.getCell(15)));

                // 날짜 포맷 처리 (yyyy-MM-dd)
                Cell dateCell = row.getCell(16);
                String instYmd = "";
                if (dateCell != null) {
                    if (dateCell.getCellType() == org.apache.poi.ss.usermodel.Cell.CELL_TYPE_NUMERIC && DateUtil.isCellDateFormatted(dateCell)) {
                        instYmd = new SimpleDateFormat("yyyy-MM-dd").format(dateCell.getDateCellValue());
                    } else {
                        String val = formatter.formatCellValue(dateCell);
                        if (val != null && val.matches("^\\d{1,2}/\\d{1,2}/\\d{2,4}$")) {
                            try {
                                Date d = new SimpleDateFormat("M/d/yy").parse(val);
                                instYmd = new SimpleDateFormat("yyyy-MM-dd").format(d);
                            } catch (Exception e) {
                                instYmd = val;
                            }
                        } else {
                            instYmd = val;
                        }
                    }
                }
                sensorInfo.put("inst_ymd", instYmd);

                sensorInfo.put("disp_prior_yn", formatter.formatCellValue(row.getCell(9)));
                sensorInfo.put("multi_senstype_no", formatter.formatCellValue(row.getCell(10)));
                sensorInfo.put("multi_sens_no", formatter.formatCellValue(row.getCell(11)));
                sensorInfo.put("sens_lon", formatter.formatCellValue(row.getCell(18)));
                sensorInfo.put("sens_lat", formatter.formatCellValue(row.getCell(19)));
                sensorInfo.put("sens_maker", formatter.formatCellValue(row.getCell(20)));
                sensorInfo.put("model_nm", formatter.formatCellValue(row.getCell(21)));

                // District No 설정
                String district_no = districtInfoService.getDistrictInfoIdByEtc1(logrNo.get(0).get("logr_no").toString());
                sensorInfo.put("district_no", district_no);
                sensorInfo.put("sens_chnl_nm", finalSensNm);



                String excelSensNo = formatter.formatCellValue(row.getCell(0));
                boolean isUpdate = false;
                String targetSensNo = "";


                if (excelSensNo != null && !excelSensNo.trim().isEmpty()) {
                    String trimmedSensNo = excelSensNo.trim();
                    int existCount = mapper.countBySensNo(trimmedSensNo); // DB에 있는지 확인
                    if (existCount > 0) {
                        isUpdate = true;
                        targetSensNo = trimmedSensNo;
                    } else {
                        isUpdate = false;
                        targetSensNo = trimmedSensNo;

                        if (targetSensNo.compareTo(currentSensNo) >= 0) {
                            currentSensNo = incrementSensNo(targetSensNo);
                        }
                    }
                } else {
                    isUpdate = false;
                    targetSensNo = currentSensNo;

                    // 다음 빈칸 데이터를 위해 자동 채번 번호 1 증가
                    currentSensNo = incrementSensNo(currentSensNo);
                }

                sensorInfo.put("sens_no", targetSensNo);

                if (isUpdate) {
                    mapper.updateSensorInfo(sensorInfo);

                } else {
                    sensorInfo.put("mapping_no", currentMappingNo);

                    // 로거 정보 인서트
                    this.logrInfoInsert(sensorInfo);

                    // 채널 개수 파악
                    int chnlCnt = 0;
                    Object chnlCntObj = sensAbbr.get(0).get("sens_chnl_cnt");
                    if (chnlCntObj instanceof Number) {
                        chnlCnt = ((Number) chnlCntObj).intValue();
                    } else if (chnlCntObj instanceof String) {
                        chnlCnt = Integer.parseInt((String) chnlCntObj);
                    }

                    final int finalChnlCnt = chnlCnt;

                    // 채널 정보 세팅 및 인서트
                    IntStream.rangeClosed(1, finalChnlCnt).forEach(ch -> {
                        Map<String, Object> perChParam = new HashMap<>(sensorInfo);

                        if (finalChnlCnt == 1) {
                            perChParam.put("sens_chnl_id", "");
                            perChParam.put("sens_chnl_nm", sensorInfo.get("sens_chnl_nm").toString());
                        } else {
                            String mappedId = mapChannelId(ch);
                            perChParam.put("sens_chnl_id", mappedId);
                            perChParam.put("sens_chnl_nm", sensorInfo.get("sens_chnl_nm").toString() + "-" + mappedId);
                        }

                        sensorInitialSettingService.create(perChParam);
                        alertStandardManagementService.create(perChParam);
                        this.chnlCreate(perChParam);
                    });

                    // 최종 메인 테이블 인서트
                    mapper.insertSensorInfo(sensorInfo);

                    // 다음 신규 등록을 위해 mapping_no 1 증가
                    // (업데이트일 때는 굳이 증가시킬 필요가 없으므로 else 블록 안으로 이동시켰습니다)
                    currentMappingNo++;
                }

                // 분기에 상관없이 한 행 처리가 완료되면 성공 카운트 증가
                successCount++;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Rollback is handled by @Transactional
            throw new Exception("An error occurred while processing the file: " + e.getMessage(), e);
        }

        // 메시지 생성 및 리턴
        StringBuilder message = new StringBuilder();
        message.append("success: ").append(successCount).append(", fail: ").append(failureCount);
        if (!duplicateKeys.isEmpty()) {
            message.append(", duplicate_keys: ").append(duplicateKeys.toString());
        }
        return message.toString();
    }

    public List<SensorInfoDto> getAllSensorInfo(Map<String, Object> param) {
        return mapper.getAllSensorInfo(param);
    }

    public List<Map<String, Object>> getSensorTypesByLogrNo(Map<String, Object> param) {
        return mapper.getSensorTypesByLogrNo(param);
    }

    public String getNextSensNo() {
        String maxNo = mapper.selectMaxSensNo();
        if (maxNo == null || maxNo.trim().isEmpty()) {
            return "S0001";
        }

        String trimmed = maxNo.trim();
        Matcher matcher = Pattern.compile("^(.*?)(\\d+)$").matcher(trimmed);
        if (!matcher.matches()) {
            return trimmed + "0001";
        }

        String prefix = matcher.group(1);
        String numericPart = matcher.group(2);
        int next = Integer.parseInt(numericPart) + 1;
        return prefix + String.format("%0" + numericPart.length() + "d", next);
    }

    public void logrInfoInsert(Map<String, Object> param) {
        /* send_chnl_id > cnt가 1이면 X, 2면 Y, 3이면 Z */
        /* logr_chnl_seq > cnt가 1이면 0, 2면 1, 3이면 2 */
        /* logr_idx_no > tb_logr_idx_map에서 동일한 senstype_no의 logr_idx_no max 값 + 1 */

        SensorTypeDto sensorTypeDto = commonCodeEditService.selectSensorTypeInfo(param.get("senstype_no").toString());
        int channelCnt = Integer.parseInt(sensorTypeDto.getSens_chnl_cnt());
        String senstypeNo = param.get("senstype_no").toString();

        for (int i = 1; i <= channelCnt; i++) {

            /* map 복사 */
            Map<String, Object> newMap = new HashMap<>(param);

            // 현재 DB에서 max(logr_idx_no) 조회
            /*Integer maxIdx = mapper.getMaxLogrIdxNo(senstypeNo);
            if (maxIdx == null) {
                try {
                    maxIdx = Integer.parseInt(sensorTypeDto.getLogr_idx_str());
                    newMap.put("logr_idx_no", maxIdx);
                } catch (NumberFormatException e) {
                    break;
                }
            }else{
                newMap.put("logr_idx_no", ++maxIdx);
            }*/
            newMap.put("logr_idx_no", "");

            // send_chnl_id 매핑
            String sendChnlId;
            switch (i) {
                case 1:
                    sendChnlId = "X";
                    break;
                case 2:
                    sendChnlId = "Y";
                    break;
                case 3:
                    sendChnlId = "Z";
                    break;
                default:
                    sendChnlId = "";
            }

            if (channelCnt == 1) {
                newMap.put("sens_chnl_id", ""); // 컨트롤러 로직과 통일 (DB 설정에 따라 필요시 "1" 등으로 변경)
                newMap.put("sens_chnl_nm", param.get("sens_chnl_nm").toString()); // "-X" 제외
            } else {
                newMap.put("sens_chnl_id", sendChnlId);
                newMap.put("sens_chnl_nm", param.get("sens_chnl_nm").toString() + "-" + sendChnlId);
            }

            newMap.put("logr_chnl_seq", i - 1);
            newMap.put("senstype_no", senstypeNo);
            logrIdxMapService.create(newMap);
        }
    }
    private String incrementSensNo(String currentNo) {
        if (currentNo == null || currentNo.trim().isEmpty()) {
            return "S0001";
        }
        String trimmed = currentNo.trim();
        java.util.regex.Matcher matcher = java.util.regex.Pattern.compile("^(.*?)(\\d+)$").matcher(trimmed);
        if (!matcher.matches()) {
            return trimmed + "0001";
        }

        String prefix = matcher.group(1);
        String numericPart = matcher.group(2);
        int next = Integer.parseInt(numericPart) + 1;
        return prefix + String.format("%0" + numericPart.length() + "d", next);
    }
}

