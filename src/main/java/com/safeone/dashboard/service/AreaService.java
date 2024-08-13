package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.AreaMapper;
import com.safeone.dashboard.dao.CommonCodeMapper;
import com.safeone.dashboard.dto.AreaDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class AreaService implements JqGridService<AreaDto> {
    private final AreaMapper mapper;

    @Override
    public List<AreaDto> getList(Map param) {
        return mapper.selectAreaList(param);
    }
    
    @Override
    public int getTotalCount(Map param) {
        return mapper.selectAreaListTotal(param);
    }

	@Override
	public boolean create(Map param) {
		return mapper.insertArea(param) > 0;
	}

	@Override
	public AreaDto read(int id) {
		// TODO Auto-generated method stub
	    throw new UnsupportedOperationException("Unimplemented method 'read'");
	}

	@Override
	public boolean update(Map param) {
		return mapper.updateArea(param) > 0;
	}

	@Override
	public int delete(Map param) {
		return mapper.deleteArea(param);
	}

}
