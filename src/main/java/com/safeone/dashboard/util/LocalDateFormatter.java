package com.safeone.dashboard.util;

import org.springframework.format.Formatter;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class LocalDateFormatter implements Formatter<LocalDate> {

    @Override
    public String print(LocalDate date, Locale locale) {
        return date.format(formatter);
    }

    @Override
    public LocalDate parse(String text, Locale locale) {
        return LocalDate.parse(text, formatter);
    }

    private static final String PATTERN = "yyyy-MM-dd";
    private static DateTimeFormatter formatter = DateTimeFormatter.ofPattern(PATTERN);

}
