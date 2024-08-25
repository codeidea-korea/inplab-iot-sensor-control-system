package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Schema
@Getter
@Setter
@Builder
public class GetAdminAddMaintCompDto {

    @Schema(example = "1", description = "파트너타입")
    private String partner_type_flag;
}
