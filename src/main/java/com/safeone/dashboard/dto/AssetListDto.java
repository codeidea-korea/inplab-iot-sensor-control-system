package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class AssetListDto implements Serializable {
	@FieldLabel(title="자산명", type="hidden")
    String asset_id;
	
	@FieldLabel(title="자산 종류 ID", type="hidden")
    String asset_kind_id_hid;

    @FieldLabel(title="지구명" , width=180)
    String zone_id;
	
	@FieldLabel(title="자산종류")
    String asset_kind_id;
	
	@FieldLabel(title="센서명", width = 180)
    String name;
	
	@FieldLabel(title="수정일", type="hidden")
    String mod_date;
	@FieldLabel(title="수정인", type="hidden")
    String mod_user;
	@FieldLabel(title="등록일", type="hidden")
    String reg_date;
	
	@FieldLabel(title="설명", type="hidden")
    String description;
	
	@FieldLabel(title="장비 ID", type = "hidden")
    String device_id;
	
	@FieldLabel(title="센서 ID", type="hidden")
    String sensor_id;
	
	@FieldLabel(title="현장", type = "hidden")
    String area_id;
	
	@FieldLabel(title="현장 ID", type="hidden")
    String area_id_hid;
	
	@FieldLabel(title="사용 여부", type="hidden")
    String use_flag;
	
	@FieldLabel(title="지구 ID", type="hidden")
    String zone_id_hid;
	
	@FieldLabel(title="설치일자", type = "range")
    String install_date;
	
	@FieldLabel(title="X축 위치", type="hidden")
    String x;
	@FieldLabel(title="Y축 위치", type="hidden")
    String y;
	@FieldLabel(title="Z축 위치", type="hidden")
    String z;
	
	@FieldLabel(title="상태값", type="hidden")
    String status_hid;
	
    @FieldLabel(title="최종 측정 일시", width=180, type = "timestamp_range")
    String collect_date;
    
	@FieldLabel(title="상태")
    String status;
    
    @FieldLabel(title="센서값", width=170)
    String real_value;

    @FieldLabel(title="RTSP 주소(전광판 IP)", width=200)
    String etc1;
    @FieldLabel(title="기타2", type="hidden")
    String etc2;
    @FieldLabel(title="웹 콘솔(전광판 PORT)", width = 200)
    String etc3;
}