package com.safeone.dashboard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.CctvListDto;

@Repository
public interface CctvListMapper {
    List<CctvListDto> selectCctvList(Map param);
    int selectCctvListTotal(Map param);    
}
