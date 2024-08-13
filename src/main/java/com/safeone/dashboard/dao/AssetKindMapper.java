package com.safeone.dashboard.dao;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.AssetKindDto;

import java.util.List;
import java.util.Map;

@Repository
public interface AssetKindMapper {
    int selectAssetKindListTotal(Map param);
    List<AssetKindDto> selectAssetKindList(Map param);
    int insertAssetKind(Map param);
    int updateAssetKind(Map param);
    int deleteAssetKind(Map param);
    int isAssetKindName(Map param);
}
    