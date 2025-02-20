package com.safeone.dashboard.domain.maintenancecompany.repository;

import com.safeone.dashboard.domain.maintenancecompany.dto.MaintenanceCompany;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MaintenanceCompanyMapper {
    List<MaintenanceCompany> getAll();
}
