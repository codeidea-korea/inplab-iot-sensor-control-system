package com.safeone.dashboard.dao;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.DataMeasureDto;
import com.safeone.dashboard.dto.OtherDataMeasureDto;

import java.util.List;
import java.util.Map;

@Repository
public interface DataMeasureMapper {
    int selectDataMeasureListTotal(Map param);
    List<DataMeasureDto> selectDataMeasureList(Map param);
    int insertDataMeasure(Map param);
    int deleteDataMeasure(Map param);
    
    int selectOtherDataMeasureListTotal(Map param);
    List<OtherDataMeasureDto> selectOtherDataMeasureList(Map param);
}
    