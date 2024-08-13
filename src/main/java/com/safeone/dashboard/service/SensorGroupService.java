package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.SensorMapper;
import com.safeone.dashboard.dto.SensorDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class SensorGroupService implements JqGridService<SensorDto> {
    private final SensorMapper mapper;

    @Override
    public List<SensorDto> getList(Map param) {
        return mapper.selectGroupSensorList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectGroupSensorTotal(param);
    }

	@Override
	public boolean create(Map param) {
		throw new UnsupportedOperationException("Unimplemented method 'create'");//return false;
	}

	@Override
	public SensorDto read(int id) {
		throw new UnsupportedOperationException("Unimplemented method 'read'");//return null;
	}

	@Override
	public boolean update(Map param) {
		throw new UnsupportedOperationException("Unimplemented method 'update'");//return false;
	}

	@Override
	public int delete(Map param) {
		throw new UnsupportedOperationException("Unimplemented method 'delete'");//return 0;
	}
}
