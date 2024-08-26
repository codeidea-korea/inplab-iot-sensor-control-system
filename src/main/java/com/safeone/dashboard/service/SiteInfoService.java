package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.SiteInfoMapper;
import com.safeone.dashboard.dto.SiteInfoDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class SiteInfoService implements JqGridService<SiteInfoDto> {
    private final SiteInfoMapper mapper;

    @Override
    public List<SiteInfoDto> getList(Map param) {
        return mapper.selectSiteInfoList(param);
    }
    
    @Override
    public int getTotalCount(Map param) {
        return mapper.selectSiteInfoListTotal(param);
    }

	@Override
	public boolean create(Map param) {
		return mapper.insertSiteInfo(param) > 0;
	}

	@Override
	public SiteInfoDto read(int id) {
		// TODO Auto-generated method stub
	    throw new UnsupportedOperationException("Unimplemented method 'read'");
	}

	@Override
	public boolean update(Map param) {
		return mapper.updateSiteInfo(param) > 0;
	}

	@Override
	public int delete(Map param) {
		return mapper.deleteSiteInfo(param);
	}

}
