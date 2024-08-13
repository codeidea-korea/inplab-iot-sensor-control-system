package com.safeone.dashboard.scheduler;

import java.io.IOException;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.safeone.dashboard.dto.AssetListDto;
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
    private final static SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
    private static String lastCollectTime = null;

    private final static long DELAY_MS = 60 * 1000; // 60초


    @Autowired
    Environment env;

    @Autowired
    SmsService smsService;

    @Autowired
    SmsAlarmService smsAlarmService;

    /**
     * 계측기 통신 장애 관련 알람 스케쥴러(1분)
     * 수집이 현재시간보다 1분 초과하는 계측기는 통신장애로 간주(type= 1)
     * 장애시, 해당 자산의 상태값은 비정상(2)으로 update
     * 구조물 경사계인 경우, 센서가 2개이므로, 한개라도 장애 있을시, 비정상
     */
    @Scheduled(fixedDelay = DELAY_MS)
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
//                map.put("alarm_desc", param.get("description").toString());
                map.put("status_hid", "2");
//                System.out.println(map);
                assetListService.update(map);
                // 알람설정에서 사용여부에 따라 알람 insert
                if (param.get("use_flag").equals("Y")) {
                    alarmListService.create(param);
//                    sendAlarmSMS(param, "통신 장애");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * CCTV 통신 장애 스케쥴러(1분)
     * socket 통신으로 확인
     * 장애시, 해당 자산의 상태값은 비정상(2)으로 update
     * url 잘못된 경우 또한 비정상 처리
     */
    @Scheduled(fixedDelay = DELAY_MS)
    public void insertCCTVDelayScheduler() {
        if (env.getProperty("dev").equalsIgnoreCase("true"))   // 개발모드이면 실행안함
            return;

        String regex = "rtsp://([^:/]+):(\\d+)";
        Map<String, Object> map = new HashMap<>();
        map.put("asset_kind_id", "8");
        List<AssetListDto> list = assetListService.getList(map);
        Map m = alarmSchedulerService.selectCCTVAlarm();

        for (AssetListDto assetListDto : list) {
            String url = assetListDto.getEtc1();
            Map<String, Object> param = new HashMap<>();
            param.put("asset_id", assetListDto.getAsset_id());
            param.put("status_hid", "2");
            m.put("asset_id", assetListDto.getAsset_id());

            if (!url.contains("rtsp://")) {
//                m.put("alarm_desc", "Invalid rtsp url - " + url);
                if (m.get("use_flag").equals("Y")) {
                    alarmListService.create(m);
                }
                assetListService.update(param);
                continue;
            }

            Pattern pattern = Pattern.compile(regex);
            Matcher matcher = pattern.matcher(url);

            if (!matcher.find()) {
//                m.put("alarm_desc", "URL pattern mismatch - " + url);
                if (m.get("use_flag").equals("Y")) {
                    alarmListService.create(m);
                }
                assetListService.update(param);
                continue;
            }

            String ipAddress = matcher.group(1);
            int port = Integer.parseInt(matcher.group(2));

            try (Socket socket = new Socket(ipAddress, port)) {
                // Connection successful
                param.put("status_hid", "1");
            } catch (IOException e) {
                // Connection failed
//                m.put("alarm_desc", "Connection failed to CCTV at " + ipAddress + ":" + port);
                if (m.get("use_flag").equals("Y")) {
                    alarmListService.create(m);
//                    sendAlarmSMS(m, "통신 장애");
                }
//                e.printStackTrace();
            }
            assetListService.update(param);
        }
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

            smsService.send(target.getPhone().toString().replace("-", ""), mms);
        }

//        System.out.println(param);
//        System.out.println(alarmInfo);
    }

    @Scheduled(fixedDelay = DELAY_MS)
    public void insertThresholdAlarmScheduler() {
        if (env.getProperty("dev").equalsIgnoreCase("true"))   // 개발모드이면 실행안함
            return;

        alarmSchedulerService.updateViewFlag();

        Map param = new HashMap();
        param.put("cdate", lastCollectTime);

        List<Map> alarmList = alarmSchedulerService.selectThresholdAlarm(param);

        // {raw_value=31827, num=0662, asset_kind_id=2, mod_date=2023-11-20 10:42:51.693302, asset_id=6, area_id=0, type=2, sensor_id=053, 
        //  zone_id=1, collect_date=2023/11/22/16:53:32, install_date=2023-09-13 00:00:00.0, seq=1, real_value=0.02, range_value5=150, mod_user=test_admin, 
        //  calc_value=0.94, range_value3=50, range_value4=100, device_id=, range_value1=-10, range_value2=10, _cdate=2023-11-22T16:48:45.404, 
        //  reg_date=2023-09-13 12:15:34.15349, name=TTW-02-02, x=128.3408891746636, y=36.12744754695781, channel_id=12, use_flag=Y, status=2}
        for (Map alarm : alarmList) {
            // System.out.println(alarm);

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
                alarm.put("name", alarm.get("asset_kind_name").toString() + " " +  alarm.get("asset_name").toString());
                alarm.put("description", alarm.get("channel_name").toString() + " 센서값 " +  alarm.get("real_value").toString());

                alarmListService.create(alarm);
                sendAlarmSMS(alarm, "임계치");
            }
        }
    }

    /**
     * 알람 현황 표시 - 1분마다 지난 알람 카운트 안되게 view_flag N으로 update
     */
//    @Scheduled(fixedDelay = DELAY_MS)
//    public void updateViewFlagScheduler() {
//        if (env.getProperty("dev").equalsIgnoreCase("true"))
//            return;
//
//        try {
//            alarmSchedulerService.updateViewFlag();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
}

