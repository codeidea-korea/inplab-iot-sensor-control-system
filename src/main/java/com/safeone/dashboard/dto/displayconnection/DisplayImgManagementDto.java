package com.safeone.dashboard.dto.displayconnection;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class DisplayImgManagementDto implements Serializable {
	
	@FieldLabel(title="No", width=60)
    String mgnt_no;

    @FieldLabel(title="이벤트 구분", width=200, type=":;1:평시;2:긴급;3:센서경보")
    String dispbd_evnt_flag;

    @FieldLabel(title="전송그룹명", width=460)
    String img_grp_nm;

    @FieldLabel(title="센서경보기준", width=200, type=":;ARM001:관심;ARM002:주의;ARM003:경계;ARM004:심각")
    String alarm_lvl_cd;

    @FieldLabel(title="사용여부", width=460, type=":;Y:사용;N:사용중지")
    String use_yn;

    @FieldLabel(title="전송그룹설명", width=460)
    String img_grp_comment;

}