package com.safeone.dashboard.service.maintenance;

import com.safeone.dashboard.dao.maintenance.MaintenanceDetailsMapper;
import com.safeone.dashboard.dto.maintenance.MaintenanceDetailsDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class MaintenanceDetailsService implements JqGridService<MaintenanceDetailsDto> {

    private final MaintenanceDetailsMapper mapper;

    @Override
    public List<MaintenanceDetailsDto> getList(Map param) {
        return mapper.selectMaintenanceDetailsList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectMaintenanceDetailsListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertMaintenanceDetails(param) > 0;
    }

    @Override
    public MaintenanceDetailsDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateMaintenanceDetails(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteMaintenanceDetails(param);
    }
}
