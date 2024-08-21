package com.safeone.dashboard.dto;

import java.io.Serializable;

import com.safeone.dashboard.config.annotate.FieldLabel;

import lombok.Data;

@Data
public class LoginLogDto implements Serializable {
    @FieldLabel(title="로그 ID", type="hidden")
    String login_log_id;
	
    @FieldLabel(title="사용자 ID", width=200)
    String usr_id;
//    String user_id;
    
    @FieldLabel(title="사용자 명", width=250)
    String usr_nm;
//    String name;
    
    @FieldLabel(title="로그인 일시", width=250, type = "timestamp_range")
    String login_date;
    
    @FieldLabel(title="접속 IP", width=250)
    String login_ip;
    
    @FieldLabel(title="접속 정보", width=250)
    String login_pc_name;
    
    @FieldLabel(title="결과", width = 200)
    String status;
}