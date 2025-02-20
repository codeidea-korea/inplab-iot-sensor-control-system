package com.safeone.dashboard.domain.district.repository;

import com.safeone.dashboard.domain.district.dto.District;
import com.safeone.dashboard.domain.district.dto.UpdatePosition;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface DistrictMapper {
    int updatePosition(UpdatePosition updatePosition);

    List<District> getAll();
}
