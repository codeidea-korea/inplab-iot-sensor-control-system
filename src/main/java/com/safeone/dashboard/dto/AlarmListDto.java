package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class AlarmListDto implements Serializable {

    @FieldLabel(title = "발생일시")
    private String reg_date;

    @FieldLabel(title = "현장명", width = 180)
    private String zone_id;

    @FieldLabel(title = "채널명")
    private String channel_nm;

    @FieldLabel(title = "알림상태")
    private String risk_level;

    @FieldLabel(title = "계측값")
    private String value;

    @FieldLabel(title = "관리기준 범위")
    private String standard;

    @FieldLabel(title = "센서상태")
    private String status;

    @FieldLabel(title = "통신상태")
    private String comm_status;

    @FieldLabel(title = "문자(성공/대상)(명)")
    private String sms_success;

    @FieldLabel(title = "현장", width = 170, type = "hidden")
    private String area_name;

//    @FieldLabel(title = "센서종류", type = "hidden") //
//    private String asset_kind_name;

    @FieldLabel(title = "자산 종류 ID", type = "hidden")
    private String asset_kind_id;

    @FieldLabel(title = "센서", width = 220, type = "hidden")
    private String asset_name;

    @FieldLabel(title = "센서ID", type = "hidden")
    private String asset_id;

    @FieldLabel(title = "알람 종류", width = 250, type = "hidden")
    private String alarm_kind_id;

//    @FieldLabel(title = "알람 종류", width = 170, type = "hidden") //
//    private String alarm_kind_name;

    @FieldLabel(title = "일자", width = 200, type = "hidden")
    private String reg_day;

    @FieldLabel(title = "알람발생시간", width = 210, type = "hidden")
    private String reg_time;

    @FieldLabel(title = "설명", type = "hidden")
    private String description;
    @FieldLabel(title = "알람 현황 횟수 유무", type = "hidden")
    private String view_flag;

}