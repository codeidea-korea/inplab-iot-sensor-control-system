package com.safeone.dashboard.util;

import java.security.Key;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * Created by trueg on 2018-07-24.
 */

public class CryptoUtil {
    /** 암호화 키 16자리 */
    public static String key = "xorhkwkddhdlajrj";
    public static String iv = "xorhkwkddhdlajrj";
    
    public static void main(String[] args) throws Exception {
		System.out.println(encrypt("010-1234-5678"));
		
		System.out.println(decrypt("662CAFE9C8C2EA6B915BB11D9C14FAB5"));
	}

    public static byte[] hexStringToByteArray(String s) {
	    int len = s.length();
	    byte[] data = new byte[len / 2];
	    for (int i = 0; i < len; i += 2) {
	        data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
	                             + Character.digit(s.charAt(i+1), 16));
	    }
	    return data;
	}
	
	public static String byteArrayToHexString(byte[] bytes){ 
		
		StringBuilder sb = new StringBuilder(); 
		
		for(byte b : bytes){ 
			
			sb.append(String.format("%02X", b&0xff)); 
		} 
		
		return sb.toString(); 
	} 
      
    public static Key getAESKey() throws Exception {
        String iv;
        Key keySpec;

        iv = key.substring(0, 16);
        byte[] keyBytes = new byte[16];
        byte[] b = key.getBytes("UTF-8");

        int len = b.length;
        if (len > keyBytes.length) {
           len = keyBytes.length;
        }

        System.arraycopy(b, 0, keyBytes, 0, len);
        keySpec = new SecretKeySpec(keyBytes, "AES");

        return keySpec;
    }

    // 암호화
    public static String encrypt(String str) throws Exception {
        Key keySpec = getAESKey();
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes("UTF-8")));
        byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
        String enStr = new String(encrypted, "UTF-8");
//        String enStr = new String(Base64.encodeBase64(encrypted));

        return byteArrayToHexString(encrypted);
    }

    // 복호화
    public static String decrypt(String enStr) throws Exception {
//    	byte[] bytes = hexStringToByteArray(enStr);
//    	enStr = new String(bytes);
        Key keySpec = getAESKey();
        Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
        c.init(Cipher.DECRYPT_MODE, keySpec, new IvParameterSpec(iv.getBytes("UTF-8")));
        byte[] byteStr = hexStringToByteArray(enStr);
//        byte[] byteStr = Base64.decodeBase64(enStr.getBytes("UTF-8"));
        String decStr = new String(c.doFinal(byteStr), "UTF-8");

        return decStr;
    }
}
