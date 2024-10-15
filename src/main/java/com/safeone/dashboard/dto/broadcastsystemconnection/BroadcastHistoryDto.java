package com.safeone.dashboard.dto.broadcastsystemconnection;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class BroadcastHistoryDto implements Serializable {
    @FieldLabel(title = "No", width = 150)
    private int mgnt_no;

    @FieldLabel(title = "전송일시", type = "range")
    private String send_dt;

    @FieldLabel(title = "안내 문구", width = 400)
    private String brdcast_msg_dtls;

    @FieldLabel(title = "방송장비ID")
    private String brdcast_no;

    @FieldLabel(title = "전송결과")
    private String send_rslt_yn;

    @FieldLabel(title = "방송결과")
    private String broadcast_rslt_yn;

    @FieldLabel(title = "등록일시", type = "hidden")
    private String reg_dt;

    @FieldLabel(title = "수정일시", type = "hidden")
    private String mod_dt;

}
