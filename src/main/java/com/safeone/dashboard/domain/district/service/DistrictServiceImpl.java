package com.safeone.dashboard.domain.district.service;

import com.safeone.dashboard.domain.district.dto.District;
import com.safeone.dashboard.domain.district.dto.UpdatePosition;
import com.safeone.dashboard.domain.district.repository.DistrictMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class DistrictServiceImpl implements DistrictService {

    private final DistrictMapper districtMapper;

    @Override
    public int updatePosition(UpdatePosition updatePosition) {
        return districtMapper.updatePosition(updatePosition);
    }

    @Override
    public List<District> getAll() {
        return districtMapper.getAll();
    }

}
