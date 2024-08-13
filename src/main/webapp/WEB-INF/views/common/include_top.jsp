<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.safeone.dashboard.dto.UserDto" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    UserDto loginUser = (UserDto)session.getAttribute("login");
%>
<script>
    $(function () {

        var currentURI = '<%=request.getServletPath()%>';

        if (currentURI.indexOf('dashboard') > -1) {} else {
            $('.right-utill li').hide();
            $('.right-utill li.login').show();
        }

        // 상단 영역
        $(document).on("mouseenter", ".login", function () {
            $("#header .login-info").show();
        });
        $(document).on("mouseleave", ".login", function () {
            $("#header .login-info").hide();
        });

        //비밀번호 변경 팝업창
        $(document).on('click', '.change-password', function (e) {
            popFancy('#lay-find-pw');
            // console.log("localStorage :: " + localStorage);
        });

        // 로그 아웃
        $(document).on('click', '.logout', function (e) {
            localStorage.setItem('loginSuccess', false);
            localStorage.setItem('autoLogin', false);
            window.location.href = "/logout";
        });

        // 상단 영역 사용자 이름 표출
        $('.login span').html('<%=loginUser.getName()%>');

        // 상단 사용자 상세 정보
        let grade = '<%=loginUser.getGrade()%>'
        if (grade === '1') $('.login-info strong').html('관리자:');
        else $('.login-info strong').html('일반 사용자:');
        $('.login-info span').html('<%=loginUser.getName()%>');

        // 비밀번호 변경 이메일 표출
        $('#lay-find-pw .mem-form .email').html('<%=loginUser.getEmail()%>');

        // 비밀번호 변경 버튼 클릭시
        $('#lay-find-pw .change-btn').on('click', function() {

            const regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

            const password = $('#lay-find-pw input[name=password]').val();

            if(!regex.test(password)) {
                alert('비밀번호는 영문+숫자 조합 8자리 이상입니다.');
                return false;
            }

            $.get('/changePassword', {
                password,
                password_confirm : $('#lay-find-pw input[name=password_confirm]').val(),
            }, function(res) {
                console.log(res);
                if (res.result) {
                    popFancyClose('#lay-find-pw');
                    alert('비밀번호가 변경되었습니다.');
                    localStorage.clear();
                    window.location.href = "/logout";
                } else {
                    alert(res.resultMessage);
                }
            });
        });

        function updateTime() {
            let currentTime = new Date();
            let year = currentTime.getFullYear();
            let month = currentTime.getMonth() + 1;
            month = (month < 10 ? "0" : "") + month;
            let day = currentTime.getDate();
            day = (day < 10 ? "0" : "") + day;
            let hour = currentTime.getHours();
            let minute = currentTime.getMinutes();
            minute = (minute < 10 ? "0" : "") + minute;
            let second = currentTime.getSeconds();
            second = (second < 10 ? "0" : "") + second;

            let week = [
                '일',
                '월',
                '화',
                '수',
                '목',
                '금',
                '토'
            ];
            let weekDay = week[currentTime.getDay()];

            let amPm = hour >= 12 ? '오후' : '오전';
            hour = hour % 12;
            hour = hour ? hour : 12; // the hour '0' should be '12'
            hour = (hour < 10 ? "0" : "") + hour;

            let currentTimeString = year + "-" + month + "-" + day + "(" + weekDay + ") " + amPm + " " + hour + ":" + minute + ":" + second;

            $('.current_time').html(currentTimeString);
            setTimeout(updateTime, 1000);
        }

        updateTime();
    });
</script>

