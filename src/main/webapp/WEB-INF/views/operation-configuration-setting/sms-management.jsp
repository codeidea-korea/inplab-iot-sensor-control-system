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
            const path = "/operation-configuration-setting/sms-management";
            initGrid($grid, path, $('#grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                useFilterToolbar: true,
            }, null, null, {alarm_lvl_nm: "1:1차 초과 이상;2:2차 초과 이상;3:3차 초과 이상;4:4차 초과 이상", sms_autosnd_yn: "Y:Y;N:N"});

            $('.save-btn').on('click', function () {
                const allRowData = $grid.jqGrid("getRowData");
                const filteredData = allRowData.filter((item) =>
                    item.mgnt_no && item.alarm_lvl_nm
                );
                $.ajax({
                    method: 'post',
                    url: '/operation-configuration-setting/sms-management/mod',
                    traditional: true,
                    data: {jsonData: JSON.stringify(filteredData)},
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
    <jsp:include page="../common/include_top.jsp" flush="true"/>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"/>
    </div>
    <div id="container">
        <h2 class="txt">SMS (경보문자) 연계</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">SMS 경보 대상 관리</h3>
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