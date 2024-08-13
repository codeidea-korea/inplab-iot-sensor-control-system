package com.safeone.dashboard.dao;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.LoginLogDto;

import java.util.List;
import java.util.Map;

@Repository
public interface LoginLogMapper {
    int selectLoginLogListTotal(Map param);
    List<LoginLogDto> selectLoginLogList(Map param);
    int deleteLoginLog(Map param);
    int insertLoginLog(Map param);
}
    