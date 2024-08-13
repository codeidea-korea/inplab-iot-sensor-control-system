package com.safeone.dashboard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.safeone.dashboard.dto.SensorDto;

@Repository
public interface SensorMapper {
	//센서목록
    int selectSensorListTotal(Map param);
    List<SensorDto> selectSensorList(Map param);
    
    int selectGroupSensorTotal(Map param);
    List<SensorDto> selectGroupSensorList(Map param);
    
    //계측기 데이터 관리 - 좌측목록
    int selectSensorByChannelListTotal(Map param);
    List<SensorDto> selectSensorByChannelList(Map param);
}
    