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
import com.safeone.dashboard.util.ExcelUtil;
import com.safeone.dashboard.util.ExcelUtil.FieldDetails;

@Slf4j
public abstract class JqGridAbstract<T> {
    private Class<T> type;

    protected JqGridAbstract(Class<T> type) {
        this.type = type;
    }
    /**
     * 그리드의 내용을 리턴
     * 
     * @param param
     * @return
     */
    protected abstract List<T> getList(Map param);

    /**
     * 데이터의 총 갯수를 리턴
     * 
     * @param param
     * @return
     */
    protected abstract int getTotalCount(Map param);

    protected abstract String setViewPage();

    @GetMapping(value = { "/", "" })
    public String main(Model model) {
        model.addAttribute("columns", (new Gson()).toJson(getColumnDataJson()));
        return setViewPage();
    }
    //콤보박스 조회에 사용 
    public Map<String, FieldDetails> getColumnDataJson() {
        return ExcelUtil.getPojoFieldNamesAndLabels(type);
    }

    @GetMapping(value = "/excel/{fileName}")
    public void downloadExcel(HttpServletRequest request, HttpServletResponse response,
                              @RequestParam Map<String, Object> param, @PathVariable String fileName) {
        param.put("page", "0");

        //20231228 다운로드엑셀리스트 재가공
        Map<String, FieldDetails> result = getColumnDataJson();
        List<Map> list = ExcelUtil.convertListToMap((List<Object>) getList(param));

        List<Map> excellist = this.getDownloadExcelDataList(result, list);
        ExcelUtil.downloadExcel(request, response, excellist, ExcelUtil.getPojoFieldNamesAndLabels(type), fileName + ".xls");
    }

    public List<Map> getDownloadExcelDataList(Map<String, FieldDetails> result, List<Map> list){
        List<Map> excellist = new ArrayList<>();
        Map dataMap = new HashMap();

        for (Map map : list) {
//            log.info(map.toString());
            Set<String> keySet = result.keySet();
            for (String key : keySet) {
                if(map.get(key) != null){
                    dataMap.put(key, map.get(key));

                    String[] type = result.get(key).type.split(";");
                    for (int i = 0; i < type.length; i++) {
                        if(!":".equals(type[i].trim())){
                            if(map.get(key).equals(type[i].split(":")[0]) ){
//                                log.info(type[i].split(":")[0], type[i].split(":")[1]);
                                dataMap.put(key, type[i].split(":")[1]);
                                break;
                            }
                        }
                    }
                }
            }
            excellist.add(dataMap);
            dataMap = new HashMap();
        }
        return excellist;
    }

    @ResponseBody
    @GetMapping(value="/columns", produces="application/json; charset=utf8")
    public Object getColumns() {
        return (new Gson()).toJson(getColumnDataJson());
    }

    @ResponseBody
    @GetMapping("/list")
    public JqGridResponse<T> list(@RequestParam Map<String, Object> param) {
        List<T> list = getList(param);
        int totalRows = getTotalCount(param);

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