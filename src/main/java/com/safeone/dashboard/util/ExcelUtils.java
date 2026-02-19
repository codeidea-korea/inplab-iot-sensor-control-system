package com.safeone.dashboard.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.util.*;
import java.util.Arrays;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.safeone.dashboard.config.annotate.FieldLabel;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import lombok.NoArgsConstructor;

@NoArgsConstructor
public class ExcelUtils {
    public static void downloadExcel(HttpServletRequest request, HttpServletResponse response, List<?> list, Map<String, FieldDetails> columnData, String fileName) {
        List<String> fieldList = new ArrayList<>();
        List<String> headerList = new ArrayList<>();
        for (Map.Entry<String, FieldDetails> entry : columnData.entrySet()) {
            String[] excArray = {"hidden", "password"};
            String type = entry.getValue().type;
            String lowerType = NVL(type).toString().toLowerCase();

            boolean excluded = false;
            String[] typeTokens = lowerType.split(";");
            for (String token : typeTokens) {
                if (Arrays.asList(excArray).contains(token.trim())) {
                    excluded = true;
                    break;
                }
            }
            if (excluded) {
                continue;
            }

            fieldList.add(entry.getKey());
            headerList.add(entry.getValue().title);
        }
        String[] fieldset = fieldList.toArray(new String[0]);
        String[] headerset = headerList.toArray(new String[0]);
        downloadExcel(request, response, list, fieldset, headerset, fileName);
    }

    public static void downloadExcel(HttpServletRequest request, HttpServletResponse response, List<?> list, String[] fieldset, String[] headerset, String fileName) {
        SXSSFWorkbook wb = new SXSSFWorkbook(100);
        String userAgent = request.getHeader("User-Agent");
        try {
            response.setHeader("Set-Cookie", "fileDownload=true; path=/");
            if (userAgent != null && userAgent.contains("MSIE 5.5")) {
                response.setHeader("Content-Disposition", "filename=" + URLEncoder.encode(fileName, "UTF-8") + ";");
            } else if (userAgent != null && userAgent.contains("MSIE")) {
                response.setHeader("Content-Disposition", "attachment; filename=" + java.net.URLEncoder.encode(fileName, "UTF-8") + ";");
            } else {
                response.setHeader("Content-Disposition", "attachment; filename=" + new String(fileName.getBytes("euc-kr"), "latin1") + ";");
            }

            response.setHeader("Pragma", "no-cache;");
            response.setHeader("Expires", "-1;");

            File file = write(fileName, list, fieldset, headerset);

            response.setHeader("Content-Transfer-Encoding", "binary;");
            response.setHeader("Content-Length", "" + file.length());

            FileInputStream fileIn = new FileInputStream(file);
            ServletOutputStream out = response.getOutputStream();

            byte[] outputByte = new byte[(int) file.length()];

            while (fileIn.read(outputByte, 0, (int) file.length()) != -1) {
                out.write(outputByte, 0, (int) file.length());
            }

        } catch (Exception e) {
            response.setHeader("Set-Cookie", "fileDownload=false; path=/");
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Content-Type", "text/html; charset=utf-8");

            OutputStream out = null;

            try {
                out = response.getOutputStream();
                byte[] data = "fail..".getBytes();
                out.write(data, 0, data.length);
            } catch (Exception ignore) {
                ignore.printStackTrace();
            } finally {
                if (out != null) try {
                    out.close();
                } catch (Exception ignore) {
                }
            }
        } finally {
            wb.dispose();
            try {
                wb.close();
            } catch (Exception ignore) {
            }
        }
    }

    public static List<Map<Object, Object>> convertListToMap(List<Object> list) {
        List<Map<Object, Object>> result = new ArrayList<>();
        ObjectMapper mapper = new ObjectMapper();

        for (Object obj : list) {
            Map map = mapper.convertValue(obj, Map.class);
            result.add(map);
        }

        return result;
    }

    public static Map<String, FieldDetails> getPojoFieldNamesAndLabels(Class<?> clazz) {
        Map<String, FieldDetails> fieldDetailsMap = new LinkedHashMap<>();

        for (Field field : clazz.getDeclaredFields()) {
            FieldDetails details = new FieldDetails();
            details.columnName = field.getName();

            if (field.isAnnotationPresent(FieldLabel.class)) {
                FieldLabel annotation = field.getAnnotation(FieldLabel.class);
                details.title = annotation.title();
                details.type = annotation.type();
                details.width = annotation.width();
            } else {
                details.title = field.getName();
            }
            fieldDetailsMap.put(field.getName(), details);
        }
        return fieldDetailsMap;
    }

    public static class FieldDetails {
        public String title;
        public String type;
        public String columnName;
        public int width;
    }

