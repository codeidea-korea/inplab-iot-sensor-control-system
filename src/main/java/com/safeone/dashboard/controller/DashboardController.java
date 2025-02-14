package com.safeone.dashboard.controller;

import com.google.gson.Gson;
import com.safeone.dashboard.service.*;
import com.safeone.dashboard.util.ExcelUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class DashboardController {
    @Autowired
    private AreaService areaService;
    @Autowired
    private AlarmListService alarmService;
    @Autowired
    private AssetListService assetService;
    @Autowired
    private EmergencyCallService emergencyCallService;
    @Autowired
    private ZoneService zoneService;
    @Autowired
    private CommonCodeService commonCodeService;
    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private NewDashboardService newDashboardService;
    
    @GetMapping(value = "dashboard")
    public String main(Model model) {
        model.addAttribute("sensorTypes", (new Gson()).toJson(newDashboardService.getSensorTypes()));
        model.addAttribute("assetKind", (new Gson()).toJson(commonCodeService.getAssetKindList()));
        model.addAttribute("areaInfo", (new Gson()).toJson(areaService.getList(null).get(0)));
        return "dashboard";
    }

    @ResponseBody
    @GetMapping(value="/getAreaList", produces="application/json; charset=utf8")
    public Object getAreaList() {
        Map param = new HashMap();
        return areaService.getList(param);
    }

    @ResponseBody
    @GetMapping(value="/getAlarmList", produces="application/json; charset=utf8")
    public Object getAlarmList(@RequestParam Map param) {
        return alarmService.getList(param);
    }
    
    @ResponseBody
    @GetMapping(value="/getAssetList", produces="application/json; charset=utf8")
    public Object getAssetList(@RequestParam Map param) {
        return assetService.getList(param);
    }

    @ResponseBody
    @GetMapping(value="/getMarkerList", produces="application/json; charset=utf8")
    public Object getMarkerList(@RequestParam Map param) {
        return dashboardService.selectMarkerList(param);
    }

    @ResponseBody
    @GetMapping(value="/getAssetAlarm", produces="application/json; charset=utf8")
    public Object selectAssetAlarm(@RequestParam Map param) {
        return dashboardService.selectAssetAlarm(param);
    }

    @ResponseBody
    @GetMapping(value="/getZoneList", produces="application/json; charset=utf8")
    public Object getZoneList(@RequestParam Map param) {
        return zoneService.getList(param);
    }

    @ResponseBody
    @GetMapping(value="/setAssetLocation", produces="application/json; charset=utf8")
    public Object setAssetLocation(@RequestParam Map param) {
        return assetService.updateLocation(param);
    }

    @ResponseBody
    @GetMapping(value="/setZoneLocation", produces="application/json; charset=utf8")
    public Object setZoneLocation(@RequestParam Map param) {
        return zoneService.updateZoneLocation(param);
    }

    @ResponseBody
    @GetMapping(value = "/sensorCount", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getSensorCountByStatus(@RequestParam Map param) {
        return dashboardService.selectSensorCountByStatus(param);
    }

    @ResponseBody
    @GetMapping(value = "/cctvCount", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getCCTVCountByStatus(@RequestParam Map param) {
        return dashboardService.selectCCTVCountByStatus(param);
    }

    @ResponseBody
    @GetMapping(value = "/systemCount", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getSystemCountByStatus(@RequestParam Map param) {
        return dashboardService.selectSystemCountByStatus(param);
    }

    @ResponseBody
    @GetMapping(value = "/detailSystemCount", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getDetailSystemCountByStatus(@RequestParam Map param) {
        return dashboardService.selectDetailSystemCountByStatus(param);
    }

    @GetMapping(value = "/popup/sensorInfo")
    public String popupSensorInfo(Model model, @RequestParam Map param) {        
        model.addAttribute("asset", assetService.selectAssetInfo(param.get("asset_id").toString()));
        // model.addAttribute("chart", dashboardService.selectSensorChartData(param));
        return "layout/sensorInfo";
    }

    @GetMapping(value = "/popup/zoneDetail")
    public String popupZoneDetail(Model model, @RequestParam Map param) {        
        model.addAttribute("zone", dashboardService.selectAreaInfo(param).get(0));
        return "layout/zoneDetail";
    }

    /**
     * 센서모니터링 - 캔들차트
     * min : 간격(분)
     * asset_id : 자산id
     * start_date : 시작일자 (일시 가능)
     * end_date : 종료일                       
     * @param param
     * @return
     */
    @ResponseBody
    @GetMapping(value="/getSensorChartData", produces="application/json; charset=utf8")
    public Object getSensorChartData(@RequestParam Map param) {
        String[] asset_ids = (new Gson()).fromJson(param.get("asset_ids").toString(), String[].class);
        param.put("asset_ids", asset_ids);
        return dashboardService.selectSensorChartData(param);
    }

    /**
     * 센서모니터링 - 라인차트
     * @param param
     * @return
     */
    @ResponseBody
    @GetMapping(value="/getSensorChartRealData", produces="application/json; charset=utf8")
    public Object getSensorChartRealData(@RequestParam Map param) {
        String[] asset_ids = (new Gson()).fromJson(param.get("asset_ids").toString(), String[].class);
        param.put("asset_ids", asset_ids);
        return dashboardService.selectSensorChartRealData(param);
    }

    @GetMapping(value = "/excel/{fileName}")
    public void downloadExcel(HttpServletRequest request, HttpServletResponse response,
                              @RequestParam Map<String, Object> param, @PathVariable String fileName) {
        String[] asset_ids = (new Gson()).fromJson(param.get("asset_ids").toString(), String[].class);
        param.put("asset_ids", asset_ids);
        param.put("page", "0");
        List<Map> list = dashboardService.selectSensorChartData(param);

        String[] fields = new String[]{"asset_kind_name", "asset_name", "channel_name", "data_time", "avg_value"};
        String[] headers = new String[]{"센서종류", "센서명", "채널명", "데이터시간", "센서값"};

        ExcelUtils.downloadExcel(request, response, list, fields, headers, fileName + ".xls");
    }

    @ResponseBody
    @GetMapping(value = "/deviceCount", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getDeviceCount(@RequestParam Map param) {
        return dashboardService.selectDeviceCount(param);
    }

    @ResponseBody
    @GetMapping(value = "/getAlarm", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getAlarm(@RequestParam Map param) {
        return dashboardService.selectAlarm(param);
    }

    @ResponseBody
    @GetMapping(value = "/emergencyInfo", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getEmergencyInfo(@RequestParam Map param) {
        return emergencyCallService.getList(param);
    }

    @ResponseBody
    @GetMapping(value = "/maintenanceInfo", produces = MediaType.APPLICATION_JSON_VALUE)
    public Object getMaintenanceInfo(@RequestParam Map param) {
        return dashboardService.selectMaintenanceInfo(param);
    }

    @GetMapping(value = "/vwsearch/{query}", produces="application/json; charset=utf8")
    public ResponseEntity<?> getVworldData(@PathVariable String query) {
        String url = "http://api.vworld.kr/req/data";

        // 파라미터 설정
        Map<String, String> params = new HashMap<>();
        params.put("service", "data");
        params.put("request", "GetFeature");
        params.put("version", "2.0");
        params.put("crs", "EPSG:4326");
        params.put("address", query);
        params.put("refine", "true");
        params.put("simple", "false");
        params.put("format", "json");
        params.put("type", "ROAD");
        params.put("key", "935413DC-CBE2-382F-B307-933501B0DC45");

        RestTemplate restTemplate = new RestTemplate();
        String response = restTemplate.getForObject(url, String.class, params);

        return ResponseEntity.ok(response);
    }
}
