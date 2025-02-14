package com.safeone.dashboard.controller.extend;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.safeone.dashboard.dto.JqGridResponse;
import com.safeone.dashboard.util.ExcelUtils;
import com.safeone.dashboard.util.ExcelUtils.FieldDetails;

@Slf4j
public abstract class JqGridAbstract<T> {
    private final Class<T> type;

    protected JqGridAbstract(Class<T> type) {
        this.type = type;
    }

    protected abstract List<T> getList(Map<String, Object> param);

    protected abstract int getTotalRows(Map<String, Object> param);

    protected abstract String setViewPage();

    @GetMapping(value = {"/", ""})
    public String index(Model model) {
        model.addAttribute("columns", (new Gson()).toJson(getColumnDataJson()));
        return setViewPage();
    }

    public Map<String, FieldDetails> getColumnDataJson() {
        return ExcelUtils.getPojoFieldNamesAndLabels(type);
    }

    @GetMapping(value = "/excel/{fileName}")
    public void downloadExcel(HttpServletRequest request, HttpServletResponse response,
                              @RequestParam Map<String, Object> param, @PathVariable String fileName) {
        param.put("page", "0");

        Map<String, FieldDetails> result = getColumnDataJson();
        List<Map<Object, Object>> list = ExcelUtils.convertListToMap((List<Object>) getList(param));

        List<Map<Object, Object>> excellist = this.getDownloadExcelDataList(result, list);
        ExcelUtils.downloadExcel(request, response, excellist, ExcelUtils.getPojoFieldNamesAndLabels(type), fileName + ".xls");
    }

    public List<Map<Object, Object>> getDownloadExcelDataList(Map<String, FieldDetails> result, List<Map<Object, Object>> list) {
        List<Map<Object, Object>> excellist = new ArrayList<>();
        Map<Object, Object> dataMap = new HashMap<>();

        for (Map<Object, Object> map : list) {
            Set<String> keySet = result.keySet();
            for (String key : keySet) {
                if (map.get(key) != null) {
                    dataMap.put(key, map.get(key));
                    String[] type = result.get(key).type.split(";");
                    for (String s : type) {
                        if (!":".equals(s.trim())) {
                            if (map.get(key).equals(s.split(":")[0])) {
                                dataMap.put(key, s.split(":")[1]);
                                break;
                            }
                        }
                    }
                }
            }
            excellist.add(dataMap);
            dataMap = new HashMap<>();
        }
        return excellist;
    }

    @ResponseBody
    @GetMapping(value = "/columns", produces = "application/json; charset=utf8")
    public Object getColumns() {
        return (new Gson()).toJson(getColumnDataJson());
    }

    @ResponseBody
    @GetMapping("/list")
    public JqGridResponse<T> list(@RequestParam Map<String, Object> param) {
        List<T> list = getList(param);
        int totalRows = getTotalRows(param);

        int rows = Integer.parseInt(param.get("rows").toString());
        int page = Integer.parseInt(param.get("page").toString());

        JqGridResponse<T> response = new JqGridResponse<>();
        response.setRows(list);
        response.setRecords(totalRows);
        response.setTotal((int) Math.ceil((double) totalRows / (double) rows));
        response.setPage(page);

        return response;
    }
}