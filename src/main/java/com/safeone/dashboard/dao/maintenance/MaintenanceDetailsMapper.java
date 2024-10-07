package com.safeone.dashboard.dao.maintenance;

import com.safeone.dashboard.dto.maintenance.MaintenanceDetailsDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface MaintenanceDetailsMapper {
    int selectMaintenanceDetailsListTotal(Map param);

    List<MaintenanceDetailsDto> selectMaintenanceDetailsList(Map param);

    int insertMaintenanceDetails(Map param);

    int updateMaintenanceDetails(Map param);

    int deleteMaintenanceDetails(Map param);
}
    