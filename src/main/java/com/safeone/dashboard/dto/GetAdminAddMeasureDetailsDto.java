package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Schema
@Getter
@Setter
@Builder
public class GetAdminAddMeasureDetailsDto {

    @Schema(example = "S0048", description = "센서 아이디")
    private String sens_no;

    @Schema(example = "10", description = "row수")
    private String limit;

    @Schema(example = "0", description = "조회시작 row_num")
    private String offset;
}
