package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.LogrIdxMapDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface LogrIdxMapMapper {
    int selectLogrIdxMapListTotal(Map param);
    List<LogrIdxMapDto> selectLogrIdxMapList(Map param);
    int insertLogrIdxMap(Map param);
    int updateLogrIdxMap(Map param);
    int deleteLogrIdxMap(Map param);

    void updateLogrIdx(LogrIdxMapDto dto);
}
    