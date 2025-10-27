package com.safeone.dashboard.dao;

import java.util.List;
import java.util.Map;

import com.safeone.dashboard.dto.EquipmentDto;
import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.AssetListDto;

@Repository
public interface AssetListMapper {
    List<AssetListDto> selectAssetList(Map param);
    List<EquipmentDto> selectEquipmentList(Map param);
    int selectAssetListTotal(Map param);
    int insertAsset(Map param);
    int updateAsset(Map param);
    int deleteAsset(Map param);
    
    int insertChannel(Map param);
    int deleteChannel(Map param);

    int insertCalc(Map param);
    int deleteCalc(Map param);
    
    int insertManage(Map param);
    int deleteManage(Map param);

    Map selectAssetInfo(String assetId);
}
