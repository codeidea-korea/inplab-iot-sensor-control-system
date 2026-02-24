package com.safeone.dashboard.dto.displayconnection;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class DisplaySendHistoryDto implements Serializable {

    @FieldLabel(title = "No")
    private String mgnt_no;

    @FieldLabel(title = "전광판번호", type = "hidden")
    private String dispbd_no;

    @FieldLabel(title = "전송일시")
    private String sms_trans_dt;

    @FieldLabel(title = "현장명")
    private String district_nm;

    @FieldLabel(title = "전광판위치")
    private String dispbd_nm;

    @FieldLabel(title = "이벤트 구분", type = ":;1:평시;2:긴급;3:센서경보")
    private String dispbd_evnt_flag;

    @FieldLabel(title = "전송 그룹")
    private String dispbd_group;

    @FieldLabel(title = "자동전송여부", type = "hidden")
    private String dispbd_autosnd_yn;

    @FieldLabel(title = "전송결과")
    private String dispbd_rslt_yn;

}
