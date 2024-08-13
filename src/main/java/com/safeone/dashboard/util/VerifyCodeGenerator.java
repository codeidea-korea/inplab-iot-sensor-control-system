package com.safeone.dashboard.util;

import org.springframework.stereotype.Component;

import java.util.Random;

@Component
public class VerifyCodeGenerator {

    public static final String PWD_CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()";
    public static final String AUTH_CHARS = "0123456789";
    public static final int PWD_CHARS_LEN = PWD_CHARS.length();
    public static final int AUTH_CHARS_LEN = AUTH_CHARS.length();
    public static final Random rand = new Random();

    public static String getAuthVerifyCode(){
        StringBuilder sb = new StringBuilder();
        for(int i=0; i<6; i++) {
            char c = AUTH_CHARS.charAt(rand.nextInt(AUTH_CHARS_LEN));
            sb.append(c);
        }

        return sb.toString();
    }

    public static String getGenPassword(){
        StringBuilder sb = new StringBuilder();
        for(int i=0; i<6; i++) {
            char c = PWD_CHARS.charAt(rand.nextInt(PWD_CHARS_LEN));
            sb.append(c);
        }

        return sb.toString();
    }


}
