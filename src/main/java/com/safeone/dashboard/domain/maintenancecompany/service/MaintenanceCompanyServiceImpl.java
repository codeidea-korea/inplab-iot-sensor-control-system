package com.safeone.dashboard.domain.maintenancecompany.service;

import com.safeone.dashboard.domain.maintenancecompany.dto.MaintenanceCompany;
import com.safeone.dashboard.domain.maintenancecompany.repository.MaintenanceCompanyMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class MaintenanceCompanyServiceImpl implements MaintenanceCompanyService {

    private final MaintenanceCompanyMapper maintenanceCompanyMapper;

    @Override
    public List<MaintenanceCompany> getAll() {
        return maintenanceCompanyMapper.getAll();
    }
}
