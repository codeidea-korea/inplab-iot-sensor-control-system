package com.safeone.dashboard.service.maintenance;

import java.util.List;
import java.util.Map;

import com.safeone.dashboard.service.JqGridService;
import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.maintenance.MaintenanceManageMapper;
import com.safeone.dashboard.dto.maintenance.MaintenanceManageDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class MaintenanceManageService implements JqGridService<MaintenanceManageDto> {

    private final MaintenanceManageMapper mapper;

    @Override
    public List<MaintenanceManageDto> getList(Map param) {
        return mapper.selectMaintenanceList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectMaintenanceListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertMaintenance(param) > 0;
    }

    @Override
    public MaintenanceManageDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateMaintenance(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteMaintenance(param);
    }
}
