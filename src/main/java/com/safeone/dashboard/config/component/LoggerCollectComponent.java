package com.safeone.dashboard.config.component;

import com.safeone.dashboard.dto.RawData;
import com.safeone.dashboard.service.CalcService;
import com.safeone.dashboard.service.ZoneService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import javax.annotation.PostConstruct;
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Slf4j
@Configuration
@Component
public class LoggerCollectComponent {

    static String head_pattern = "(\\w+)(\\d{4}):(\\d{4}/\\d{2}/\\d{2}/\\d{2}:\\d{2}:\\d{2})";
    static String body_pattern = "(\\d+):(\\d+):(\\d+)";
    static String except_pattern = "\\w+\\d{4}:\\d{4}/\\d{2}/\\d{2}/\\d{2}:\\d{2}:\\d{2}\\|";
    private final Set<String> processedData = new HashSet<>();

    @Autowired
    private CalcService calcService;

    @Autowired
    private ZoneService zoneService;

    @Value("${dev}")
    private String devFlag;

    @Value("${dps.collect.port}")
    private int PORT;
    @Value("${collect.send.url}")
    private String send_url;
    @Value("${collect.send.index}")
    private String send_index;

    @PostConstruct
    public void init() {
        if (devFlag.equals("true"))
            return;
            
        if (!getDataFromTCP.isAlive()) {
            getDataFromTCP.start();
            startScheduledDataRemoval();
        }
    }

//    private Thread getDataFromUDP = new Thread() {
//        public void run() {
//            log.info("Starting Logger Collect UDP Server running on port " + PORT);
//            try {
//                // UDP 소켓을 생성하고 포트에 바인딩합니다.
//                DatagramSocket socket = new DatagramSocket(PORT);
//                byte[] buffer = new byte[1024];
//
//                while (true) {
//                    // 데이터를 수신할 버퍼를 생성합니다.
//                    DatagramPacket packet = new DatagramPacket(buffer, buffer.length);
//
//                    // 클라이언트로부터 데이터를 수신합니다.
//                    socket.receive(packet);
//                    InetAddress clientAddress = packet.getAddress();
//                    int clientPort = packet.getPort();
//
//                    // 수신한 데이터를 문자열로 변환합니다.
//                    String data = new String(packet.getData(), 0, packet.getLength());
//                    System.out.println("Received from client " + clientAddress + ":" + clientPort + ": " + data);
//
//                    // 데이터를 처리하는 메서드를 호출합니다.
//                    handleClient(socket, packet);
//                }
//            } catch (Exception e) {
//                log.error("Error in server: " + e.getMessage());
//            }
//        }
//    };
//
//    public void handleClient(DatagramSocket socket, DatagramPacket packet) {
//        try {
//            // 클라이언트로부터 수신한 데이터를 문자열로 변환합니다.
//            String receivedData = new String(packet.getData(), 0, packet.getLength());
//            log.info("Received from client: " + receivedData);
//            processData(receivedData);
//        } catch (Exception e) {
//            log.error("Error handling client: " + e.getMessage());
//        }
//    }

    private Thread getDataFromTCP = new Thread(){
        public void run(){
            log.info("Starting Logger Collect TCP Server running on port " + PORT);

            while (true) {
                try {
                    Thread.sleep(1000 * 5);

                    // 서버 소켓을 생성하고 포트에 바인딩합니다.
                    ServerSocket serverSocket = new ServerSocket(PORT);
                    System.out.println("Server is waiting for client connection...");
    
                    // 클라이언트가 접속할 때까지 기다립니다.
                    Socket clientSocket = serverSocket.accept();
                    System.out.println("Client connected: " + clientSocket.getInetAddress());
    
                    // 새로운 스레드를 생성하여 클라이언트 연결을 처리합니다.
                    new Thread(() -> handleClient(clientSocket)).start();
    
                    // 서버 소켓을 닫습니다.
                    serverSocket.close();                    
                } catch (Exception e) {
                    log.error("Error in server: " + e.getMessage());
                }
            }
        }
    };

    public void handleClient(Socket clientSocket) {
        try {
            // 클라이언트와 통신할 입력 스트림과 출력 스트림을 얻습니다.
            BufferedReader inputReader = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
            PrintWriter outputWriter = new PrintWriter(new OutputStreamWriter(clientSocket.getOutputStream()), true);

            // 클라이언트로 명령을 보냅니다.
            String command = "SCQ";
            outputWriter.println(command);

            // 클라이언트로부터 여러 줄의 문자열 데이터를 읽어 들입니다.
            String line;
            String data = "";
            
            while ((line = inputReader.readLine()) != null) {
                log.info("Received from client: " + line);
                data += line+"|";

                if (line.trim().indexOf("END") > -1) {
                    processData(data);
//                    data = "";
                    break;
                }
            }
            // 리소스를 정리하고 소켓을 닫습니다.
            inputReader.close();
            outputWriter.close();
            clientSocket.close();
        } catch (IOException e) {
            System.err.println("Error handling client: " + e.getMessage());
        }
    }
    
