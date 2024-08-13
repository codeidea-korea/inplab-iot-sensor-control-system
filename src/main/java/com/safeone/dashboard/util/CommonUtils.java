package com.safeone.dashboard.util;

import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class CommonUtils {

    /**
     * 생성자 (생성금지)
     */
    private CommonUtils() {
    }
    
    public static RestTemplate getRestTemplate() {
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        factory.setConnectTimeout(3*1000);
        factory.setReadTimeout(3*1000);
        RestTemplate restTemplate = new RestTemplate(factory);
        return restTemplate;
    }

    public static int getYear(int date){

        return Integer.parseInt(String.valueOf(date).substring(0,4));
    }

    public static int getYear(String date){

        return Integer.parseInt(date.substring(0,4));
    }

    public static int getMonth(int date){

        return Integer.parseInt(String.valueOf(date).substring(4,6));
    }

    public static int getMonth(String date){

        return Integer.parseInt(date.substring(4,6));
    }

    public static int getDay(int date){

        return Integer.parseInt(String.valueOf(date).substring(6,8));
    }

    public static int getDay(String date){

        return Integer.parseInt(date.substring(6,8));
    }

    public static int getHour(int time){
        return Integer.parseInt(String.valueOf(time).substring(0,2));
    }

    public static int getHour(String time){
        return Integer.parseInt(time.substring(0,2));
    }

    public static int getMinute(int time){
        return Integer.parseInt(String.valueOf(time).substring(2,4));
    }

    public static int getMinute(String time){
        return Integer.parseInt(time.substring(2,4));
    }

    public static int getSecond(int time){
        return Integer.parseInt(String.valueOf(time).substring(2,4));
    }

    public static int getSecond(String time){
        return Integer.parseInt(time.substring(2,4));
    }

    public static boolean hasRole(String role) {

        SecurityContext context = SecurityContextHolder.getContext();
        if (context == null)
            return false;

        Authentication authentication = context.getAuthentication();
        if (authentication == null)
            return false;

        for (GrantedAuthority auth : authentication.getAuthorities()) {
            if (role.equals(auth.getAuthority()))
                return true;
        }

        return false;
    }

    public static String encrypt(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean isMatch(String password, String hashed){
        return BCrypt.checkpw(password, hashed);
    }

    public static byte[] parseHex(String hexString, String delimiter) {
        // 구분자 ":"를 제거합니다.
        String[] hexParts = hexString.split(delimiter);
        byte[] data = new byte[hexParts.length];

        for (int i = 0; i < hexParts.length; i++) {
            // 16진수 문자열을 정수로 변환한 다음, byte로 캐스팅합니다.
            int hex = Integer.parseInt(hexParts[i], 16);
            data[i] = (byte) hex;
        }

        return data;
    }

}
