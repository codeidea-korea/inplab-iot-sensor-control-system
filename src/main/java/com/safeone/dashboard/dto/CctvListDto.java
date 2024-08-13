package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class CctvListDto implements Serializable {
	@FieldLabel(title="자산 ID", type="hidden")
    String asset_id;
	
	@FieldLabel(title="자산 종류 ID", type="hidden")
    String asset_kind_id_hid;
	
	@FieldLabel(title="자산종류", type="hidden")
    String asset_kind_id;

    @FieldLabel(title="지구명" , width=180)
    String zone_name;
    @FieldLabel(title="CCTV명", width = 180)
    String name;
	@FieldLabel(title="URL", type="text", width = 200)
    String etc1;
	@FieldLabel(title="기타2", type="hidden")
    String etc2;
	@FieldLabel(title="기타3", type="hidden")
    String etc3;
	
	@FieldLabel(title="설명", type="text", width = 200)
    String description;
	
	@FieldLabel(title="장비 ID", type="hidden")
    String device_id;
	
	@FieldLabel(title="센서 ID", type="hidden")
    String sensor_id;

	@FieldLabel(title="현장 ID", type="hidden")
    String area_id_hid;
	
	@FieldLabel(title="사용 여부", type="hidden")
    String use_flag;
	
	@FieldLabel(title="지구 ID", type="hidden")
    String zone_id_hid;

}