package com.safeone.dashboard.util;

import org.springframework.web.util.UriComponentsBuilder;

public class VworldGeocoder {
    private final static String API_KEY = "935413DC-CBE2-382F-B307-933501B0DC45";

    public static String getAddressToCoord(String address) {
        String url = "http://api.vworld.kr/req/address";

        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
            .queryParam("service", "address")
            .queryParam("request", "getcoord")
            .queryParam("version", "2.0")
            .queryParam("address", address)
            .queryParam("type", "PARCEL")
            .queryParam("key", API_KEY);

        String response = HttpUtils.getRestTemplate().getForObject(builder.toUriString(), String.class);
        return response; // JSON 형식의 응답 반환
    }

    public static String getCoordToAddress(String lat, String lon) {
        String url = "http://api.vworld.kr/req/address";
    
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
            .queryParam("service", "address")
            .queryParam("request", "getaddress")
            .queryParam("version", "2.0")
            .queryParam("point", lon + "," + lat)
            .queryParam("type", "PARCEL")
            .queryParam("key", API_KEY);
    
        String response = HttpUtils.getRestTemplate().getForObject(builder.toUriString(), String.class);
        return response; // JSON 형식의 응답 반환
    }
}
