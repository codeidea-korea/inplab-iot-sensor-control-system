package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class AlarmRangeDto implements Serializable {
    @FieldLabel(title = "센서 종류 ID", type="hidden")
    String asset_kind_id;
    @FieldLabel(title="센서 종류명", width=200)
    String asset_kind_name;
    @FieldLabel(title = "안전", width=250, type="editable")
    String range_value1;
    @FieldLabel(title = "관심", width=250, type="editable")
    String range_value2;
    @FieldLabel(title = "주의", width=250, type="editable")
    String range_value3;
    @FieldLabel(title = "경계", width=250, type="editable")
    String range_value4;
    @FieldLabel(title = "심각", width=250, type="editable")
    String range_value5;
}
