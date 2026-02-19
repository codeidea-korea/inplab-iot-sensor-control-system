package com.safeone.dashboard.dto.maintenance;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class MaintenanceCompanyManagementDto implements Serializable {
    @FieldLabel(title = "협력사 ID")
    private String partner_comp_id;

    @FieldLabel(title = "협력사명")
    private String partner_comp_nm;

    @FieldLabel(title = "협력사구분")
    private String partner_type_flag;

    @FieldLabel(title = "주소")
    private String partner_comp_addr;

    @FieldLabel(title = "상세주소", type="hidden")
    private String partner_comp_addr_add;

    @FieldLabel(title = "사업자번호")
    private String comp_biz_no;

    @FieldLabel(title = "대표명")
    private String maint_rep_nm;

    @FieldLabel(title = "대표연락처")
    private String maint_rep_ph;

    @FieldLabel(title = "등록일자", type = "range")
    private String reg_dt;

    @FieldLabel(title = "수정일자", type = "range")
    private String mod_dt;

}