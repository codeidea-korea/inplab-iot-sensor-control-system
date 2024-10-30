package com.safeone.dashboard.dao;

import com.safeone.dashboard.dto.SensorDto;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Mapper
@Repository("modifySensorMapper")
@RequiredArgsConstructor
public class ModifySensorMapper {

    private final SqlSessionTemplate sqlSession;

    public List<HashMap<String, Object>> getSensorList(Map<String, Object> map) {
        return sqlSession.selectList("com.safeone.dashboard.dao.ModifySensorMapper.selectSensorList", map);
    }

    public int getSensorListTotalCnt(Map<String, Object> map) {
        return sqlSession.selectOne("com.safeone.dashboard.dao.ModifySensorMapper.selectSensorListTotal", map);
    }

    public List<HashMap<String, Object>> getDistinctDistrict(Map<String, Object> map) {
        return sqlSession.selectList("com.safeone.dashboard.dao.ModifySensorMapper.getDistinctDistrict", map);
    }

    public List<HashMap<String, Object>> getDistinctSensorType(Map<String, Object> map) {
        return sqlSession.selectList("com.safeone.dashboard.dao.ModifySensorMapper.getDistinctSensorType", map);
    }

    public int getSimpleTotalCount(Map param) {
        return sqlSession.selectOne("com.safeone.dashboard.dao.ModifySensorMapper.getSimpleTotalCount", param);
    }

    public List<SensorDto> getAll(Map<String, Object> param) {
        return sqlSession.selectList("com.safeone.dashboard.dao.ModifySensorMapper.getAll", param);
    }
}
