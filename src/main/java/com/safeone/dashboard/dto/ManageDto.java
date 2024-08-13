package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class ManageDto implements Serializable {
    @FieldLabel(title = "지구명", width=120)
    String zone_name;
	@FieldLabel(title="센서종류", width=120)
    String asset_kind_name;
	@FieldLabel(title = "센서명", width=150)
    String asset_name;
	@FieldLabel(title = "채널명", width=150)
    String channel_name;	
    @FieldLabel(title = "ID", type="hidden")
    String manage_id;
    @FieldLabel(title = "변화량 기준 시간", type="editable")
    String standard_time;
    @FieldLabel(title = "관리기준 최소1", type="editable", width=100)
    String min1;
    @FieldLabel(title = "관리기준 최소2", type="editable", width=100)
    String min2;
    @FieldLabel(title = "관리기준 최소3", type="editable", width=100)
    String min3;
    @FieldLabel(title = "관리기준 최소4", type="editable", width=100)
    String min4;
    @FieldLabel(title = "관리기준 최대1", type="editable", width=100)
    String max1;
    @FieldLabel(title = "관리기준 최대2", type="editable", width=100)
    String max2;
    @FieldLabel(title = "관리기준 최대3", type="editable", width=100)
    String max3;
    @FieldLabel(title = "관리기준 최대4", type="editable", width=100)
    String max4;
    @FieldLabel(title = "기타", type="hidden")
    String etc;
    @FieldLabel(title = "센서 ID", type="hidden")
    String sensor_id;
    @FieldLabel(title = "지구 ID", type="hidden")
    String zone_id;
}
