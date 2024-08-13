package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class OtherDataMeasureDto implements Serializable {
//	@FieldLabel(title="실 운용 센서값")
//	String real_value;		//실제 운용되는 센서값(센서변환값 - 센서 초기값)
	@FieldLabel(title="수집 일시", width=200, type = "timestamp_range")
	String collect_date;
//	@FieldLabel(title="센서값 변환")
//	String calc_value;		//센서값 변환(센서별 계산식)
//	@FieldLabel(title="오리지날 센서값")
//	String raw_value;		//오리지날 센서값
//	@FieldLabel(title="디바이스 ID")
//	String device_id;		//디바이스 ID
//	@FieldLabel(title="가비지 컬럼", type="hidden")
//	String num;				//가비지 컬럼?
//	@FieldLabel(title="지구명")
//	String zone_name;		//지구명
//	@FieldLabel(title="센서 타입")
//	String type;			//센서 타입
//	@FieldLabel(title="수집일시", type="hidden")
//	String _cdate;
	
//	real_value;	collect_date;			calc_value;	raw_value;	device_id;	num;	zone_name;	type;	_cdate
//	0.0;		2023/08/04/17:22:15;	0.0;		00000;		255;		0139;	testbed003;	4;		2023-08-04T17:21:42.517

	@FieldLabel(title="timestamp", type="hidden")
	String timestamp;
	
	@FieldLabel(title="raw_data", width=180)
	String raw_data;
	@FieldLabel(title="mm", width=180)
	String deg;
	
}