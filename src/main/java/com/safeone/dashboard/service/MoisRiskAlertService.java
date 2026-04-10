package com.safeone.dashboard.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.safeone.dashboard.dto.AlertStandardDto;
import com.safeone.dashboard.dto.DistrictInfoDto;
import com.safeone.dashboard.dto.SensInfoDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.client.ResponseErrorHandler;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;

@Service
@RequiredArgsConstructor
@Slf4j
public class MoisRiskAlertService {

    private static final DateTimeFormatter ALERT_DATE_FORMAT = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

    private final ObjectMapper objectMapper;

    @Value("${mois.risk-district.enabled:false}")
    private boolean enabled;

    @Value("${mois.risk-district.base-url:}")
    private String baseUrl;

    @Value("${mois.risk-district.ds-code:}")
    private String dsCode;

    @Value("${mois.risk-district.ds-password:}")
    private String dsPassword;

    @Value("${mois.risk-district.cd-dist-obsv-default:0}")
    private int defaultCdDistObsv;

    @Value("${mois.risk-district.token-expire-minutes:62}")
    private long tokenExpireMinutes;

    @Value("${mois.risk-district.token-refresh-buffer-minutes:5}")
    private long tokenRefreshBufferMinutes;

    private final Set<String> activeAlarmKeys = ConcurrentHashMap.newKeySet();
    private final AtomicBoolean disabledLogged = new AtomicBoolean(false);
    private final AtomicBoolean configLogged = new AtomicBoolean(false);

    private final RestTemplate restTemplate = createRestTemplate();

    private volatile String accessToken;
    private volatile String refreshToken;
    private volatile Instant accessTokenExpireAt;

    public String buildAlarmKey(AlertStandardDto alert) {
        return String.join("|",
                safe(alert.getDistrict_no()),
                safe(alert.getSens_no()),
                safe(alert.getSens_chnl_id()),
                safe(alert.getOver()));
    }

    public synchronized void sendAlertIfNeeded(int alarmMgntNo,
                                               AlertStandardDto alert,
                                               DistrictInfoDto districtInfo,
                                               SensInfoDto sensInfo) {
        String alarmKey = buildAlarmKey(alert);

        if (!enabled) {
            if (disabledLogged.compareAndSet(false, true)) {
                log.info("[행안부 경보연동][SKIP] feature disabled. mois.risk-district.enabled=false");
            }
            return;
        }

        if (!isConfigured()) {
            if (configLogged.compareAndSet(false, true)) {
                log.warn("[행안부 경보연동][SKIP] config incomplete. baseUrl/dsCode/dsPassword 확인 필요");
            }
            return;
        }

        if (activeAlarmKeys.contains(alarmKey)) {
            log.info("[행안부 경보연동][SKIP][DUPLICATE] alarmMgntNo={} district={} sensor={} level={}",
                    alarmMgntNo,
                    safe(districtInfo == null ? null : districtInfo.getDistrict_nm()),
                    safe(sensorName(sensInfo, alert)),
                    levelName(alert.getOver()));
            return;
        }

        try {
            if (!ensureAccessToken()) {
                log.error("[행안부 경보연동][FAILED] token unavailable. alarmMgntNo={} district={} sensor={} level={}",
                        alarmMgntNo,
                        safe(districtInfo == null ? null : districtInfo.getDistrict_nm()),
                        safe(sensorName(sensInfo, alert)),
                        levelName(alert.getOver()));
                return;
            }

            log.info("[행안부 경보연동][REQUEST] alarmMgntNo={} district={} sensor={} level={}",
                    alarmMgntNo,
                    safe(districtInfo == null ? null : districtInfo.getDistrict_nm()),
                    safe(sensorName(sensInfo, alert)),
                    levelName(alert.getOver()));
            ApiCallResult result = sendAlert(alert, districtInfo, sensInfo);
            if (!result.success && isAuthError(result.resultCode)) {
                log.warn("[행안부 경보연동][AUTH][RETRY] auth issue detected. resultCode={} resultMessage={}",
                        safe(result.resultCode), safe(result.resultMessage));
                clearTokens();
                if (ensureAccessToken()) {
                    result = sendAlert(alert, districtInfo, sensInfo);
                }
            }

            if (result.success) {
                activeAlarmKeys.add(alarmKey);
                log.info("[행안부 경보연동][SUCCESS] alarmMgntNo={} district={} sensor={} level={} httpStatus={} resultCode={} message={}",
                        alarmMgntNo,
                        safe(districtInfo == null ? null : districtInfo.getDistrict_nm()),
                        safe(sensorName(sensInfo, alert)),
                        levelName(alert.getOver()),
                        result.httpStatus,
                        safe(result.resultCode),
                        safe(result.resultMessage));
                return;
            }

            log.error("[행안부 경보연동][FAILED] alarmMgntNo={} district={} sensor={} level={} httpStatus={} resultCode={} message={} body={}",
                    alarmMgntNo,
                    safe(districtInfo == null ? null : districtInfo.getDistrict_nm()),
                    safe(sensorName(sensInfo, alert)),
                    levelName(alert.getOver()),
                    result.httpStatus,
                    safe(result.resultCode),
                    safe(result.resultMessage),
                    safe(result.rawBody));
        } catch (Exception e) {
            log.error("[행안부 경보연동][FAILED] unexpected error. alarmMgntNo={} district={} sensor={} level={}",
                    alarmMgntNo,
                    safe(districtInfo == null ? null : districtInfo.getDistrict_nm()),
                    safe(sensorName(sensInfo, alert)),
                    levelName(alert.getOver()),
                    e);
        }
    }

