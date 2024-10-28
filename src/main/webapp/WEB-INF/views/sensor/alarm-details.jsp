<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"/>
    <style>
        .layer-base-conts table td:first-child {
            border-left: 1px solid rgba(0, 0, 0, 0.2);
        }

        .message_text > tbody > tr > td {
            line-height: 3rem;
        }

        .btn_large {
            width: 15rem !important;
        }

        .search-top > input {
            width: 22rem !important;
        }

        .search-top-label {
            color: #ffffff76;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            padding: 1rem;
        }
    </style>
    <script type="text/javascript" src="/jqgrid.js"></script>
    <script>
        $(document).ready(function () {
            const $grid = $("#jq-grid");
            const path = "/sensor/alarm-details"
            initGrid($grid, path, $('#grid-wrapper'), {
                multiselect: true,
                multiboxonly: true,
                useFilterToolbar: true,
            })

            const currentYear = new Date().getFullYear();
            const startDate = currentYear + "-01-01";
            const endDate = currentYear + "-12-31";
            $('#history-date-range').val(startDate + " ~ " + endDate);

            $('#history-date-range').change(() => {
                setGridData();
                $grid.trigger('reloadGrid');
            })

            function setGridData() {
                $grid.setGridParam({
                    page: 1,
                    postData: {
                        ...$grid.jqGrid('getGridParam', 'postData'),
                        reg_day: $('#history-date-range').val()
                    }
                }).trigger('reloadGrid', [{page: 1}]);
            }

            $('.excelBtn').on('click', function () {
                downloadExcel('alarm-list', $grid, path);
            });

            $("#open-modal").click(() => {
                    const targetArr = getSelectedCheckData($grid);

                    if (targetArr.length > 1) {
                        alert('데이터를 1건만 선택해주세요.');
                        return;
                    } else if (targetArr.length === 0) {
                        alert('조회할 데이터를 선택해주세요.');
                        return;
                    }

                    popFancy('#lay-sensor-message')
                }
            );
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
        <div class="search-top">
            <p class="search-top-label">조회기간</p>
            <input type="text" id="history-date-range" datetimepicker/>
            <a id="open-modal" class="pop-modaㅣ btns btn_large">문자 전송
                상세내역</a>
            <a class="excelBtn btns">다운로드</a>
        </div>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">알람이력조회</h3>
                <div id="grid-wrapper" class="contents-in">
                    <table id="jq-grid"></table>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="./sms-details.jsp" flush="true"/>
</section>
</body>
</html>
