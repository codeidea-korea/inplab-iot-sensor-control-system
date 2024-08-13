package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.safeone.dashboard.dao.DataMeasureMapper;
import com.safeone.dashboard.dto.DataMeasureDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class DataMeasureService implements JqGridService<DataMeasureDto> {

  private final DataMeasureMapper mapper;

  @Override
  public List<DataMeasureDto> getList(Map param) {
	  return mapper.selectDataMeasureList(param);
  }

  @Override
  public int getTotalCount(Map param) {
    return mapper.selectDataMeasureListTotal(param);
  }

  @Override
  public boolean create(Map param) {
	return mapper.insertDataMeasure(param) > 0;
  }

  @Override
  public DataMeasureDto read(int id) {
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
