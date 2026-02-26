package com.safeone.dashboard.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.DisplayBoardMapper;
import com.safeone.dashboard.dto.DelAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.GetAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.InsAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.UdtAdminAddDisplayBoardDto;
import com.safeone.dashboard.dto.displayconnection.DisplayBoardDto;
import com.safeone.dashboard.service.DisplayBoardService;
import com.safeone.dashboard.util.CommonUtils;
import com.safeone.dashboard.util.DisplayUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import javax.annotation.Resource;
import java.nio.charset.Charset;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Transactional
@Service("displayBoardService")
@RequiredArgsConstructor
public class DisplayBoardServiceImpl implements DisplayBoardService {

    @Resource(name = "displayBoardMapper")
    private final DisplayBoardMapper displayBoardMapper;

    @Value("${display.simulator.ip:127.0.0.1}")
    private String simulatorIp;

    @Value("${display.simulator.port:8000}")
    private int simulatorPort;

    @Value("${display.simulator.image-base-url:http://127.0.0.1:8080}")
    private String simulatorImageBaseUrl;

    public ObjectNode getDisplayBoard(GetAdminAddDisplayBoardDto getAdminAddDisplayBoardDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getAdminAddDisplayBoardDto);
        List<HashMap<String, Object>> list = displayBoardMapper.getDisplayBoardList(map);
        int totalCnt = displayBoardMapper.getDisplayBoardListTotalCnt(map);
        an = om.valueToTree(list);

        CommonUtils.setCountInfo("list", list.size(), on);
        CommonUtils.setCountInfo("total", totalCnt, on);

        on.put("rows", an);

