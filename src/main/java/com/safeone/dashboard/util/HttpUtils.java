package com.safeone.dashboard.util;

import com.google.gson.Gson;
import lombok.NoArgsConstructor;
import org.apache.commons.text.StringEscapeUtils;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.util.Base64Utils;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Map;
import java.util.stream.Collectors;

/**
 *  HTTP 유틸
 *
 *  @author ss
 *  @since 2017.06.22
*/
@NoArgsConstructor
public class HttpUtils {

    /**
     * IP 구하기
     * @param request HttpRequest
     * @return IP
     */
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

	/**
	 * IP 구하기
	 * RequestContextHolder 를 사용하여 인자없이 구하기
	 * @return
	 */
	public static String getRemoteAddr() {
		return getRemoteAddr(getRequest());
	}


	/**
	 * HttpServletRequest 구하기
	 * @return
	 */
	public static HttpServletRequest getRequest() throws IllegalStateException {
		return ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
	}

	/**
	 * 모바일 브라우저 여부
	 * @return
	 */
	public static boolean isMobile(HttpServletRequest request) {
		String userAgent = request.getHeader("user-agent");
		boolean mobile1 = userAgent.matches(".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
		boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*");
		if (mobile1 || mobile2) {
			return true;
		}
		return false;
	}

	/**
	 * 줄변환까지 적용한 html escape 분자열
	 * @param text
	 * @return
	 */
	public static String getEscapedContent(String text) {
		text = StringEscapeUtils.escapeHtml4(text);
		text = text.replaceAll("\r", "<br/>");
		return text;
	}

	public static String getMaxLines(String text, int max) {
		return Arrays.stream(text.split("\n")).map(String::trim).filter(l->l.length()>0).limit(max).collect(Collectors.joining("\n"));
	}

	public static String getUnescapeHtml(String content) {
		String text = content.replaceAll("<[^>]*>","");
		text = text.replaceAll("&nbsp;", " ");// 이상하게 &nbsp; 가 안먹음..
		text = StringEscapeUtils.unescapeHtml4(text);
		//빈줄제거 및 crlf 정규화
		text = Arrays.stream(text.split("\r")).map(String::trim).filter(l->l.length()>0).collect(Collectors.joining("\n"));
		return text;
	}

	public static String markKeyword(String title, String keyword) {
		title = StringEscapeUtils.escapeHtml4(title);
		title = title.replaceAll(keyword, "<span class=\"keyword\">" + keyword + "</span>");
		return title;
	}

	public static String addMonth(String dateFormat, int addMonth){

		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(dateFormat);

		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MONTH, addMonth);

		return simpleDateFormat.format(calendar.getTime());
	}

	public static String formatLocalDateTime(String dateFormat){
		return LocalDateTime.now().format(DateTimeFormatter.ofPattern(dateFormat));
	}

	public static String encodeBase64(String str){
		return Base64Utils.encodeToUrlSafeString(str.getBytes());
	}

	/**
	 * jstl 쿠키 사용시에 특수기호 decode 용
	 * @param str
	 * @param enc
	 * @return
	 */
	public static String urlDecode(String str,String enc){
		try {
			return URLDecoder.decode(str, enc);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return "";
		}
	}

	/**
	 * 팝업 보여줄 때 필터링용
	 * @param arrays
	 * @param contains
	 * @return
	 */
	public static boolean arraySearch(String[] arrays, String contains){
		return !Arrays.asList(arrays).contains(contains);
	}

	public static RestTemplate getRestTemplate() {
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        factory.setConnectTimeout(3*1000);
        factory.setReadTimeout(15*1000);
        RestTemplate restTemplate = new RestTemplateWithCookies(factory);

        return restTemplate;
    }