    public synchronized void reconcileActiveKeys(Set<String> currentActiveKeys) {
        Set<String> snapshot = new HashSet<>(activeAlarmKeys);
        snapshot.removeAll(currentActiveKeys);
        if (!snapshot.isEmpty()) {
            activeAlarmKeys.retainAll(currentActiveKeys);
            log.info("[행안부 경보연동][RESET] clearedResolvedActiveAlerts={}", snapshot.size());
        }
    }

    private boolean ensureAccessToken() {
        if (hasValidAccessToken()) {
            return true;
        }

        if (StringUtils.hasText(refreshToken) && refreshAccessToken()) {
            return true;
        }

        return login();
    }

    private boolean hasValidAccessToken() {
        if (!StringUtils.hasText(accessToken) || accessTokenExpireAt == null) {
            return false;
        }
        Instant threshold = accessTokenExpireAt.minus(Duration.ofMinutes(Math.max(tokenRefreshBufferMinutes, 0)));
        return Instant.now().isBefore(threshold);
    }

    private boolean login() {
        try {
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("dsCode", dsCode);
            body.put("dsPwd", dsPassword);

            ApiCallResult result = postJson(normalizeBaseUrl() + "/c/v1/lo", null, body);
            if (!result.success) {
                log.error("[행안부 경보연동][AUTH][LOGIN][FAILED] httpStatus={} resultCode={} message={} body={}",
                        result.httpStatus, safe(result.resultCode), safe(result.resultMessage), safe(result.rawBody));
                return false;
            }

            String newAccessToken = findText(result.jsonNode, "atoken");
            String newRefreshToken = findText(result.jsonNode, "rtoken");
            if (!StringUtils.hasText(newAccessToken) || !StringUtils.hasText(newRefreshToken)) {
                log.error("[행안부 경보연동][AUTH][LOGIN][FAILED] token field missing. body={}", safe(result.rawBody));
                return false;
            }

            this.accessToken = newAccessToken;
            this.refreshToken = newRefreshToken;
            this.accessTokenExpireAt = Instant.now().plus(Duration.ofMinutes(Math.max(tokenExpireMinutes, 1)));
            log.info("[행안부 경보연동][AUTH][LOGIN][SUCCESS] dsCode={}", dsCode);
            return true;
        } catch (Exception e) {
            log.error("[행안부 경보연동][AUTH][LOGIN][FAILED] unexpected error", e);
            return false;
        }
    }

