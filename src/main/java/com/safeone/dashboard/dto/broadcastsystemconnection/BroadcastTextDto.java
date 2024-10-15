package com.safeone.dashboard.dto.broadcastsystemconnection;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class BroadcastTextDto implements Serializable {
    @FieldLabel(title = "No", width = 150)
    private int mgnt_no;

    @FieldLabel(title = "방송장비 No", type = "hidden")
    private String brdcast_no;

    @FieldLabel(title = "방송일시", type = "hidden")
    private String brdcast_dt;

    @FieldLabel(title = "안내 제목", width = 300)
    private String brdcast_title;

    @FieldLabel(title = "안내 문구", width = 300)
    private String brdcast_msg_dtls;

    @FieldLabel(title = "전송 성공 여부", type = "hidden")
    private String brdcast_rslt_yn;

    @FieldLabel(title = "상세 정보", type = "hidden")
    private String brdcast_contnts;

    @FieldLabel(title = "현장 No", type = "hidden")
    private String district_no;

    @FieldLabel(title = "등록일시", type = "hidden")
    private String reg_dt;

    @FieldLabel(title = "수정일시", type = "hidden")
    private String mod_dt;

}
