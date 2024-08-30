package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import java.util.HashMap;
import java.util.List;

@Schema
@Getter
@Setter
public class InsAdminAddMeasureDetailsDto {

    @Schema(example = "", description = "insert할 데이터")
    private List<HashMap<String, Object>> ins_arr;

    @Schema(example = "", description = "delete할 데이터")
    private List<String> del_arr;

}
