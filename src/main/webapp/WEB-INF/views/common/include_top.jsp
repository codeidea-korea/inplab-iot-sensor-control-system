<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.safeone.dashboard.dto.UserDto" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    System.out.println("include_top.jsp");
    System.out.println("session.getAttribute(\"login\") :: " + session.getAttribute("login"));
    UserDto loginUser = (UserDto) session.getAttribute("login");
%>
<script>
    $(function () {
        const currentURI = '<%=request.getServletPath()%>';

        if (currentURI.indexOf('dashboard') > -1) {
        } else {
            $('.right-utill li').hide();
            $('.right-utill li.login').show();
        }

        $(document).on("mouseenter", ".login", function () {
            $("#header .login-info").show();
        });
        $(document).on("mouseleave", ".login", function () {
            $("#header .login-info").hide();
        });

        $(document).on('click', '.change-password', function (e) {
            popFancy('#lay-find-pw');
        });

        $(document).on('click', '.logout', function (e) {
            localStorage.setItem('loginSuccess', false);
            localStorage.setItem('autoLogin', false);
            window.location.href = "/logout";
        });

        $('.login span').html('<%=loginUser.getUsr_nm()%>');

        let grade = '<%=loginUser.getUsr_flag()%>'
        if (grade === '1') $('.login-info strong').html('관리자:');
        else $('.login-info strong').html('일반 사용자:');
        $('.login-info span').html('<%=loginUser.getUsr_nm()%>');
        $('#lay-find-pw .mem-form .email').html('<%=loginUser.getUsr_flag()%>');

        $('#lay-find-pw .change-btn').on('click', function () {
            const regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
            const password = $('#lay-find-pw input[name=password]').val();

            if (!regex.test(password)) {
                alert('비밀번호는 영문+숫자 조합 8자리 이상입니다.');
                return false;
            }

            $.get('/changePassword', {
                password,
                password_confirm: $('#lay-find-pw input[name=password_confirm]').val(),
            }, function (res) {
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
        <a href="/">
            <img src="data:image/jpeg;base64,${sessionScope.site_logo}" alt="${sessionScope.site_sys_nm}"
                 title="${sessionScope.site_sys_nm}"/>

            <span class="">${sessionScope.site_sys_nm}</span>
        </a>
    </h1>

    <div class="center-text">
        <span class="current_time">2022-11-09(수) 오전 11:56:11</span>
        </span>
    </div>

    <ul class="right-utill">
        <li>
            <button type="button" data-type="mask" class="roadview">
                <img src="/images/btn_roadview.png" alt="로드뷰"/>
            </button>
            <p class="tooltip">로드뷰</p>
        </li>
        <li>
            <button type="button" data-type="mask" class="editmode">
                <img src="/images/btn_editmode.png" alt="Edit Mode"/>
            </button>
            <p class="tooltip">Edit Mode</p>
        </li>

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
                <dd><input type="password" name="password_confirm" id="password_confirm" required
                           placeholder="비밀번호 다시 입력">
                </dd>
            </dl>
        </div>

        <div class="mem-btn">
            <a class="change-btn">저장</a>
        </div>
    </div>
</div>