package com.safeone.dashboard.domain.smsreceiver.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class SmsReceiverCreate {

    private String partnerCompId;
    private String smsRecvDept;
    private String smsRecvPh;
    private String districtNo;
    private String smsChgrNm;
    private String alarmLvlNm;
    private String smsAutosndYn;

}
