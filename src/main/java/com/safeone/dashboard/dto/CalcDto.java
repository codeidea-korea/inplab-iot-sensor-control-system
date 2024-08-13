package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class CalcDto implements Serializable {
    @FieldLabel(title = "지구명", width=200)
    String zone_name;
    @FieldLabel(title="센서종류", width=200)
    String asset_kind_name;
	@FieldLabel(title = "센서명", width=220)
    String asset_name;
	@FieldLabel(title = "채널명", width=220)
    String channel_name;
    @FieldLabel(title = "계산 ID", type="hidden")
    String calc_id;
    @FieldLabel(title = "초기 센서값", width=200, type="editable")
    String initial_value;
    @FieldLabel(title = "게이지 팩터", width=200, type="editable")
    String factor_value;
    @FieldLabel(title = "오프셋", width=200, type="editable")
    String offset_value;
    @FieldLabel(title = "센서 ID", type="hidden")
    String sensor_id;
    @FieldLabel(title = "지구 ID", type="hidden")
    String zone_id;
}
