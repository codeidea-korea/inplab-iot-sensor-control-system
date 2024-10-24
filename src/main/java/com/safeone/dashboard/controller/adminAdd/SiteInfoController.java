package com.safeone.dashboard.controller.adminAdd;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.controller.extend.JqGridAbstract;
import com.safeone.dashboard.dto.SiteInfoDto;
import com.safeone.dashboard.service.CommonCodeEditService;
import com.safeone.dashboard.service.SiteInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/adminAdd/siteInfo")
public class SiteInfoController extends JqGridAbstract<SiteInfoDto> {
    @Autowired
    private SiteInfoService siteInfoService;

    @Autowired
    private CommonCodeEditService commonCodeEditService;

    @Value("${upload.path}")
    private String upload_path;

    protected SiteInfoController() {
        super(SiteInfoDto.class);
    }

    @Override
    protected List getList(Map param) {
        return siteInfoService.getList(param);
    }

    @Override
    protected int getTotalRows(Map param) {
        return siteInfoService.getTotalCount(param);
    }

    @Override
    protected String setViewPage() {
        return "admin/siteInfo";
    }

    @ResponseBody
    @GetMapping("/del")
    public int delete(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        // todo : 관리자 권한 체크, 삭제에 대한 validate
        return siteInfoService.delete(param);
    }

    @ResponseBody
    @PostMapping("/add")
    public synchronized boolean insert(@RequestParam Map<String, Object> param,
                                       @RequestParam("site_logo") MultipartFile file,
                                       @RequestParam("site_title_logo") MultipartFile file2) {
        try {
            if (!file.isEmpty()) {
                byte[] fileBytes = file.getBytes(); // 파일을 byte 배열로 변환

                // 파일 데이터를 파라미터 맵에 추가
                param.put("site_logo", fileBytes);
                param.put("site_logo_nm", file.getOriginalFilename());
            }

            if (!file2.isEmpty()) {
                byte[] fileBytes2 = file2.getBytes(); // 파일을 byte 배열로 변환

                // 파일 데이터를 파라미터 맵에 추가
                param.put("site_title_logo", fileBytes2);
                param.put("site_title_logo_nm", file2.getOriginalFilename());
            }

            //site_no 생성
            Map<String, Object> newMap = new HashMap<>();
            newMap.put("table_nm", "tb_site_info");
            newMap.put("column_nm", "site_no");
            ObjectNode generationKeyOn = commonCodeEditService.newGenerationKey(newMap);
            param.put("site_no", generationKeyOn.get("newId").asText());

            // 서비스 호출하여 데이터베이스에 데이터 저장
            return siteInfoService.create(param);
        } catch (Exception e) {
            e.printStackTrace();
            return false; // 오류 발생 시 false 반환
        }
    }

    @ResponseBody
    @PostMapping("/mod")
    public boolean update(@RequestParam Map<String, Object> param,
                          @RequestParam("site_logo") MultipartFile file,
                          @RequestParam("site_title_logo") MultipartFile file2) {
        try {
            if (!file.isEmpty()) {
                byte[] fileBytes = file.getBytes(); // 파일을 byte 배열로 변환

                // 파일 데이터를 파라미터 맵에 추가
                param.put("site_logo", fileBytes);
                param.put("site_logo_nm", file.getOriginalFilename());

            }

            if (!file2.isEmpty()) {
                byte[] fileBytes2 = file2.getBytes(); // 파일을 byte 배열로 변환

                // 파일 데이터를 파라미터 맵에 추가
                param.put("site_title_logo", fileBytes2);
                param.put("site_title_logo_nm", file2.getOriginalFilename());
            }

            // 서비스 호출하여 데이터베이스에 데이터 저장
            return siteInfoService.update(param);
        } catch (Exception e) {
            e.printStackTrace();
            return false; // 오류 발생 시 false 반환
        }
    }

}
