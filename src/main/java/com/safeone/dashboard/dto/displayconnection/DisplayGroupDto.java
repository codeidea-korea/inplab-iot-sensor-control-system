package com.safeone.dashboard.dto.displayconnection;

import lombok.Data;

import java.io.Serializable;

@Data
public class DisplayGroupDto implements Serializable {

    private String mgnt_no;
    private String img_grp_nm;
    private String img_grp_comment;
    private String use_yn;
    private String reg_dt;
    private String mod_dt;

}