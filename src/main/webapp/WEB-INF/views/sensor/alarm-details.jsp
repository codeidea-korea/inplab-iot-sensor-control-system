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

        #cb_sms-details-grid {
            display: none;
        }

        .contents_header {
            display: flex;
            align-items: center;
            justify-content: space-between;
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
                custom: {
                    useFilterToolbar: true,
                }
            }, null, {
                sms_cnt: {
                    formatter: function (cellValue) {
                        return cellValue + "/" + cellValue;
                    }
                },
                alarm_lvl_cd: {
                    formatter: function (cellValue, options, rowObject) {
                        const alarmLevel = +rowObject?.alarm_lvl_cd;
                        if (alarmLevel === 1) {
                            return "관심"
                        } else if (alarmLevel === 2) {
                            return "주의"
                        } else if (alarmLevel === 3) {
                            return "경계"
                        } else if (alarmLevel === 4) {
                            return "심각"
                        } else {
                            return "관심"
                        }
                    }
                },
                maint_sts_cd: {
                    formatter: (cellValue, _options, _rowObject) => {
                        let value = '';
                        if (cellValue === 'MTN001') {
                            value = '정상';
                        } else if (cellValue === 'MTN002') {
                            value = '망실';
                        } else if (cellValue === 'MTN003') {
                            value = '점검';
                        } else if (cellValue === 'MTN004') {
                            value = '철거';
                        }
                        return value
                    }
                },
                standard: {
                    formatter: function (cellValue, options, rowObject) {
                        const standard = +rowObject?.alarm_lvl_cd;
                        if (standard === 1) {
                            return rowObject.min1 + " ~ " + rowObject.max1
                        }
                        else if (standard === 2) {
                            return rowObject.min2 + " ~ " + rowObject.max2
                        }
                        else if (standard === 3) {
                            return rowObject.min3 + " ~ " + rowObject.max3
                        }
                        else if (standard === 4) {
                            return rowObject.min4 + " ~ " + rowObject.max4
                        }
                        else {
                            return "-"
                        }
                    }
                }
            })

            // const currentYear = new Date().getFullYear();
            // const startDate = currentYear + "-01-01";
            // const endDate = currentYear + "-12-31";

            function formatDate(date) {
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                return year + "-" + month + "-" + day;
            }

            const today = new Date();

            // 종료일
            const endDate = new Date(today);
            // 시작일
            const startDate = new Date(today);
            startDate.setMonth(startDate.getMonth() - 1);

            $('#history-date-range').val(formatDate(startDate) + " ~ " + formatDate(endDate));

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
        <div id="contents">
            <div class="contents-re">
                <div class="contents_header">
                    <h3 class="txt">알람이력조회</h3>
                    <div class="search-top_">
                        <p class="search-top-label">조회기간</p>
                        <input type="text" id="history-date-range" datetimepicker/>
                        <a id="open-modal" class="pop-modaㅣ btns btn_large">문자 전송
                            상세내역</a>
                        <a class="excelBtn btns">다운로드</a>
                    </div>
                </div>
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