    public static String postForObject(String url, Map param, String cookie) {
    	RestTemplate restTemplate = getRestTemplate();

    	String requestJson = "";

    	if (param != null)
    		requestJson = new Gson().toJson(param);

//    	if (mHeaders != null)
//    		mHeaders.setContentType(MediaType.APPLICATION_JSON);
//    	if (cookies != null)
    	HttpHeaders headers = new HttpHeaders();
    	headers.setContentType(MediaType.APPLICATION_JSON);
    	headers.set("Cookie", cookie);

//    	headers.add("cookie", "user_id=skinfosec%40secudiumiot.com; user_no=2147483647; user_email=skinfosec%40secudiumiot.com; user_name=system; user_dstnct_code=03; access_token=u%2FPnubuVu2f9DbmLX03dHsuZKBJ7snrL2DZ3X0j5iSU%3D.JPMHrciewTEMUEOsdDfI%2B2v0%2B9gIfQ74zVh3lUQ4tZKp1Y5oKUVIPzHO50hbRVEKputRk9aA6Nj4GSUkN5ufHJS0W7d67nmXRVbzk8yL%2F%2Fw%3D.%2F1YasYy9M3n%2FKrt3tD4jMxvqhSDJnqHfolW5he%2FrZx%2FEbtlrd02lg3OXuzt7vdG45mI3gE%2BU2js0GwDYCj%2FXiA%3D%3D; refresh_token=u%2FPnubuVu2f9DbmLX03dHsuZKBJ7snrL2DZ3X0j5iSU%3D.JPMHrciewTEMUEOsdDfI%2B2v0%2B9gIfQ74zVh3lUQ4tZKvs2KbTuZmNB7oNluY9HFrPQEzWbWKeNZDr%2BpToR%2B5Lmu5BAbCFG45c0qFPeIEAto%3D.%2F1YasYy9M3n%2FKrt3tD4jMxvqhSDJnqHfolW5he%2FrZx%2FEbtlrd02lg3OXuzt7vdG45mI3gE%2BU2js0GwDYCj%2FXiA%3D%3D; SESSION=09d7079f-1e25-4ab8-b4e6-fa209ce7d830; expiration_timestamp=test_exist; dspDefaultTZ=Asia/Seoul; access_token=u%2FPnubuVu2f9DbmLX03dHsuZKBJ7snrL2DZ3X0j5iSU%3D.JPMHrciewTEMUEOsdDfI%2B2v0%2B9gIfQ74zVh3lUQ4tZKp1Y5oKUVIPzHO50hbRVEKputRk9aA6Nj4GSUkN5ufHJS0W7d67nmXRVbzk8yL%2F%2Fw%3D.%2F1YasYy9M3n%2FKrt3tD4jMxvqhSDJnqHfolW5he%2FrZx%2FEbtlrd02lg3OXuzt7vdG45mI3gE%2BU2js0GwDYCj%2FXiA%3D%3D; refresh_token=u%2FPnubuVu2f9DbmLX03dHsuZKBJ7snrL2DZ3X0j5iSU%3D.JPMHrciewTEMUEOsdDfI%2B2v0%2B9gIfQ74zVh3lUQ4tZKvs2KbTuZmNB7oNluY9HFrPQEzWbWKeNZDr%2BpToR%2B5Lmu5BAbCFG45c0qFPeIEAto%3D.%2F1YasYy9M3n%2FKrt3tD4jMxvqhSDJnqHfolW5he%2FrZx%2FEbtlrd02lg3OXuzt7vdG45mI3gE%2BU2js0GwDYCj%2FXiA%3D%3D; user_id=skinfosec%40secudiumiot.com; user_no=2147483647; user_email=skinfosec%40secudiumiot.com; user_name=system; user_dstnct_code=03; SESSION=09d7079f-1e25-4ab8-b4e6-fa209ce7d830; expiration_timestamp=test_exist; dspDefaultTZ=Asia/Seoul");
    	HttpEntity<String> entity = new HttpEntity<String>(requestJson, headers);

    	String answer = restTemplate.postForObject(url, entity, String.class);

    	return answer;
    }

