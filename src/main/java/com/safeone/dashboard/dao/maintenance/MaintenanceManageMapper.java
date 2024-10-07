package com.safeone.dashboard.dao.maintenance;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.maintenance.MaintenanceManageDto;

import java.util.List;
import java.util.Map;

@Repository
public interface MaintenanceManageMapper {
    int selectMaintenanceListTotal(Map param);
    List<MaintenanceManageDto> selectMaintenanceList(Map param);
    int insertMaintenance(Map param);
    int updateMaintenance(Map param);
    int deleteMaintenance(Map param);
}
    