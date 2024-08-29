<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>

        <style></style>

        <script>
            window.jqgridOption = {
                multiselect: false,
                multiboxonly: false
            }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택
        </script>
    </head>

    <body data-pgcode="0000">
        <section id="wrap">
            <!--[s] 상단 -->
            <jsp:include page="common/include_top.jsp" flush="true"></jsp:include>
            <!--[e] 상단 -->

            <!--[s] 왼쪽 메뉴 -->
            <div
                id="global-menu">
                <!--[s] 주 메뉴 -->
                <jsp:include page="common/include_sidebar.jsp" flush="true"></jsp:include>
                <!--[e] 주 메뉴 -->
            </div>
            <!--[e] 왼쪽 메뉴 -->

			<!--[s] 컨텐츠 영역 -->
            <div id="container">
                <h2 class="txt">알람 조회</h2>
<!--                 <div class="search-top"> -->
<!--                     <select id="dateCombo" name=""> -->
<!--                         <option value="today">금일</option> -->
<!--                         <option value="week">일주일</option> -->
<!--                         <option value="month">1개월</option> -->
<!--                     </select> -->
<!--                     <input type="text" id="datePicker" name="datePicker" value="" placeholder="2023-11-18  to  2023-11-18" datetimepicker="" class="flatpickr-input" readonly="readonly" /> -->
<!--                     <a href="javascript:search();" class="btns">조회</a> -->
<!--                 </div> -->

                <div id="contents">
                    <div class="contents-re">
                        <h3 class="txt">알람이력조회</h3>
                        <div class="contents-in">
<%--                            <jsp:include page="common/include_jqgrid.jsp" flush="true"></jsp:include>--%>
                            <jsp:include page="common/include_jqgrid_old.jsp" flush="true"></jsp:include>
                        </div>
                    </div>
                </div>
            </div>
            <!--[e] 컨텐츠 영역 -->
        </section>
    </body>
</html>
