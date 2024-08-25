package com.safeone.dashboard.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Schema
@Getter
@Setter
public class ExcelDto {

    @Schema(example = "[\"CCTV ID\",\"CCTV 명\",\"모델명\"]", description = "헤더리스트")
    private List<String> header;

    @Schema(example = "[[\"T01\",\"JC1CCTV-01\",\"JIT-P4271RH\"],[\"T02\",\"JC2CCTV-01\",\"JIT-P4271RH\"]]", description = "데이터")
    private List<List<String>> rows;

    @Schema(example = "CCTV 관리", description = "파일명")
    private String file_name;

}
