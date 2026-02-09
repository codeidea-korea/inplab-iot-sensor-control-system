package com.safeone.dashboard.dto.broadcastsystemconnection;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class BroadcastTextDto implements Serializable {
    @FieldLabel(title = "No", width = 70)
    private int mgnt_no;

    @FieldLabel(title = "안내제목", width = 190, type = "editable")
    private String brdcast_title;

    @FieldLabel(title = "안내문구", width = 420, type = "editable")
    private String brdcast_msg_dtls;
}
