package com.safeone.dashboard.scheduler;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.core.env.Environment;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.safeone.dashboard.dto.SmsAlarmListDto;
import com.safeone.dashboard.service.AlarmListService;
import com.safeone.dashboard.service.AlarmSchedulerService;
import com.safeone.dashboard.service.AssetListService;
import com.safeone.dashboard.service.SmsAlarmService;
import com.safeone.dashboard.service.SmsService;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class AlarmScheduler {
    private final AlarmSchedulerService alarmSchedulerService;
    private final AlarmListService alarmListService;
    private final AssetListService assetListService;
    private static String lastCollectTime = null;
    private final static long DELAY_MS = 5 * 60 * 1000; // 5분
    private final Environment env;
    private final SmsService smsService;
    private final SmsAlarmService smsAlarmService;

    /**
     * 계측기 통신 장애 관련 알람 스케쥴러(1분)
     * 수집이 현재시간보다 1분 초과하는 계측기는 통신장애로 간주(type= 1)
     * 장애시, 해당 자산의 상태값은 비정상(2)으로 update
     * 구조물 경사계인 경우, 센서가 2개이므로, 한개라도 장애 있을시, 비정상
     */
//    @Scheduled(fixedDelay = DELAY_MS)
    public void insertCommDelayScheduler() {
        if (env.getProperty("dev").equalsIgnoreCase("true"))   // 개발모드이면 실행안함
            return;

        try {
            // 센서만 상태값 초기화
            alarmSchedulerService.defaultStatusSensor();
            List<Map> result = alarmSchedulerService.selectCommDelayAlarm(env.getProperty("`최근 전송 현황`"));
            for (Map param : result) {
                Map map = new HashMap();
                map.put("asset_id", param.get("asset_id").toString());
                map.put("status_hid", "2");
                assetListService.update(map);

                // 알람설정에서 사용여부에 따라 알람 insert
                if (param.get("use_flag").equals("Y")) {
                    alarmListService.create(param);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * CCTV 통신 상태는 tb_cctv_info 기준으로 갱신됨.
     * 기존 tb_asset / tb_alarm_kind 기반 로직은 사용하지 않음.
     * 실제 업데이트는 CctvRtspStatusScheduler에서 수행.
     */
//    @Scheduled(fixedDelay = DELAY_MS)
    public void insertCCTVDelayScheduler() {
        // Deprecated: kept for backward compatibility only.
    }

    private void sendAlarmSMS(Map param, String title) {
        Map alarmInfo = smsAlarmService.selectAlarmInfo(param).get(0);
        List<SmsAlarmListDto> targets = smsAlarmService.getList(null);

        for (SmsAlarmListDto target : targets) {
            if (!target.getAuto_send_flag().equals("ON")) continue;
            if (Integer.parseInt(param.get("risk_level").toString()) < Integer.parseInt(target.getThreshold())) {
                continue;
            }

            String mms = "[" + title + " 알람]\n" +
                    "현장명 : " + alarmInfo.get("area_name").toString() + " / " + alarmInfo.get("zone_name").toString() + "\n" +
                    "현장주소 : " + alarmInfo.get("address").toString() + "\n\n";

            int smsCount = smsAlarmService.selectSmsCountPerDay(target.getPhone());

            mms += "[24시간내 전송된 회차]\n회차 : " + (smsCount + 1) + "\n\n";

            if (title.equals("통신 장애")) {
                mms += "[현장 요약]\n" +
                        "알람레벨 : " + alarmInfo.get("risk_name").toString() + "\n" +
                        "센서종류 : " + alarmInfo.get("asset_kind_name").toString() + "\n" +
                        "센서명 : " + alarmInfo.get("asset_name").toString() + "\n\n";
            } else {
                mms += "[현장 요약]\n" +
                        "알람레벨 : " + alarmInfo.get("risk_name").toString() + "\n" +
                        "센서종류 : " + alarmInfo.get("asset_kind_name").toString() + "\n" +
                        "센서명 : " + param.get("channel_name").toString() + "\n" +
                        "센서값 : " + param.get("real_value").toString() + "\n";

                Map rainGuage = smsAlarmService.selectRainGaugeInfo(param);

                if (rainGuage != null && rainGuage.containsKey("real_value") && !rainGuage.get("real_value").equals("")) {
                    mms += "강우량 : " + rainGuage.get("real_value").toString() + "mm\n\n";
                } else {
                    mms += "\n\n";
                }
            }

            mms += "[시공업체정보]\n" +
                    "시공사 : " + alarmInfo.get("constructor").toString() + "\n" +
                    "담당자명 : 최덕만 부장\n" +
                    "연락처 : 010-3164-2913";

            smsService.send(target.getPhone().replace("-", ""), mms);
        }
    }

//    @Scheduled(fixedDelay = DELAY_MS)
    public void insertThresholdAlarmScheduler() {
        if (env.getProperty("dev").equalsIgnoreCase("true"))   // 개발모드이면 실행안함
            return;

        alarmSchedulerService.updateViewFlag();

        Map param = new HashMap();
        param.put("cdate", lastCollectTime);

        List<Map> alarmList = alarmSchedulerService.selectThresholdAlarm(param);

        for (Map alarm : alarmList) {
            lastCollectTime = alarm.get("collect_date").toString();

            // description 생성
            // type 은 tb_common_code 의 alarm_kind type 대로 1: 통신이상, 2: 임계치알람 as alarm_type 으로
            // alarm_title 알람 제목
            // alarm_desc 알람 내용

            // 1: 관심, 2: 주의, 3: 경계, 4: 심각
            if (Integer.parseInt(alarm.get("risk_level").toString()) > 0) {
                if (alarm.get("risk_level").toString().equals("1")) {
                    alarm.put("alarm_kind_id", "7");
                } else if (alarm.get("risk_level").toString().equals("2")) {
                    alarm.put("alarm_kind_id", "8");
                } else if (alarm.get("risk_level").toString().equals("3")) {
                    alarm.put("alarm_kind_id", "9");
                } else if (alarm.get("risk_level").toString().equals("4")) {
                    alarm.put("alarm_kind_id", "10");
                }
                alarm.put("type", "2");
                alarm.put("name", alarm.get("asset_kind_name").toString() + " " + alarm.get("asset_name").toString());
                alarm.put("description", alarm.get("channel_name").toString() + " 센서값 " + alarm.get("real_value").toString());

                alarmListService.create(alarm);
                sendAlarmSMS(alarm, "임계치");
            }
        }
    }
}

