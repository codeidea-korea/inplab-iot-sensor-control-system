package com.safeone.dashboard.util;

import lombok.extern.slf4j.Slf4j;

import java.io.InputStream;
import java.io.OutputStream;
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
public class DisplayUtils {
    private static String serverAddress = "192.168.10.141";
    private static int serverPort = 8090;
    private static final byte STX = 0x02;
    private static final byte INC = (byte) 0xC0;
    private static final byte ETX = 0x03;
    public final static byte NOR = 0x00;
    public final static byte EMG = 0x01;

    public DisplayUtils(String serverAddress, int serverPort) {
        DisplayUtils.serverAddress = serverAddress;
        DisplayUtils.serverPort = serverPort;
    }

    public static void sendCommand(ElectronicDisplay ed) throws UnknownHostException {
        try (Socket socket = new Socket(serverAddress, serverPort);
             OutputStream out = socket.getOutputStream();
             InputStream in = socket.getInputStream()) {

            log.info("TCP Socket connected - " + serverAddress + ":" + serverPort);
            out.write(ed.commandData, 0, ed.length);
            log.info("request - " + toHex(ed.commandData, ed.length));
            out.flush();

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
        int length;
        byte[] body = new byte[512];
        byte[] commandData = new byte[519];
        public ElectronicDisplay() {
            Arrays.fill(body, (byte) 0);
            Arrays.fill(commandData, (byte) 0);
        }
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

    private static void setCommandLength(ElectronicDisplay ed) {
        ed.commandData[3] = (byte) ((ed.length & 0xFF00) >> 8);
        ed.commandData[4] = (byte) (ed.length & 0x00FF);
    }

    public static void displayModeSetting(ElectronicDisplay ed, byte mode) throws UnknownHostException {
        ed.length = 8;
        commandInit(ed);
        ed.commandData[2] = 0x09;
        ed.body[0] = mode;
        setCommandLength(ed);
        System.arraycopy(ed.body, 0, ed.commandData, 5, ed.body.length);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);
        sendCommand(ed);
        log.info("displayModeSetting create");
    }

    public static void deleteAllPeacetimePhrases(ElectronicDisplay ed) throws UnknownHostException {
        ed.length = 7;
        commandInit(ed);
        ed.commandData[2] = 0x19;
        setCommandLength(ed);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);
        sendCommand(ed);
        log.info("deleteAllPeacetimePhrases create");
    }

    public static void deleteAllEmergencyPhrases(ElectronicDisplay ed) throws UnknownHostException {
        ed.length = 7;
        commandInit(ed);
        ed.commandData[2] = 0x1A;
        setCommandLength(ed);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);
        sendCommand(ed);
        log.info("deleteAllEmergencyPhrases create");
    }

    public static void addPeacetimeImageScenario(ElectronicDisplay ed, byte[] sc, byte[] url) throws UnknownHostException {
        ed.length = sc.length + url.length + 7;
        commandInit(ed);
        ed.commandData[2] = 0x22;
        setCommandLength(ed);
        System.arraycopy(sc, 0, ed.commandData, 5, sc.length);
        System.arraycopy(url, 0, ed.commandData, 5 + sc.length, url.length);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);
        sendCommand(ed);
        log.info("addPeacetimeImageScenario create");
    }

    public static void downloadPeacetimeImage(ElectronicDisplay ed) throws UnknownHostException {
        ed.length = 7;
        commandInit(ed);
        ed.commandData[2] = 0x23;
        setCommandLength(ed);
        ed.commandData[ed.length - 2] = ETX;
        checkCRC(ed);
        sendCommand(ed);
        log.info("downloadPeacetimeImage create");
    }

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
}