<div id="header">
    <h1>
        <a href="/"><img src="/images/logo.png" alt="Golden City - IoT센서관제시스템" title="Golden City - IoT센서관제시스템"/>
            <span class="">IoT센서관제시스템</span>
        </a>
    </h1>

    <div class="center-text">
        <span class="current_time">2022-11-09(수) 오전 11:56:11</span>
        <!-- <span class="weather-info" point>경주시 > 덕동 온도 3 ° 습도 60% 강우량 10mm -->
        </span>
    </div>

    <ul class="right-utill">
        <li class="hide">
            <button type="button" data-type="mask" class="fullscreen">
                <img src="/images/btn_fullscreen.png" alt="전체보기"/>
            </button>
            <p class="tooltip">전체보기</p>
        </li>
        <!-- <li>
            <button type="button" data-type="mask" class="iconlayer">
                <img src="/images/btn_iconlayer.png" alt="레이어"/>
            </button>
            <p class="tooltip">레이어</p>
            <div class="map-option">
                <p class="tit">레이어</p>
                <ul class="option-btn-list">
                    <li>
                        <div class="option-btn">
                            <strong>시/도 경계선</strong>
                            <p class="check-box" notxt small>
                                <input type="checkbox" id="option_btn01" name="option_btn01" value=""/>
                                <label for="option_btn01">
                                    <span class="graphic"></span>
                                </label>
                            </p>
                        </div>
                    </li>
                    <li>
                        <div class="option-btn">
                            <strong>아이콘 글씨</strong>
                            <p class="check-box" notxt small>
                                <input type="checkbox" id="option_btn02" name="option_btn02" value=""/>
                                <label for="option_btn02">
                                    <span class="graphic"></span>
                                </label>
                            </p>
                        </div>
                    </li>
                    <li>
                        <div class="option-btn">
                            <strong>센서계측기기</strong>
                            <p class="check-box" notxt small>
                                <input type="checkbox" id="option_btn03" name="option_btn03" value=""/>
                                <label for="option_btn03">
                                    <span class="graphic"></span>
                                </label>
                            </p>
                        </div>

                        <ul class="option-btn-in">
                            <li>
                                <div class="option-btn">
                                    <strong>지표면변위계</strong>
                                    <p class="check-box" notxt small>
                                        <input type="checkbox" id="option_btn03_01" name="option_btn03_01" value=""/>
                                        <label for="option_btn03_01">
                                            <span class="graphic"></span>
                                        </label>
                                    </p>
                                </div>
                            </li>
                            <li>
                                <div class="option-btn">
                                    <strong>강우계</strong>
                                    <p class="check-box" notxt small>
                                        <input type="checkbox" id="option_btn03_02" name="option_btn03_02" value=""/>
                                        <label for="option_btn03_02">
                                            <span class="graphic"></span>
                                        </label>
                                    </p>
                                </div>
                            </li>
                            <li>
                                <div class="option-btn">
                                    <strong>구조물 경사계 (TM)</strong>
                                    <p class="check-box" notxt small>
                                        <input type="checkbox" id="option_btn03_03" name="option_btn03_03" value=""/>
                                        <label for="option_btn03_03">
                                            <span class="graphic"></span>
                                        </label>
                                    </p>
                                </div>
                            </li>
                            <li>
                                <div class="option-btn">
                                    <strong>구조물 경사계 (TTW)</strong>
                                    <p class="check-box" notxt small>
                                        <input type="checkbox" id="option_btn03_04" name="option_btn03_04" value=""/>
                                        <label for="option_btn03_04">
                                            <span class="graphic"></span>
                                        </label>
                                    </p>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <div class="option-btn">
                            <strong>제어기기</strong>
                            <p class="check-box" notxt small>
                                <input type="checkbox" id="option_btn04" name="option_btn04" value=""/>
                                <label for="option_btn04">
                                    <span class="graphic"></span>
                                </label>
                            </p>
                        </div>

                        <ul class="option-btn-in">
                            <li>
                                <div class="option-btn">
                                    <strong>CCTV</strong>
                                    <p class="check-box" notxt small>
                                        <input type="checkbox" id="option_btn04_01" name="option_btn04_01" value=""/>
                                        <label for="option_btn04_01">
                                            <span class="graphic"></span>
                                        </label>
                                    </p>
                                </div>
                            </li>
                            <li>
                                <div class="option-btn">
                                    <strong>재난 방송시스템</strong>
                                    <p class="check-box" notxt small>
                                        <input type="checkbox" id="option_btn04_02" name="option_btn04_02" value=""/>
                                        <label for="option_btn04_02">
                                            <span class="graphic"></span>
                                        </label>
                                    </p>
                                </div>
                            </li>
                            <li>
                                <div class="option-btn">
                                    <strong>재난 문자전광판</strong>
                                    <p class="check-box" notxt small>
                                        <input type="checkbox" id="option_btn04_03" name="option_btn04_03" value=""/>
                                        <label for="option_btn04_03">
                                            <span class="graphic"></span>
                                        </label>
                                    </p>
                                </div>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </li> -->
        <li>
            <button type="button" data-type="mask" class="roadview">
                <img src="/images/btn_roadview.png" alt="로드뷰"/>
            </button>
            <p class="tooltip">로드뷰</p>
        </li>

        <c:if test="${sessionScope.login.grade eq '1'}">
        <li>
            <button type="button" data-type="mask" class="editmode">
                <img src="/images/btn_editmode.png" alt="Edit Mode"/>
            </button>
            <p class="tooltip">Edit Mode</p>
        </li>
        </c:if>

        <li class="login">
            <span>관리자</span>
            &nbsp;님
            <div class="login-info">
                <dl>
                    <dt>
                        <strong>관리자 :
                        </strong>
                        <span>김관제</span>
                    </dt>
                    <dd>
                        <a class="change-password">비밀번호 변경</a>
                    </dd>
                </dl>

                <a class="logout" data-font="Play">Log Out</a>
            </div>
        </li>
    </ul>
</div>
<div id="lay-find-pw" class="layer-base layer-member">
    <div class="layer-base-btns">
        <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
    </div>
    <div class="layer-base-title">비밀번호 변경</div>
    <div class="layer-base-conts">
        <dl class="mem-title">
            <dt>비밀번호 변경</dt>
            <dd>새로 사용할 비밀번호를 입력해주세요.</dd>
        </dl>
        </dl>
        <div class="mem-form">
            <dl style="background-color: #eee">
                <dt>이메일</dt>
                <dd class="email" style="font-size: 2rem;"><input type="text" name="email" readonly>
                </dd>
            </dl>
            <dl>
                <dt>비밀번호</dt>
                <dd><input type="password" name="password" id="password" required placeholder="영문+숫자 8자리 이상">
                </dd>
            </dl>
            <dl>
                <dt>비밀번호 확인</dt>
                <dd><input type="password" name="password_confirm" id="password_confirm" required placeholder="비밀번호 다시 입력">
                </dd>
            </dl>
        </div>

        <div class="mem-btn">
            <a class="change-btn">저장</a>
        </div>
    </div>
</div>