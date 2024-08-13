package com.safeone.dashboard.dto;

import java.io.Serializable;

import lombok.Data;

@Data
public class RawData implements Serializable {
    String zone_id;         //지구 ID
    String num;             //폴더넘버(가비지 데이터)
    String collect_date;    //수집 일자
    String sensor_id;       //센서 ID(보드의 고유번호)
    String raw_value;       //센서값(수집된 원본 그대로인 값)
    String type;            //센서 종류
    String calc_value;      //센서 계산값(종류에 따라 계산식이 다름)
    String real_value;      //센서 최종값(센서 계산값 - 센서 초기값)
}