    private void processData(String data) {
        log.info("SensorData : " + data);
        try {
            // 정규표현식으로 데이터 파싱
            List<RawData> parser_data = parserData(data);
            ClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory();
            RestTemplate restTemplate = new RestTemplate(requestFactory);
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            for (RawData parserData : parser_data) {
                String key = parserData.getCollect_date() + parserData.getZone_id() + parserData.getSensor_id();
                if (!processedData.contains(key)) {
                    HttpEntity<RawData> entity = new HttpEntity<>(parserData, headers);
                    ResponseEntity<String> response = restTemplate.postForEntity(send_url + send_index, entity, String.class);
                    // 간헐적으로 _cdate가 겹쳐서 insert 빠지는 상황 보안
                    Thread.sleep(100);
                    processedData.add(key);
                } else {
                    log.info("Duplicate data found. Skipping transmission.");
                }
            }
        } catch (Exception e) {
            log.error("Error processData: " + e.getMessage());
        }
    }

    /**
     * 수집된 센서의 로우 데이터의 공통부분을 제외한 나머지 파싱
     * 센서값 도출 순서 : 1.오리지날 센서값 -> 2.센서값 변환(센서별 계산식에 의해) -> 3.실제 운용되는 센서값 따로 계산
     * 파싱할 데이터 예시
     * testbed0030896:2023/03/29/09:24:08|000:21787:3|050:32315:2|051:33605:2|END|
     * testbed0030338:2023/04/17/17:25:29|000:21911:3|050:05145:2|051:11580:2|180:02088:6|181:00000:7|255:00000:4|END|
     * @param data
     * @return
     */
    private List<RawData> parserData(String data) {
        String data_tail = data.replaceAll(except_pattern, "");
        List<RawData> list = new ArrayList<>();
        Pattern p = Pattern.compile(body_pattern);
        Matcher m = p.matcher(data_tail);
        while (m.find()) {
            RawData rawData = commonData(data);
            rawData.setSensor_id(m.group(1));
            rawData.setRaw_value(m.group(2));
            rawData.setType(m.group(3));
            rawData.setCalc_value(String.valueOf(calcData(m.group(2), m.group(3))) );
            if (m.group(1) != null) rawData.setReal_value(realData(rawData, calcData(m.group(2), m.group(3))) );
            list.add(rawData);
            System.out.println(rawData);
        }
        return list;
    }

    /**
     * 수집된 센서의 로우 데이터의 공통부분(앞단-> 지구명, 넘버, 수집일자)만 파싱
     * Zone ID 로 변환해서 insert(ex. testbed003 -> 1), tb_zone 테이블에 값이 없으면 수집된 값 그대로
     * @param data
     * @return
     */
    private RawData commonData(String data) {
        RawData rawData = new RawData();
        Pattern p = Pattern.compile(head_pattern);
        Matcher m = p.matcher(data);
        if (m.find()) {
            if (m.group(1) != null){
                String zone_id = zoneService.getZoneIdByEtc1(m.group(1));
                rawData.setZone_id(zone_id);
            } else {
                rawData.setZone_id(m.group(1));
            }
            rawData.setNum(m.group(2));
            rawData.setCollect_date(m.group(3));
        }
        return rawData;
    }

    /**
     * 센서 타입별 계산식 적용 (센서값 변환)
     * @param raw_value
     * @param type
     * @return
     */
    private double calcData(String raw_value, String type) {
        double raw = Double.parseDouble(raw_value);
        double calc;
        switch (type) {
            case "3":
                calc = (raw / 100.0);
                break;
            case "2":
                calc = ((32767 - raw) / 1000.0);
                break;
            case "6":
            case "7":
                calc = Math.round(raw * 100) / 100.0;
                break;
            case "4":
                calc = raw * 0.5;
                break;
            default:
                calc = 0;
                break;
        }
        return calc;
    }

    /**
     * 실제 운용되는 센서값 따로 계산(센서변환값 - 센서 초기값)
     * @param rawData
     * @param calcData
     * @return
     */
    private String realData(RawData rawData, double calcData) {
        Map map = new HashMap();
        map.put("zone_id", rawData.getZone_id());
        map.put("sensor_id", rawData.getSensor_id());
        String initial_value = calcService.getInitialValue(map);
//        System.out.println("initial_value :: " + initial_value);
        if (initial_value != null)
            return String.valueOf(Math.round((calcData - Double.parseDouble(initial_value))*10000)/10000.0);
        else
            return String.valueOf(calcData);
    }

    // 1시간마다 processedData 데이터를 제거하는 메서드
    private void removeExpiredData() {
        long currentTime = System.currentTimeMillis();
        processedData.removeIf(key -> currentTime - Long.parseLong(key) > TimeUnit.HOURS.toMillis(1));
    }

    public void startScheduledDataRemoval() {
        ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor();
        executorService.scheduleAtFixedRate(this::removeExpiredData, 0, 5, TimeUnit.MINUTES); // 5분마다 실행
    }
}