    private boolean refreshAccessToken() {
        try {
            ApiCallResult result = postJson(normalizeBaseUrl() + "/c/v1/rl/" + dsCode, refreshToken, null);
            if (!result.success) {
                log.warn("[행안부 경보연동][AUTH][REFRESH][FAILED] httpStatus={} resultCode={} message={}",
                        result.httpStatus, safe(result.resultCode), safe(result.resultMessage));
                clearTokens();
                return false;
            }

            String newAccessToken = findText(result.jsonNode, "atoken");
            if (!StringUtils.hasText(newAccessToken)) {
                log.warn("[행안부 경보연동][AUTH][REFRESH][FAILED] access token missing. body={}", safe(result.rawBody));
                clearTokens();
                return false;
            }

            String newRefreshToken = findText(result.jsonNode, "rtoken");
            this.accessToken = newAccessToken;
            if (StringUtils.hasText(newRefreshToken)) {
                this.refreshToken = newRefreshToken;
            }
            this.accessTokenExpireAt = Instant.now().plus(Duration.ofMinutes(Math.max(tokenExpireMinutes, 1)));
            log.info("[행안부 경보연동][AUTH][REFRESH][SUCCESS] dsCode={}", dsCode);
            return true;
        } catch (Exception e) {
            clearTokens();
            log.error("[행안부 경보연동][AUTH][REFRESH][FAILED] unexpected error", e);
            return false;
        }
    }

    private ApiCallResult sendAlert(AlertStandardDto alert,
                                    DistrictInfoDto districtInfo,
                                    SensInfoDto sensInfo) throws IOException {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("dsCode", dsCode);
        body.put("cdDistObsv", defaultCdDistObsv);
        body.put("almNote", buildAlarmNote(alert, districtInfo, sensInfo));
        body.put("almGb", "1");
        body.put("almDe", resolveAlarmDate(alert));
        body.put("almCode", toAlarmCode(alert.getOver()));

        return postJson(normalizeBaseUrl() + "/c/v1/dsalmord/insert/" + dsCode, accessToken, body);
    }

    private ApiCallResult postJson(String url, String bearerToken, Map<String, Object> body) throws IOException {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        headers.set("Accept-Charset", "UTF-8");
        if (StringUtils.hasText(bearerToken)) {
            headers.setBearerAuth(bearerToken);
        }

        String requestBody = body == null ? null : objectMapper.writeValueAsString(body);
        HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);

