package com.safeone.dashboard.dao;

import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Mapper
@Repository("broadcastMapper")
@RequiredArgsConstructor
public class BroadcastMapper {

    private final SqlSessionTemplate sqlSession;

    public List<HashMap<String, Object>> getBroadcastList(Map<String, Object> map) {
        return sqlSession.selectList("getBroadcastList", map);
    }

    public int getBroadcastListTotalCnt(Map<String, Object> map) {
        return sqlSession.selectOne("getBroadcastListTotalCnt", map);
    }

    public int insBroadcast(Map<String, Object> map) {
        return sqlSession.insert("insBroadcast", map);
    }

    public int udtBroadcast(Map<String, Object> map) {
        return sqlSession.update("udtBroadcast", map);
    }

    public int delBroadcast(Map<String, Object> map) {
        return sqlSession.delete("delBroadcast", map);
    }

}
