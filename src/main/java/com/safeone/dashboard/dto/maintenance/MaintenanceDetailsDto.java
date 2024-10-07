package com.safeone.dashboard.dto.maintenance;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class MaintenanceDetailsDto implements Serializable {
    @FieldLabel(title = "관리_no", type = "hidden")
    private String mgnt_no;

    @FieldLabel(title = "접수일자", type = "range")
    private String maint_accpt_ymd;

    @FieldLabel(title = "작업시작일자", type = "range")
    private String maint_str_ymd;

    @FieldLabel(title = "작업종료일자", type = "range")
    private String maint_end_ymd;

    @FieldLabel(title = "현장 no", type = "hidden")
    private String district_no;
    @FieldLabel(title = "현장 명") // 현장 no
    private String district_nm;

    @FieldLabel(title = "센서_no", type = "hidden")
    private String sens_no;
    @FieldLabel(title = "센서(장치)명") // 센서_no
    private String sens_nm;

    @FieldLabel(title = "작업 결과 cd", type = "hidden")
    private String maint_rslt_cd;
    @FieldLabel(title = "작업결과") // 작업 결과 cd
    private String code_nm;

    @FieldLabel(title = "세부 내역") // 작업내역
    private String maint_dtls;

    @FieldLabel(title = "작업업체") // 업체명
    private String maint_comp_nm;

    @FieldLabel(title = "작업담당자")
    private String maint_chgr_nm;

    @FieldLabel(title = "담당자연락처")
    private String maint_chgr_ph;

    @FieldLabel(title = "사진경로", type = "hidden")
    private String maint_pic_path;

    @FieldLabel(title = "등록일시", type = "range")
    private String reg_dt;

    @FieldLabel(title = "수정일시", type = "hidden")
    private String mod_dt;

}