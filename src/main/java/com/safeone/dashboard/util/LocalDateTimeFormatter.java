package com.safeone.dashboard.util;

import org.springframework.format.Formatter;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class LocalDateTimeFormatter implements Formatter<LocalDateTime> {

    @Override
    public String print(LocalDateTime date, Locale locale) {
        return date.format(formatter);
    }

    @Override
    public LocalDateTime parse(String text, Locale locale) {
        return LocalDateTime.parse(text, formatter);
    }

    private static final String PATTERN = "yyyy-MM-dd HH:mm";
    private static DateTimeFormatter formatter = DateTimeFormatter.ofPattern(PATTERN);

}
