<%@ page import="com.safeone.dashboard.dto.UserDto" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    UserDto loginUser = (UserDto)session.getAttribute("login");
%>
<script>
    $(function () {
        var currentURI = '<%=request.getServletPath()%>';
        let grade = '<%=loginUser.getUsr_flag()%>';
        if (grade !== '0') {
            // $("ul#gnb-menu li:last-child").hide();
            document.querySelectorAll('.admin-menu').forEach(menu => {
                menu.style.display = 'none';
            });
        }
        if (currentURI.indexOf('dashboard') > -1) {
            $('#gnb-menu').on('mouseover', function () {
                $(this).addClass('default open');
            });

            $('#gnb-menu').on('mouseleave', function () {
                $(this).removeClass('default open');
            });
        } else {
            $('#gnb-menu').addClass('default open');
        }

        $('#gnb-menu li').on('click', function () {
            $('#gnb-menu li').removeClass('active');
            // $('#gnb-menu li ul.menu-sub').removeClass('active');

            if ($(this).find('ul.menu-sub').length > 0) {
                $(this).addClass('active');
            }
        });

        // $('#gnb-menu li').on('mouseleave', function () {
        //     if ($(this).find('ul.menu-sub').length > 0) {
        //         $(this).removeClass('active');
        //     }
        // });

        var currentUrl = window.location.href;

        $.each($('ul#gnb-menu li a'), function() {
            if (currentUrl.indexOf($(this).attr('href')) > -1) {
                $(this).addClass('active');
                $(this).closest('li').addClass('active');
                if ($(this).closest('li').parent().hasClass('menu-sub')) {
                    $(this).closest('li').parent().closest('li').addClass('active');
                }

                $(this)[0].scrollIntoView();
                return false;
            }
        });
    });
</script>

