package com.safeone.dashboard.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Arrays;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.ss.usermodel.Sheet;
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
public class ExcelUtil {
	public static void downloadExcel(HttpServletRequest request, HttpServletResponse response, List list, Map<String, FieldDetails> columnData, String fileName) {
		String[] fieldset = new String[columnData.size()];
		String[] headerset = new String[columnData.size()];

		int index = 0;
		for(Map.Entry<String, FieldDetails> entry : columnData.entrySet()) {

			//20231228 hidden, pw field 제외
			String[] excArray = {"hidden", "password"};
			String type = entry.getValue().type;
			String lowerType = NVL(type).toString().toLowerCase();

			if(!Arrays.asList(excArray).contains(lowerType)) { //20231228 hidden, pw field 제외

				fieldset[index] = entry.getKey();
				headerset[index] = ((FieldDetails) entry.getValue()).title;
				index++;
			}
		}

		downloadExcel(request, response, list, fieldset, headerset, fileName);
	}

	public static void downloadExcel(HttpServletRequest request, HttpServletResponse response, List list, String[] fieldset, String[] headerset, String fileName) {
		// 메모리에 100개의 행을 유지합니다. 행의 수가 넘으면 디스크에 적습니다.
		SXSSFWorkbook wb = new SXSSFWorkbook(100);
		Sheet sheet = wb.createSheet();
		String userAgent = request.getHeader("User-Agent");
		try {
			response.setHeader("Set-Cookie", "fileDownload=true; path=/");

			if (userAgent != null && userAgent.indexOf("MSIE 5.5") > -1) { // MS IE 5.5 이하
				response.setHeader("Content-Disposition", "filename=" + URLEncoder.encode(fileName, "UTF-8") + ";");
			} else if (userAgent != null && userAgent.indexOf("MSIE") > -1) { // MS IE (보통은 6.x 이상 가정)
				response.setHeader("Content-Disposition", "attachment; filename=" + java.net.URLEncoder.encode(fileName, "UTF-8") + ";");
			} else { // 모질라나 오페라
				response.setHeader("Content-Disposition", "attachment; filename=" + new String(fileName.getBytes("euc-kr"), "latin1") + ";");
			}

			response.setHeader("Pragma", "no-cache;");
			response.setHeader("Expires", "-1;");

			File file = write(fileName, list, fieldset, headerset);

			response.setHeader("Content-Transfer-Encoding", "binary;");
			response.setHeader("Content-Length", "" + file.length());

			FileInputStream fileIn = new FileInputStream(file);
			ServletOutputStream out = response.getOutputStream();

			byte[] outputByte = new byte[(int)file.length()];

			while (fileIn.read(outputByte, 0, (int)file.length()) != -1) {
				out.write(outputByte, 0, (int)file.length());
			}

		} catch(Exception e) {
			response.setHeader("Set-Cookie", "fileDownload=false; path=/");
			response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
			response.setHeader("Content-Type","text/html; charset=utf-8");

			OutputStream out = null;

			try {
				out = response.getOutputStream();
				byte[] data = new String("fail..").getBytes();
				out.write(data, 0, data.length);
			} catch(Exception ignore) {
				ignore.printStackTrace();
			} finally {
				if(out != null) try { out.close(); } catch(Exception ignore) {}
			}
		} finally {
			// 디스크 적었던 임시파일을 제거합니다.
			wb.dispose();

			try { wb.close(); } catch(Exception ignore) {}
		}
	}

	public static List<Map> convertListToMap(List<Object> list) {
		List<Map> result = new ArrayList<>();
		ObjectMapper mapper = new ObjectMapper();

		for (Object obj : list) {
			Map map = mapper.convertValue(obj, Map.class);
			result.add(map);
		}

		return result;
	}

	/**
	 * dto 로부터 필요한 컬럼 정보를 jqgrid 에 전달하기 위한 메서드
	 * @param clazz
	 * @return
	 */
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
				// 어노테이션 정의가 없을때
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

