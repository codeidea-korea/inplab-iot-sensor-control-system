package com.safeone.dashboard.dao;

import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Mapper
@Repository("displayBoardMapper")
@RequiredArgsConstructor
public class DisplayBoardMapper {

    private final SqlSessionTemplate sqlSession;

    public List<HashMap<String, Object>> getDisplayBoardList(Map<String, Object> map) {
        return sqlSession.selectList("getDisplayBoardList", map);
    }

    public int getDisplayBoardListTotalCnt(Map<String, Object> map) {
        return sqlSession.selectOne("getDisplayBoardListTotalCnt", map);
    }

    public int insDisplayBoard(Map<String, Object> map) {
        return sqlSession.insert("insDisplayBoard", map);
    }

    public int udtDisplayBoard(Map<String, Object> map) {
        return sqlSession.update("udtDisplayBoard", map);
    }

    public int delDisplayBoard(Map<String, Object> map) {
        return sqlSession.delete("delDisplayBoard", map);
    }

}
