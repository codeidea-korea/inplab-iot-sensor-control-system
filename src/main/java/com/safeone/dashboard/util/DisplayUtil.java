package com.safeone.dashboard.util;

import lombok.extern.slf4j.Slf4j;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Arrays;

/**
 * 전광판 프로토콜 Util
 * No   Name            Size(Byte)  Type    Remark
 * 1    STX             1           HEX     0x02
 * 2    내부 카운트     1           HEX     0xC0
 * 3    명령코드        1           HEX     0x20
 * 4    총 데이터길이   2           HEX     0x00 ~ 0x01FF
 * 5    Body            가변        HEX     각종 데이터 (최대 512바이트)
 * 6    ETX             1           HEX     0x03
 * 7    CRC             1           HEX     STX~ETX 전체 XOR
 */
@Slf4j
public class DisplayUtil {
    private static String clientAddress = "127.0.0.1";
    private static int clientPort = 8000;

    private static String serverAddress = "192.168.10.141";
    private static int serverPort = 8090;

    // 시작 (고정값)
    private static final byte STX = 0x02;
    // 내부 카운트 (고정값)
    private static final byte INC = (byte) 0xC0;
    // 종료 (고정값)
    private static final byte ETX = 0x03;
    // 검증 CRC

    // 표출 모드 - 평시 (긴급 해제 할 때)
    public final static byte NOR = 0x00;
    // 표출 모드 - 긴급 (긴급문구 추가시 자동으로 변경됨)
    public final static byte EMG = 0x01;

    public DisplayUtil(String serverAddress, int serverPort) {
        this.serverAddress = serverAddress;
        this.serverPort = serverPort;
    }

