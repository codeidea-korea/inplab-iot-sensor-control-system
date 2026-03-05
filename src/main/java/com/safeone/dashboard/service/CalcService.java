package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.CalcMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class CalcService {

    private final CalcMapper mapper;

	public String getInitialValue(Map param) {
		return mapper.selectCalcByDeviceId(param);
	}

}
