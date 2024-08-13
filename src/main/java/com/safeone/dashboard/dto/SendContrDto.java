package com.safeone.dashboard.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 전광판 전송 제어
 * @TableName tb_send_contr
 */
@Data
public class SendContrDto implements Serializable {

    /**
     * 전송제어 ID
     */
    private String send_contr_id;

    /**
     * 전송그룹 ID
     */
    private String send_group_id;

    /**
     * 표시효과
     */
    private String dp_effect;

    /**
     * 표시효과명
     */
    private String dp_effect_name;

    /**
     * 표시시간
     */
    private String dp_time;

    /**
     * url 경로
     */
    private String url_path;

    /**
     * 파일명
     */
    private String filename;

    /**
     * 평시긴급구분
     */
    private String send_type;

    /**
     * 사용여부
     */
    private String use_yn;
}