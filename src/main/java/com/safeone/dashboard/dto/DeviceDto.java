package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class DeviceDto implements Serializable {
    @FieldLabel(title="매핑 ID", type="hidden")
    String mapping_id;

    @FieldLabel(title="로거 ID", width=250)
    String device_id;

    @FieldLabel(title="설명", width=450)
    String description;

    @FieldLabel(title="수정일자", type="range", width=350)
    String mod_date;

    @FieldLabel(title="수정인", type="text", width=350)
    String mod_user;
}