package com.safeone.dashboard.service.maintenance;

import com.safeone.dashboard.dao.maintenance.MaintenanceCompanyManagementMapper;
import com.safeone.dashboard.dto.maintenance.MaintenanceCompanyManagementDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class MaintenanceCompanyManagementService implements JqGridService<MaintenanceCompanyManagementDto> {

    private final MaintenanceCompanyManagementMapper mapper;

    @Override
    public List<MaintenanceCompanyManagementDto> getList(Map param) {
        return mapper.selectMaintenanceCompanyManagementList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectMaintenanceCompanyManagementListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        String biggestIdString = mapper.getBiggestId(); // C01, C02, C03, ...
        int biggestId = Integer.parseInt(biggestIdString.substring(1));
        String partner_comp_id = "C" + String.format("%02d", biggestId + 1);
        param.put("partner_comp_id", partner_comp_id);
        return mapper.insertMaintenanceCompanyManagement(param) > 0;
    }

    @Override
    public MaintenanceCompanyManagementDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateMaintenanceCompanyManagement(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteMaintenanceCompanyManagement(param);
    }

    public List<MaintenanceCompanyManagementDto> getAll() {
        return mapper.selectAllMaintenanceCompanyManagementList();
    }
}
