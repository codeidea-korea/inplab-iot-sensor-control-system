package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.EmergencyCallDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface EmergencyCallMapper {
	List<EmergencyCallDto> selectEmergencyCallList(Map param);
    int selectEmergencyCallListTotal(Map param);
    int insertEmergencyCall(Map param);
    int updateEmergencyCall(Map param);
    int deleteEmergencyCall(Map param);
}
    