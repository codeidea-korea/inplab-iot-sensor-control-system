package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Schema
@Getter
@Setter
@Builder
public class GetAdminAddBroadcastDto {

    @Schema(example = "B01", description = "방송장비 no")
    private String brdcast_no;

    @Schema(example = "BrdCast-01", description = "검색가능대상 : 방송장비명 or 현장명 or 설치상태")
    private String search_text;

    @Schema(example = "10", description = "row수")
    private String limit;

    @Schema(example = "0", description = "조회시작 row_num")
    private String offset;
}
