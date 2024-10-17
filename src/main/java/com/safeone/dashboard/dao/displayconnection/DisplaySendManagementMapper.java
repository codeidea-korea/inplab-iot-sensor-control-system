package com.safeone.dashboard.dao.displayconnection;

import com.safeone.dashboard.dto.displayconnection.DisplayGroupDto;
import com.safeone.dashboard.dto.displayconnection.DisplaySendManagementDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface DisplaySendManagementMapper {
    List<DisplaySendManagementDto> selectDisplaySendManagementList(Map param);
    int selectDisplaySendManagementListTotal(Map param);
    boolean insertDisplaySendManagement(Map param);
    int updateDisplaySendManagement(Map param);
    int deleteDisplaySendManagement(Map param);

    List<DisplayGroupDto> selectDisplayGroupList(Map<String, Object> param);
}
