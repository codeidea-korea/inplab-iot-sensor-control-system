package com.safeone.dashboard.dao.operationconfigurationsetting;

import com.safeone.dashboard.dto.operationconfigurationsetting.UserManagementDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface UserManagementMapper {
    int updateExpiredUsersUseYn();

    int selectUserManagementListTotal(Map param);

    List<UserManagementDto> selectUserManagementList(Map param);

    int insertUserManagement(Map param);

    int updateUserManagement(Map param);

    int deleteUserManagement(Map param);

    int selectByUserId(Map param);
}
    
