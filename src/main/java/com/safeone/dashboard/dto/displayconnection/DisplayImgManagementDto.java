package com.safeone.dashboard.dto.displayconnection;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class DisplayImgManagementDto implements Serializable {
	
	@FieldLabel(title="ID", type="hidden")
    String mgnt_no;

    @FieldLabel(title="전송그룹", width=460)
    String img_grp_nm;

    @FieldLabel(title="설명", width=460)
    String img_grp_comment;

    @FieldLabel(title="사용여부", width=460, type=":;Y:사용;N:사용중지")
    String use_yn;

}