package com.safeone.dashboard.controller;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.safeone.dashboard.config.annotate.NoLoginCheck;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.safeone.dashboard.service.CommonCodeService;
import com.safeone.dashboard.util.VworldGeocoder;

@Controller
@RequestMapping("/common")
public class CommonController{
    @Autowired
    private CommonCodeService commonCodeService;

    @Value("${upload.path}")
    private String upload_path;

    @Value("${upload.dppath}")
    private String upload_dppath;

    @ResponseBody
    @GetMapping("/code/list")
    public List list(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return commonCodeService.getCommonCodeList(param);
    }
    
    @ResponseBody
    @GetMapping("/code/assetKindList")
    public List assetKindList(HttpServletRequest request) {
        return commonCodeService.getAssetKindList();
    }
    
    @ResponseBody
    @GetMapping("/code/areaList")
    public List areaList(HttpServletRequest request) {
        return commonCodeService.getAreaList();
    }
    
    @ResponseBody
    @GetMapping("/code/sensorList")
    public List assetList(HttpServletRequest request) {
        return commonCodeService.getSensorList();
    }

    @ResponseBody
    @GetMapping("/code/sensorListByZone")
    public List sensorListByZone(HttpServletRequest request, @RequestParam Map<String, Object> param) {
        return commonCodeService.getSensorListByZone(param);
    }

    @ResponseBody
    @GetMapping("/code/zoneList")
    public List zoneList(HttpServletRequest request) {
        return commonCodeService.getZoneList();
    }

    @ResponseBody
    @GetMapping("/code/mappingList")
    public List mappingList(HttpServletRequest request) {
        return commonCodeService.getMappingList();
    }

    @GetMapping("/img/view")
    public ResponseEntity<Resource> imgView(@RequestParam Map<String, Object> param) {
    	
    	String pathAndName = upload_path + (String)param.get("name");
    	
        Resource resource = new FileSystemResource(pathAndName);

        if(!resource.exists()){
            return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
        }

        HttpHeaders header = new HttpHeaders();
        Path filePath = null;
        try {
            filePath = Paths.get(pathAndName);
            header.add("Content-Type", Files.probeContentType(filePath));
        }catch (Exception e){
            e.printStackTrace();
        }
        
        return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
    }
    
    @ResponseBody
    @PostMapping("/file/upload")
    public boolean upload(@RequestParam("uploadFile") MultipartFile multi, HttpServletRequest request, @RequestParam Map<String, Object> param) {
		try {
			
			if(!multi.isEmpty()){
				File file = new File(upload_path, (String)param.get("serverFileName"));
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

        if(!resource.exists()){
            return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
        }

        HttpHeaders header = new HttpHeaders();
        Path filePath = null;
        try {
            filePath = Paths.get(pathAndName);
            header.add("Content-Type", Files.probeContentType(filePath));
        }catch (Exception e){
            e.printStackTrace();
        }

        return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
    }

    @ResponseBody
    @PostMapping("/file/uploaddp")
    public boolean uploaddp(@RequestParam("uploadFile") MultipartFile multi, HttpServletRequest request, @RequestParam Map<String, Object> param) {
        try {

            if(!multi.isEmpty()){
                File file = new File(upload_dppath, (String)param.get("serverFileName"));
                multi.transferTo(file);
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @ResponseBody
    @GetMapping(value="/getCoords/{address}", produces="application/json; charset=utf8")
    public Object getCoords(@PathVariable String address) {        
        return VworldGeocoder.getAddressToCoord(address);
    }

    @ResponseBody
    @GetMapping(value="/getAddress", produces="application/json; charset=utf8")
    public Object getAddress(@RequestParam Map param) {        
        return VworldGeocoder.getCoordToAddress(param.get("lat").toString(), param.get("lng").toString());
    }
}
