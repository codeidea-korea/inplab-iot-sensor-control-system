package com.safeone.dashboard.service.displayconnection;

import com.safeone.dashboard.dao.displayconnection.DisplaySendManagementMapper;
import com.safeone.dashboard.dto.displayconnection.DisplaySendManagementDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class DisplaySendManagementService implements JqGridService<DisplaySendManagementDto> {

    private final DisplaySendManagementMapper mapper;

    @Override
    public List<DisplaySendManagementDto> getList(Map param) {
        return mapper.selectDisplaySendManagementList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectDisplaySendManagementListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertDisplaySendManagement(param);
    }

    @Override
    public DisplaySendManagementDto read(int id) {
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateDisplaySendManagement(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteDisplaySendManagement(param);
    }
}
