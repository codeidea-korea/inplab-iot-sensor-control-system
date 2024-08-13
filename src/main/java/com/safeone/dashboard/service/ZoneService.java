package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.ZoneMapper;
import com.safeone.dashboard.dto.ZoneDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ZoneService implements JqGridService<ZoneDto> {
    private final ZoneMapper mapper;

    @Override
    public List<ZoneDto> getList(Map param) {
        return mapper.selectZoneList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectZoneListTotal(param);
    }

	@Override
	public boolean create(Map param) {
		return mapper.insertZone(param) > 0;
	}

	@Override
	public ZoneDto read(int id) {
		// TODO Auto-generated method stub
		throw new UnsupportedOperationException("Unimplemented method 'read'");
	}
	
	public String getZoneIdByEtc1(String name) {
		return mapper.getZoneIdByEtc1(name);
	}

	@Override
	public boolean update(Map param) {		 
		return mapper.updateZone(param) > 0;
	}

	public boolean updateZoneLocation(Map param) {		 
		return mapper.updateZoneLocation(param) > 0;
	}

	@Override
	public int delete(Map param) {
		return mapper.deleteZone(param);
	}

}
