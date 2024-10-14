<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>
    <script>
        window.jqgridOption = {
            columnAutoWidth: true,
            multiselect: true,
            multiboxonly: false
        };
        $(function () {
            $('.save-btn').on('click', function () {
                const allRowData = $(".jqGrid").jqGrid("getRowData");
                const filteredData = allRowData.filter((item) =>
                    item.mgnt_no && item.alarm_lvl_nm
                );
                $.ajax({
                    method: 'post',
                    url: '/operation-configuration-setting/sms-management/mod',
                    traditional: true,
                    data: { jsonData: JSON.stringify(filteredData) },
                    dataType: 'json',
                    success: function (_res) {
                        alert('저장되었습니다.')
                    }
                });
            });
        });

    </script>
</head>

<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"></jsp:include>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"></jsp:include>
    </div>
    <div id="container">
        <h2 class="txt">SMS (경보문자) 연계</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">SMS 경보 대상 관리</h3>
                <div class="btn-group">
                    <input type="text" class="search_input" id="search" name="search" placeholder="이름/소속기관/휴대폰번호"/>
                    <a class="searchBtn">검색</a>
                    <a class="save-btn">저장</a>
                </div>
                <div class="contents-in">
                    <jsp:include page="./sms-management-grid.jsp" flush="true"></jsp:include>
                </div>
            </div>
        </div>
    </div>
    </div>
</section>
</body>
</html>