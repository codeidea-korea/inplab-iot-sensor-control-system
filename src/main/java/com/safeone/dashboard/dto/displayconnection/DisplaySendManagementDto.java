package com.safeone.dashboard.dto.displayconnection;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class DisplaySendManagementDto implements Serializable {

    @FieldLabel(title="관리 no", type = "hidden")
    private String mgnt_no;

    @FieldLabel(title="이미지")
    private String dispbd_imgfile_nm;

    @FieldLabel(title="이미지 경로", type = "hidden")
    private String img_file_path;

    @FieldLabel(title="효과")
    private String img_effect_nm;

    @FieldLabel(title="효과코드", type = "hidden")
    private String img_effect_cd;

    @FieldLabel(title="이벤트구분", type = "hidden")
    private String dispbd_evnt_flag;

    @FieldLabel(title="전송그룹", type = "hidden")
    private String img_grp_nm;

    @FieldLabel(title="표시시간", type = "hidden")
    private String img_disp_min;

    @FieldLabel(title="사용여부")
    private String use_yn;

    @FieldLabel(title="이미지사이즈")
    private String img_size;

    @FieldLabel(title="배경색")
    private String img_bg_color;

    @FieldLabel(title="폰트사이즈")
    private String font_size;

    @FieldLabel(title="폰트색상")
    private String font_color;

    @FieldLabel(title="상세정보")
    private String detail;

}
