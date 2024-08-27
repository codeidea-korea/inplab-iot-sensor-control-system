package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Schema
@Getter
@Setter
@Builder
public class GetAdminAddDisplayBoardDto {

    @Schema(example = "P01", description = "전광판 아이디")
    private String dispbd_no;

    @Schema(example = "BrdCast-01", description = "검색가능대상 : 전광판명 or 현장명 or 설치상태")
    private String search_text;

    @Schema(example = "10", description = "row수")
    private String limit;

    @Schema(example = "0", description = "조회시작 row_num")
    private String offset;
}
