package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.DistrictInfoDto;
import com.safeone.dashboard.service.CommonCodeEditService;
import com.safeone.dashboard.service.DistrictInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/adminAdd/districtInfo")
public class DistrictInfoController extends JqGridAbstract<DistrictInfoDto> {
    @Autowired
    private DistrictInfoService districtInfoService;

    @Autowired
    private CommonCodeEditService commonCodeEditService;

    protected DistrictInfoController() {
        super(DistrictInfoDto.class);
    }

    @Override
    protected List getList(Map param) {
        return districtInfoService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        return districtInfoService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/districtInfo";
    }

    @ResponseBody
    @GetMapping("/all")
    public List<DistrictInfoDto> getAll() {
        return districtInfoService.getAll();
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        boolean exists = commonCodeEditService.isLoggerNoExists(param);
        if (exists) {
            return -1; // -1은 삭제 불가 상태를 의미함.
        }
        // 삭제 수행
        return districtInfoService.delete(param); // 1: 성공, 0: 실패 (삭제할 항목이 없거나 삭제 실패)
    }

    @ResponseBody
    @PostMapping("/add")
    public synchronized Map<String, Object> insert(HttpServletRequest request, @RequestParam Map<String, Object> param,
                                                   @RequestParam("dist_pic") MultipartFile file1,
                                                   @RequestParam("dist_view_pic") MultipartFile file2) {

        System.out.println("add param : " + param);

        Map<String, Object> response = new HashMap<>();
        try {

            int chkNm = districtInfoService.getDistrictInfoNmChk(param);

            if(chkNm != 0) {
                response.put("success", false);
                response.put("message", "현장명이 존재합니다.");
                return response;
            }

            int chkAbbr = districtInfoService.getDistrictInfoAbbrChk(param);

            if(chkAbbr != 0) {
                response.put("success", false);
                response.put("message", "약어가 존재합니다.");
                return response;
            }

            if (!file1.isEmpty()) {
                byte[] fileBytes1 = file1.getBytes();
                param.put("dist_pic", fileBytes1);
            }

            if (!file2.isEmpty()) {
                byte[] fileBytes2 = file2.getBytes();
                param.put("dist_view_pic", fileBytes2);
            }

            // district_no 생성
            Map<String, Object> newMap = new HashMap<>();
            newMap.put("table_nm", "tb_district_info");
            newMap.put("column_nm", "district_no");
            ObjectNode generationKeyOn = commonCodeEditService.newGenerationKey(newMap);
            param.put("district_no", generationKeyOn.get("newId").asText());

            // 서비스 호출하여 데이터베이스에 데이터 저장
            boolean createResult = districtInfoService.create(param);

            response.put("success", createResult);
            response.put("message", createResult ? "저장되었습니다." : "저장에 실패했습니다.");
            return response;

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "오류가 발생했습니다.");
            return response;
        }
    }

    @ResponseBody
    @GetMapping("/max-no")
    public String getMaxNo() {
        return districtInfoService.getMaxNo();
    }


    @ResponseBody
    @PostMapping("/mod")
    public boolean update(HttpServletRequest request, @RequestParam Map<String, Object> param,
                          @RequestParam("dist_pic") MultipartFile file1,
                          @RequestParam("dist_view_pic") MultipartFile file2) {
        try {
            if (!file1.isEmpty()) {
                byte[] fileBytes1 = file1.getBytes();
                param.put("dist_pic", fileBytes1);
            }

            if (!file2.isEmpty()) {
                byte[] fileBytes2 = file2.getBytes();
                param.put("dist_view_pic", fileBytes2);
            }

            return districtInfoService.update(param);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
