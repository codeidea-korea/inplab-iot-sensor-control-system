package com.safeone.dashboard.dto.displayconnection;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class DisplaySendManagementDto implements Serializable {

    @FieldLabel(title="관리 no", type = "hidden")
    private String mgnt_no;

	@FieldLabel(title="이미지")
    private String img_file_path;

    @FieldLabel(title="효과")
    private String img_effect_cd;

    @FieldLabel(title="표시시간(Sec)")
    private String img_disp_min;

    @FieldLabel(title="사용여부")
    private String use_yn;

    @FieldLabel(title="수정")
    private String edit;

    @FieldLabel(title="삭제")
    private String del;

}