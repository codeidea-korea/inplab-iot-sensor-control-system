package com.safeone.dashboard.controller.admin;

import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.safeone.dashboard.dto.ManageDto;
import com.safeone.dashboard.service.ManageService;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.DataMeasureDto;
import com.safeone.dashboard.service.DataMeasureService;

import org.springframework.web.multipart.MultipartFile;

import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;

@Controller
@RequestMapping("/admin/dataMeasure")
public class DataMeasureController extends JqGridAbstract<DataMeasureDto> {
	@Autowired
	private DataMeasureService dataMeasureService;
	@Autowired
	private ManageService manageService;

	protected DataMeasureController() {
		super(DataMeasureDto.class);
	}

	@Override
	protected List getList(Map param) {

		if(param.containsKey("collect_date")) {
			String[] dates = ((String)param.get("collect_date")).split(" ~ ");
			if(dates.length > 1) {
				param.put("collect_date_start", dates[0]);
				param.put("collect_date_end", dates[1]);
			}else {
				param.put("collect_date_start", dates[0]);
				param.put("collect_date_end", dates[0]);
			}
		}
		String ch_name_sensor_keys = String.valueOf(param.get("ch_name_sensor_keys"));
		String[] ch_name_sensor_id = ch_name_sensor_keys.split(",");

		String x_fields = ch_name_sensor_id[0];
		String y_fields = ch_name_sensor_id[1];

		String[] x_field = x_fields.split(":");
		String[] y_field = y_fields.split(":");

		param.put("x_sensor_id", x_field[1]);
		param.put("y_sensor_id", y_field[1]);
		param.put("x_zone_id", x_field[2]);//sensor_id는 x,y 두개이고, zone_id는 하나라는데, asset에 하나의zone_id 들어가면 될것같으나, 채널테이블에 x,y별 각 1개씩 들어있음
		param.put("y_zone_id", y_field[2]);//sensor_id는 x,y 두개이고, zone_id는 하나라는데, asset에 하나의zone_id 들어가면 될것같으나, 채널테이블에 x,y별 각 1개씩 들어있음

		return dataMeasureService.getList(param);
	}

	@Override
	protected int getTotalRows(Map param) {
		if(param.containsKey("collect_date")) {
			String[] dates = ((String)param.get("collect_date")).split(" ~ ");
			if(dates.length > 1) {
				param.put("collect_date_start", dates[0]);
				param.put("collect_date_end", dates[1]);
			}else {
				param.put("collect_date_start", dates[0]);
				param.put("collect_date_end", dates[0]);
			}
		}
		String ch_name_sensor_keys = String.valueOf(param.get("ch_name_sensor_keys"));
		String[] ch_name_sensor_id = ch_name_sensor_keys.split(",");

		String x_fields = ch_name_sensor_id[0];
		String y_fields = ch_name_sensor_id[1];

		String[] x_field = x_fields.split(":");
		String[] y_field = y_fields.split(":");

		param.put("x_sensor_id", x_field[1]);
		param.put("y_sensor_id", y_field[1]);
		param.put("x_zone_id", x_field[2]);//sensor_id는 x,y 두개이고, zone_id는 하나라는데, asset에 하나의zone_id 들어가면 될것같으나, 채널테이블에 x,y별 각 1개씩 들어있음
		param.put("y_zone_id", y_field[2]);//sensor_id는 x,y 두개이고, zone_id는 하나라는데, asset에 하나의zone_id 들어가면 될것같으나, 채널테이블에 x,y별 각 1개씩 들어있음

		return dataMeasureService.getTotalCount(param);
	}

	@Override
	protected String setViewPage() {
		return "admin/dataMeasure";
	}

	@ResponseBody
	@GetMapping("/newchartData")
	public List newchartData(HttpServletRequest request, @RequestParam Map<String, Object> param) {

		if(param.containsKey("collect_date")) {
			String[] dates = ((String)param.get("collect_date")).split(" ~ ");
			if(dates.length > 1) {
				param.put("collect_date_start", dates[0]);
				param.put("collect_date_end", dates[1]);
			}else {
				param.put("collect_date_start", dates[0]);
				param.put("collect_date_end", dates[0]);
			}
		}

		String ch_name_sensor_keys = String.valueOf(param.get("ch_name_sensor_keys"));
		String[] ch_name_sensor_id = ch_name_sensor_keys.split(",");
		String x_fields = ch_name_sensor_id[0];
		String y_fields = ch_name_sensor_id[1];
		String[] x_field = x_fields.split(":");
		String[] y_field = y_fields.split(":");
		param.put("x_sensor_id", x_field[1]);
		param.put("y_sensor_id", y_field[1]);
		param.put("x_zone_id", x_field[2]);//sensor_id는 x,y 두개이고, zone_id는 하나라는데, asset에 하나의zone_id 들어가면 될것같으나, 채널테이블에 x,y별 각 1개씩 들어있음
		param.put("y_zone_id", y_field[2]);//sensor_id는 x,y 두개이고, zone_id는 하나라는데, asset에 하나의zone_id 들어가면 될것같으나, 채널테이블에 x,y별 각 1개씩 들어있음
		param.put("sensor_id", x_field[1]);
		param.put("zone_id", x_field[2]);



		List<DataMeasureDto> rList = dataMeasureService.getList(param);
		List<ManageDto> mList = manageService.getList(param);

		List chartData = new ArrayList<>();
		List chartData2 = new ArrayList<>();
		List chartData3 = new ArrayList<>();
		for(DataMeasureDto dto : rList) {
			//double value = 0.0;
			double x_value = 0.0;
			double y_value = 0.0;
			double x_deg = Double.parseDouble(dto.getX_deg());
			double y_deg = Double.parseDouble(dto.getY_deg());

			//if(x_deg > y_deg) value = x_deg;
			//else value = y_deg;
			x_value = x_deg;
			y_value = y_deg;

			double[] db01 = {(Double.parseDouble(dto.getTimestamp())*1000), x_value};
			chartData2.add(db01);
			double[] db02 = {(Double.parseDouble(dto.getTimestamp())*1000), y_value};
			chartData3.add(db02);
		}
		chartData.add(chartData2);
		chartData.add(chartData3);
//		System.out.println("chartData :"+chartData);
//		System.out.println("chartData2 :"+chartData2);
//		System.out.println("chartData3 :"+chartData3);
		chartData.add(mList.get(0));

		return chartData;
	}


