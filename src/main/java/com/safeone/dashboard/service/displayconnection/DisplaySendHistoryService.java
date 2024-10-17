package com.safeone.dashboard.service.displayconnection;

import com.safeone.dashboard.dao.displayconnection.DisplaySendHistoryMapper;
import com.safeone.dashboard.dao.displayconnection.DisplaySendManagementMapper;
import com.safeone.dashboard.dto.displayconnection.DisplayGroupDto;
import com.safeone.dashboard.dto.displayconnection.DisplaySendHistoryDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class DisplaySendHistoryService implements JqGridService<DisplaySendHistoryDto> {

    private final DisplaySendHistoryMapper mapper;

    @Override
    public List<DisplaySendHistoryDto> getList(Map param) {
        return mapper.getList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.getTotalCount(param);
    }

    @Override
    public boolean create(Map param) {
        throw new UnsupportedOperationException("Unimplemented method 'create'");
    }

    @Override
    public DisplaySendHistoryDto read(int id) {
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        throw new UnsupportedOperationException("Unimplemented method 'update'");
    }

    @Override
    public int delete(Map param) {
        throw new UnsupportedOperationException("Unimplemented method 'delete'");
    }
}
