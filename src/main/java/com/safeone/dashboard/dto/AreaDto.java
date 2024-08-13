package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class AreaDto implements Serializable {
    @FieldLabel(title="현장 ID", type="hidden")
    String area_id;
	
    @FieldLabel(title="현장명", width=150)
    String name;
    
    @FieldLabel(title="현장종류")
    String type;

    @FieldLabel(title="위도", width=160)
    String lat;

    @FieldLabel(title="경도", width=160)
    String lng;

    @FieldLabel(title="줌", width=160)
    String zoom;
    
    @FieldLabel(title="기타1", type="hidden")
    String etc1;

    @FieldLabel(title="현장주소", width=300)
    String etc2;
    
    @FieldLabel(title="기타3", type="hidden")
    String etc3;
    
    @FieldLabel(title="현장사진", type="hidden")
    String file1;

    @FieldLabel(title="임시1", type="hidden")
    String file2;
    
    @FieldLabel(title="임시2", type="hidden")
    String file3;
    
    @FieldLabel(title="시공사", width=130)
    String constructor;
    
    @FieldLabel(title="계측사1", width=130)
    String measure1;
    
    @FieldLabel(title="계측사2", width=130)
    String measure2;
    
}