package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Schema
@Getter
@Setter
@Builder
public class DelAdminAddBroadcastDto {

    @Schema(example = "B01", description = "방송장비 아이디")
    private String brdcast_no;
}
