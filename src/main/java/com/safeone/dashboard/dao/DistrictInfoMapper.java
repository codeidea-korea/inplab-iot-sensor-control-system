package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.DistrictInfoDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface DistrictInfoMapper {
    int selectDistrictInfoListTotal(Map param);
    List<DistrictInfoDto> selectDistrictInfoList(Map param);
    String getDistrictInfoIdByEtc1(String name);
    int insertDistrictInfo(Map param);
    int updateDistrictInfo(Map param);
    int updateDistrictInfoLocation(Map param);
    int deleteDistrictInfo(Map param);
}
    