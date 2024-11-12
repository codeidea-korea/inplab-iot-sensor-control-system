package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.SmsSenderMapper;
import com.safeone.dashboard.dto.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class SmsSenderService {

    private final SmsSenderMapper mapper;
    private static final int SMS_SEND_TERM_MINUTE = 5;

    @Transactional
    public void run() {
        LocalDateTime now = LocalDateTime.now();

        List<AlertStandardDto> alertStandards = getAlertStandards();

        // 1. 경보기준들을 district_no로 그룹핑
        Map<String, List<AlertStandardDto>> map = alertStandards.stream()
                .collect(Collectors.groupingBy(AlertStandardDto::getDistrict_no));

        // 2. district_no 기준으로 순회
        map.forEach((districtNo, alertStandardList) -> {
            DistrictInfoDto districtInfo = mapper.getDistrictInfo(Collections.singletonMap("district_no", districtNo));

            System.out.println("districtInfo = " + districtInfo);

            alertStandardList.forEach(alertStandard -> {

                // 3. 경보기준으로 경보기준이 넘는 데이터가 있는지 확인한다
                MeasureDataDto data = getMeasuredData(alertStandard, now);
                if (data != null) {
                    alertStandard.setAdditionalData(data);
                }
            });

            // 4. 문자를 발송할 후보군을 조회한다
            List<SmsTargetDto> candidates = getSmsTargetList(districtNo);
            int maxOver = getMaxOver(alertStandardList);

            // 5. 후보군을 필터링하여 실질적으로 문자를 발송할 대상을 선정한다
            List<SmsTargetDto> smsTargets = filterToTarget(candidates, maxOver);

            HashMap<String, List<SensInfoDto>> sensInfos = getSensInfos(alertStandardList);

            alertStandardList.stream().filter(item -> item.getOver() != null).forEach(item -> {

                // 6. 알람이력을 저장한다
                int insertedMgntNo = saveAlarmDetails(item);


                // 7. 알람이력 > 문자 전송 상세내역을 저장한다
                smsTargets.forEach(smsTarget -> {
                    String msg = makeMessage(smsTarget, districtInfo, sensInfos);
                    msg = msg.replace("[$MOBILE]", smsTarget.getSms_recv_ph());
                    msg = msg.replace("[$NAME]", smsTarget.getSms_chgr_nm());

                    saveSmsDetails(smsTarget, insertedMgntNo, msg);
                });

            });

            System.out.println("smsTargets = " + smsTargets);
            System.out.println("alertStandardList = " + alertStandardList);

            // 8. 문자를 발송한다
            smsTargets.forEach(smsTarget -> {
                try {
                    sendSms(smsTarget, districtInfo, sensInfos);
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            });
        });
    }

    private HashMap<String, List<SensInfoDto>> getSensInfos(List<AlertStandardDto> alertStandardList) {
        HashMap<String, List<SensInfoDto>> sensInfos = new HashMap<>();

        for (AlertStandardDto alertStandard : alertStandardList) {
            SensInfoDto sensInfo = mapper.getSensInfo(alertStandard.getSens_no());
            if (alertStandard.getOver() != null) {
                sensInfo.setOver(true);
            }
            if (sensInfos.containsKey(sensInfo.getSens_tp_nm())) {
                sensInfos.get(sensInfo.getSens_tp_nm()).add(sensInfo);
            } else {
                sensInfos.put(sensInfo.getSens_tp_nm(), Collections.singletonList(sensInfo));
            }
        }

        return sensInfos;
    }

    private void saveSmsDetails(SmsTargetDto smsTarget, int insertedMgntNo, String sms) {
        Map<String, Object> param = new HashMap<>();
        param.put("alarm_mgnt_no", insertedMgntNo);
        param.put("sms_subj", "문자 제목");
        param.put("sms_msg_dtls", sms);
        param.put("sms_recv_ph", smsTarget.getSms_recv_ph());
        param.put("sms_recv_chgr", smsTarget.getSms_chgr_nm());
        param.put("district_nm", "현장명");
        param.put("inst_comp_nm", "설치업체명");
        param.put("inst_comp_chgr", "설치업체 담당자");
        param.put("inst_comp_ph", "설치업체 담당자 연락처");
        param.put("alarm_lvl_nm", smsTarget.getAlarm_lvl_nm());
        param.put("send_tp_nm", "send_tp_nm");
        param.put("inst_sens_cnt", 0);
        param.put("alarm_sens_cnt", 0);
        param.put("nonrecv_sens_cnt", "nonrecv_sens_cnt");
        param.put("sens_nm", "sens_nm");
        param.put("dps_chgr_nm", "dps_chgr_nm");
        param.put("dps_chgr_ph", "dps_chgr_ph");
        param.put("mobil_link_url", "mobil_link_url");
        param.put("sms_rslt_yn", "Y");
        mapper.saveSmsDetails(param);
    }

    private int saveAlarmDetails(AlertStandardDto alertStandardDto) {
        int nextMgntNo = mapper.getMaxMgntNoFromAlarmDetails() + 1;

        Map<String, Object> param = new HashMap<>();
        param.put("district_no", alertStandardDto.getDistrict_no());
        param.put("sens_no", alertStandardDto.getSens_no());
        param.put("sens_chnl_id", alertStandardDto.getSens_chnl_id());
        param.put("meas_dt", alertStandardDto.getMeas_dt());
        param.put("raw_data", alertStandardDto.getRaw_data());
        param.put("formul_data", alertStandardDto.getFormul_data());
        param.put("mgnt_no", nextMgntNo);
        param.put("alarm_lvl_cd", alertStandardDto.getOver());
        param.put("net_err_yn", 'Y');
        mapper.saveAlarmDetails(param);

        return nextMgntNo;
    }

    private List<SmsTargetDto> filterToTarget(List<SmsTargetDto> candidatesToSend, int maxOver) {
        return candidatesToSend.stream()
                .filter(candidate -> {
                    if ("1차 초과 이상".equals(candidate.getAlarm_lvl_nm())) {
                        return maxOver >= 1;
                    } else if ("2차 초과 이상".equals(candidate.getAlarm_lvl_nm())) {
                        return maxOver >= 2;
                    } else if ("3차 초과 이상".equals(candidate.getAlarm_lvl_nm())) {
                        return maxOver >= 3;
                    } else if ("4차 초과 이상".equals(candidate.getAlarm_lvl_nm())) {
                        return maxOver >= 4;
                    }
                    return false;
                })
                .collect(Collectors.toList());
    }

    private List<SmsTargetDto> getSmsTargetList(String districtNo) {
        return mapper.getSmsTargetList(Collections.singletonMap("district_no", districtNo));
    }

    private int getMaxOver(List<AlertStandardDto> alertStandardList) {
        int maxOver = 0;
        for (AlertStandardDto alertStandard : alertStandardList) {
            if (alertStandard.getOver() != null && !alertStandard.getOver().isEmpty()) {
                maxOver = Math.max(maxOver, Integer.parseInt(alertStandard.getOver()));
            }
        }
        return maxOver;
    }

    private MeasureDataDto getMeasuredData(AlertStandardDto alertStandard, LocalDateTime now) {
        Map<String, Object> param = new HashMap<>();
        param.put("sens_no", alertStandard.getSens_no());
        param.put("sens_chnl_id", alertStandard.getSens_chnl_id());
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        param.put("meas_dt_start", now.minusMinutes(SMS_SEND_TERM_MINUTE).format(formatter));
        param.put("meas_dt_end", now.format(formatter));

//        param.put("meas_dt_start", now.withHour(0).withMinute(0).withSecond(0).format(formatter));
//        param.put("meas_dt_end", now.withHour(23).withMinute(59).withSecond(59).format(formatter));

        param.put("raw_data", alertStandard.getMax4());
        MeasureDataDto data = mapper.getMeasuredData(param);
        if (data != null) {
            data.setOver("4");
            return data;
        }

        param.put("raw_data", alertStandard.getMax3());
        data = mapper.getMeasuredData(param);
        if (data != null) {
            data.setOver("3");
            return data;
        }

        param.put("raw_data", alertStandard.getMax2());
        data = mapper.getMeasuredData(param);
        if (data != null) {
            data.setOver("2");
            return data;
        }

        param.put("raw_data", alertStandard.getMax1());
        data = mapper.getMeasuredData(param);
        if (data != null) {
            data.setOver("1");
            return data;
        }
        return null;
    }


    private List<AlertStandardDto> getAlertStandards() {
        return mapper.getAlertStandards();
    }

    private String makeSensorMessage(HashMap<String, List<SensInfoDto>> sensInfos) {
        StringBuilder sb = new StringBuilder();

        for (String key : sensInfos.keySet()) {
            sb.append("\n").append("[").append(key).append("]");
            sb.append("\n").append("설치수량 : ").append(sensInfos.get(key).size()).append("EA ").append("/ 초과수량 : ").append(
                    sensInfos.get(key).stream().filter(SensInfoDto::isOver).count()
            ).append("EA ").append("/ 미측정 : 0EA");

        }

        return sb.toString();
    }

    private String makeErrorSensorMessage(HashMap<String, List<SensInfoDto>> sensInfos) {
        StringBuilder sb = new StringBuilder();
        sb.append("\n");
        for (String key : sensInfos.keySet()) {
            for (SensInfoDto sensInfo : sensInfos.get(key)) {
                if (sensInfo.isOver()) {
                    sb.append(sensInfo.getSens_nm()).append(" ");
                }
            }
        }

        return sb.toString();
    }

    private String makeMessage(SmsTargetDto target, DistrictInfoDto district, HashMap<String, List<SensInfoDto>> sensInfos) {
        return "<<<현장 상태 이상 경보 문자>>>" +
                "\n수신정보 전화번호 : [$MOBILE] [$NAME](" + target.getSms_recv_dept() + ")" +
                "\n" +
                "\n전송정보 : 비탈면 IoT 통합 시스템 경보문자" +
                "\n**현장명 정보 :" +
                "\n[" + district.getDistrict_nm() + "]" +
                "\n" + district.getDist_road_addr() +
                "\n" +
                "\n**시공업체정보 :" +
                "\n아주엔지니어링 / 권순기 이사" +
                "\n010-6207-9185" +
                "\n" +
                "\n**24시간내 전송된 회차 :" +
                "\n1회차" +
                "\n" +
                "\n**현장 요약:" +
                "\n관리기준상태 / 수신 100% / 누적강수량: 0mm" +
                "\n" +
                "\n**센서 상태 통계 :" +
                makeSensorMessage(sensInfos) +
                "\n" +
                "\n**이상센서 리스트 :" +
                makeErrorSensorMessage(sensInfos);
    }

    private void sendSms(SmsTargetDto target, DistrictInfoDto district, HashMap<String, List<SensInfoDto>> sensInfos) throws IOException {
        String url = "https://directsend.co.kr/index.php/api_v2/sms_change_word";

        java.net.URL obj;
        obj = new java.net.URL(url);
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        con.setRequestProperty("Cache-Control", "no-cache");
        con.setRequestProperty("Content-Type", "application/json;charset=utf-8");
        con.setRequestProperty("Accept", "application/json");

        String title = "코드아이디어";
        String message = makeMessage(target, district, sensInfos);

        String sender = "01054405414";
        String username = "codeidea";
        String key = "mUJrCPVuyMOq02W";

        System.out.println("message : " + message);

        String receiver = "{\n" +
                "  \"mobile\": \"" + target.getSms_recv_ph() + "\",\n" +
                "  \"name\": \"" + target.getSms_chgr_nm() + "\"\n" +
                "}";
        receiver = "[" + receiver + "]";

        String urlParameters = "\"title\":\"" + title + "\" "
                + ", \"message\":\"" + message + "\" "
                + ", \"sender\":\"" + sender + "\" "
                + ", \"username\":\"" + username + "\" "
                + ", \"receiver\":" + receiver
                + ", \"key\":\"" + key + "\" "
                + ", \"type\":\"" + "java" + "\" ";

        urlParameters = "{" + urlParameters + "}";

        System.setProperty("jsse.enableSNIExtension", "false");
        con.setDoOutput(true);
        OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream(), "UTF-8");
        wr.write(urlParameters);
        wr.flush();
        wr.close();

        int responseCode = con.getResponseCode();
        System.out.println(responseCode);

        java.io.BufferedReader in = new java.io.BufferedReader(
                new java.io.InputStreamReader(con.getInputStream(), "UTF-8"));
        String inputLine;
        StringBuffer response = new StringBuffer();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }

        in.close();

        System.out.println(response);
		/*
			status code
			0   : 정상발송 (성공코드는 다이렉트센드 DB서버에 정상수신됨을 뜻하며 발송성공(실패)의 결과는 발송완료 이후 확인 가능합니다.)
			100 : POST validation 실패
			101 : sender 유효한 번호가 아님
			102 : recipient 유효한 번호가 아님
			103 : 회원정보가 일치하지 않음
			104 : 받는 사람이 없습니다
			105 : message length = 0, message length >= 2000, title >= 20
			106 : message validation 실패
			107 : 이미지 업로드 실패
			108 : 이미지 갯수 초과
			109 : return_url이 유효하지 않습니다
			110 : 이미지 용량 300kb 초과
			111 : 이미지 확장자 오류
			112 : euckr 인코딩 에러 발생
			114 : 예약정보가 유효하지 않습니다.
			200 : 동일 예약시간으로는 200회 이상 API 호출을 할 수 없습니다.
			201 : 분당 300회 이상 API 호출을 할 수 없습니다.
			205 : 잔액부족
			999 : Internal Error.
		 */
    }
}
