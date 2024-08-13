package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.DataMeasureMapper;
import com.safeone.dashboard.dto.OtherDataMeasureDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class RainDataMeasureService implements JqGridService<OtherDataMeasureDto> {

  private final DataMeasureMapper mapper;

  @Override
  public List<OtherDataMeasureDto> getList(Map param) {
	  return mapper.selectOtherDataMeasureList(param);
  }

  @Override
  public int getTotalCount(Map param) {
    return mapper.selectOtherDataMeasureListTotal(param);
  }

  @Override
  public boolean create(Map param) {
	return mapper.insertDataMeasure(param) > 0;
  }

  @Override
  public OtherDataMeasureDto read(int id) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'read'");
  }

  @Override
  public boolean update(Map param) {
	  throw new UnsupportedOperationException("Unimplemented method 'update'");
  }

  @Override
  public int delete(Map param) {
	  return mapper.deleteDataMeasure(param);
  }
}
