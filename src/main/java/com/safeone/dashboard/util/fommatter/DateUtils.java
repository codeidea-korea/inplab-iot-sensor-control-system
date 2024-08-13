package com.safeone.dashboard.util.fommatter;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtils {
    public static final String PATTERN_1 = "yyyy_MM_dd_HH_mm_ss";
    public static final String PATTERN_2 = "yyyy-MM-dd-HH-mm-ss";
    public static final String PATTERN_3 = "mm/dd/yyyy";

    /**
     * @param src         : 8/10/2019 to 9/17/2019 or 2019/8/10 to 2019/9/17
     * @param rangex      : split pattern
     * @param fromPattern : mm/dd/yyyy or yyyy/mm/dd/ or etc..
     * @param toPattern   yyyy/mm/dd or mm/dd/yyyy or etc
     * @param type        S : start , E: end
     * @return
     * @throws ParseException
     */
    public static String parseRangeDateToString(String src, String rangex, String fromPattern, String toPattern, char type) {
        String result = null;
        String[] splitData = src.split(rangex);
        SimpleDateFormat fromFormat = new SimpleDateFormat(fromPattern);
        SimpleDateFormat toFormat = new SimpleDateFormat(toPattern);

        try {
            Date fromDate = (type == 'S') ? fromFormat.parse(splitData[0]) : fromFormat.parse(splitData[1]);

            if (fromDate != null) {
                result = toFormat.format(fromDate);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return result;
    }

    public static String toCurrentDate(String patterns) {
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat format = new SimpleDateFormat(patterns);
        return format.format(calendar.getTime());
    }

    public static String toUnixTimeStamp(String src, String rangex, String fromPattern, char type) {
        String result = null;
        SimpleDateFormat fromFormat = new SimpleDateFormat(PATTERN_3);
        String[] splitData = src.split(rangex);
        SimpleDateFormat toFormat = new SimpleDateFormat(PATTERN_2);
        try {
            Date fromDate = (type == 'S') ? fromFormat.parse(splitData[0]) : fromFormat.parse(splitData[1]);

            if (fromDate != null) {
                String tof = toFormat.format(fromDate);
                Date dt = toFormat.parse(tof);
                long epoch = dt.getTime();
                result = String.valueOf((epoch/1000));
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return result;
    }

}
