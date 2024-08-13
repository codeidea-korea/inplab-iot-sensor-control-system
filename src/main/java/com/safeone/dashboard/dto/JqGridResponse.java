package com.safeone.dashboard.dto;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class JqGridResponse<T> {
    private int page;
    private int total;
    private int records;
    private List<T> rows;

    public JqGridResponse() {
        this.rows = new ArrayList<T>();
    }
}
