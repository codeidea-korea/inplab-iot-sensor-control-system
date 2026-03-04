package com.safeone.dashboard.dao;

import java.util.List;
import java.util.Map;

import com.safeone.dashboard.dto.EquipmentDto;
import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.AssetListDto;

@Repository
public interface AssetListMapper {
    List<EquipmentDto> selectEquipmentList(Map param);
}
