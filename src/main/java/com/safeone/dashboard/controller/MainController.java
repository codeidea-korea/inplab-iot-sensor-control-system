package com.safeone.dashboard.controller;

import com.safeone.dashboard.dto.UserDto;
import com.safeone.dashboard.service.UserService;
import com.safeone.dashboard.util.CommonUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
public class MainController {

    @Autowired
    private UserService userService;
    @GetMapping(value = { "/", "" })
    public String main(Model model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        if (session.getAttribute("login") != null) {
            return "redirect:/dashboard";
        } else {
            return "redirect:/login";
        }
    }

    @GetMapping(value = "/changePassword", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map changePassword(HttpServletRequest request, Model model, @RequestParam Map param) {
        param.put("result", false);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpSession session = request.getSession();
//        param.put("user_id", ((UserDto) session.getAttribute("login")).getUser_id());
        param.put("user_id", ((UserDto) session.getAttribute("login")).getUsr_id());
        if (!param.get("password").toString().equals(param.get("password_confirm").toString())) {
            param.put("resultMessage", "비밀번호가 일치하지 않습니다.");
        } else if (param.get("password") == "" || param.get("password_confirm") == "") {
            param.put("resultMessage", "비밀번호을 입력해 주세요.");
        } else {
            param.put("password", CommonUtils.encrypt(param.get("password").toString()));
            param.put("result", true);
            userService.updateUserPassword(param);
        }
        return param;
    }
}
