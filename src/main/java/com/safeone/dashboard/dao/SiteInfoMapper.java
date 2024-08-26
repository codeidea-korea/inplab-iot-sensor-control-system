package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.SiteInfoDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface SiteInfoMapper {
    int selectSiteInfoListTotal(Map param);
    List<SiteInfoDto> selectSiteInfoList(Map param);
    int insertSiteInfo(Map param);
    int updateSiteInfo(Map param);
    int deleteSiteInfo(Map param);
}
    