package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.CalcDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface CalcMapper {
    int selectCalcListTotal(Map param);
    List<CalcDto> selectCalcList(Map param);
    int updateCalc(Map param);
    String selectCalcByDeviceId(Map param);
    int initCalc();
}
    