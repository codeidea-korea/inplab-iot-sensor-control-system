package com.safeone.dashboard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.ZoneDto;

@Repository
public interface ZoneMapper {
    int selectZoneListTotal(Map param);
    List<ZoneDto> selectZoneList(Map param);
    String getZoneIdByEtc1(String name);
    int insertZone(Map param);
    int updateZone(Map param);
    int updateZoneLocation(Map param);
    int deleteZone(Map param);
}
    