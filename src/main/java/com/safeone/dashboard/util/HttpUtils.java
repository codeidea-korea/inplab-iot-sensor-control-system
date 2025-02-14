package com.safeone.dashboard.util;

import lombok.NoArgsConstructor;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;

@NoArgsConstructor
public class HttpUtils {

    public static String getRemoteAddr(HttpServletRequest request) {

        String ip = request.getHeader("Proxy-Client-IP"); //for weblogic plugin

        if (StringUtils.isEmpty(ip) || ip.equalsIgnoreCase("unknown")) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR"); //for iis arr
        }
        if (StringUtils.isEmpty(ip) || ip.equalsIgnoreCase("unknown")) {
            ip = request.getHeader("X-Forwarded-For"); //for iis arr
        }
        if (StringUtils.isEmpty(ip) || ip.equalsIgnoreCase("unknown")) {
            ip = request.getHeader("REMOTE_ADDR");
        }
        if (StringUtils.isEmpty(ip) || ip.equalsIgnoreCase("unknown")) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    public static HttpServletRequest getRequest() throws IllegalStateException {
        return ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
    }

    public static RestTemplate getRestTemplate() {
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        factory.setConnectTimeout(3 * 1000);
        factory.setReadTimeout(15 * 1000);
        return new RestTemplateWithCookies(factory);
    }

}
