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
                const allRowData = $("#alert-standard-management-grid").jqGrid("getRowData");
                console.log(allRowData);
                $.ajax({
                    method: 'post',
                    url: '/sensor/alert-standard-management/mod',
                    traditional: true,
                    data: { jsonData: JSON.stringify(allRowData) },
                    dataType: 'json',
                    success: function (_res) {
                        alert('저장되었습니다.')
                    },
                    error: function (_res) {
                        alert('저장에 실패하였습니다. 입력 값을 확인해 주세요.')
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
        <h2 class="txt">센서모니터링</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">경보기준관리</h3>
                <div class="btn-group">
                    <a class="save-btn">저장</a>
                </div>
                <div class="contents-in">
                    <jsp:include page="./alert-standard-management-grid.jsp" flush="true"></jsp:include>
                </div>
            </div>
        </div>
    </div>
    </div>
</section>
</body>
</html>