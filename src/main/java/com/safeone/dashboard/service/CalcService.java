package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.CalcMapper;
import com.safeone.dashboard.dto.CalcDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class CalcService implements JqGridService<CalcDto> {

    private final CalcMapper mapper;

    @Override
    public List<CalcDto> getList(Map param) {
        return mapper.selectCalcList(param);
    }

    @Override
    public int getTotalCount(Map param) {
        return mapper.selectCalcListTotal(param);
    }

    @Override
    public CalcDto read(int id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'read'");
    }

    @Override
    public boolean update(Map param) {
        return mapper.updateCalc(param) > 0;
    }

	@Override
	public boolean create(Map param) {
		// TODO Auto-generated method stub
		throw new UnsupportedOperationException("Unimplemented method 'create'");
	}
	
	public String getInitialValue(Map param) {
		return mapper.selectCalcByDeviceId(param);
	}

	@Override
	public int delete(Map param) {
		// TODO Auto-generated method stub
		throw new UnsupportedOperationException("Unimplemented method 'delete'");
	}
	
    public boolean initCalc() {
        return mapper.initCalc() > 0;
    }

}
