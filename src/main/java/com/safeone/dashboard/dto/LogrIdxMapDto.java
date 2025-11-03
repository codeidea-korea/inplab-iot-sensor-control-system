package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class LogrIdxMapDto implements Serializable {

    @FieldLabel(title="관리_no", type="hidden")
    String mapping_no;

    @FieldLabel(title="센서_no", type="hidden")
    String sens_no;

    @FieldLabel(title="현장명")
    String district_nm;

    @FieldLabel(title="현장 TYPE명")
    String senstype_nm;

    @FieldLabel(title="센서 ID")
    String sens_nm;

    @FieldLabel(title="로거명")
    String logr_nm;

    @FieldLabel(title="로거번호", type="hidden")
    String logr_no;

    @FieldLabel(title="체널명")
    String sens_chnl_nm;

    @FieldLabel(title="채널seq")
    String logr_chnl_seq;

    @FieldLabel(title="로거_Idx")
    String logr_idx_no;

    @FieldLabel(title="단면번호")
    String sect_no;

    @FieldLabel(title="데이터 등록 일자", type="hidden")
    String reg_dt;

    @FieldLabel(title="현장 TYPE no", type="hidden")
    String senstype_no;

    @FieldLabel(title="등록일자")
    String mapping_dt;

}