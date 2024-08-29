package com.safeone.dashboard.dao;

import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Mapper
@Repository("sensorAddMapper")
@RequiredArgsConstructor
public class SensorAddMapper {

    private final SqlSessionTemplate sqlSession;

    public List<HashMap<String, Object>> getSensorList(Map<String, Object> map) {
        return sqlSession.selectList("getSensorList", map);
    }

    public int getSensorListTotalCnt(Map<String, Object> map) {
        return sqlSession.selectOne("getSensorListTotalCnt", map);
    }

    public List<HashMap<String, Object>> getMeasureDetailsList(Map<String, Object> map) {
        return sqlSession.selectList("getMeasureDetailsList", map);
    }

    public int getMeasureDetailsListTotalCnt(Map<String, Object> map) {
        return sqlSession.selectOne("getMeasureDetailsListTotalCnt", map);
    }
}
