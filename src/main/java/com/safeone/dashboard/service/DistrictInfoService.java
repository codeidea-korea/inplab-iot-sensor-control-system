package com.safeone.dashboard.service;

import com.safeone.dashboard.dao.DistrictInfoMapper;
import com.safeone.dashboard.dto.DistrictInfoDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@RequiredArgsConstructor
@Slf4j
public class DistrictInfoService implements JqGridService<DistrictInfoDto> {
    private final DistrictInfoMapper mapper;

    @Override
    public List<DistrictInfoDto> getList(Map param) {
        return mapper.selectDistrictInfoList(param);
    }

	public List<DistrictInfoDto> getAll() {
		return mapper.selectAll();
	}



    @Override
    public int getTotalCount(Map param) {
        return mapper.selectDistrictInfoListTotal(param);
    }

    public int getDistrictInfoAbbrChk(Map param) {
        return mapper.selectDistrictInfoAbbrChk(param);
    }
	public int getDistrictInfoNmChk(Map param) {
        return mapper.selectDistrictInfoNmChk(param);
    }

	@Override
	public boolean create(Map param) {
		return mapper.insertDistrictInfo(param) > 0;
	}

	@Override
	public DistrictInfoDto read(int id) {
		// TODO Auto-generated method stub
		throw new UnsupportedOperationException("Unimplemented method 'read'");
	}
	
	public String getDistrictInfoIdByEtc1(String name) {
		return mapper.getDistrictInfoIdByEtc1(name);
	}

	@Override
	public boolean update(Map param) {		 
		return mapper.updateDistrictInfo(param) > 0;
	}

	public boolean updateDistrictInfoLocation(Map param) {		 
		return mapper.updateDistrictInfoLocation(param) > 0;
	}

	@Override
	public int delete(Map param) {
		return mapper.deleteDistrictInfo(param);
	}

    public String getMaxNo() {
		return mapper.selectMaxNo();
    }

    public String getNextDistrictNo() {
        String maxNo = mapper.selectMaxNo();
        if (maxNo == null || maxNo.trim().isEmpty()) {
            return "D01";
        }
        Matcher matcher = Pattern.compile("^(.*?)(\\d+)$").matcher(maxNo.trim());
        if (!matcher.matches()) {
            return maxNo.trim() + "01";
        }
        String prefix = matcher.group(1);
        String numericPart = matcher.group(2);
        int number = Integer.parseInt(numericPart) + 1;
        return prefix + String.format("%0" + numericPart.length() + "d", number);
    }
}
