package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Schema
@Getter
@Setter
@Builder
public class GetModifyCctvDto {

    @Schema(example = "진천", description = "현장명")
    private String district_nm;

    @Schema(example = "이월CCTV-01", description = "cctv명")
    private String cctv_nm;

    @Schema(example = "10", description = "row수")
    private String limit;

    @Schema(example = "0", description = "조회시작 row_num")
    private String offset;
}
