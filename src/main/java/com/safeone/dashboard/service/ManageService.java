package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.ManageMapper;
import com.safeone.dashboard.dto.ManageDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class ManageService implements JqGridService<ManageDto> {

    private final ManageMapper mapper;

    @Override
    public List<ManageDto> getList(Map param) {
        return mapper.selectManageList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectManageListTotal(param);
    }

    @Override
    public boolean create(Map param) {
    	// TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'create'");
    }

    @Override
    public ManageDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateManage(param) > 0;
    }

    @Override
    public int delete(Map param) {
    	// TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'delete'");
    }
}
