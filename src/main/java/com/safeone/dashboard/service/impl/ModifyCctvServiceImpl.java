package com.safeone.dashboard.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.safeone.dashboard.dao.CctvListMapper;
import com.safeone.dashboard.dto.CctvListDto;
import com.safeone.dashboard.dto.GetModifyCctvDto;
import com.safeone.dashboard.service.ModifyCctvService;
import com.safeone.dashboard.util.CommonUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.hc.client5.http.auth.AuthScope;
import org.apache.hc.client5.http.auth.Credentials;
import org.apache.hc.client5.http.auth.UsernamePasswordCredentials;
import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.impl.auth.BasicCredentialsProvider;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.client5.http.protocol.HttpClientContext;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Slf4j
@Transactional
@Service("modifyCctvService")
@RequiredArgsConstructor
public class ModifyCctvServiceImpl implements ModifyCctvService {

    @Resource(name = "cctvListMapper")
    private final CctvListMapper cctvListMapper;

    public ObjectNode getCctv(GetModifyCctvDto getModifyCctvDto) {
        ObjectMapper om = new ObjectMapper();
        ObjectNode on = om.createObjectNode();
        ArrayNode an = om.createArrayNode();

        Map<String, Object> map = CommonUtils.dtoToMap(getModifyCctvDto);
        List<CctvListDto> list = cctvListMapper.selectCctvList(map);
        for (CctvListDto dto : list) {
            if (dto.getCctv_ip() == null || dto.getWeb_port() == null || dto.getCctv_conn_id() == null || dto.getCctv_conn_pwd() == null) {
                dto.setRtsp_status("N");
            } else {
                if (getPtzValues(dto.getCctv_ip(), dto.getWeb_port(), dto.getCctv_conn_id(), dto.getCctv_conn_pwd()).equals("FAIL")) {
                    dto.setRtsp_status("N");
                } else {
                    dto.setRtsp_status("Y");
                }
            }
        }
        int totalCnt = cctvListMapper.selectCctvListTotal(map);
        an = om.valueToTree(list);

        CommonUtils.setCountInfo("list", list.size(), on);
        CommonUtils.setCountInfo("total", totalCnt, on);

        on.put("rows", an);

        return on;
    }

    @Override
    public String operation(Map<String, Object> param) {
        String operator = param.get("operator").toString();
        CctvListDto cctvInfo = cctvListMapper.getCctvInfo(param);

        String currentValues = getPtzValues(cctvInfo.getCctv_ip(), cctvInfo.getWeb_port(), cctvInfo.getCctv_conn_id(), cctvInfo.getCctv_conn_pwd());

        double pan = parseValue(currentValues, "Pan");
        double tilt = parseValue(currentValues, "Tilt");
        double zoom = parseValue(currentValues, "Zoom");

        if (operator.equals("left")) {
            pan = pan - 10;
        } else if (operator.equals("right")) {
            pan = pan + 10;
        } else if (operator.equals("up")) {
            tilt = tilt - 10;
        } else if (operator.equals("down")) {
            tilt = tilt + 10;
        } else if (operator.equals("plus")) {
            zoom = zoom + 1;
        } else if (operator.equals("minus")) {
            zoom = zoom - 1;
        }

        pan = Math.max(0, Math.min(180, pan));
        tilt = Math.max(-45, Math.min(45, tilt));
        zoom = Math.max(1, Math.min(10, zoom));

        return setPtzValues(cctvInfo.getCctv_ip(), cctvInfo.getWeb_port(), cctvInfo.getCctv_conn_id(), cctvInfo.getCctv_conn_pwd(), pan, tilt, zoom);
    }

    private String setPtzValues(String ipAddress, String port, String id, String password, double pan, double tilt, double zoom) {
        String requestUrl = "http://" + ipAddress + ":" + port + "/stw-cgi/ptzcontrol.cgi?msubmenu=absolute&action=control&Pan=" + pan + "&Tilt=" + tilt + "&Zoom=" + zoom;

        Credentials credentials = new UsernamePasswordCredentials(id, password.toCharArray());
        BasicCredentialsProvider credentialsProvider = new BasicCredentialsProvider();
        credentialsProvider.setCredentials(new AuthScope(ipAddress, Integer.parseInt(port)), credentials);

        HttpClientContext context = HttpClientContext.create();
        context.setCredentialsProvider(credentialsProvider);

        try (CloseableHttpClient httpClient = HttpClients.custom()
                .setDefaultCredentialsProvider(credentialsProvider)
                .build()) {

            HttpGet request = new HttpGet(requestUrl);

            try (CloseableHttpResponse response = httpClient.execute(new HttpHost(ipAddress, Integer.parseInt(port)), request, context)) {
                if (response.getCode() == 200) {
                    return "PTZ adjustment successful";
                } else {
                    return "Error: " + response.getCode() + " - " + response.getReasonPhrase();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Error adjusting PTZ values";
        }
    }

    private double parseValue(String data, String key) {
        int index = data.indexOf(key + "=");
        if (index == -1) return 0;
        int endIndex = data.indexOf("\n", index);
        if (endIndex == -1) endIndex = data.length();
        return Double.parseDouble(data.substring(index + key.length() + 1, endIndex).trim());
    }



    private String getPtzValues(String ipAddress, String port, String id, String password) {
        String requestUrl = "http://" + ipAddress + ":" + port + "/stw-cgi/ptzcontrol.cgi?msubmenu=query&action=view&Channel=0&Query=Pan,Tilt,Zoom";

        Credentials credentials = new UsernamePasswordCredentials(id, password.toCharArray());
        BasicCredentialsProvider credentialsProvider = new BasicCredentialsProvider();
        credentialsProvider.setCredentials(new AuthScope(ipAddress, Integer.parseInt(port)), credentials);

        HttpClientContext context = HttpClientContext.create();
        context.setCredentialsProvider(credentialsProvider);

        try (CloseableHttpClient httpClient = HttpClients.custom()
                .setDefaultCredentialsProvider(credentialsProvider)
                .build()) {

            HttpGet request = new HttpGet(requestUrl);

            try (CloseableHttpResponse response = httpClient.execute(new HttpHost(ipAddress, Integer.parseInt(port)), request, context)) {
                if (response.getCode() == 200) {
                    return EntityUtils.toString(response.getEntity());
                } else {
                    return "FAIL";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "FAIL";
        }
    }
}
