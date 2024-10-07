package com.safeone.dashboard.dto.maintenance;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class MaintenanceManageDto implements Serializable {
    @FieldLabel(title="유지보수 ID", type="hidden")
    String maintenance_id;

    @FieldLabel(title="일자", type="range", width = 155)
    String reg_day;
    
    @FieldLabel(title="등록시간", width = 155)
    String reg_time;
    
    @FieldLabel(title="지구명", type="hidden")
    String zone_id_hid;
    @FieldLabel(title="지구명", width = 150)
    String zone_id;
    
    @FieldLabel(title="센서명", type="hidden")
    String asset_id_hid;
    @FieldLabel(title="센서명", width = 150)
    String asset_id;
    
    @FieldLabel(title="유지보수 종류", type="hidden")
    String type_hid;
    @FieldLabel(title="유지보수 종류", width = 150)
    String type;
    
    @FieldLabel(title="유지보수 일자", type="range", width = 155)
    String mt_date;
    
    @FieldLabel(title="담당자", width = 150)
    String manager_name;

    @FieldLabel(title="연락처", width=155)
    String manager_tel;

    @FieldLabel(title="설명", width=200)
    String description;
    
    @FieldLabel(title="등록 일자", type="hidden")
    String reg_date;
    
    @FieldLabel(title="현장 ID", type="hidden")
    String area_id;
    
    @FieldLabel(title="현장 사진(서버파일명)", type="hidden")
    String file1;
    
}