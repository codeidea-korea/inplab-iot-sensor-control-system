package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.LoggerInfoDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface LoggerInfoMapper {
    int selectLoggerInfoListTotal(Map param);
    List<LoggerInfoDto> selectLoggerInfoList(Map param);
    int insertLoggerInfo(Map param);
    int updateLoggerInfo(Map param);
    int deleteLoggerInfo(Map param);

    LoggerInfoDto getLoggerInfo(Map param);
}
    