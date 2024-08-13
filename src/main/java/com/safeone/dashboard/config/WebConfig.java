package com.safeone.dashboard.config;

import java.io.File;
import java.nio.charset.Charset;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.format.FormatterRegistry;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.AsyncSupportConfigurer;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.resource.EncodedResourceResolver;
import org.springframework.web.servlet.resource.PathResourceResolver;

import com.safeone.dashboard.interceptor.LoginInterceptor;
import com.safeone.dashboard.util.fommatter.LocalDateFormatter;
import com.safeone.dashboard.util.fommatter.LocalDateTimeFormatter;

import lombok.extern.slf4j.Slf4j;

@Configuration
@ComponentScan(basePackages = { "com.safeone.dashboard.controller" }, excludeFilters = @Filter(Configuration.class))
@Slf4j
public class WebConfig extends WebMvcConfigurationSupport {
    @Autowired
    Environment env;

    public static final int BROWSER_CACHE_CONTROL = 60 * 60 * 24 * 1;
    public static final String UPLOADED_BASE_URL = "/upload";
    public static final String UPLOADED_DP_BASE_URL = "/upload/dp";
    public static final String UPLOADED_IMAGE_THUMB_POSTFIX = "_thumb";

    @Bean
    public ThreadPoolTaskExecutor mvcTaskExecutor() {
        ThreadPoolTaskExecutor taskExecutor = new ThreadPoolTaskExecutor();
        taskExecutor.setCorePoolSize(15);
        taskExecutor.setMaxPoolSize(100);
        taskExecutor.setQueueCapacity(500);
        taskExecutor.setKeepAliveSeconds(60 * 60);
        return taskExecutor;
    }

    public void configureAsyncSupport(AsyncSupportConfigurer configurer) {
        configurer.setTaskExecutor(mvcTaskExecutor());
    }

    @Override
    protected void addResourceHandlers(ResourceHandlerRegistry registry) {
        // static resource 경로 매핑
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/")
                .setCachePeriod(BROWSER_CACHE_CONTROL)
                .resourceChain(true)
                .addResolver(new EncodedResourceResolver())
                .addResolver(new PathResourceResolver());

        // 업로드 경로 매핑
//        registry.addResourceHandler(UPLOADED_BASE_URL + "/**")
//                .addResourceLocations("file:" + env.getProperty("upload.path") + File.separator)
//                .setCachePeriod(BROWSER_CACHE_CONTROL)
//                .resourceChain(true)
//                .addResolver(new PathResourceResolver());

        // //banner 업로드 경로 매핑
        // registry
        // .addResourceHandler(UPLOADED_BANNER_BASE_URL + "/**")
        // .addResourceLocations("file:" + env.getProperty("upload.banner.path")+
        // File.separator)
        // .setCachePeriod(BROWSER_CACHE_CONTROL)
        // .resourceChain(true)
        // .addResolver(new PathResourceResolver());
        super.addResourceHandlers(registry);
    }

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.jsp("/WEB-INF/views/", ".jsp");
    }

    // @Override
    // protected void addCorsMappings(CorsRegistry registry) {
    //     registry.addMapping("/**")
    //         .allowedOrigins("*")
    //         .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
    //         .allowCredentials(true)
    //         .maxAge(3600);
    // }

    /**
     * jpa의 domain 에서 타 domain을 참조하려고 할 때 객체를 읽어오는 경우에 사용
     * ex) <form:select path="club" items="${clubs}" itemLabel="name" itemValue="id"
     * cssClass="form-control" cssErrorClass="form-control error"/>
     *
     * @param registry
     */
    @Override
    protected void addFormatters(FormatterRegistry registry) {
        // model
        // registry.addFormatter(new GenericModelFormatter<Club,
        // ClubService>(clubService) {});

        // dates
        registry.addFormatter(new LocalDateFormatter());
        registry.addFormatter(new LocalDateTimeFormatter());
    }

    // @Override
    // public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
    //     argumentResolvers.add(new AuthenticationPrincipalArgumentResolver());
    // }

    @Override
    protected void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(LoginInterceptor())
                .excludePathPatterns("/login", "/**/*.js", "/**/*.css", "/**/*.map", "/**/*.ico", "/**/*.woff2", "/common/css/**", "/images/**", "/common/dp/**", "/error");
        registry.addInterceptor(localeInterceptor());
//        super.addInterceptors(registry);
    }

    // /**
    // * 모바일 접속 유무 및 그외 권한 처리
    // *
    // * @return
    // */
    // @Bean
    // public HandlerInterceptor PermissionInterceptor() {
    // PermissionInterceptor interceptor = new PermissionInterceptor();
    // return interceptor;
    // }

     /**
      * 로그인 처리 인터셉터
      *
      * @return
      */
     @Bean
     public HandlerInterceptor LoginInterceptor() {
         return new LoginInterceptor();
     }

    @Bean
    public LocaleChangeInterceptor localeInterceptor() {
        LocaleChangeInterceptor interceptor = new LocaleChangeInterceptor();
        interceptor.setParamName("lang");
        return interceptor;
    }

    @Bean(name = "multipartResolver")
    public StandardServletMultipartResolver resolver() {
        return new StandardServletMultipartResolver();
    }

    @Bean
    public HttpMessageConverter<String> responseBodyConverter() {
        return new StringHttpMessageConverter(Charset.forName("UTF-8"));
    }
}
