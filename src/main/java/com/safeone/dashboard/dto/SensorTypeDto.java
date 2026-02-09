package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class SensorTypeDto implements Serializable {

    @FieldLabel(title="센서타입ID")
    String senstype_no;

    @FieldLabel(title="사이트_no", type="hidden")
    String site_no;

    @FieldLabel(title="로거 구분", type="hidden")
    String logr_flag;

    @FieldLabel(title="센서 TYPE명")
    String sens_tp_nm;

    @FieldLabel(title="약어")
    String sens_abbr;

    @FieldLabel(title="보정식(계산식)")
    String basic_formul;

    @FieldLabel(title="채널수")
    String sens_chnl_cnt;

    @FieldLabel(title="로거_idx_S")
    String logr_idx_str;

    @FieldLabel(title="로거_idx_E")
    String logr_idx_end;

    @FieldLabel(title="담당자")
    String contactor_nm;

    @FieldLabel(title="연락처")
    String contactor_phone;

    public String getSens_chnl_cnt() {
        return sens_chnl_cnt;
    }

    public String getLogr_idx_str() {
        return logr_idx_str;
    }

}