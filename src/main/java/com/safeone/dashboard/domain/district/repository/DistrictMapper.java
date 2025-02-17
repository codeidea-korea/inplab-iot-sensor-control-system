package com.safeone.dashboard.domain.district.repository;

import com.safeone.dashboard.domain.district.dto.UpdatePosition;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DistrictMapper {
    int updatePosition(UpdatePosition updatePosition);
}
