package com.safeone.dashboard.dto.broadcastsystemconnection;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class BroadcastHistoryDto implements Serializable {
    @FieldLabel(title = "No", width = 70)
    private int mgnt_no;

    @FieldLabel(title = "전송일시", width = 170, type = "range")
    private String send_dt;

    @FieldLabel(title = "현장명", width = 120, type = "selectable")
    private String district_nm;

    @FieldLabel(title = "방송장비명", width = 140, type = "selectable")
    private String brdcast_nm;

    @FieldLabel(title = "안내제목", width = 220)
    private String brdcast_title;

    @FieldLabel(title = "전송결과", width = 90)
    private String send_rslt_yn;

    @FieldLabel(title = "방송결과", width = 90)
    private String broadcast_rslt_yn;

    @FieldLabel(title = "등록일시", type = "hidden")
    private String reg_dt;

    @FieldLabel(title = "수정일시", type = "hidden")
    private String mod_dt;

}