    public void receiveData() {
        try (Socket socket = new Socket(serverAddress, serverPort);
            InputStream in = socket.getInputStream()) {

            ReceiveData rxData = new ReceiveData();
            byte[] receivedBuffer = new byte[1024];
            int bytesRead;

            while ((bytesRead = in.read(receivedBuffer)) != -1) {
                for (int i = 0; i < bytesRead; i++) {
                    boolean result = rxData.receiveBuffer(receivedBuffer[i]);
                    if (!result) {
                        // 데이터 처리 중 오류 발생
                        log.error("Data processing error.");
                        break;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void sendCommand(ElectronicDisplay ed) throws UnknownHostException {
        try (Socket socket = new Socket(serverAddress, serverPort);
            OutputStream out = socket.getOutputStream();
            InputStream in = socket.getInputStream()) {

            log.info("TCP Socket connected - " + serverAddress + ":" + serverPort);

            // 서버로 명령어 전송
            out.write(ed.commandData, 0, ed.length);

            log.info("request - " + toHex(ed.commandData, ed.length));

            out.flush();

            // 서버 응답 출력
            byte[] responseBuffer = new byte[1024];
            int bytesRead = in.read(responseBuffer);
            if (bytesRead != -1) {
                log.info("Response - ");
                for (int i = 0; i < bytesRead; i++) {
                    log.info(String.format("%02x ", responseBuffer[i]));
                }

            } else {
                log.info("No response from server.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new UnknownHostException();
        }
    }

    public static String toHex(byte[] byteArray, int length) {
        StringBuilder hexString = new StringBuilder();

        int i = 0;
        for (byte b : byteArray) {
            if (i >= length)
                break;

            hexString.append(String.format("%02X ", b));

            i++;
        }

        return hexString.toString();
    }

    public static class ElectronicDisplay {

        // 총 데이터 길이
        int length;

        // Body 최대 512 바이트
        byte[] body = new byte[512];

        // 검증 STX~ETX 전체 XOR (0x00 경우는 바이패스 처리)
        byte crc;

        byte[] commandData = new byte[519];

        public ElectronicDisplay() {
            Arrays.fill(body, (byte) 0);
            Arrays.fill(commandData, (byte) 0);
        }

        public void setBody(byte[] data, int offset, int len) {
            System.arraycopy(data, 0, this.body, offset, len);
        }
    }

    public class ReceiveData {
        int count;
        int length;
        byte[] buffer = new byte[519];

        public ReceiveData() {
            count = 0;
            length = 0;
            Arrays.fill(buffer, (byte) 0);
        }

        public boolean receiveBuffer(byte data) {
            boolean ret = true;

            if ((count == 0 && data == STX) || (count == 1 && data == INC)) {
                buffer[count++] = data;
            } else if (count >= 2 && count <= 4) {
                if (count == 3) {
                    length = (data << 8) & 0xFF00;
                } else if (count == 4) {
                    length |= (data & 0xFF);
                }
                buffer[count++] = data;
            } else if (count < length - 1) {
                buffer[count++] = data;
            } else if ((count == length) && data == ETX) {
                buffer[count++] = data;
            } else if (count <= length) {
                buffer[count++] = data;
            } else {
                ret = false;
            }

            return ret;
        }
    }

    /**
     * 바이트를 비트 표현하는 문자열로 변경
     * @param b
     * @return
     */
    static String bytesToBinaryString(Byte b) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < 8; i++) {
            builder.append(((0x80 >>> i) & b) == 0 ? '0' : '1');  // byte는 0x80, int는 0x80000000
        }

        return builder.toString();
    }

    private static void checkCRC(ElectronicDisplay ed) {
        byte crc = 0x00;
        for (int i = 0; i < ed.length - 1; i++) {
            crc ^= ed.commandData[i]; // xor
        }

        ed.commandData[ed.length - 1] = crc;
    }

    private static void commandInit(ElectronicDisplay ed) {
        ed.commandData[0] = STX;
        ed.commandData[1] = INC;
    }

    public static boolean rxDataConversion(ElectronicDisplay ed, ReceiveData rxData) {
        boolean ret = true;
        byte tempCRC = 0;

        Arrays.fill(ed.commandData, (byte) 0);      // commandData 배열 초기화
        Arrays.fill(ed.body, (byte) 0);             // body 배열 초기화

        System.arraycopy(rxData.buffer, 0, ed.commandData, 0, rxData.length);       // commandData 배열 복사


        ed.crc = rxData.buffer[rxData.length - 1];      // CRC 데이터 대입
        ed.length = rxData.length;                      // 길이 데이터 대입

        if (rxData.length - 7 >= 0) System.arraycopy(rxData.buffer, 0, ed.body, 0, rxData.length - 7);      // 바디 데이터 대입

        // CRC 검사
        for (int i = 0; i < ed.length - 1; i++) {
            tempCRC ^= ed.commandData[i];
        }

        if (tempCRC != ed.crc) {
            ret = false;
        }

        return ret;
    }

    /**
     * 총 데이터는 2바이트 자리 계산하여 입력
     * @param ed
     */
    private static void setCommandLength(ElectronicDisplay ed) {                // 길이 정보를 commandData 배열에 설정
        ed.commandData[3] = (byte) ((ed.length & 0xFF00) >> 8);                 // 길이의 상위 바이트
        ed.commandData[4] = (byte) (ed.length & 0x00FF);                        // 길이의 하위 바이트
    }


    public static void powerStatusCheckTX(ElectronicDisplay ed) {
        ed.length = 7; // 커맨드 길이 설정
        commandInit(ed);
        ed.commandData[2] = 0x01; // 전원 상태조회 명령
        setCommandLength(ed);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        log.info("powerStatusCheckTX create");
    }

    public static void displayModeSetting(ElectronicDisplay ed, byte mode) throws UnknownHostException {
        ed.length = 8;
        commandInit(ed);
        ed.commandData[2] = 0x09; // 표출 모드 설정 명령
        ed.body[0] = mode; // 모드 설정
        setCommandLength(ed);
        System.arraycopy(ed.body, 0, ed.commandData, 5, ed.body.length);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        sendCommand(ed);

        log.info("displayModeSetting create");
    }

    public static void brightnessSettingTX(ElectronicDisplay ed) {
        // 밝기 설정 명령의 예시 로직
        ed.length = 31; // 해당 커맨드의 길이
        commandInit(ed);
        ed.commandData[2] = 0x08; // 밝기 설정 명령
        setCommandLength(ed);
        System.arraycopy(ed.body, 0, ed.commandData, 5, ed.length - 7);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        log.info("brightnessSettingTX create");
    }

    public static void displayStatusCheck(ElectronicDisplay ed) {
        // 현재 표출 상태 확인 명령의 예시 로직
        ed.length = 7; // 해당 커맨드의 길이
        commandInit(ed);
        ed.commandData[2] = 0x0a; // 현재 표출 상태 확인 명령
        setCommandLength(ed);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        log.info("displayStatusCheck create");
    }

    /**
     * 시스템 시간 정보 요청
     * @param ed
     */
    public static void displaySystemTime(ElectronicDisplay ed) {
        // 현재 표출 상태 확인 명령의 예시 로직
        ed.length = 7; // 해당 커맨드의 길이
        commandInit(ed);
        ed.commandData[2] = 0x51; // 현재 표출 상태 확인 명령
        setCommandLength(ed);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        log.info("displaySystemTime create");
    }

    /**
     * 평시 문구 전체 삭제 명령
     * @param ed
     */
    public static void deleteAllPeacetimePhrases(ElectronicDisplay ed) throws UnknownHostException {
        // 평시 문구 전체 삭제 명령의 예시 로직
        ed.length = 7; // 해당 커맨드의 길이
        commandInit(ed);
        ed.commandData[2] = 0x19; // 평시 문구 전체 삭제 명령
        setCommandLength(ed);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        sendCommand(ed);

        log.info("deleteAllPeacetimePhrases create");
    }

    /**
     * 긴급 문구 전체 삭제 명령
     * @param ed
     */
    public static void deleteAllEmergencyPhrases(ElectronicDisplay ed) throws UnknownHostException {
        ed.length = 7; // 해당 커맨드의 길이 설정
        commandInit(ed);
        ed.commandData[2] = 0x1A; // 긴급 문구 전체 삭제 명령
        setCommandLength(ed);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        sendCommand(ed);

        log.info("deleteAllEmergencyPhrases create");
    }

    /**
     * (X) 평시, 문구 추가 명령 -현재 작동 안됨
     * @param ed
     * @param length
     */
    public static void addPeacetimePhrases(ElectronicDisplay ed, int length) {
        ed.length = length + 7;
        commandInit(ed);
        ed.commandData[2] = 0x21; // 평시, 문구 추가 명령
        setCommandLength(ed);
        System.arraycopy(ed.body, 0, ed.commandData, 5, length);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        log.info("addPeacetimePhrases create");
    }

    /**
     * 평시, 이미지로 시나리오 추가 명령
     * @param ed
     * @param sc
     * 01:01:04:05:05:04 : 방번호(1~100)<br/>
     * 표시효과 : 1=바로표시, 2=좌스크롤, 3=위스크롤, 4=다운스크롤, 5=레이서효과, 6=상하로, 7=중심으로, 8=1단으로 좌스크롤<br/>
     * 표시속도 : 1(빠름)~8(느림) ex) 0x04<br/>
     * 표시 후 대기시간 : x초<br/>
     * 완료효과 : 1=위스크롤, 2=다운스크롤, 3=위아래, 4=중심으로, 5=바로, 6=반전, 7=좌스크롤, 8=효과없음<br/>
     * 완료속도 : 1(빠름)~8(느림) ex) 0x04<br/>
     * 00:00 : 예약<br/>
     * 18:01:0C:09:00:00:18:01:0C:12:00:00 : 24 년 1월 12일 09시 00분 00초 ~ 24 년 1월 12일 18시 00분 00초<br/>
     * 00 : 릴레이출력여부 (00: off, 0f: on)<br/>
     * @param url
     * getBytes("ksc5601") 로 변환
     */
    public static void addPeacetimeImageScenario(ElectronicDisplay ed, byte[] sc, byte[] url) throws UnknownHostException {
        ed.length = sc.length + url.length + 7;
        commandInit(ed);
        ed.commandData[2] = 0x22; // 평시, 이미지로 시나리오 추가 명령
        setCommandLength(ed);
        System.arraycopy(sc, 0, ed.commandData, 5, sc.length);
        System.arraycopy(url, 0, ed.commandData, 5 + sc.length, url.length);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        sendCommand(ed);

        log.info("addPeacetimeImageScenario create");
    }

    /**
     * 평시, 이미지다운로드 Ack명령
     * @param ed
     */
    public static void downloadPeacetimeImage(ElectronicDisplay ed) throws UnknownHostException {
        ed.length = 7;
        commandInit(ed);
        ed.commandData[2] = 0x23; // 평시, 이미지다운로드 Ack명령
        setCommandLength(ed);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        sendCommand(ed);

        log.info("downloadPeacetimeImage create");
    }

    /**
     * 긴급, 문구 추가 명령
     * @param ed
     * @param length
     */
    public static void addEmergencyPhrases(ElectronicDisplay ed, int length) {
        ed.length = length + 7;
        commandInit(ed);
        ed.commandData[2] = 0x31; // 긴급, 문구 추가 명령
        setCommandLength(ed);
        System.arraycopy(ed.body, 0, ed.commandData, 5, length);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        log.info("addEmergencyPhrases create");
    }

    /**
     * 긴급, 이미지로 시나리오 추가 명령
     * @param ed
     * @param sc
     * 01:01:04:05:05:04 : 방번호(1~100)<br/>
     * 표시효과 : 1=바로표시, 2=좌스크롤, 3=위스크롤, 4=다운스크롤, 5=레이저효과, 6=상하로, 7=중심으로, 8=1단으로 좌스크롤<br/>
     * 표시속도 : 1(빠름)~8(느림) ex) 0x04<br/>
     * 표시 후 대기시간 : x초<br/>
     * 완료효과 : 1=위스크롤, 2=다운스크롤, 3=위아래, 4=중심으로, 5=바로, 6=반전, 7=좌스크롤, 8=효과없음<br/>
     * 완료속도 : 1(빠름)~8(느림) ex) 0x04<br/>
     * 00:00 : 예약<br/>
     * 18:01:0C:09:00:00:18:01:0C:12:00:00 : 24 년 1월 12일 09시 00분 00초 ~ 24 년 1월 12일 18시 00분 00초<br/>
     * 00 : 릴레이출력여부 (00: off, 0f: on)<br/>
     * @param url
     * getBytes("ksc5601") 로 변환
     */
    public static void addEmergencyImageScenario(ElectronicDisplay ed, byte[] sc, byte[] url) throws UnknownHostException {
        ed.length = sc.length + url.length + 7;
        commandInit(ed);
        ed.commandData[2] = 0x32; // 긴급, 이미지로 시나리오 추가 명령
        setCommandLength(ed);
        System.arraycopy(sc, 0, ed.commandData, 5, sc.length);
        System.arraycopy(url, 0, ed.commandData, 5 + sc.length, url.length);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        sendCommand(ed);

        log.info("addEmergencyImageScenario create");
    }

    /**
     * 긴급, 이미지다운로드 Ack명령
     * @param ed
     */
    public static void downloadEmergencyImage(ElectronicDisplay ed) throws UnknownHostException {
        ed.length = 7;
        commandInit(ed);
        ed.commandData[2] = 0x33; // 긴급, 이미지다운로드 Ack명령
        setCommandLength(ed);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);

        sendCommand(ed);

        log.info("downloadEmergencyImage create");
    }

    public static void main(String[] args) throws UnsupportedEncodingException, UnknownHostException {
//        ElectronicDisplay ed = new ElectronicDisplay();
//
//        deleteAllPeacetimePhrases(ed);
//
//        byte[] url = "http://platform.kyungwoo.com:8080/common/dp/2024251622713436.png".getBytes("ksc5601"); // 구동 서버 이미지 경로
////        // : 기준으로 hex 값을 byte 값으로 변환
//        byte[] sc = HexFormat.ofDelimiter(":").parseHex("01:01:04:05:05:04:" + // 방번호, 표시효과, 표시속도, 표시 후 대기시간, 완료효과, 완료속도
//                "00:00:" + // 예약
//                "18:01:01:00:00:63:0C:1F:17:3B" + // 24 년 1월 1일 00시 00분 ~ 99 년 12월 31일 23시 59분
//                ":00"); // 릴레이출력여부
//        addPeacetimeImageScenario(ed, sc, url);
//        url = "http://platform.kyungwoo.com:8080/common/dp/202425162272264.png".getBytes("ksc5601"); // 구동 서버 이미지 경로
////        // : 기준으로 hex 값을 byte 값으로 변환
//        sc = HexFormat.ofDelimiter(":").parseHex("02:01:04:05:05:04:" + // 방번호, 표시효과, 표시속도, 표시 후 대기시간, 완료효과, 완료속도
//                "00:00:" + // 예약
//                "18:01:01:00:00:63:0C:1F:17:3B" + // 24 년 1월 1일 00시 00분 ~ 99 년 12월 31일 23시 59분
//                ":00"); // 릴레이출력여부
//        addPeacetimeImageScenario(ed, sc, url);
//        url = "http://platform.kyungwoo.com:8080/common/dp/2024251623221662.png".getBytes("ksc5601"); // 구동 서버 이미지 경로
////        // : 기준으로 hex 값을 byte 값으로 변환
//        sc = HexFormat.ofDelimiter(":").parseHex("03:01:04:05:05:04:" + // 방번호, 표시효과, 표시속도, 표시 후 대기시간, 완료효과, 완료속도
//                "00:00:" + // 예약
//                "18:01:01:00:00:63:0C:1F:17:3B" + // 24 년 1월 1일 00시 00분 ~ 99 년 12월 31일 23시 59분
//                ":00"); // 릴레이출력여부
//        addPeacetimeImageScenario(ed, sc, url);
//
//        downloadPeacetimeImage(ed);
//        displayModeSetting(ed, NOR);
    }

//        String string = "http://125.60.28.107/imgData.do?ym=202001&save_file_name=3b55094d-f4c5-4a58-ae7a-be7df7769728.png_thumb.bmp\0";
//        byte[] bytes = string.getBytes("ksc5601");
//        log.info(toHex(bytes, bytes.length));
    // 위 HEX 출력 값 => 가이드에 경로를 변경하여 문서의 HEX 값과 비교
//        68 74 74 70 3A 2F 2F 31 32 35 2E 36 30 2E 32 38 2E 31 30 37 2F 69 6D 67 44 61 74 61 2E 64 6F 3F 79 6D 3D 32
//        30 32 30 30 31 26 73 61 76 65 5F 66 69 6C 65 5F 6E 61 6D 65 3D 33 62 35 35 30 39 34 64 2D 66 34 63 35 2D 34
//        61 35 38 2D 61 65 37 61 2D 62 65 37 64 66 37 37 36 39 37 32 38 2E 70 6E 67 5F 74 68 75 6D 62 2E 62 6D 70 00

//    String string = "http://platform.kyungwoo.com:8080/images/logo.bmp\0"; // 구동 서버 이미지 경로
//    byte[] bytes = string.getBytes("ksc5601");
//    // : 기준으로 hex 값을 byte 값으로 변환
//    byte[] times = HexFormat.ofDelimiter(":").parseHex("01:03:04:05:05:04:00:00:" + // 방번호, 표시효과, 예약 등
//            "18:01:08:0e:00:00:18:01:08:0f:00:00" + // 24 년 1월 8일 14시 00분 00초 ~ 24 년 1월 8일 15시 00분 00초
//            ":00"); // 릴레이출력여부
//
//    ed.length = times.length + bytes.length + 7;
//    ed.commandData[0] = STX;                                        // 시작 - 고정
//    ed.commandData[1] = INC;                                        // 내부 카운트 - 고정
//    ed.commandData[2] = 0x22;                                       // 평시, 이미지 시나리오 추가 명령
//    ed.commandData[3] = (byte) ((ed.length & 0xFF00) >> 8);         // 길이의 상위 바이트
//    ed.commandData[4] = (byte) (ed.length & 0x00FF);                // 길이의 하위 바이트
//        System.arraycopy(times, 0, ed.commandData, 5, times.length);                // times 값을 commendData 에 복사
//        System.arraycopy(bytes, 0, ed.commandData, 5 + times.length, bytes.length); // bytes 값을 commendData 에 복사
//    ed.commandData[ed.length - 2] = ETX;                            // 종료 - 고정
//    checkCRC(ed);                                                   // CRC 체크 로직
//    sendCommand(ed);                                                // 명령 전송


//    String string = "ABCDEFGHIJKL\0"; // 문자열 만들기
//    byte[] bytes = string.getBytes("ksc5601");
//    ed.length = bytes.length + 7;
//    ed.commandData[0] = STX;                                        // 시작 - 고정
//    ed.commandData[1] = INC;                                        // 내부 카운트 - 고정
//    ed.commandData[2] = 0x31;                                       // 긴급, 문구 추가 명령
//    ed.commandData[3] = (byte) ((ed.length & 0xFF00) >> 8);         // 길이의 상위 바이트
//    ed.commandData[4] = (byte) (ed.length & 0x00FF);                // 길이의 하위 바이트
//        System.arraycopy(bytes, 0, ed.commandData, 5, bytes.length); // bytes 값을 commendData 에 복사
//    ed.commandData[ed.length - 2] = ETX;                            // 종료 - 고정
//    checkCRC(ed);                                                   // CRC 체크 로직
//    sendCommand(ed);                                                // 명령 전송


//    ed.length = 7;                                                  // 커맨드 길이 설정
//    ed.commandData[0] = STX;                                        // 시작 - 고정
//    ed.commandData[1] = INC;                                        // 내부 카운트 - 고정
//    ed.commandData[2] = 0x32;                                       // 긴급, 이미지다운로드 ACK 명령 코드
//    ed.commandData[3] = (byte) ((ed.length & 0xFF00) >> 8);         // 길이의 상위 바이트
//    ed.commandData[4] = (byte) (ed.length & 0x00FF);                // 길이의 하위 바이트
//    ed.commandData[ed.length - 2] = ETX;                            // 종료 - 고정
//    checkCRC(ed);                                                   // CRC 체크 로직
//    sendCommand(ed);                                                // 명령 전송
}
