package com.safeone.dashboard.dao;

import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Mapper
@Repository("cctvMapper")
@RequiredArgsConstructor
public class CctvMapper {

    private final SqlSessionTemplate sqlSession;

    public List<HashMap<String, Object>> getCctvList(Map<String, Object> map) {
        return sqlSession.selectList("getCctvList", map);
    }

    public int getCctvListTotalCnt(Map<String, Object> map) {
        return sqlSession.selectOne("getCctvListTotalCnt", map);
    }

    public int insCctv(Map<String, Object> map) {
        return sqlSession.insert("insCctv", map);
    }

    public int udtCctv(Map<String, Object> map) {
        return sqlSession.update("udtCctv", map);
    }

    public int delCctv(Map<String, Object> map) {
        return sqlSession.delete("delCctv", map);
    }

    public List<HashMap<String, Object>> getDistrictList(Map<String, Object> map) {
        return sqlSession.selectList("getDistrictList", map);
    }

    public int getDistrictListTotalCnt(Map<String, Object> map) {
        return sqlSession.selectOne("getDistrictListTotalCnt", map);
    }

    public List<HashMap<String, Object>> getGenerationKey2(Map<String, Object> map) {
        return sqlSession.selectList("getGenerationKey2", map);
    }

    public int nextPreCodeGenerationKey2(Map<String, Object> map) {
        return sqlSession.update("nextPreCodeGenerationKey2", map);
    }

    public int incMaxGenerationKey2(Map<String, Object> map) {
        return sqlSession.insert("incMaxGenerationKey2", map);
    }

    public List<HashMap<String, Object>> getMaintCompList(Map<String, Object> map) {
        return sqlSession.selectList("getMaintCompList", map);
    }

    public int getMaintCompListTotalCnt(Map<String, Object> map) {
        return sqlSession.selectOne("getMaintCompListTotalCnt", map);
    }
}
