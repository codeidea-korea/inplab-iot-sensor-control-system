package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class AlarmSettingDto implements Serializable {
    
    @FieldLabel(title="알람위험레벨", type="hidden")
    String risk_level_hid;
    @FieldLabel(title="알람위험레벨", type = "hidden")
    String risk_level;
	
	@FieldLabel(title="알람 종류 ID", type="hidden")
    String alarm_kind_id;

    @FieldLabel(title="알람 종류 이름", width=420)
    String name;

    @FieldLabel(title="카테고리", type="hidden")
    String category_hid;
    
    @FieldLabel(title="카테고리", type="hidden")
    String category;

    @FieldLabel(title="알람종류타입", type="hidden")
    String type_hid;
    @FieldLabel(title="알람종류타입", type="hidden")
    String type;
    
    @FieldLabel(title="알람 종류 설명", width=600)
    String description;
    
    @FieldLabel(title="자산 종류", type="hidden")
    String asset_kind_id_hid;
    @FieldLabel(title="자산 종류", width=200)
    String asset_kind_id;
    
    @FieldLabel(title="사용여부", type=":;Y:Y;N:N", width=200)
    String use_flag;
    
    @FieldLabel(title="알람 중복발생 무시 시간 (분)", type="hidden")
    String dupe_check_min;

    @FieldLabel(title="수정일자", type="hidden")
    String mod_date;

    @FieldLabel(title="수정자", type="hidden")
    String mod_user;
}