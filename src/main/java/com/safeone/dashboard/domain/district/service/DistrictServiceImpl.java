package com.safeone.dashboard.domain.district.service;

import com.safeone.dashboard.domain.district.dto.UpdatePosition;
import com.safeone.dashboard.domain.district.repository.DistrictMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class DistrictServiceImpl implements DistrictService {

    private final DistrictMapper districtMapper;

    @Override
    public int updatePosition(UpdatePosition updatePosition) {
        return districtMapper.updatePosition(updatePosition);
    }

}
