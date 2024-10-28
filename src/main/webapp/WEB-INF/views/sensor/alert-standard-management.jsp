<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"/>
    <script type="text/javascript" src="/jqgrid.js"></script>
    <script>
        $(function () {
            const $grid = $("#jq-grid");
            const path = "/sensor/alert-standard-management"
            initGrid($grid, path, $('#grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                useFilterToolbar: true,
            })

            $('.save-btn').on('click', function () {
                $.ajax({
                    method: 'post',
                    url: '/sensor/alert-standard-management/mod',
                    traditional: true,
                    data: {jsonData: JSON.stringify($grid.jqGrid("getRowData"))},
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
    <jsp:include page="../common/include_top.jsp" flush="true"/>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"/>
    </div>
    <div id="container">
        <h2 class="txt">센서모니터링</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">경보기준관리</h3>
                <div class="btn-group">
                    <a class="save-btn">저장</a>
                </div>
                <div id="grid-wrapper" class="contents-in">
                    <table id="jq-grid"></table>
                </div>
            </div>
        </div>
    </div>
    </div>
</section>
</body>
</html>