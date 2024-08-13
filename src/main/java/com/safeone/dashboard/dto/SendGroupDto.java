package com.safeone.dashboard.dto;

import com.safeone.dashboard.config.annotate.FieldLabel;
import lombok.Data;

import java.io.Serializable;

@Data
public class SendGroupDto implements Serializable {
	
	@FieldLabel(title="전송그룹 ID", type="hidden")
    String send_group_id;

    @FieldLabel(title="전송그룹", width=460)
    String send_group_name;

    @FieldLabel(title="설명", width=460)
    String description;

    @FieldLabel(title="사용여부", width=460, type=":;Y:사용;N:사용중지")
    String use_yn;

}