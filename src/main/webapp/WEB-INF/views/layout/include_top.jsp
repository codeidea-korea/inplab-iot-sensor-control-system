<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <nav class="navbar top navbar-expand-lg" style="margin-bottom: 0;">
            <a class="navbar-brand" href="/"><img src="/img/logo_gyeongju.png" height="35"
                    style="margin: 0 20px 0 10px">
<%--                <span style="color: #fff; font-weight: 700; font-size: 15px; font-family: 'Nanum Gothic';">IoT센서관제시스템</span>--%>
                <span style="color: #fff; font-weight: 700; font-size: 15px; font-family: 'Nanum Gothic';">${sessionScope.site_sys_nm}</span>
            </a>
            <!-- <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown"
        aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button> -->
            <div class="collapse navbar-collapse navbarNavDropdown" id="navbarNavDropdown">
                <ul class="navbar-nav">
                    <li class="nav-item active">
                        <a class="nav-link" href="#"><span class="menuname1"></span></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#"><span class="menuname2"></span></a>
                    </li>
                    <!-- <li class="nav-item">
                <a class="nav-link" href="#">Pricing</a>
            </li> -->
                    <!-- <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button"
                    data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Dropdown link
                    &nbsp;</a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                    <a class="dropdown-item" href="#">Action</a>
                    <a class="dropdown-item" href="#">Another action</a>
                    <a class="dropdown-item" href="#">Something else here</a>
                </div>
            </li> -->
                </ul>
                <div class="displayTime"></div>
                <ul class="navbar-nav">
                    <li class="nav-item active">
                        <a class="nav-link" href="#"><i class="fa-solid fa-magnifying-glass-location"></i></a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button"
                            data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i
                                class="fa-solid fa-layer-group"></i> 현장선택
                            &nbsp;</a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                            <a class="dropdown-item" href="#">Action</a>
                            <a class="dropdown-item" href="#">Another action</a>
                            <a class="dropdown-item" href="#">Something else here</a>
                        </div>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link" href="#"><i class="fa-solid fa-user"></i> 테스트 <span
                                style="color:#607396">님</span></a>
                    </li>
                </ul>
            </div>
        </nav>