	public static File write(String sFileName, List _list, String[] fieldset, String[] headerset) throws Exception {
		if (_list == null) return null;

		WritableWorkbook workbook = null;
		WritableSheet sheet = null;
		int iSheetNum = 0;

		Map<String, String> Headers = null;
		if (_list.get(0) instanceof Map)
			Headers = (HashMap)_list.get(0);
		else
			Headers = BeanUtils.describe(_list.get(0));


		File excelFile = null;

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

		Boolean bGroupHeader = false;
		for (int cols = 0; cols < fieldset.length; cols++) {
			//20231228 hidden, pw field 제외
			if (headerset[cols] != null && headerset[cols].indexOf("`") > -1) {
				bGroupHeader = true;
				break;
			}
		}

		for (int row = 0; row < _list.size(); row++) {
			if (row % 65535 == 0) {
				workbook.createSheet("Sheet"+iSheetNum, iSheetNum);
				sheet = workbook.getSheet(iSheetNum);
				iSheetNum++;

				for (int cols = 0; cols < fieldset.length; cols++) {

					if(headerset[cols] == null){ //20231228 hidden, pw field 제외
						continue;
					}
					String headerName = fieldset[cols];

					if (cols < headerset.length) {
						if (headerset[cols].indexOf("`") > -1) {
							Label label = new Label(cols, 0, headerset[cols].split("`")[0], headerCellFormat);
							sheet.addCell(label);
							label = new Label(cols, 1, headerset[cols].split("`")[1], headerCellFormat);
							sheet.addCell(label);
							label = null;
						} else {
							Label label = new Label(cols, 0, headerset[cols], headerCellFormat);
							sheet.addCell(label);
							label = null;

							if (bGroupHeader)
								sheet.mergeCells(cols, 0, cols, 1);
						}
					} else {
						Label label = new Label(cols, 0, fieldset[cols], headerCellFormat);
						sheet.addCell(label);
						label = null;

						if (bGroupHeader)
							sheet.mergeCells(cols, 0, cols, 1);
					}
				}

				int mergeStart = -1;
				String mergeLabel = "";

				for (int cols = 0; cols < headerset.length; cols++) {

					if(headerset[cols] == null){ //20231228 hidden, pw field 제외
						continue;
					}

					// 그룹헤더이면 시작번호를 저장하고, 그룹라벨명도 저장하고
					if (headerset[cols].indexOf("`") > -1) {
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

			try {
				HashMap<String, String> data;
				if (_list.get(0) instanceof Map)
					data = (HashMap)_list.get(row);
				else
					data = (HashMap) BeanUtils.describe(_list.get(row));

				for (int cols = 0; cols < fieldset.length; cols++) {
					Label label = new Label(cols, (row % 65535)+1, NVL(data.get(fieldset[cols])).toString(), defaultCellFormat);
					sheet.addCell(label);
					label = null;
				}
				data = null;
			} catch (Exception e) {
				System.out.println(e.getMessage());
				e.printStackTrace();
			}
		}

		Headers = null;
		workbook.write();
		workbook.close();

		return excelFile;
	}

	public static File write(String sFileName, List _List) throws Exception {
		if (_List == null) return null;
		WritableWorkbook workbook = null;
		WritableSheet sheet = null;

		int iSheetNum = 0;

//		String sFileName = this.getTimeStamp() + ".xls";

		File excelFile = null;
//			File tempDictory = new File(save_url);

//			if(!tempDictory.isDirectory()){
//				tempDictory.mkdirs();
//			}

//			excelFile = new File(tempDictory + File.separator + System.currentTimeMillis() +"_"+ sFileName  );

		excelFile = new File(sFileName);
		workbook = Workbook.createWorkbook(excelFile);

		WritableCellFormat cellFormat = new WritableCellFormat();
		cellFormat.setBorder(Border.ALL, BorderLineStyle.NONE);

		for (int row = 0; row < _List.size(); row++) {
			if (row % 65530 == 0) {
				workbook.createSheet("Sheet"+iSheetNum, iSheetNum);
				sheet = workbook.getSheet(iSheetNum);
				iSheetNum++;

				// Set Header
				Map mCols = (Map)_List.get(row);
				Iterator ir = mCols.keySet().iterator();
				int iCol = 0;

				while(ir.hasNext()) {
					String keys = (String)ir.next().toString();

					if (!NVL(keys).toString().toLowerCase().equals("hidden")) {
						String sColumnName = NVL(keys).toString();
						sColumnName = sColumnName.toUpperCase().replace("SUM(", "");
						sColumnName = sColumnName.replace(")", "");

						Label label = new Label(iCol, 0, sColumnName, cellFormat);
						sheet.addCell(label);
						iCol++;
						label = null;
					}

				}

				mCols = null;
				ir = null;
			}

			Map mCols = (Map)_List.get(row);
			Iterator ir = mCols.keySet().iterator();
			int iCol = 0;

			while (ir.hasNext()) {
				String keys = (String)ir.next().toString();

				if (!keys.toLowerCase().equals("hidden")) {
					Label label = new Label(iCol, row+1, NVL(mCols.get(keys)).toString(), cellFormat);
					sheet.addCell(label);
					label = null;
					iCol++;
				}
			}

			mCols = null;
			ir = null;
		}

		workbook.write();
		workbook.close();

		return excelFile;
	}

	private static Boolean containStrArray(String[] target, String source) {
		if (target == null) return false;

		for (int i = 0; i < target.length; i++)
			if (source.toLowerCase().equals(target[i].toLowerCase()))
				return true;

		return false;
	}

	protected static String getTimeStamp() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
		java.util.Date date = new java.util.Date();
		Long lRes = (Long)date.getTime();

		return lRes.toString();
	}



	protected static Object NVL(Object object) {
		if (object == null) return "";
		return object;
	}

	protected static boolean isStringDouble(String s) {
		try {
			Double.parseDouble(s);

			return true;
		} catch (NumberFormatException e) {
			return false;
		}
	}
}