	@ResponseBody
	@PostMapping("/addByExcel")
	public Map upload(@RequestParam("uploadFile") MultipartFile file, HttpServletRequest request, @RequestParam Map<String, Object> param) {// throws IOException {

		Map resultMap = new HashMap();

		String ch_name_sensor_keys = String.valueOf(param.get("ch_name_sensor_keys"));
		String[] ch_name_sensor_id = ch_name_sensor_keys.split(",");
		String x_fields = ch_name_sensor_id[0];
		String y_fields = ch_name_sensor_id[1];
		String[] x_field = x_fields.split(":");
		String[] y_field = y_fields.split(":");

		String asset_kind_id = String.valueOf(param.get("asset_kind_id"));

		//for delete
//    	String collect_date = String.valueOf(param.get("collect_date"));
		String collect_date_start = "";
		String collect_date_end = "";

		if(param.containsKey("collect_date")) {
			String[] dates = ((String)param.get("collect_date")).split(" ~ ");
			if(dates.length > 1) {
				collect_date_start = dates[0];
				collect_date_end = dates[1];
			}else {
				collect_date_start = dates[0];
				collect_date_end = dates[0];
			}
		}

		String x_raw_data = String.valueOf(param.get("x_raw_data"));
		String x_deg = String.valueOf(param.get("x_deg"));
		String y_raw_data = String.valueOf(param.get("y_raw_data"));
		String y_deg = String.valueOf(param.get("y_deg"));

		//20240103 구조물경사계 엑셀업로드 데이터형식 체크
		String regex = "^(-?[0-9]{1,5})(\\.[0-9]{1,5})?$";	//정수5자리 소수점5자리
		int successCnt = 0;
		int failCnt = 0;

		Workbook workbook = null;

		try {
			if(!file.isEmpty()){
				List<Map<String, String>> xInsList = new ArrayList<>();
				List<Map<String, String>> yInsList = new ArrayList<>();

				String extension = file.getOriginalFilename().split("\\.")[1];
				if("xls".equalsIgnoreCase(extension)){
					workbook = new HSSFWorkbook(file.getInputStream());
				}else{
					workbook = new XSSFWorkbook(file.getInputStream());
				}

				Sheet sheet = workbook.getSheetAt(0);

				//0번째 행 버림
				for(int ri=1 ; ri<sheet.getPhysicalNumberOfRows() ; ri++){

					Map<String, String> xMap = new HashMap<>();
					Map<String, String> yMap = new HashMap<>();

					xMap.put("sensor_id", x_field[1]);
					yMap.put("sensor_id", y_field[1]);
					xMap.put("zone_id", x_field[2]);//sensor_id는 x,y 두개이고, zone_id는 하나라는데, asset에 하나의zone_id 들어가면 될것같으나, 채널테이블에 x,y별 각 1개씩 들어있음
					yMap.put("zone_id", y_field[2]);//sensor_id는 x,y 두개이고, zone_id는 하나라는데, asset에 하나의zone_id 들어가면 될것같으나, 채널테이블에 x,y별 각 1개씩 들어있음
					//calc_value
					//num
					//type
					xMap.put("type", asset_kind_id);
					yMap.put("type", asset_kind_id);

					Row row = sheet.getRow(ri);
					if(row != null){
						for(int ci=0; ci<=row.getPhysicalNumberOfCells(); ci++){

							Cell cell = row.getCell(ci);
							String value="";

							if(cell == null){
								continue;
							}else{
								//타입별로 내용 읽기
								switch(cell.getCellType()){
									case Cell.CELL_TYPE_FORMULA:
										value = cell.getCellFormula();
										break;
									case Cell.CELL_TYPE_NUMERIC:
										value = cell.getNumericCellValue()+"";
										break;
									case Cell.CELL_TYPE_STRING:
										value = cell.getStringCellValue()+"";
										break;
									case Cell.CELL_TYPE_BLANK:
										value = cell.getBooleanCellValue()+"";
										break;
									case Cell.CELL_TYPE_ERROR:
										value = cell.getErrorCellValue()+"";
										break;
								}
							}

							xMap.put("addFlag", "true");
							yMap.put("addFlag", "true");
							if(0==ci) {
								if(!checkDate(value, "yyyy/MM/dd HH:mm:ss")){
									failCnt++;
									failCnt++;
									xMap.put("addFlag", "false");
									yMap.put("addFlag", "false");
									break;
								}
								xMap.put("collect_date", value);
								yMap.put("collect_date", value);
							}else if(1==ci){
								if(!value.matches(regex)){
									failCnt++;
									xMap.put("addFlag", "false");
									break;
								}
								xMap.put("raw_value", value);
							}
							else if(2==ci){
								if(!value.matches(regex)){
									failCnt++;
									xMap.put("addFlag", "false");
									break;
								}
								xMap.put("real_value", value);
							}
							else if(3==ci){
								if(!value.matches(regex)){
									failCnt++;
									yMap.put("addFlag", "false");
									break;
								}
								yMap.put("raw_value", value);
							}
							else if(4==ci){
								if(!value.matches(regex)){
									failCnt++;
									yMap.put("addFlag", "false");
									break;
								}
								yMap.put("real_value", value);
							}

						}//for(int ci=0; ci<=row.getPhysicalNumberOfCells(); ci++){

						xInsList.add(xMap);
						yInsList.add(yMap);

					}//if(row != null){

				}//for(int ri=0 ; ri<sheet.getPhysicalNumberOfRows() ; ri++){

				//데이터값 설정 목록 검색 조건으로 기 데이터 삭제
				//x
				Map<String, String> xMapToDel = new HashMap<>();
				xMapToDel.put("sensor_id", x_field[1]);
				xMapToDel.put("zone_id", x_field[2]);//sensor_id는 x,y 두개이고, zone_id는 하나라는데, asset에 하나의zone_id 들어가면 될것같으나, 채널테이블에 x,y별 각 1개씩 들어있음
//		    	xMapToDel.put("type", asset_kind_id);
				if(!"".equals(collect_date_start)) xMapToDel.put("collect_date_start", collect_date_start);
				if(!"".equals(collect_date_end)) xMapToDel.put("collect_date_end", collect_date_end);
				xMapToDel.put("raw_value", x_raw_data);
				xMapToDel.put("real_value", x_deg);

				dataMeasureService.delete(xMapToDel);

				//y
				Map<String, String> yMapToDel = new HashMap<>();
				yMapToDel.put("sensor_id", y_field[1]);
				yMapToDel.put("zone_id", y_field[2]);//sensor_id는 x,y 두개이고, zone_id는 하나라는데, asset에 하나의zone_id 들어가면 될것같으나, 채널테이블에 x,y별 각 1개씩 들어있음
//		    	yMapToDel.put("type", asset_kind_id);
				if(!"".equals(collect_date_start)) yMapToDel.put("collect_date_start", collect_date_start);
				if(!"".equals(collect_date_end)) yMapToDel.put("collect_date_end", collect_date_end);
				yMapToDel.put("raw_value", y_raw_data);
				yMapToDel.put("real_value", y_deg);

				dataMeasureService.delete(yMapToDel);

				for(Map<String, String> x : xInsList) {
					if("true".equalsIgnoreCase(x.get("addFlag")+"")) {
						dataMeasureService.create(x);
						successCnt++;
					}
				}

				for(Map<String, String> y : yInsList) {
					if("true".equalsIgnoreCase(y.get("addFlag")+"")) {
						dataMeasureService.create(y);
						successCnt++;
					}
				}

			}//if(!file.isEmpty()){

//			return true;

		} catch (Exception e) {
			e.printStackTrace();
		}

//		return false;
		resultMap.put("totCnt", successCnt+failCnt);
		resultMap.put("successCnt", successCnt);
		resultMap.put("failCnt", failCnt);
		return resultMap;
	}

	/**
	 * 업로드데이터 날짜형식 체크
	 * @param checkDate
	 * @param dateFormat
	 * @return
	 */
	public boolean checkDate(String checkDate, String dateFormat) {
		boolean result = false;
		try {
			DateTimeFormatter dateFormatParser = DateTimeFormatter.ofPattern(dateFormat);
//			SimpleDateFormat dateFormatParser = new SimpleDateFormat(dateFormat); //검증할 날짜 포맷 설정
//			dateFormatParser.setLenient(false);
			dateFormatParser.parse(checkDate);
			result =  true;
		} catch (Exception e) {
			try{
				DateTimeFormatter dateFormatParser = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
//				SimpleDateFormat dateFormatParser = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); //검증할 날짜 포맷 설정
//				dateFormatParser.setLenient(false);
				dateFormatParser.parse(checkDate);
				result =  true;
			}catch (Exception e1){
				result =  false;
			}

		}finally {
			return result;
		}
	}

}