        try {
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
            return toApiCallResult(response.getStatusCodeValue(), response.getBody());
        } catch (Exception e) {
            if (e instanceof org.springframework.web.client.HttpStatusCodeException) {
                org.springframework.web.client.HttpStatusCodeException ex =
                        (org.springframework.web.client.HttpStatusCodeException) e;
                return toApiCallResult(ex.getRawStatusCode(), ex.getResponseBodyAsString());
            }
            throw e;
        }
    }

    private ApiCallResult toApiCallResult(int httpStatus, String responseBody) {
        JsonNode jsonNode = null;
        try {
            if (StringUtils.hasText(responseBody)) {
                jsonNode = objectMapper.readTree(responseBody);
            }
        } catch (Exception ignored) {
            // non-json response는 raw body 그대로만 기록한다.
        }

        String resultCode = findText(jsonNode, "resultCode");
        String resultMessage = findText(jsonNode, "resultMessage");
        boolean success = httpStatus >= 200 && httpStatus < 300 && "101".equals(resultCode);
        return new ApiCallResult(httpStatus, responseBody, jsonNode, resultCode, resultMessage, success);
    }

    private String findText(JsonNode node, String fieldName) {
        if (node == null || fieldName == null) {
            return null;
        }
        if (node.has(fieldName) && !node.get(fieldName).isNull()) {
            return node.get(fieldName).asText();
        }
        if (node.isObject()) {
            java.util.Iterator<Map.Entry<String, JsonNode>> fields = node.fields();
            while (fields.hasNext()) {
                Map.Entry<String, JsonNode> entry = fields.next();
                String found = findText(entry.getValue(), fieldName);
                if (StringUtils.hasText(found)) {
                    return found;
                }
            }
        }
        if (node.isArray()) {
            for (JsonNode child : node) {
                String found = findText(child, fieldName);
                if (StringUtils.hasText(found)) {
                    return found;
                }
            }
        }
        return null;
    }

    private boolean isAuthError(String resultCode) {
        return "211".equals(resultCode)
                || "212".equals(resultCode)
                || "213".equals(resultCode)
                || "215".equals(resultCode);
    }

    private boolean isConfigured() {
        return StringUtils.hasText(baseUrl)
                && StringUtils.hasText(dsCode)
                && StringUtils.hasText(dsPassword);
    }

    private String normalizeBaseUrl() {
        String trimmed = safe(baseUrl);
        if (trimmed.endsWith("/")) {
            return trimmed.substring(0, trimmed.length() - 1);
        }
        return trimmed;
    }

    private void clearTokens() {
        this.accessToken = null;
        this.refreshToken = null;
        this.accessTokenExpireAt = null;
    }

    private String buildAlarmNote(AlertStandardDto alert, DistrictInfoDto districtInfo, SensInfoDto sensInfo) {
        return String.format("[현장명] %s / %s / %s / 센서값 %s",
                safe(districtInfo == null ? null : districtInfo.getDistrict_nm()),
                safe(sensorName(sensInfo, alert)),
                levelName(alert.getOver()),
                safe(alert.getFormul_data()));
    }

    private String resolveAlarmDate(AlertStandardDto alert) {
        String measDt = safe(alert.getMeas_dt());
        if (StringUtils.hasText(measDt)) {
            try {
                return LocalDateTime.parse(measDt, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")).format(ALERT_DATE_FORMAT);
            } catch (DateTimeParseException ignored) {
                try {
                    return LocalDateTime.parse(measDt, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSSS")).format(ALERT_DATE_FORMAT);
                } catch (DateTimeParseException ignoredAgain) {
                    // 아래 now() fallback 사용
                }
            }
        }
        return LocalDateTime.now().format(ALERT_DATE_FORMAT);
    }

    private String sensorName(SensInfoDto sensInfo, AlertStandardDto alert) {
        if (sensInfo != null && StringUtils.hasText(sensInfo.getSens_nm())) {
            return sensInfo.getSens_nm();
        }
        return safe(alert.getSens_no());
    }

    private String levelName(String levelCode) {
        if ("1".equals(levelCode) || "ARM001".equals(levelCode)) {
            return "관심";
        }
        if ("2".equals(levelCode) || "ARM002".equals(levelCode)) {
            return "주의";
        }
        if ("3".equals(levelCode) || "ARM003".equals(levelCode)) {
            return "경계";
        }
        if ("4".equals(levelCode) || "ARM004".equals(levelCode)) {
            return "심각";
        }
        return safe(levelCode);
    }

    private String toAlarmCode(String levelCode) {
        if ("1".equals(levelCode) || "ARM001".equals(levelCode)) {
            return "01";
        }
        if ("2".equals(levelCode) || "ARM002".equals(levelCode)) {
            return "02";
        }
        if ("3".equals(levelCode) || "ARM003".equals(levelCode)) {
            return "03";
        }
        if ("4".equals(levelCode) || "ARM004".equals(levelCode)) {
            return "04";
        }
        return "01";
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }

    private RestTemplate createRestTemplate() {
        RestTemplate template = new RestTemplate();
        template.setErrorHandler(new ResponseErrorHandler() {
            @Override
            public boolean hasError(ClientHttpResponse response) throws IOException {
                return false;
            }

            @Override
            public void handleError(ClientHttpResponse response) {
                // 상태코드는 호출부에서 직접 판별한다.
            }
        });
        return template;
    }

    private static class ApiCallResult {
        private final int httpStatus;
        private final String rawBody;
        private final JsonNode jsonNode;
        private final String resultCode;
        private final String resultMessage;
        private final boolean success;

        private ApiCallResult(int httpStatus,
                              String rawBody,
                              JsonNode jsonNode,
                              String resultCode,
                              String resultMessage,
                              boolean success) {
            this.httpStatus = httpStatus;
            this.rawBody = rawBody;
            this.jsonNode = jsonNode;
            this.resultCode = resultCode;
            this.resultMessage = resultMessage;
            this.success = success;
        }
    }
}