    public static HttpEntity<String> postForLogin(String url, Map param) {
    	RestTemplate restTemplate = getRestTemplate();

    	String requestJson = new Gson().toJson(param);
    	HttpHeaders headers = new HttpHeaders();
    	headers.setContentType(MediaType.APPLICATION_JSON);
    	HttpEntity<String> entity = new HttpEntity<String>(requestJson, headers);

    	ResponseEntity<String> answer = restTemplate.postForEntity(url, entity, String.class);

    	return answer;
    }

    public static String postForForm(String url, Map param, String cookie) {
    	RestTemplate restTemplate = getRestTemplate();

    	MultiValueMap<String, String> parameters= new LinkedMultiValueMap<String, String>();
    	if (param != null)
    		parameters.setAll(param);

    	HttpHeaders headers = new HttpHeaders();
    	headers.set("Cookie", cookie);

    	System.out.println("request - " + url + " / param - " + param.values());
    	HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(parameters, headers);

    	String answer = restTemplate.postForObject(url, request , String.class);
    	System.out.println("response - " + answer);
    	return answer;
    }

	/**
	 * MAC Adress 구하기
	 * @return
	 */
	public static String getLocalMacAddress() {
		StringBuilder macAddr = new StringBuilder();
		try {
			InetAddress addr = InetAddress.getLocalHost();
			/* IP 주소 가져오기 */
			String ipAddr = addr.getHostAddress();
			System.out.println(ipAddr);

			/* 호스트명 가져오기 */
			String hostname = addr.getHostName();
			System.out.println(hostname);

			NetworkInterface ni = NetworkInterface.getByInetAddress(addr);
			byte[] mac = ni.getHardwareAddress();
			for (int i = 0; i < mac.length; i++) {
				macAddr.append(String.format("%02X%s", mac[i], (i < mac.length - 1) ? "-" : ""));
			}
			System.out.println(macAddr);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return macAddr.toString();
	}

	/**
	 * User-Agent & 브라우저 버전 확인
	 * @param request
	 * @return
	 */
	public static String UserBrowserChk(HttpServletRequest request) {
		String userAgent = request.getHeader("User-Agent");
		String browser = "";

		if (userAgent.contains("Trident") || userAgent.contains("MSIE")) { //IE

			if (userAgent.contains("Trident/7")) {
				browser = "IE 11";
			} else if (userAgent.contains("Trident/6")) {
				browser = "IE 10";
			} else if (userAgent.contains("Trident/5")) {
				browser = "IE 9";
			} else if (userAgent.contains("Trident/4")) {
				browser = "IE 8";
			} else if (userAgent.contains("edge")) {
				browser = "IE edge";
			}

		} else if (userAgent.contains("Whale")) { //네이버 WHALE
			browser = "WHALE " + userAgent.split("Whale/")[1].toString().split(" ")[0].toString();
		} else if (userAgent.contains("Opera") || userAgent.contains("OPR")) { //오페라
			if (userAgent.contains("Opera")) {
				browser = "OPERA " + userAgent.split("Opera/")[1].toString().split(" ")[0].toString();
			} else if (userAgent.contains("OPR")) {
				browser = "OPERA " + userAgent.split("OPR/")[1].toString().split(" ")[0].toString();
			}
		} else if (userAgent.contains("Firefox")) { //파이어폭스
			browser = "FIREFOX " + userAgent.split("Firefox/")[1].toString().split(" ")[0].toString();
		} else if (userAgent.contains("Safari") && !userAgent.contains("Chrome")) { //사파리
			browser = "SAFARI " + userAgent.split("Safari/")[1].toString().split(" ")[0].toString();
		} else if (userAgent.contains("Chrome")) { //크롬
			browser = "CHROME " + userAgent.split("Chrome/")[1].toString().split(" ")[0].toString();
		}

		System.out.println("userAgent 확인 [" + userAgent + "]");
		System.out.println("브라우저/버전 확인 [" + browser + "]");

		return browser;
	}
}
