package com.safeone.dashboard.service;


import com.safeone.dashboard.dao.SendContrMapper;
import com.safeone.dashboard.dto.AssetListDto;
import com.safeone.dashboard.dto.SendContrDto;
import com.safeone.dashboard.util.DisplayUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.net.UnknownHostException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.safeone.dashboard.util.CommonUtils.parseHex;

@Service
@RequiredArgsConstructor
@Slf4j
public class SendContrService {

    @Value("${upload.dppath}")
    private String upload_dppath;

    private final SendContrMapper mapper;

    public List<SendContrDto> getList(Map param) {
        return mapper.selectSendContrList(param);
    }

    public boolean create(Map param) {
        return mapper.insertSendContr(param) > 0;
    }

    public boolean update(Map param) {

        if(StringUtils.isNoneEmpty(String.valueOf(param.get("new_filename")))) {
            try {
                // 삭제할 파일의 경로를 지정
                Path path = Paths.get(upload_dppath + param.get("filename"));

                // 파일 삭제 시도
                Files.delete(path);
                log.info(path.getFileName() + " 파일이 삭제되었습니다.");

                param.put("filename", param.get("new_filename"));

            } catch (Exception e) {
                log.error("파일 삭제에 실패했습니다.");
                e.printStackTrace();
            }
        }

        return mapper.updateSendContr(param) > 0;
    }

    public boolean delete(Map param) {
        try {
            // 삭제할 파일의 경로를 지정
            Path path = Paths.get(upload_dppath + param.get("filename"));

            // 파일 삭제 시도
            Files.delete(path);
            log.info(path.getFileName() + " 파일이 삭제되었습니다.");
        } catch (Exception e) {
            log.error("파일 삭제에 실패했습니다.");
            e.printStackTrace();
        }
        return mapper.deleteSendContr(param) > 0;
    }

    public List<AssetListDto> assetList (Map param) {
        return mapper.selectAssetList(param);
    }

    public HashMap getSendLog() {
        return mapper.selectSendLog();
    }

    public HashMap send(Map<String, Object> param) {
        List<AssetListDto> assetList = mapper.selectAssetList(param);

        // 1건이 아니면 문제 있음
        if(assetList.size() != 1) {
            HashMap sendLog = getSendLog();
            sendLog.put("result", "전송할 전광판이 없습니다.");
            return sendLog;
        }

        AssetListDto assetDto = assetList.get(0);

        // etc1 => ip, etc3 => port
        DisplayUtils displayUtil = new DisplayUtils(assetDto.getEtc1(), Integer.parseInt(assetDto.getEtc3()));
        DisplayUtils.ElectronicDisplay ed = new DisplayUtils.ElectronicDisplay();
        StringBuilder stringBuilder = new StringBuilder();
        byte displayMode = displayUtil.NOR;

        List<SendContrDto> sendContrDtoList = mapper.selectSendContrList(param);

        if(sendContrDtoList.size() > 0) {
            try {
                if("normal".equals(param.get("send_type"))) {
                    displayUtil.deleteAllPeacetimePhrases(ed);
                }else if("emergency".equals(param.get("send_type"))){
                    displayUtil.deleteAllEmergencyPhrases(ed);
                    displayMode = displayUtil.EMG;
                }else{ // 에러
                    throw new RuntimeException();
                }

                for (int i = 0; i < sendContrDtoList.size(); i++) {
                    SendContrDto sendContrDto = sendContrDtoList.get(i);
                    stringBuilder.setLength(0);

                    log.info("전광판 :: {} ", sendContrDto);
                    stringBuilder.append(String.format("%02X", (i+1))) // 방번호
                            .append(":") // 구분자
                            .append(String.format("%02X", Integer.parseInt(sendContrDto.getDp_effect()))) // 표시효과
                            .append(":") // 구분자
                            .append(String.format("%02X", Integer.parseInt(sendContrDto.getDp_time()))) // 표시속도
                            .append(":") // 구분자
                            .append(String.format("%02X", Integer.parseInt(sendContrDto.getDp_time()))) // 표시 후 대기시간
                            .append(":") // 구분자
                            .append("05") // 완료효과 (바로 사라짐)
                            .append(":") // 구분자
                            .append(String.format("%02X", Integer.parseInt(sendContrDto.getDp_time()))) // 완료속도
                            .append(":") // 구분자
                            .append("00:00:") // 예약
                            .append("18:01:01:00:00:63:0C:1F:17:3B") // 24 년 1월 1일 00시 00분 ~ 99 년 12월 31일 23시 59분
                            .append(":") // 구분자
                            .append("00");

                    log.info("stringBuilder.toString() ::: {}", stringBuilder);

                    // : 기준으로 hex 값을 byte 값으로 변환
                    byte[] sc = parseHex(stringBuilder.toString(), ":"); // 시나리오
                    byte[] url = (sendContrDto.getUrl_path() + sendContrDto.getFilename()).getBytes("ksc5601"); // 구동 서버 이미지 경로

                    if("normal".equals(param.get("send_type"))) {
                        displayUtil.addPeacetimeImageScenario(ed, sc, url);
                    }else if("emergency".equals(param.get("send_type"))){
                        displayUtil.addEmergencyImageScenario(ed, sc, url);
                    }
                }

                // 다운로드 명령어 전송
                if("normal".equals(param.get("send_type"))) {
                    displayUtil.downloadPeacetimeImage(ed);
                }else if("emergency".equals(param.get("send_type"))){
                    displayUtil.downloadEmergencyImage(ed);
                }

                // 평시 모드 전황 명령어 전송
                displayUtil.displayModeSetting(ed, displayMode);

                // 전송할 리스트 조회
                param.put("send_result", "성공");

                // 전송 로그
                log.info("send");
                mapper.insertSendLog(param);
                HashMap sendLog = getSendLog();
                sendLog.put("result", "전송 처리하였습니다.");
                return getSendLog();
            } catch (UnknownHostException | UnsupportedEncodingException e) {
                param.put("send_result", "실패");

                // 전송 에러
                log.error("send");
                mapper.insertSendLog(param);
                e.printStackTrace();
                HashMap sendLog = getSendLog();
                sendLog.put("result", "전송 실패하였습니다.");
                return getSendLog();
            }


        } else {
            HashMap sendLog = getSendLog();
            sendLog.put("result", "전송할 내역이 없습니다.");
            return sendLog;
        }
    }


}
