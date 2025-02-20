package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

public interface JqGridService<T> {
    List<T> getList(Map<String, Object> param);
    int getTotalCount(Map<String, Object> param);
    boolean create(Map<String, Object> param);
    T read(int id);
    boolean update(Map<String, Object> param);
    int delete(Map<String, Object> param);
}
