package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class DistrictInfoDto implements Serializable {
    @FieldLabel(title = "기관 ID", type = "hidden")
    String site_no;

    @FieldLabel(title = "ID")
    String district_no;

    @FieldLabel(title = "현장명")
    String district_nm;

    @FieldLabel(title = "주소")
    String dist_addr;

    @FieldLabel(title = "우편번호", type = "hidden")
    String dist_zip;

    @FieldLabel(title = "도로명", type = "hidden")
    String dist_road_addr;

    @FieldLabel(title = "현장구분", type = "hidden")
    String dist_type_cd;

    @FieldLabel(title = "현장구분")
    String dist_type_cd_nm;

    @FieldLabel(title = "현장사진", type = "hidden")
    String dist_pic;

    @FieldLabel(title = "전경도사진", type = "hidden")
    String dist_view_pic;

    @FieldLabel(title = "현장사진_src", type = "hidden")
    String dist_pic_src;

    @FieldLabel(title = "전경도사진_src", type = "hidden")
    String dist_view_pic_src;

    @FieldLabel(title = "경도", type = "hidden")
    String dist_lon;

    @FieldLabel(title = "위도", type = "hidden")
    String dist_lat;

    @FieldLabel(title = "시공사1", type = "hidden")
    String inst_comp_id1;

    @FieldLabel(title = "시공사1")
    String inst_comp_id1_nm;

    @FieldLabel(title = "계측사1", type = "hidden")
    String meas_comp_id1;

    @FieldLabel(title = "계측사1")
    String meas_comp_id1_nm;

    @FieldLabel(title = "시공사2", type = "hidden")
    String inst_comp_id2;

    @FieldLabel(title = "계측사2", type = "hidden")
    String meas_comp_id2;

    @FieldLabel(title = "계측시작일")
    String meas_str_ymd;

    @FieldLabel(title = "계측종료일")
    String meas_end_ymd;

    @FieldLabel(title = "현장약어")
    String dist_abbr;

    @FieldLabel(title = "관리사업소명")
    String dist_offi_nm;


}
