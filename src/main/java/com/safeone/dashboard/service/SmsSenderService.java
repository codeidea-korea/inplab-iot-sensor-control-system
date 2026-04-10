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
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class SmsSenderService {

    private final SmsSenderMapper mapper;
    private final MoisRiskAlertService moisRiskAlertService;
    private static final int SMS_SEND_TERM_MINUTE = 1;

    @Transactional
    public void run() {
        LocalDateTime now = LocalDateTime.now();
        Set<String> currentActiveAlarmKeys = new HashSet<>();

        List<AlertStandardDto> alertStandards = getAlertStandards();

        // 1. 경보기준들을 district_no로 그룹핑
        Map<String, List<AlertStandardDto>> map = alertStandards.stream()
                .collect(Collectors.groupingBy(AlertStandardDto::getDistrict_no));

        // 2. district_no 기준으로 순회
        map.forEach((districtNo, alertStandardList) -> {
            DistrictInfoDto districtInfo = mapper.getDistrictInfo(Collections.singletonMap("district_no", districtNo));

            alertStandardList.forEach(alertStandard -> {
                // 3. 경보기준이 넘는 데이터가 있는지 확인
                MeasureDataDto data = getMeasuredData(alertStandard, now);
                if (data != null) {
                    alertStandard.setAdditionalData(data);
                }
            });

            List<AlertStandardDto> overAlerts = alertStandardList.stream()
                    .filter(item -> item.getOver() != null)
                    .collect(Collectors.toList());

            if (overAlerts.isEmpty()) {
                return;
            }

            // 4. 문자를 발송할 후보군 조회
            List<SmsTargetDto> candidates = getSmsTargetList(districtNo);
            int maxOver = getMaxOver(overAlerts);

            // 5. 후보군 필터링
            List<SmsTargetDto> smsTargets = filterToTarget(candidates, maxOver);
            Map<String, Object> maintCompInfo = smsTargets.isEmpty()
                    ? Collections.emptyMap()
                    : getMaintCompInfo(districtInfo.getMeas_comp_id1());

            // 6. 알람이력 저장 + 문자 상세내역 저장
            overAlerts.forEach(item -> {
                currentActiveAlarmKeys.add(moisRiskAlertService.buildAlarmKey(item));
                int insertedMgntNo = saveAlarmDetails(item);
                SensInfoDto sensInfo = mapper.getSensInfo(item.getSens_no());
                moisRiskAlertService.sendAlertIfNeeded(insertedMgntNo, item, districtInfo, sensInfo);
                if (!smsTargets.isEmpty()) {
                    smsTargets.forEach(smsTarget -> {
                        String msg = makeMessage(smsTarget, districtInfo, maintCompInfo, overAlerts);
                        saveSmsDetails(smsTarget, insertedMgntNo, msg);
                    });
                }
            });

            // 7. 문자 발송
            if (!smsTargets.isEmpty()) {
                smsTargets.forEach(smsTarget -> {
                    try {
                        sendSms(smsTarget, districtInfo, maintCompInfo, overAlerts);
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                });
            }
        });

        moisRiskAlertService.reconcileActiveKeys(currentActiveAlarmKeys);
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

        MeasureDataDto data = queryByLevel(param, alertStandard.getMin4(), alertStandard.getMax4(), "4");
        if (data != null) {
            return data;
        }

        data = queryByLevel(param, alertStandard.getMin3(), alertStandard.getMax3(), "3");
        if (data != null) {
            return data;
        }

        data = queryByLevel(param, alertStandard.getMin2(), alertStandard.getMax2(), "2");
        if (data != null) {
            return data;
        }

        return queryByLevel(param, alertStandard.getMin1(), alertStandard.getMax1(), "1");
    }

    private MeasureDataDto queryByLevel(Map<String, Object> param, String minThreshold, String maxThreshold, String over) {
        boolean hasMin = minThreshold != null && !minThreshold.trim().isEmpty();
        boolean hasMax = maxThreshold != null && !maxThreshold.trim().isEmpty();

        if (!hasMin && !hasMax) {
            return null;
        }

        param.put("min_formul_data", hasMin ? minThreshold : null);
        param.put("max_formul_data", hasMax ? maxThreshold : null);

        MeasureDataDto data = mapper.getMeasuredData(param);
        if (data != null) {
            data.setOver(over);
        }
        return data;
    }

    private List<AlertStandardDto> getAlertStandards() {
        return mapper.getAlertStandards();
    }

    private Map<String, Object> getMaintCompInfo(String partnerCompId) {
        if (partnerCompId == null || partnerCompId.trim().isEmpty()) {
            return Collections.emptyMap();
        }
        Map<String, Object> info = mapper.getMaintCompInfo(partnerCompId);
        return info == null ? Collections.emptyMap() : info;
    }

    private int getAlarmSendCount(AlertStandardDto alert) {
        Map<String, Object> param = new HashMap<>();
        param.put("sens_no", alert.getSens_no());
        param.put("sens_chnl_id", alert.getSens_chnl_id());
        return mapper.getAlarmSendCount(param);
    }

    private String getSensorName(AlertStandardDto alert) {
        SensInfoDto sensInfo = mapper.getSensInfo(alert.getSens_no());
        if (sensInfo == null || sensInfo.getSens_nm() == null || sensInfo.getSens_nm().trim().isEmpty()) {
            return alert.getSens_no();
        }
        return sensInfo.getSens_nm();
    }

    private String mapAlarmLevelName(String levelCode) {
        if (levelCode == null) {
            return "-";
        }
        switch (levelCode.trim()) {
            case "1":
            case "ARM001":
                return "관심";
            case "2":
            case "ARM002":
                return "주의";
            case "3":
            case "ARM003":
                return "경계";
            case "4":
            case "ARM004":
                return "심각";
            default:
                return levelCode;
        }
    }

    private String getOverallAlarmLevelName(List<AlertStandardDto> overAlerts) {
        int maxLevel = overAlerts.stream()
                .map(AlertStandardDto::getOver)
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(v -> !v.isEmpty())
                .mapToInt(v -> {
                    try {
                        return Integer.parseInt(v);
                    } catch (NumberFormatException e) {
                        return 0;
                    }
                })
                .max()
                .orElse(0);
        return mapAlarmLevelName(String.valueOf(maxLevel));
    }

    private String getReceiveRateText(String districtNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("district_no", districtNo);
        Map<String, Object> row = mapper.getReceiveRate(param);
        if (row == null || row.get("receive_rate") == null) {
            return "0%";
        }
        return String.valueOf(row.get("receive_rate")) + "%";
    }

    private String getLatestRainText(String districtNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("district_no", districtNo);
        Map<String, Object> row = mapper.getLatestRainData(param);
        if (row == null || row.get("formul_data") == null) {
            return "0";
        }
        return String.valueOf(row.get("formul_data"));
    }

    private String makeSensorAlarmStatus(List<AlertStandardDto> overAlerts) {
        StringBuilder sb = new StringBuilder();
        for (AlertStandardDto alert : overAlerts) {
            if (sb.length() > 0) {
                sb.append("\n");
            }
            sb.append(getSensorName(alert))
              .append(" : 기준치 초과 (")
              .append(mapAlarmLevelName(alert.getOver()))
              .append(") : 변위값 (")
              .append(alert.getFormul_data())
              .append(")");
        }
        return sb.toString();
    }

    private String makeSendCountSection(List<AlertStandardDto> overAlerts) {
        StringBuilder sb = new StringBuilder();
        Set<String> seen = new HashSet<>();

        for (AlertStandardDto alert : overAlerts) {
            String key = String.valueOf(alert.getSens_no()) + "|" + String.valueOf(alert.getSens_chnl_id());
            if (!seen.add(key)) {
                continue;
            }

            if (sb.length() > 0) {
                sb.append("\n");
            }

            sb.append(getSensorName(alert))
              .append(" : ")
              .append(getAlarmSendCount(alert))
              .append(" 회차");
        }

        return sb.toString();
    }

    private String makeMessage(SmsTargetDto target, DistrictInfoDto district, Map<String, Object> maintCompInfo, List<AlertStandardDto> overAlerts) {
        String partnerCompNm = String.valueOf(maintCompInfo.getOrDefault("partner_comp_nm", "-"));
        String maintRepNm = String.valueOf(maintCompInfo.getOrDefault("maint_rep_nm", "-"));
        String sendCountSection = makeSendCountSection(overAlerts);
        String receiveRate = getReceiveRateText(district.getDistrict_no());
        String siteNm = district.getSite_nm() == null || district.getSite_nm().trim().isEmpty()
                ? district.getSite_no()
                : district.getSite_nm();

        return "IOT센서 상시계측 시스템 경보문자" +
                "\n[현장명]" +
                "\n" + siteNm + " / " + district.getDistrict_nm() +
                "\n[시공업체정보]" +
                "\n" + partnerCompNm + " / " + maintRepNm +
                "\n[24시간내 전송된 회차]" +
                "\n" + sendCountSection +
                "\n[현장요약]" +
                "\n관리기준상태:" + " / 수신율 : " + receiveRate + " / 누적강우량:" + getLatestRainText(district.getDistrict_no()) + "mm" +
                "\n[센서알람상태]" +
                "\n" + makeSensorAlarmStatus(overAlerts) +
                "\n[연락처]" +
                "\n" + target.getSms_recv_dept() + " : " + target.getSms_chgr_nm() + " : " + target.getSms_recv_ph();
    }

    private void sendSms(SmsTargetDto target, DistrictInfoDto district, Map<String, Object> maintCompInfo, List<AlertStandardDto> overAlerts) throws IOException {
        String url = "https://directsend.co.kr/index.php/api_v2/sms_change_word";

        java.net.URL obj;
        obj = new java.net.URL(url);
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        con.setRequestProperty("Cache-Control", "no-cache");
        con.setRequestProperty("Content-Type", "application/json;charset=utf-8");
        con.setRequestProperty("Accept", "application/json");

        String title = "코드아이디어";
        String message = makeMessage(target, district, maintCompInfo, overAlerts);

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
    }
}
