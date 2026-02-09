package com.safeone.dashboard.dao.displayconnection;

import com.safeone.dashboard.dto.displayconnection.DisplayImgManagementDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface DisplayImgManagementMapper {
    List<DisplayImgManagementDto> selectDisplayImgManagementList(Map param);
    int selectDisplayImgManagementListTotal(Map param);
    boolean insertDisplayImgManagement(Map param);
    int updateDisplayImgManagement(Map param);
    int deleteDisplayImgManagement(Map param);
    boolean insertDisplayMapping(Map param);

    boolean insertGroup(Map<String, Object> param);
}
