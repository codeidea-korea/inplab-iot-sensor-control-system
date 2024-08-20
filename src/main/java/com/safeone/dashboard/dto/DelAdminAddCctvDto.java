package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Schema
@Getter
@Setter
@Builder
public class DelAdminAddCctvDto {

    @Schema(example = "T01", description = "cctv 아이디")
    private String cctv_no;
}
