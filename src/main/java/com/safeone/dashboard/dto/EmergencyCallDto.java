package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class EmergencyCallDto implements Serializable {
    @FieldLabel(title="ID", type="hidden")
    String emergency_call_id;

    @FieldLabel(title="현장명", width=150)
    String area_id;
    
    @FieldLabel(title="현장명", type="hidden")
    String area_id_hid;
    
    @FieldLabel(title="역할", width=150)
    String role;
    
    @FieldLabel(title="소속", width=150)
    String company_name;

    @FieldLabel(title="이름", width=150)
    String name;
    
    @FieldLabel(title="사용자연락처", width=250)
    String tel1;
    
    @FieldLabel(title="사용자연락처2", type="hidden")
    String tel2;
    
    @FieldLabel(title="이메일", width=250)
    String email;
    
    @FieldLabel(title="기타1", width=300)
    String etc1;

    @FieldLabel(title="기타2", type="hidden")
    String etc2;

    @FieldLabel(title="기타3", type="hidden")
    String etc3;
}