package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class AlarmListDto implements Serializable {
    @FieldLabel(title="지구명", width=180)
    String zone_id;
    @FieldLabel(title="알람 ID", type="hidden")
    String alarm_uid;

    @FieldLabel(title="알람 레벨", width=180)
    String risk_level;
    
    /*@FieldLabel(title="현장", width=170)
//    String zone_name;
    String area_name;*/
    
    @FieldLabel(title="센서종류", width=180)
    String asset_kind_name;
    
    @FieldLabel(title="자산 종류 ID", type="hidden")
    String asset_kind_id;
    
    @FieldLabel(title="센서", width=220)
    String asset_name;
    
    @FieldLabel(title="센서ID", type="hidden")
    String asset_id;

    @FieldLabel(title="알람 종류", width=250)
    String alarm_kind_id;
    
//    @FieldLabel(title="알람 종류", width=170)
//    String alarm_kind_name;

    @FieldLabel(title="일자", width=200, type="range")
    String reg_day;
    
    @FieldLabel(title="알람발생시간", width=210)
    String reg_time;

    @FieldLabel(title="설명", type="hidden")
    String description;
    @FieldLabel(title="알람 현황 횟수 유무", type="hidden")
    String view_flag;

}