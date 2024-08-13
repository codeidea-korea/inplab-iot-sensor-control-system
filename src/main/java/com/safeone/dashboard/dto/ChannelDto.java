package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class ChannelDto implements Serializable {
    @FieldLabel(title = "지구명", width=280)
    String zone_name;
	@FieldLabel(title="센서종류", width=280)
    String asset_kind_name;
	@FieldLabel(title = "센서명", width=300)
    String asset_name;
    @FieldLabel(title = "채널 ID", type="hidden")
    String channel_id;
    @FieldLabel(title = "채널 명", width=300)
    String name;
    @FieldLabel(title = "순서", type="editable", width=300)
    String seq;
    @FieldLabel(title = "자산 ID", type="hidden")
    String asset_id;
    @FieldLabel(title = "센서 ID", type="hidden")
    String sensor_id;
    @FieldLabel(title = "지구 ID", type="hidden")
    String zone_id;
}
