package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class ZoneDto implements Serializable {
	@FieldLabel(title="지구 ID", type="hidden")
    String zone_id;
	
    @FieldLabel(title="현장명", type="hidden")
    String area_id_hid;
	@FieldLabel(title="현장명", width=180)
    String area_id;
	
	@FieldLabel(title="지구명", width=180)
    String name;
	
	@FieldLabel(title="위도", width=180)
    String lat;
	
	@FieldLabel(title="경도", width=180)
    String lng;
	
	@FieldLabel(title="높이", width=180, type = "hidden")
    String height;
	
	@FieldLabel(title="로거 ID", width=180)
    String etc1;

	@FieldLabel(title="로거 ID",type = "hidden")
    String etc1_hid;

	@FieldLabel(title="기타1", width=180)
    String etc2;
	
	@FieldLabel(title="기타2", width=180)
    String etc3;
	
	@FieldLabel(title="지구사진", type="hidden")
    String file1;
	
	@FieldLabel(title="배선도사진", type="hidden")
    String file2;
	
	@FieldLabel(title="임시", type="hidden")
    String file3;

    @FieldLabel(title="사용여부", width=170, type=":;Y:Y;N:N")
    String use_flag;
}
