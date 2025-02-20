package com.safeone.dashboard.domain.maintenancecompany;

import com.safeone.dashboard.domain.maintenancecompany.dto.MaintenanceCompany;
import com.safeone.dashboard.domain.maintenancecompany.service.MaintenanceCompanyService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/maintenance-companies")
@RequiredArgsConstructor
public class MaintenanceCompanyController {

    private final MaintenanceCompanyService maintenanceCompanyService;

    @GetMapping("/all")
    public List<MaintenanceCompany> getAll() {
        return maintenanceCompanyService.getAll();
    }
}
