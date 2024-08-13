package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class SensorGroupDto implements Serializable {
	
	@FieldLabel(title="자산 ID", type="hidden")
    String asset_id;
    
    @FieldLabel(title="기타1", type="hidden")
    String etc1;
    @FieldLabel(title="기타2", type="hidden")
    String etc2;
    @FieldLabel(title="기타3", type="hidden")
    String etc3;
    @FieldLabel(title="수정일", type="hidden")
    String mod_date;
    @FieldLabel(title="수정인", type="hidden")
    String mod_user;
    @FieldLabel(title="등록일", type="hidden")
    String reg_date;
    @FieldLabel(title="설명", type="hidden")
    String description;
    @FieldLabel(title="현장 ID", type="hidden")
    String area_id;
    @FieldLabel(title="센서 ID", type="hidden")
    String sensor_id;
    @FieldLabel(title="사용 여부", type="hidden")
    String use_flag;
    @FieldLabel(title="지구 ID", type="hidden")
    String zone_id;
    @FieldLabel(title="X축 위치", type="hidden")
    String x;
    @FieldLabel(title="Y축 위치", type="hidden")
    String y;
    @FieldLabel(title="Z축 위치", type="hidden")
    String z;

    @FieldLabel(title="지구명", width=180)
    String zone_name;

    @FieldLabel(title="센서 종류", type="hidden")
    String asset_kind_id;
    
    @FieldLabel(title="센서 종류", type="hidden")
    String asset_kind_name;

    @FieldLabel(title="센서명", width=110)
    String name;

    @FieldLabel(title="설치 일자", type="hidden")
    String install_date;
    
    @FieldLabel(title="최종 측정 일시", width=180, type = "timestamp_range")
    String collect_date;
    
    @FieldLabel(title="계측기 최종 측정 일시", type="hidden")
    String ch_collect_date;
    
    @FieldLabel(title="상태", width=70)
    String status;

    @FieldLabel(title="센서값", type="hidden")
    String real_value;
    
    @FieldLabel(title="센서의 채널명 및 키그룹", type="hidden")
    String ch_name_sensor_keys;
}