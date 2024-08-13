package com.safeone.dashboard.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.safeone.dashboard.util.HttpUtils;

@RequestMapping("/weather")
@RestController
public class WeatherController {

    /**
     * 기상청 RSS 파싱
     * 
     * RSS 데이터 정의 
     * https://www.weather.go.kr/w/resources/pdf/dongnaeforecast_1hr_rss.pdf
     * https://www.weather.go.kr/w/pop/rss-guide.do?sido=4700000000&gugun=4713000000&dong=4729053000(경주시)
     * https://www.weather.go.kr/w/pop/rss-guide.do?sido=4300000000&gugun=4375000000&dong=4375035000(충북 진천군)
     *
     * @param zoneCode
     * @return
     * @throws IOException
     */
    @GetMapping(value = "/today/{zoneCode}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> today(@PathVariable String zoneCode) throws IOException {
        String rssUrl = "https://www.weather.go.kr/w/rss/dfs/hr1-forecast.do?zone=" + zoneCode;      // 1시간 간격 날씨 RSS (경주시 4713000000)
        Document doc = Jsoup.connect(rssUrl).get();

        Element firstDataElement = doc.select("data").first();                              // 가장 가까운 시간
        if (firstDataElement != null) {
//            System.out.println(firstDataElement);
            // System.out.println("firstDataElement");
        } else {
            System.out.println("No data elements found.");
        }

        Map result = new HashMap<>();
        result.put("temp", firstDataElement.select("temp").text());     // 온도
        result.put("temx", firstDataElement.select("temx").text());     // 최고온도
        result.put("temn", firstDataElement.select("temn").text());     // 최저온도
        result.put("reh", firstDataElement.select("reh").text());       // 습도
        result.put("wfKor", firstDataElement.select("wfKor").text());   // 날씨(한글)
        result.put("wfEn", firstDataElement.select("wfEn").text());     // 날씨(영문)
        result.put("wdKor", firstDataElement.select("wdKor").text());   // 바람방향
        result.put("ws", firstDataElement.select("ws").text());         // 풍속 m/s
        result.put("pcp", firstDataElement.select("pcp").text());       // 시간당 예상 강수량        
        result.put("pop", firstDataElement.select("pop").text());       // 강수확율

        ObjectMapper objectMapper = new ObjectMapper();
        String json = objectMapper.writeValueAsString(result);

        return ResponseEntity.ok(json);
    }

    @GetMapping(value = "/special/{areaName}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> getSpecialWeatherInfo(@PathVariable String areaName) throws IOException {
        String url = "https://apihub.kma.go.kr/api/typ01/url/wrn_now_data_new.php?fe=f&tm=&disp=0&help=1&authKey=SU0suZFuQ-6NLLmRbkPubw";
        String html = HttpUtils.getRestTemplate().getForObject(url, String.class);

        // html = html.substring(html.lastIndexOf("ED_TM") + 6);
        String[] rows = html.split("\n");
        
        List<String> result = new ArrayList<>();

        for (String row : rows) {
            if (row.indexOf(areaName) > -1)                                 // 진천군 추출
                result.add(row);
        }

        ObjectMapper objectMapper = new ObjectMapper();
        String json = objectMapper.writeValueAsString(result);

        return ResponseEntity.ok(json);
    }
}
