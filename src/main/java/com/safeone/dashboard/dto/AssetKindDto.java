package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class AssetKindDto implements Serializable {
    @FieldLabel(title="자산 ID", type="hidden")
    String asset_kind_id;

    @FieldLabel(title="자산종류명", width=180)
    String name;

    @FieldLabel(title="자산종류설명", width=300)
    String description;

    @FieldLabel(title="기타1", width=180)
    String etc1;

    @FieldLabel(title="기타2", width=180)
    String etc2;

    @FieldLabel(title="기타3", width=180)
    String etc3;

    @FieldLabel(title="수정일자", type="range", width=200)
    String mod_date;

    @FieldLabel(title="수정인", type="text", width=180)
    String mod_user;
}