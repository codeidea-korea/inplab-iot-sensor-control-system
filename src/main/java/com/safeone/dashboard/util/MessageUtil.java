package com.safeone.dashboard.util;

import lombok.RequiredArgsConstructor;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.Locale;

@RequiredArgsConstructor
@Component
//@AllArgsConstructor
public class MessageUtil {
    private static MessageSource ms;

    private final MessageSource messageSource;

    @PostConstruct
    private void init() {
        ms = messageSource;
    }

    public static String getMessage(String code) {
        return ms.getMessage(code, null, Locale.getDefault());
    }

    public static String getMessage(String code, String... args) {
        return ms.getMessage(code, args, Locale.getDefault());
    }
    public static String getMessageDefault(String code, String defaultMsg, Object... args) {
        return ms.getMessage(code, args, defaultMsg, Locale.getDefault());
    }
    public static String getMessageDefault(String code, String defaultMsg) {
        return ms.getMessage(code, null, defaultMsg, Locale.getDefault());
    }
}
