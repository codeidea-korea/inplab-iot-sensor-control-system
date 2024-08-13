package com.safeone.dashboard.dao;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.MaintenanceDto;

import java.util.List;
import java.util.Map;

@Repository
public interface MaintenanceMapper {
    int selectMaintenanceListTotal(Map param);
    List<MaintenanceDto> selectMaintenanceList(Map param);
    int insertMaintenance(Map param);
    int updateMaintenance(Map param);
    int deleteMaintenance(Map param);
}
    