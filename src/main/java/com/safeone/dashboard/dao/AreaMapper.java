package com.safeone.dashboard.dao;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.AreaDto;

import java.util.List;
import java.util.Map;

@Repository
public interface AreaMapper {
    int selectAreaListTotal(Map param);
    List<AreaDto> selectAreaList(Map param);
    int insertArea(Map param);
    int updateArea(Map param);
    int deleteArea(Map param);
}
    