    public static File write(String sFileName, List<?> _list, String[] fieldset, String[] headerset) throws Exception {
        if (_list == null) return null;

        WritableWorkbook workbook;
        WritableSheet sheet = null;
        int iSheetNum = 0;

        File excelFile;
        excelFile = new File(sFileName);
        workbook = Workbook.createWorkbook(excelFile);

        WritableCellFormat headerCellFormat = new WritableCellFormat(new WritableFont(WritableFont.ARIAL, 11, WritableFont.BOLD));
        headerCellFormat.setBorder(Border.ALL, BorderLineStyle.NONE);
        headerCellFormat.setAlignment(Alignment.CENTRE);
        headerCellFormat.setVerticalAlignment(VerticalAlignment.CENTRE);

        WritableCellFormat defaultCellFormat = new WritableCellFormat();
        defaultCellFormat.setWrap(true);
        defaultCellFormat.setBorder(Border.ALL, BorderLineStyle.NONE);
        defaultCellFormat.setVerticalAlignment(VerticalAlignment.CENTRE);

        boolean bGroupHeader = false;
        for (int cols = 0; cols < fieldset.length; cols++) {
            if (headerset[cols] != null && headerset[cols].contains("`")) {
                bGroupHeader = true;
                break;
            }
        }

        // 열 너비 자동 조정을 위한 배열
        int[] columnWidths = new int[fieldset.length];

        for (int row = 0; row < _list.size(); row++) {
            if (row % 65535 == 0) {
                workbook.createSheet("Sheet" + iSheetNum, iSheetNum);
                sheet = workbook.getSheet(iSheetNum);
                iSheetNum++;

                // Adding headers
                for (int cols = 0; cols < fieldset.length; cols++) {
                    if (headerset[cols] == null) {
                        continue;
                    }

                    if (headerset[cols].contains("`")) {
                        Label label = new Label(cols, 0, headerset[cols].split("`")[0], headerCellFormat);
                        sheet.addCell(label);
                        label = new Label(cols, 1, headerset[cols].split("`")[1], headerCellFormat);
                        sheet.addCell(label);
                    } else {
                        Label label = new Label(cols, 0, headerset[cols], headerCellFormat);
                        sheet.addCell(label);

                        if (bGroupHeader)
                            sheet.mergeCells(cols, 0, cols, 1);
                    }

                    // 열 너비 초기화
                    columnWidths[cols] = getLen(headerset[cols]);
                }

                int mergeStart = -1;

                String mergeLabel = "";

                for (int cols = 0; cols < headerset.length; cols++) {
                    if (headerset[cols] == null) {
                        continue;
                    }

                    if (headerset[cols].contains("`")) {
                        if (mergeStart == -1) {
                            mergeStart = cols;
                            mergeLabel = headerset[cols].split("`")[0];
                        } else {
                            if (!headerset[cols].split("`")[0].equals(mergeLabel)) {
                                sheet.mergeCells(mergeStart, 0, cols - 1, 0);
                                mergeStart = cols;
                                mergeLabel = headerset[cols].split("`")[0];
                            }
                        }
                    } else {
                        if (mergeStart != -1) {
                            sheet.mergeCells(mergeStart, 0, cols - 1, 0);
                            mergeStart = -1;
                            mergeLabel = "";
                        }
                    }
                }

                if (mergeStart != -1) {
                    sheet.mergeCells(mergeStart, 0, headerset.length - 1, 0);
                }

                if (bGroupHeader)
                    row++;
            }

            // Writing data to cells
            try {
                HashMap<?, ?> data;
                if (_list.get(0) instanceof Map)
                    data = (HashMap<?, ?>) _list.get(row);
                else
                    data = (HashMap<?, ?>) BeanUtils.describe(_list.get(row));

                for (int cols = 0; cols < fieldset.length; cols++) {
                    String cellValue = NVL(data.get(fieldset[cols])).toString();
                    Label label = new Label(cols, (row % 65535) + 1, cellValue, defaultCellFormat);
                    sheet.addCell(label);

                    // 열 너비를 자동으로 설정하기 위해 최대 길이를 계산
                    columnWidths[cols] = Math.max(columnWidths[cols], getLen(cellValue));
                }
            } catch (Exception e) {

                System.out.println(e.getMessage());
                e.printStackTrace();
            }
        }

        // 열 너비 설정
        for (int i = 0; i < columnWidths.length; i++) {
            sheet.setColumnView(i, columnWidths[i] + 5);  // +5는 여유를 두기 위한 부분
        }

        workbook.write();
        workbook.close();
        return excelFile;
    }



    public static File write(String sFileName, List _List) throws Exception {
        if (_List == null) return null;
        WritableWorkbook workbook;
        WritableSheet sheet = null;

        int iSheetNum = 0;

        File excelFile;
        excelFile = new File(sFileName);
        workbook = Workbook.createWorkbook(excelFile);

        WritableCellFormat cellFormat = new WritableCellFormat();
        cellFormat.setBorder(Border.ALL, BorderLineStyle.NONE);

        for (int row = 0; row < _List.size(); row++) {
            if (row % 65530 == 0) {
                workbook.createSheet("Sheet" + iSheetNum, iSheetNum);
                sheet = workbook.getSheet(iSheetNum);
                iSheetNum++;

                Map<?, ?> mCols = (Map<?, ?>) _List.get(row);
                Iterator<?> ir = mCols.keySet().iterator();
                int iCol = 0;

                while (ir.hasNext()) {
                    String keys = ir.next().toString();

                    if (!NVL(keys).toString().equalsIgnoreCase("hidden")) {
                        String sColumnName = NVL(keys).toString();
                        sColumnName = sColumnName.toUpperCase().replace("SUM(", "");
                        sColumnName = sColumnName.replace(")", "");

                        Label label = new Label(iCol, 0, sColumnName, cellFormat);
                        sheet.addCell(label);
                        iCol++;
                    }

                }
            }
            Map<?, ?> mCols = (Map<?, ?>) _List.get(row);
            Iterator<?> ir = mCols.keySet().iterator();
            int iCol = 0;

            while (ir.hasNext()) {
                String keys = ir.next().toString();

                if (!keys.equalsIgnoreCase("hidden")) {
                    Label label = new Label(iCol, row + 1, NVL(mCols.get(keys)).toString(), cellFormat);
                    sheet.addCell(label);
                    iCol++;
                }
            }
        }
        workbook.write();
        workbook.close();
        return excelFile;
    }

    protected static Object NVL(Object object) {
        if (object == null) return "";
        return object;
    }

    public static int getLen(String str) {
        int len = 0;
        if (str == null) return 0;
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            if (c > 127) {
                len += 2;
            } else {
                len += 1;
            }
        }
        return len;
    }
}
