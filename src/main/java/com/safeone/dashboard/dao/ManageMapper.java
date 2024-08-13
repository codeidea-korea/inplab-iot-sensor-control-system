package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.ManageDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface ManageMapper {
    int selectManageListTotal(Map param);
    List<ManageDto> selectManageList(Map param);
    int updateManage(Map param);
}
    