        return on;
    }

    public synchronized ObjectNode insDisplayBoard(List<InsAdminAddDisplayBoardDto> insAdminAddDisplayBoardDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int insCount = 0;
        int passCount = 0;

        for (InsAdminAddDisplayBoardDto dto : insAdminAddDisplayBoardDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            String dispbdNo = map.get("dispbd_no") == null ? "" : map.get("dispbd_no").toString();
            if (dispbdNo.trim().isEmpty()) {
                map.put("dispbd_no", getNextDisplayBoardNo());
            }
            Map<String, Object> getMap = new HashMap<>();
            getMap.put("dispbd_no", map.get("dispbd_no"));
            List<HashMap<String, Object>> list = displayBoardMapper.getDisplayBoardList(getMap);
            getMap.clear();
            getMap.put("dispbd_nm", map.get("dispbd_nm"));
            List<HashMap<String, Object>> list2 = displayBoardMapper.getDisplayBoardList(getMap);

            if (!list.isEmpty()) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                map.put("message", "전광판 아이디가 " + map.get("dispbd_no") + " 인 데이터가 이미 존재합니다.");
                an.add(om.valueToTree(map));
                passCount++;
                continue;
            }

            if (!list2.isEmpty()) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                map.put("message", "전광판명이 " + map.get("dispbd_nm") + " 인 데이터가 이미 존재합니다.");
                an.add(om.valueToTree(map));
                passCount++;
                continue;
            }

            insCount += displayBoardMapper.insDisplayBoard(map);
        }

        CommonUtils.setCountInfo("ins", insCount, on);
        CommonUtils.setCountInfo("pass", passCount, on);

        on.put("pass_list", an);

        return on;
    }

    private String getNextDisplayBoardNo() {
        String maxNo = displayBoardMapper.getMaxDispbdNo();
        if (maxNo == null || maxNo.trim().isEmpty()) {
            return "P01";
        }
        String prefix = maxNo.substring(0, 1);
        int number = Integer.parseInt(maxNo.substring(1)) + 1;
        return prefix + String.format("%02d", number);
    }

    public ObjectNode udtDisplayBoard(List<UdtAdminAddDisplayBoardDto> udtAdminAddDisplayBoardDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int count = 0;

        for (UdtAdminAddDisplayBoardDto dto : udtAdminAddDisplayBoardDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            count += displayBoardMapper.udtDisplayBoard(map);
        }

        CommonUtils.setCountInfo("udt", count, on);

        return on;
    }

    public ObjectNode delDisplayBoard(List<DelAdminAddDisplayBoardDto> delAdminAddDisplayBoardDtoList) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        int count = 0;

        for (DelAdminAddDisplayBoardDto dto : delAdminAddDisplayBoardDtoList) {
            Map<String, Object> map = CommonUtils.dtoToMap(dto);
            count += displayBoardMapper.delDisplayBoard(map);
        }

        CommonUtils.setCountInfo("del", count, on);

        return on;
    }

    @Override
    public List<DisplayBoardDto> all(Map<String, Object> param) {
        return displayBoardMapper.all(param);
    }

    @Override
    public Map<String, Object> getSimulatorImageData(Map<String, Object> param) {
        Map<String, Object> row = displayBoardMapper.getSimulationImageByGroup(param);
        return toSimulatorImageResponse(row);
    }

    @Override
    public Map<String, Object> getSimulatorImageDataByMgntNo(String mgntNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("mgnt_no", mgntNo);
        Map<String, Object> row = displayBoardMapper.getSimulationImageByMgntNo(param);
        return toSimulatorImageResponse(row);
    }

    private Map<String, Object> toSimulatorImageResponse(Map<String, Object> row) {
        if (row == null || row.get("img_file_path") == null) {
            return null;
        }

        String raw = String.valueOf(row.get("img_file_path"));
        String contentType = "image/jpeg";
        String base64 = raw;
        if (raw.startsWith("data:")) {
            int commaIdx = raw.indexOf(',');
            int semicolonIdx = raw.indexOf(';');
            if (semicolonIdx > 5) {
                contentType = raw.substring(5, semicolonIdx);
            }
            if (commaIdx > -1 && commaIdx + 1 < raw.length()) {
                base64 = raw.substring(commaIdx + 1);
            }
        }

        byte[] bytes;
        try {
            bytes = Base64.getDecoder().decode(base64);
        } catch (IllegalArgumentException e) {
            log.warn("simulator image base64 decode failed.", e);
            return null;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("contentType", contentType);
        result.put("bytes", bytes);
        return result;
    }

    @Override
    public Map<String, Object> sendTest(Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        Object dispbdNo = param.get("dispbd_no");
        if (dispbdNo == null || dispbdNo.toString().trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "전광판 정보가 없습니다.");
            return result;
        }

        try {
            new DisplayUtils(simulatorIp, simulatorPort);
            DisplayUtils.ElectronicDisplay ed = new DisplayUtils.ElectronicDisplay();

            Map<String, Object> selectedImage = displayBoardMapper.getSimulationImageByGroup(param);
            if (selectedImage == null || selectedImage.get("mgnt_no") == null) {
                result.put("success", false);
                result.put("message", "선택한 이벤트/그룹에 전송할 이미지가 없습니다.");
                return result;
            }

            boolean emergency = "2".equals(String.valueOf(param.get("dispbd_evnt_flag")));
            byte[] scenario = parseScenarioBytes("01:01:04:04:05:04:00:00:18:01:01:00:00:63:0C:1F:17:3B:00");
            String imageKey = String.valueOf(selectedImage.get("mgnt_no"));
            String testUrl = simulatorImageBaseUrl
                    + "/adminAdd/displayBoard/sim-image/"
                    + imageKey
                    + ".jpg";
            byte[] url = testUrl.getBytes(Charset.forName("KSC5601"));

            if (emergency) {
                DisplayUtils.deleteAllEmergencyPhrases(ed);
                pauseBetweenCommands(200);
                DisplayUtils.addEmergencyImageScenario(ed, scenario, url);
                pauseBetweenCommands(200);
                DisplayUtils.downloadEmergencyImage(ed);
                pauseBetweenCommands(300);
                DisplayUtils.displayModeSetting(ed, DisplayUtils.EMG);
            } else {
                DisplayUtils.deleteAllPeacetimePhrases(ed);
                pauseBetweenCommands(200);
                DisplayUtils.addPeacetimeImageScenario(ed, scenario, url);
                pauseBetweenCommands(200);
                DisplayUtils.downloadPeacetimeImage(ed);
                pauseBetweenCommands(300);
                DisplayUtils.displayModeSetting(ed, DisplayUtils.NOR);
            }

            result.put("success", true);
            result.put("message", "시뮬레이터 테스트 전송 성공 (" + simulatorIp + ":" + simulatorPort + ")");
            result.put("sim_image_mgnt_no", imageKey);
            result.put("sim_image_url", testUrl);
        } catch (Exception e) {
            log.error("display-send-management test send failed. param={}", param, e);
            result.put("success", false);
            result.put("message", "시뮬레이터 테스트 전송 실패 (" + simulatorIp + ":" + simulatorPort + ")");
            result.put("sim_image_mgnt_no", null);
            result.put("sim_image_url", null);
        }

        return result;
    }

    private byte[] parseScenarioBytes(String hexByColon) {
        String[] tokens = hexByColon.split(":");
        byte[] out = new byte[tokens.length];
        for (int i = 0; i < tokens.length; i++) {
            out[i] = (byte) Integer.parseInt(tokens[i], 16);
        }
        return out;
    }

    private void pauseBetweenCommands(long millis) {
        try {
            Thread.sleep(millis);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    @Override
    public int sendHistory(Map<String, Object> param) {
        log.warn("display-send-management send API stores history only. interface module integration is pending. param={}", param);
        if (param.get("dispbd_evnt_flag").equals("2") || Integer.parseInt(param.get("dispbd_evnt_flag").toString()) == 2) {
            param.put("dispbd_autosnd_yn", "Y");
        } else {
            param.put("dispbd_autosnd_yn", "N");
        }
        return displayBoardMapper.sendHistory(param);
    }

    @Override
    public String getMaxDispbdNo() {
        String maxNo = displayBoardMapper.getMaxDispbdNo();
        if (maxNo == null || maxNo.trim().isEmpty()) {
            return "P00";
        }
        return maxNo;
    }
}
