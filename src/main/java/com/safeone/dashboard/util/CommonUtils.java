package com.safeone.dashboard.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Component;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

@Component
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CommonUtils {

    public static int getMonth(int date) {
        return Integer.parseInt(String.valueOf(date).substring(4, 6));
    }

    public static int getMonth(String date) {
        return Integer.parseInt(date.substring(4, 6));
    }

    public static String encrypt(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean isMatch(String password, String hashed) {
        return BCrypt.checkpw(password, hashed);
    }

    public static byte[] parseHex(String hexString, String delimiter) {
        String[] hexParts = hexString.split(delimiter);
        byte[] data = new byte[hexParts.length];

        for (int i = 0; i < hexParts.length; i++) {
            int hex = Integer.parseInt(hexParts[i], 16);
            data[i] = (byte) hex;
        }

        return data;
    }

    public static Map<String, Object> dtoToMap(Object dto) {
        Map<String, Object> map = new HashMap<>();
        Field[] fields = dto.getClass().getDeclaredFields();

        for (Field field : fields) {
            field.setAccessible(true);
            try {
                map.put(field.getName(), field.get(dto));
            } catch (IllegalAccessException e) {
                e.getStackTrace();
            }
        }

        Class<?> superclass = dto.getClass().getSuperclass();
        if (superclass != null) {
            Field[] inheritedFields = superclass.getDeclaredFields();
            for (Field field : inheritedFields) {
                field.setAccessible(true);
                try {
                    map.put(field.getName(), field.get(dto));
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
            }
        }
        return map;
    }

    public static void setCountInfo(String type, Integer count, ObjectNode on) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode countNode = om.createObjectNode();

        if (on.has("count")) {
            countNode = om.valueToTree(on.get("count"));
            countNode.put(type, count);
            on.putPOJO("count", countNode);
        } else {
            countNode.put(type, count);
            on.putPOJO("count", countNode);
        }
    }

    public static String isNull(Object o) {
        if (o == null) {
            return "";
        } else {
            return o.toString().trim();
        }
    }
}
