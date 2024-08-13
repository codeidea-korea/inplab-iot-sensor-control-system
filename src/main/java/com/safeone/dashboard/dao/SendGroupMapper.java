package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.SendGroupDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface SendGroupMapper {
    List<SendGroupDto> selectSendGroupList(Map param);
    int selectSendGroupListTotal(Map param);
    boolean insertSendGroup(Map param);
    int updateSendGroup(Map param);
    int deleteSendGroup(Map param);
}
