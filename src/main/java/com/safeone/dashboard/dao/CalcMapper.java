package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.CalcDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface CalcMapper {
    String selectCalcByDeviceId(Map param);
}
    