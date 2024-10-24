package com.safeone.dashboard.controller.admin;

import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.ManageDto;
import com.safeone.dashboard.dto.OtherDataMeasureDto;
import com.safeone.dashboard.service.ManageService;
import com.safeone.dashboard.service.WireDataMeasureService;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/admin/wireDataMeasure")
public class WireDataMeasureController extends JqGridAbstract<OtherDataMeasureDto> {
    @Autowired
    private WireDataMeasureService wireDataMeasureService;

	@Autowired
	private ManageService manageService;

    protected WireDataMeasureController() {
        super(OtherDataMeasureDto.class);
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
    	String ch_name_sensor_key = String.valueOf(param.get("ch_name_sensor_keys"));
    	
    	String[] field = ch_name_sensor_key.split(":");
    	
    	param.put("sensor_id", field[1]);
    	param.put("zone_id", field[2]);

    	return wireDataMeasureService.getList(param);
    }

    @Override
    protected int getTotalCount(Map param) {
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
    	String ch_name_sensor_key = String.valueOf(param.get("ch_name_sensor_keys"));
    	
    	String[] field = ch_name_sensor_key.split(":");
    	
    	param.put("sensor_id", field[1]);
    	param.put("zone_id", field[2]);
    	
        return wireDataMeasureService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/wireDataMeasure";
    }

    @ResponseBody
    @GetMapping("/chartData")
    public List chartData(HttpServletRequest request, @RequestParam Map<String, Object> param) {

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
    	
    	String ch_name_sensor_key = String.valueOf(param.get("ch_name_sensor_keys"));
    	
    	String[] field = ch_name_sensor_key.split(":");
    	
    	param.put("sensor_id", field[1]);
    	param.put("zone_id", field[2]);

		List chartData = new ArrayList<>();
		List<OtherDataMeasureDto> rList = wireDataMeasureService.getList(param);
		List<ManageDto> mList = manageService.getList(param);

    	for(OtherDataMeasureDto dto : rList) {
    		double[] db = {(Double.parseDouble(dto.getTimestamp())*1000), Double.parseDouble(dto.getDeg())};
    		chartData.add(db);
    	}

		chartData.add(mList.get(0));
    	
    	return chartData;
    }
    
    @ResponseBody
    @PostMapping("/addByExcel")
    public Map upload(@RequestParam("uploadFile") MultipartFile file, HttpServletRequest request, @RequestParam Map<String, Object> param) {// throws IOException {
		Map resultMap = new HashMap();
    	String ch_name_sensor_key = String.valueOf(param.get("ch_name_sensor_keys"));
    	String[] field = ch_name_sensor_key.split(":");
    	
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
    	
    	String raw_data = String.valueOf(param.get("raw_data"));
    	String deg = String.valueOf(param.get("deg"));

		//20240103 지표변위계 엑셀업로드 데이터형식 체크
		String regex = "^(-?[0-9]{1,5})(\\.[0-9]{1,5})?$";	//정수5자리 소수점5자리
		int successCnt = 0;
		int failCnt = 0;
		try {
			
			if(!file.isEmpty()){

			    List<Map<String, String>> insList = new ArrayList<>();
				String extension = file.getOriginalFilename().split("\\.")[1];
				Workbook workbook = null;
				if("xls".equalsIgnoreCase(extension)){
					workbook = new HSSFWorkbook(file.getInputStream());
				}else{
					workbook = new XSSFWorkbook(file.getInputStream());
				}

				Sheet sheet = workbook.getSheetAt(0);
			    //0번째 행 버림
			    for(int ri=1 ; ri<sheet.getPhysicalNumberOfRows() ; ri++){

			    	Map<String, String> map = new HashMap<>();

			    	map.put("sensor_id", field[1]);
			    	map.put("zone_id", field[2]);
			    	//calc_value
			    	//num
			    	//type
			    	map.put("type", asset_kind_id);

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

							map.put("addFlag", "true");
	                        if(0==ci) {
								//20240103 날짜형식 체크
//								log.debug("0 : {} ",value);
								if(!checkDate(value, "yyyy/MM/dd HH:mm:ss")){
									failCnt++;
									map.put("addFlag", "false");
									break;
								}
	                        	map.put("collect_date", value);

	                        }else if(1==ci) {
//								log.debug("1 : {} ",value);
								if(!value.matches(regex)){
									failCnt++;
									map.put("addFlag", "false");
									break;
								}
								map.put("raw_value", value);
							}
	                        else if(2==ci) {
//								log.debug("2 : {} ",value);
								if(!value.matches(regex)){
									failCnt++;
									map.put("addFlag", "false");
									break;
								}
								map.put("real_value", value);
							}

	                    }//for(int ci=0; ci<=row.getPhysicalNumberOfCells(); ci++){

	                	insList.add(map);

	                }//if(row != null){

	            }//for(int ri=0 ; ri<sheet.getPhysicalNumberOfRows() ; ri++){
			    
			    //데이터값 설정 목록 검색 조건으로 기 데이터 삭제
		    	Map<String, String> mapToDel = new HashMap<>();
		    	mapToDel.put("sensor_id", field[1]);
		    	mapToDel.put("zone_id", field[2]);//sensor_id는 x,y 두개이고, zone_id는 하나라는데, asset에 하나의zone_id 들어가면 될것같으나, 채널테이블에 x,y별 각 1개씩 들어있음
//		    	mapToDel.put("type", asset_kind_id);
		    	if(!"".equals(collect_date_start)) mapToDel.put("collect_date_start", collect_date_start);
		    	if(!"".equals(collect_date_end)) mapToDel.put("collect_date_end", collect_date_end);   
		    	mapToDel.put("raw_value", raw_data);
		    	mapToDel.put("real_value", deg);
		    	
		    	wireDataMeasureService.delete(mapToDel);
		    	
//		    	throw new Exception("잠시멈춤!!!");

			    for(Map<String, String> ins : insList) {
					try{
						if("true".equalsIgnoreCase(ins.get("addFlag")+"")){
							wireDataMeasureService.create(ins);
							successCnt++;
						}

					}catch (Exception e){
						log.debug("등록 ERROR : {}", e);
					}

			    }
				
			}//if(!file.isEmpty()){
			
//			return true;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
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