<ul id="gnb-menu">
    <li>
        <button type="button" class="extend">
            <i></i>
            <p class="txt bul">Menu</p>
        </button>
    </li>
    <!-- 메뉴 확장 -->
    <li >
        <button type="button" class="round dashboard" onclick="location.href='/'">
            <dl>
                <dt data-type="dashboard">
                    <img src="/images/icon_gnb01.png" alt="대시보드">
                </dt>
                <dd>대시보드</dd>
            </dl>
        </button>
    </li>
    <li>
        <button type="button" class="round" onclick="location.href='/cctv'">
            <dl>
                <dt data-type="cctv">
                    <img src="/images/icon_gnb02.png" alt="CCTV">
                </dt>
                <dd>CCTV</dd>
            </dl>
        </button>
    </li>
    <li>
        <button type="button" class="round">
            <dl>
                <dt data-type="sensor">
                    <img src="/images/icon_gnb03.png" alt="센서조회">
                </dt>
                <dd class="bul">센서조회</dd>
            </dl>
        </button>
        <ul class="menu-sub">
            <li>
                <a href="/sensorList" class="menu-link">센서 목록</a>
                <a href="/sensorGroup" class="menu-link">센서 그룹 조회</a>
                <a href="/calc" class="menu-link">센서 정보 변경</a>
            </li>
        </ul>
    </li>
    <li>
        <button type="button" class="round">
            <dl>
                <dt data-type="alarm">
                    <img src="/images/icon_gnb04.png" alt="알람조회"></dt>
                <dd class="bul">알람조회</dd>
            </dl>
        </button>
        <ul class="menu-sub">
            <li>
                <a href="/alarmList" class="menu-link">알람 이력 조회</a>
                <%--               <a href="javascript:void(0);" class="menu-link">알람 Report</a>--%>
            </li>
        </ul>
    </li>
    <li>
        <button type="button" class="round">
            <dl>
                <dt data-type="warning">
                    <img src="/images/icon_gnb05.png" alt="경보대상관리"></dt>
                <dd><a href="/smsAlarm" class="menu-link">경보대상관리</a></dd>
            </dl>
        </button>
    </li>
    <%--    <li>--%>
    <%--	    <button type="button" class="round">--%>
    <%--	    <dl>--%>
    <%--	        <dt data-type="disaster">--%>
    <%--	            <img src="/images/icon_gnb06.png" alt="재난전파조회"></dt>--%>
    <%--	            <dd class="bul">재난전파조회</dd>--%>
    <%--	        </dl>--%>
    <%--	    </button>--%>

    <%--        <ul class="menu-sub">--%>
    <%--            <li>--%>
    <%--                <a href="disaster_broadcast_list.html" class="menu-link">재난방송 시스템 이력</a>--%>
    <%--                <a href="disaster_message_list.html" class="menu-link">재난문자 전광판 이력</a>--%>
    <%--            </li>--%>
    <%--        </ul>--%>
    <%--    </li>--%>
    <li>
        <button type="button" class="round">
            <dl>
                <dt data-type="maintenance">
                    <img src="/images/icon_gnb07.png" alt="유지보수관리">
                </dt>
                <dd>
                    <a href="/maintenance" class="menu-link">유지보수관리</a>
                </dd>
            </dl>
        </button>
    </li>
    <li class="admin-menu">
        <button type="button" class="round">
            <dl>
                <dt data-type="admin">
                    <img src="/images/icon_gnb08.png" alt="관리자 전용">
                </dt>
                <dd class="bul">관리자 전용</dd>
            </dl>
        </button>
        <ul class="menu-sub">
            <li>
                <dl>
                    <dt>자산관리</dt>
                    <dd>
                        <a href="/admin/assetList" class="menu-link">자산 목록</a>
                        <a href="/admin/assetKind" class="menu-link">자산 종류</a>
                    </dd>
                </dl>
            </li>
            <li>
                <dl>
                    <dt>알람관리</dt>
                    <dd>
                        <a href="/admin/alarmSetting" class="menu-link">알람 설정</a>
                        <a href="/admin/alarmRange" class="menu-link">계측기 알람 범위 설정</a>
                    </dd>
                </dl>
            </li>
            <li>
                <dl>
                    <dt>데이터관리</dt>
                    <dd>
                        <%--	                    <a href="/admin/dataLoger" class="menu-link">Loger 관리</a>--%>
                        <a href="/admin/dataMeasure" class="menu-link">계측기 데이터 관리</a>
                    </dd>
                </dl>
            </li>
            <li>
                <dl>
                    <dt>관리자</dt>
                    <dd>
                        <a href="/admin/loginLog" class="menu-link">로그인 기록</a>
                        <a href="/admin/user" class="menu-link">사용자 관리</a>
                        <a href="/admin/area" class="menu-link">현장 관리</a>
                        <a href="/admin/zone" class="menu-link">지구 관리</a>
                        <a href="/admin/device" class="menu-link">로거 관리</a>
                        <a href="/admin/emergencyCall" class="menu-link">비상연락망 관리</a>
                    </dd>
                </dl>
            </li>
            <li>
                <dl>
                    <dt>전광판관리</dt>
                    <dd>
                        <a href="/admin/createDisplay" class="menu-link">전송이미지 생성</a>
                        <a href="/admin/sendGroup" class="menu-link">전송그룹 관리</a>
                        <a href="/admin/sendContr" class="menu-link">전송 제어</a>
                    </dd>
                </dl>
            </li>
        </ul>
    </li>


    <li class="admin-menu">
        <button type="button" class="round">
            <dl>
                <dt data-type="admin">
                    <img src="/images/icon_gnb08.png" alt="관리자 전용">
                </dt>
                <dd class="bul">관리자 전용</dd>
            </dl>
        </button>
        <ul class="menu-sub">
            <li>
                <dl>
                    <dt>현장관리</dt>
                    <dd>
                        <a href="/adminAdd/siteInfo" class="menu-link">기관 정보 관리</a>
                        <a href="/adminAdd/districtInfo" class="menu-link">현장 정보 관리</a>
                    </dd>
                </dl>
            </li>
            <li>
                <dl>
                    <dt>센서관리</dt>
                    <dd>
                        <a href="/adminAdd/loggerInfo" class="menu-link">로거 관리</a>
                        <a href="/adminAdd/sensorType" class="menu-link">센서타입관리</a>
                        <a href="/adminAdd/sensorInfo" class="menu-link">센서관리</a>
                        <a href="/adminAdd/logrIdxMap" class="menu-link">센서-로거인덱스</a>
                    </dd>
                </dl>
            </li>
            <li>
                <dl>
                    <dt>장치관리</dt>
                    <dd>
                        <a href="/adminAdd/view/cctvInfo" class="menu-link">CCTV 관리</a>
                        <a href="/adminAdd/view/dispboardInfo" class="menu-link">전광판 관리</a>
                        <a href="/adminAdd/view/broadcastInfo" class="menu-link">방송장비 관리</a>
                    </dd>
                </dl>
            </li>
            <li>
                <dl>
                    <dt>데이터관리</dt>
                    <dd>
                        <a href="/adminAdd/view/measureDetails" class="menu-link">계측기 데이터 관리</a>
                    </dd>
                </dl>
            </li>
        </ul>
    </li>


</ul>