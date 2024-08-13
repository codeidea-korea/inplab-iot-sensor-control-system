package com.safeone.dashboard.service;

import java.util.List;
import java.util.Map;

public interface JqGridService<T> {
    List<T> getList(Map param);
    int getTotalCount(Map param);
    boolean create(Map param);
    T read(int id);
    boolean update(Map param);
    int delete(Map param);
}
