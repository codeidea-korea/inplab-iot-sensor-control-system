package com.safeone.dashboard.controller.adminAdd;

import com.safeone.dashboard.service.CommonCodeEditService;
import com.safeone.dashboard.util.VworldGeocoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/adminAdd/common")
public class CommonEditController {
    @Autowired
    private CommonCodeEditService commonCodeEditService;

    @Value("${upload.path}")
    private String upload_path;

    @Value("${upload.dppath}")
    private String upload_dppath;

    @ResponseBody
    @GetMapping("/code/list")
    public List list(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return commonCodeEditService.getCommonCodeEditList(param);
    }

    @ResponseBody
    @GetMapping("/code/newSensorSeq")
    public List newSensorSeq(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return commonCodeEditService.getNewSensorSeq(param);
    }

    @ResponseBody
    @GetMapping("/code/maintcompInfoList")
    public List maintcompInfoList(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return commonCodeEditService.getMaintcompInfoList(param);
    }

    @ResponseBody
    @GetMapping("/code/sensorAbbr")
    public List sensorAbbr(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return commonCodeEditService.getSensorAbbr(param);
    }

    @ResponseBody
    @GetMapping("/code/districtInfoDistAbbr")
    public List districtInfoDistAbbr(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return commonCodeEditService.getDistrictInfoDistAbbr(param);
    }


    @ResponseBody
    @GetMapping("/code/districtInfoList")
    public List districtInfoList() {
        return commonCodeEditService.getDistrictInfoList();
    }

    @ResponseBody
    @GetMapping("/code/loggerInfo")
    public List loggerInfo() {
        return commonCodeEditService.getLoggerInfo();
    }

    @ResponseBody
    @GetMapping("/code/sensorType")
    public List sensorType() {
        return commonCodeEditService.getSensorType();
    }

    @ResponseBody
    @GetMapping("/code/getSiteInfo")
    public List getSiteInfo() {
        return commonCodeEditService.getSiteInfo();
    }

    @ResponseBody
    @GetMapping("/code/getNewGenerationKey")
    public List getNewGenerationKey(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return commonCodeEditService.getNewGenerationKey(param);
    }

    @GetMapping("/img/view")
    public ResponseEntity<Resource> imgView(@RequestParam Map<String, Object> param) {

        String pathAndName = upload_path + (String) param.get("name");

        Resource resource = new FileSystemResource(pathAndName);

        if (!resource.exists()) {
            return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
        }

        HttpHeaders header = new HttpHeaders();
        Path filePath = null;
        try {
            filePath = Paths.get(pathAndName);
            header.add("Content-Type", Files.probeContentType(filePath));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping("/file/upload")
    public boolean upload(@RequestParam("uploadFile") MultipartFile multi, HttpServletRequest request, @RequestParam Map<String, Object> param) {
        try {

            if (!multi.isEmpty()) {
                File file = new File(upload_path, (String) param.get("serverFileName"));
                multi.transferTo(file);
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @GetMapping("/dp/{filename}")
    public ResponseEntity<Resource> imgDp(@PathVariable String filename) {

        String pathAndName = upload_dppath + filename;

        Resource resource = new FileSystemResource(pathAndName);

        if (!resource.exists()) {
            return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
        }

        HttpHeaders header = new HttpHeaders();
        Path filePath = null;
        try {
            filePath = Paths.get(pathAndName);
            header.add("Content-Type", Files.probeContentType(filePath));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping("/file/uploaddp")
    public boolean uploaddp(@RequestParam("uploadFile") MultipartFile multi, HttpServletRequest request, @RequestParam Map<String, Object> param) {
        try {

            if (!multi.isEmpty()) {
                File file = new File(upload_dppath, (String) param.get("serverFileName"));
                multi.transferTo(file);
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @ResponseBody
    @GetMapping(value = "/getCoords/{address}", produces = "application/json; charset=utf8")
    public Object getCoords(@PathVariable String address) {
        return VworldGeocoder.getAddressToCoord(address);
    }

    @ResponseBody
    @GetMapping(value = "/getAddress", produces = "application/json; charset=utf8")
    public Object getAddress(@RequestParam Map param) {
        return VworldGeocoder.getCoordToAddress(param.get("lat").toString(), param.get("lng").toString());
    }



}
