package com.safeone.dashboard.controller;

import com.safeone.dashboard.config.annotate.NoLoginCheck;
import com.safeone.dashboard.dto.UserDto;
import com.safeone.dashboard.service.CommonCodeEditService;
import com.safeone.dashboard.service.LoginLogService;
import com.safeone.dashboard.service.SiteInfoService;
import com.safeone.dashboard.service.UserService;
import com.safeone.dashboard.util.CommonUtils;
import com.safeone.dashboard.util.HttpUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping(value = "/login")
public class LoginController {
    @Autowired
    private UserService userService;
    @Autowired
    private LoginLogService loginLogService;

    @Autowired
    private CommonCodeEditService commonCodeEditService;

    @NoLoginCheck
    @RequestMapping(value = {"", "/"})
    public String main(Model model) {
        List<Map> maps = commonCodeEditService.selectSiteInfoLogo();
        model.addAttribute("site_logo", maps.get(0).get("site_logo"));
        model.addAttribute("site_sys_nm", maps.get(0).get("site_sys_nm"));
        return "login";
    }


    @NoLoginCheck
    @RequestMapping(value = "/process", method = RequestMethod.POST)
    public String loginProcess(HttpServletRequest request, HttpServletResponse response, Model model, @RequestParam Map param) {
        String returnPage = "/error";
        Map<String, Object> loginLog = new HashMap<>();
        try {
            HttpSession session = request.getSession();
            if (session.getAttribute("login") != null) {
                session.removeAttribute("login");
            }
            try {
                log.info("Login - " + param);

                UserDto result = userService.getUserLogin(param);
                loginLog.put("usr_id", result.getUsr_id());
                loginLog.put("login_ip", HttpUtils.getRemoteAddr(request));
                loginLog.put("login_pc_name", getBrowser(request));
                loginLog.put("status", "N");
                if (CommonUtils.isMatch(param.get("userPw").toString(), result.getUsr_pwd())) {
                    result.setUsr_pwd(null);
                    session.setAttribute("login", result);
                    loginLog.put("status", "Y");

                    // site_logo 및 site_sys_nm 세션에 저장
                    List<Map> maps = commonCodeEditService.selectSiteInfoLogo();
                    session.setAttribute("site_logo", maps.get(0).get("site_logo"));
                    session.setAttribute("site_sys_nm", maps.get(0).get("site_sys_nm"));

                    // 수정해야됨 임시!!!
//                    returnPage = "redirect:/dashboard";
                    returnPage = "redirect:/adminAdd/siteInfo";

//                    Map user = (Map) session.getAttribute("login");
//                    if(user.get("user_lv").equals("3"))
//                        returnPage =  "redirect:/config/vehicle";
//                    else
//                        returnPage = "redirect:/dashboard";
                }
            } catch (HttpClientErrorException | HttpServerErrorException ex) {
                System.out.println(ex.getStatusCode());
                ex.printStackTrace();
                return returnPage;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        loginLogService.create(loginLog);
        return returnPage;
    }

    private String getBrowser(HttpServletRequest request) {
        String browser 	 = "";
        String userAgent = request.getHeader("User-Agent");
        if(userAgent.contains("Trident")) {												// IE
            browser = "IE";
        } else if(userAgent.contains("Edg")) {											// Edge
            browser = "Edge";
        } else if(userAgent.contains("Whale")) { 										// Naver Whale
            browser = "Whale";
        } else if(userAgent.contains("Opera") || userAgent.contains("OPR")) { 		// Opera
            browser = "Opera";
        } else if(userAgent.contains("Firefox")) { 										 // Firefox
            browser = "Firefox";
        } else if(userAgent.contains("Safari") && !userAgent.contains("Chrome")) {	 // Safari
            browser = "Safari";
        } else if(userAgent.contains("Chrome")) {										 // Chrome
            browser = "Chrome";
        }
        return browser;
    }

    @RequestMapping(value = {"/logout"})
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        session.removeAttribute("login");
        return "redirect:/login";
    }

    @RequestMapping(value = {"/test"})
    public String test(HttpServletRequest request, HttpServletResponse response) {
        return "test";
    }
}
