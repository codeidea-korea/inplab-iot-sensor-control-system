package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.LoginLogMapper;
import com.safeone.dashboard.dto.LoginLogDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class LoginLogService implements JqGridService<LoginLogDto> {

	private final LoginLogMapper mapper;

	@Override
	public List<LoginLogDto> getList(Map param) {
		return mapper.selectLoginLogList(param);
	}

	@Override
	public int getTotalCount(Map param) {
		return mapper.selectLoginLogListTotal(param);
	}

	@Override
	public int delete(Map param) {
		return mapper.deleteLoginLog(param);
	}

	@Override
	public boolean create(Map param) {
		return mapper.insertLoginLog(param) > 0;
	}
	
	@Override
	public LoginLogDto read(int id) {
		throw new UnsupportedOperationException("Unimplemented method 'read'");
	}
	
	@Override
	public boolean update(Map param) {
		throw new UnsupportedOperationException("Unimplemented method 'update'");
	}
}
