package com.safeone.dashboard.service.displayconnection;

import com.safeone.dashboard.dao.displayconnection.DisplayImgManagementMapper;
import com.safeone.dashboard.dto.displayconnection.DisplayImgManagementDto;
import com.safeone.dashboard.service.JqGridService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class DisplayImgManagementService implements JqGridService<DisplayImgManagementDto> {

    private final DisplayImgManagementMapper mapper;

    @Override
    public List<DisplayImgManagementDto> getList(Map param) {
        return mapper.selectDisplayImgManagementList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectDisplayImgManagementListTotal(param);
    }

    @Override
    public boolean create(Map param) {
        return mapper.insertDisplayImgManagement(param);
    }

    @Override
    public DisplayImgManagementDto read(int id) {
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateDisplayImgManagement(param) > 0;
    }

    @Override
    public int delete(Map param) {
        return mapper.deleteDisplayImgManagement(param);
    }

    public boolean createGroup(Map<String, Object> param) {
        return mapper.insertGroup(param);
    }
}
