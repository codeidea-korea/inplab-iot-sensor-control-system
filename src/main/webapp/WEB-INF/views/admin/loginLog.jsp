<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>

        <style></style>

        <script>
            window.jqgridOption = {
                multiselect: true,
                multiboxonly: false
            }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

            var _popupClearData;

            $(function () {
                _popupClearData = getSerialize('#lay-form-write');
                // 초기화할 데이터값

                // 삭제
                $('.deleteBtn').on('click', function () {
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 0) {
                        confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function () {
                            $.each(targetArr, function (idx) {
                                $.get('/admin/loginLog/del', this, function (res) { // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?
                                
                                    if((idx+1)==targetArr.length) reloadJqGrid();
                                
                                });
                            });

                            //reloadJqGrid();
                        });
                    } else {
                        alert('삭제하실 데이터를 선택해주세요.');
                        return;
                    }
                });

                $('.excelBtn').on('click', function () {
                    downloadExcel('로그인 로그');
                });
            });

        </script>
    </head>

    <body data-pgcode="0000">
        <section
            id="wrap">
            <!--[s] 상단 -->
            <jsp:include page="../common/include_top.jsp" flush="true"></jsp:include>
            <!--[e] 상단 -->

            <!--[s] 왼쪽 메뉴 -->
            <div
                id="global-menu">
                <!--[s] 주 메뉴 -->
                <jsp:include page="../common/include_sidebar.jsp" flush="true"></jsp:include>
                <!--[e] 주 메뉴 -->
            </div>
            <!--[e] 왼쪽 메뉴 -->

            <div id="container">
                <h2 class="txt">
                    관리자 전용
                    <span class="arr">관리자</span>
                </h2>
                <div id="contents">
                    <div class="contents-re">
                        <h3 class="txt">로그인 기록</h3>
                        <div class="btn-group">
                            <a class="deleteBtn">삭제</a>
                        </div>
                        <div class="contents-in">
<%--                            <jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>--%>
                        </div>
                    </div>
                </div>
            </div>
            <!--[e] 컨텐츠 영역 -->
        </section>
    </body>
</html>
