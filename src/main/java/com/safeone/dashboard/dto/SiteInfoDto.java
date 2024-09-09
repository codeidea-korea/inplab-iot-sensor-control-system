package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class SiteInfoDto implements Serializable {

    @FieldLabel(title="ID", width=180)
    String site_no;

    @FieldLabel(title="관리 기관명", width=180)
    String site_nm;

    @FieldLabel(title="우편번호",  type="hidden")
    String site_zip;

    @FieldLabel(title="주소", width=180)
    String site_addr;

    @FieldLabel(title="도로명주소", type="hidden")
    String site_road_addr;

    @FieldLabel(title="시스템명칭", width=180)
    String site_sys_nm;

    @FieldLabel(title="지자체로고", width=180)
    String site_logo;
    
    @FieldLabel(title="지자체로고 명", type="hidden")
    String site_logo_nm;    
    
    @FieldLabel(title="지자체 타이틀 로고 명", type="hidden")
    String site_title_logo_nm;

    @FieldLabel(title="지자체 타이틀 로고")
    String site_title_logo;

    @FieldLabel(title="지자체로고 src", type="hidden")
    String site_logo_src;

}