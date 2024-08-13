package com.safeone.dashboard.service;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.safeone.dashboard.dao.SmsAlarmMapper;

import lombok.RequiredArgsConstructor;

/**
 * 슈어엠 SMS, 알림톡 서비스
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class SmsService {
    private final SmsAlarmMapper mapper;

    private final static String USER_CODE = "dpsg1606";        // dpsg1606
    private final static String DEPT_CODE = "P3-L7I-T2";        // dpsg1606
    private final static String REQ_NUM = "0544557100";

    // public void main(String[] args) {
    //     send("01092613450", "[현장 이상 발생 알람]\n" +
    //             "현장명 : 경주경감로 / 경감08지구\n" +
    //             "현장주소 : 경주시 황용동 662번지\n\n" +
    //             "[24시간내 전송된 회차]\n" +
    //             "회차 : 1\n\n" +
    //             "[현장 요약]\n" +
    //             "알람레벨 : 주의\n" +
    //             "센서종류 :구조물경사계\n" +
    //             "센서명 : TTW-08-04-Y\n" +
    //             "센서값 : 1.05\n" +
    //             "강우량 : 10.5mm\n\n" +
    //             "[시공업체정보]\n" +
    //             "시공사 : 디피에스글로벌\n" +
    //             "담당자명 : 최덕만 부장\n" +
    //             "연락처 : 010-3164-2913");
    // }

    public boolean send(String targetMobile, String message) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.add("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" +
            " AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36");

            String requestJson = "[{\"usercode\":\"" + USER_CODE + "\", \"deptcode\":\"" + DEPT_CODE + "\", \"to\" : \"" + targetMobile
            + "\", " +
            "\"text\":\"" + message + "\", " +
            "\"reqphone\":\"" + REQ_NUM + "\" " +
            "}]";

            HttpEntity<String> entity = new HttpEntity<String>(requestJson, headers);

            String answer = restTemplate.postForObject("https://rest.surem.com/messages/mms", entity, String.class);

//            System.out.println(answer);
            log.info("sms answer :: {}" , answer);

            Gson gson = new Gson();
            Type mapType = new TypeToken<Map<String, Object>>() {}.getType();
            Map<String, Object> result = gson.fromJson(answer, mapType);

            if (result.get("code").toString().equals("200")) {
                Map param = new HashMap();
                param.put("phone", targetMobile);
                param.put("message", message);
                mapper.insertSmsLog(param);
            }

            return true;            
        } catch(Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
