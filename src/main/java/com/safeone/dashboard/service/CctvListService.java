package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.CctvListMapper;
import com.safeone.dashboard.dto.CctvListDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class CctvListService implements JqGridService<CctvListDto> {
    private final CctvListMapper mapper;

    @Override
    public List<CctvListDto> getList(Map param) {
    	return mapper.selectCctvList(param);
    }

    @Override
    public int getTotalCount(Map param) {
    	return mapper.selectCctvListTotal(param);
    }

	@Override
	public boolean create(Map param) {
		// TODO Auto-generated method stub
		throw new UnsupportedOperationException("Unimplemented method 'create'");
	}

	@Override
	public CctvListDto read(int id) {
		// TODO Auto-generated method stub
		throw new UnsupportedOperationException("Unimplemented method 'read'");
	}

	@Override
	public boolean update(Map param) {
		// TODO Auto-generated method stub
		throw new UnsupportedOperationException("Unimplemented method 'update'");
	}

	@Override
	public int delete(Map param) {
		// TODO Auto-generated method stub
		throw new UnsupportedOperationException("Unimplemented method 'delete'");
	}
}
