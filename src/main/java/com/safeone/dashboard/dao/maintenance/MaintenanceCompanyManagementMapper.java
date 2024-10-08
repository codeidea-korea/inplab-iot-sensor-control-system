package com.safeone.dashboard.dao.maintenance;

import com.safeone.dashboard.dto.maintenance.MaintenanceCompanyManagementDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface MaintenanceCompanyManagementMapper {
    int selectMaintenanceCompanyManagementListTotal(Map param);
    List<MaintenanceCompanyManagementDto> selectMaintenanceCompanyManagementList(Map param);
    int insertMaintenanceCompanyManagement(Map param);
    int updateMaintenanceCompanyManagement(Map param);
    int deleteMaintenanceCompanyManagement(Map param);
}
    