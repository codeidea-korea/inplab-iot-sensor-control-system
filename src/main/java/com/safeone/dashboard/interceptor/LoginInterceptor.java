package com.safeone.dashboard.interceptor;

import com.safeone.dashboard.config.annotate.NoLoginCheck;
import com.safeone.dashboard.dto.UserDto;
import com.safeone.dashboard.service.UserService;
import lombok.extern.slf4j.Slf4j;
import lombok.extern.slf4j.XSlf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@Slf4j
public class LoginInterceptor implements HandlerInterceptor {

    @Autowired
    UserService userService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if (!(handler instanceof HandlerMethod)) {
            return true;
        }

        HandlerMethod hm = (HandlerMethod) handler;
        NoLoginCheck method = hm.getMethodAnnotation(NoLoginCheck.class);
        NoLoginCheck type   = hm.getBeanType().getAnnotation(NoLoginCheck.class);
        if (method != null || type != null) return true;

        if (request.getSession().getAttribute("login") == null) {
            response.sendRedirect("/login");
            return false;
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        if (modelAndView != null) {
            UserDto loginInfo = userService.getLoginSession(request);
//            if (loginInfo != null) {
//                loginInfo.setPassword(null);
//                loginInfo.remove("password");
                // modelAndView.getModelMap().addAttribute("userInfoJson", (new Gson()).toJson(loginInfo));
//                modelAndView.getModelMap().addAttribute("userInfo", loginInfo);
//            }
        }
//        super.postHandle(request, response, handler, modelAndView);
    }

}