package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.AssetKindMapper;
import com.safeone.dashboard.dto.AssetKindDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class AssetKindService implements JqGridService<AssetKindDto> {

  private final AssetKindMapper mapper;

  @Override
  public List<AssetKindDto> getList(Map param) {
    return mapper.selectAssetKindList(param);
  }

  @Override
  public int getTotalCount(Map param) {
    return mapper.selectAssetKindListTotal(param);
  }

  @Override
  public boolean create(Map param) {
    return mapper.insertAssetKind(param) > 0;
  }

  @Override
  public AssetKindDto read(int id) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'read'");
  }

  @Override
  public boolean update(Map param) {
    return mapper.updateAssetKind(param) > 0;
  }

  @Override
  public int delete(Map param) {
    return mapper.deleteAssetKind(param);
  }
}
