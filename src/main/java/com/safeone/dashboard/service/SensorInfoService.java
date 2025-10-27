package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.SensorInfoMapper;
import com.safeone.dashboard.dto.SensorInfoDto;
import com.safeone.dashboard.dto.SensorTypeDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class SensorInfoService implements JqGridService<SensorInfoDto> {

    private final SensorInfoMapper mapper;

    @Autowired
    private CommonCodeEditService commonCodeEditService;

    @Autowired
    private LogrIdxMapService logrIdxMapService;

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
    public int delete(Map param) {
        return mapper.deleteSensorInfo(param);
    }


    public synchronized String saveExcelData(MultipartFile file) throws Exception {
        int failureCount = 0;  // 실패 카운트 초기화
        int successCount = 0;  // 성공 카운트 초기화
        DataFormatter formatter = new DataFormatter();

        try (InputStream is = file.getInputStream()) {
            Workbook workbook = WorkbookFactory.create(is);
            Sheet sheet = workbook.getSheetAt(0);

            for (Row row : sheet) {
                if (row.getRowNum() == 0) continue;

                List<Map> senstypeNo = commonCodeEditService.getSensorTypeSenstypeNo(Collections.singletonMap("sens_tp_nm", formatter.formatCellValue(row.getCell(0))));
                List<Map> logrNo = commonCodeEditService.getLoggerInfoLogrNo(Collections.singletonMap("logr_nm", formatter.formatCellValue(row.getCell(1))));
                List<Map> sensAbbr = commonCodeEditService.getSensorAbbr(Collections.singletonMap("senstype_no", senstypeNo.get(0).get("senstype_no")));

                Map<String, Object> newMap = new HashMap<>();
                newMap.put("table_nm", "tb_sensor_info");
                newMap.put("column_nm", "sens_no");
                ObjectNode generationKeyOn = commonCodeEditService.newGenerationKey(newMap);

                Map<String, Object> sens = new HashMap<>();
                sens.put("sensor_seq",sensAbbr.get(0).get("sens_abbr"));
                sens.put("logr_no", logrNo.get(0).get("logr_no"));
                List<Map> sensNm = commonCodeEditService.getNewSensorSeq(sens);


                Map<String, Object> maintSts = new HashMap<>();
                maintSts.put("code_grp_nm", "유지보수상태");
                maintSts.put("code_nm", formatter.formatCellValue(row.getCell(3)));
                List<Map> maintStsCd = commonCodeEditService.getCommonCodeEditList(maintSts);

                Map<String, Object> sensorInfo = new HashMap<>();

                sensorInfo.put("sens_no", generationKeyOn.get("newId").asText());
                sensorInfo.put("senstype_no", senstypeNo.get(0).get("senstype_no"));
                sensorInfo.put("sens_nm", sensNm.get(0).get("new_sensor_seq"));
                sensorInfo.put("logr_no", logrNo.get(0).get("logr_no"));
                sensorInfo.put("sect_no", formatter.formatCellValue(row.getCell(2)));
                sensorInfo.put("maint_sts_cd", maintStsCd.get(0).get("code"));
                sensorInfo.put("logrnonrecv_limit_min_lon", formatter.formatCellValue(row.getCell(4)));
                sensorInfo.put("alarm_use_yn", formatter.formatCellValue(row.getCell(5)));
                sensorInfo.put("sms_snd_yn", formatter.formatCellValue(row.getCell(6)));
                sensorInfo.put("sens_disp_yn", formatter.formatCellValue(row.getCell(7)));
                sensorInfo.put("inst_ymd", formatter.formatCellValue(row.getCell(8)));

//                System.out.println("sensorInfo: " + sensorInfo);
                 mapper.insertSensorInfo(sensorInfo);
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

    public List<SensorInfoDto> getAllSensorInfo(Map<String, Object> param) {
        return mapper.getAllSensorInfo(param);
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
            Integer maxIdx = mapper.getMaxLogrIdxNo(senstypeNo);
            if (maxIdx == null) {
                try {
                    maxIdx = Integer.parseInt(sensorTypeDto.getLogr_idx_str());
                    newMap.put("logr_idx_no", maxIdx);
                } catch (NumberFormatException e) {
                    break;
                }
            }else{
                newMap.put("logr_idx_no", ++maxIdx);
            }

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

            newMap.put("sens_chnl_id", sendChnlId);
            newMap.put("logr_chnl_seq", i - 1);
            newMap.put("senstype_no", senstypeNo);
            newMap.put("sens_chnl_nm", param.get("sens_chnl_nm").toString() + "-" + sendChnlId);

            logrIdxMapService.create(newMap);
        }
    }
}
