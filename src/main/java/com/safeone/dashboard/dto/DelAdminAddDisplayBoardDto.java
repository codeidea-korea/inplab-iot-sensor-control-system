package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Schema
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DelAdminAddDisplayBoardDto {

    @Schema(example = "P01", description = "전광판 아이디")
    private String dispbd_no;
}
