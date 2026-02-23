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

        .search-top {
            position: static;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 2.2rem;
        }

        .search-top > div {
            display: flex;
            flex-direction: row;
        }

        .search-top div:nth-child(2) > p {
            margin-right: 1rem;
        }

        #container input[type="date"] {
            width: 100%;
            height: 3.6rem;
            padding: 0 2rem;
            background-color: #fff;
            border: 1px solid rgba(0, 0, 0, 0.2);
            font-weight: 300;
            font-size: 1.5rem;
            line-height: 3.4rem;
            color: #47474c;
            text-align: center;
            display: inline-block;
            vertical-align: top;
        }
    </style>
    <script type="text/javascript" src="/jqgrid.js"></script>
    <script>
        $(document).ready(function () {

           $.when(
               $.get('/adminAdd/common/code/districtInfoList'),
               $.get('/adminAdd/common/code/list', {code_grp_nm: "유지보수상태"}),
               $.get('/adminAdd/common/code/list', {code_grp_nm: "알람상태"}),
               $.get('/adminAdd/common/netErrList')
           ).done(function(distRes, maintRes, alarmRes, netErrRes){

               function makeJqGridSelect(list) {
                   var str = ":전체";
                   $.each(list, function (i, v) {
                       // [수정] 데이터에 'sect_no'가 있으면 그것을 쓰고, 없으면 기존처럼 'code/name'을 씁니다.
                       if (v.sect_no !== undefined) {
                           str += ";" + v.sect_no + ":" + v.sect_no;
                       } else {
                           str += ";" + v.code + ":" + v.name;
                       }
                   });
                   return str;
               }

               function makeJqGridSelectByName(list){
                   var str = ':전체';
                   $.each(list, function(i,v){
                       // Value와 Label 모두 Name을 사용
                       str += ";" + v.name + ":" + v.name;
                   });
                   return str;
               }


               var distStr = makeJqGridSelectByName(distRes[0]);
               var maintStr = makeJqGridSelect(maintRes[0]);
               var alarmStr = makeJqGridSelect(alarmRes[0]);
               var netErrStr = makeJqGridSelect(netErrRes[0]);

               function formatDateOnly(date) {
                   const pad = (n) => n.toString().padStart(2, '0');
                   const year = date.getFullYear();
                   const month = pad(date.getMonth() + 1);
                   const day = pad(date.getDate());
                   return year + "-" + month + "-" + day;
               }

               const today = new Date();
               // 종료일
               const endDate = new Date(today);
               // 시작일
               const startDate = new Date(today);
               startDate.setMonth(startDate.getMonth() - 1);

               const $grid = $("#jq-grid");
               const path = "/sensor/alarm-details"
               initGrid($grid, path, $('#grid-wrapper'), {
                   multiselect: true,
                   multiboxonly: true,
                   custom: {
                       useFilterToolbar: false,
                   },
                   loadComplete: function () {
                       var $grid = $("#jq-grid");
                       if ($grid.data('toolbar_created')) return;


                       $grid.jqGrid('setColProp','district_nm', {
                           stype: 'select',
                           searchoptions: {value:distStr, sopt:['eq']  }
                       });

                       $grid.jqGrid('setColProp', 'formul_data', {
                            align: 'right'
                        });
                       

                       $grid.jqGrid('setColProp', 'maint_sts_cd', {
                           stype: 'select',
                           searchoptions: { value: maintStr, sopt: ['eq'] }
                       });

                       $grid.jqGrid('setColProp', 'alarm_lvl_cd', {
                           stype: 'select',
                           searchoptions: { value: alarmStr, sopt: ['eq'] }
                       });

                       $grid.jqGrid('setColProp', 'net_err_yn', {
                           stype: 'select',
                           searchoptions: { value: netErrStr, sopt: ['eq'] }
                       });

                       $grid.jqGrid('filterToolbar', {
                           stringResult: false,
                           searchOnEnter: true,
                           defaultSearch: "eq",
                           ignoreCase: true

                       });

                       $('#gview_jq-grid .clearsearchclass').off('click').on('click', function () {
                           var $this = $(this);

                           var $inputTd = $this.closest('td').prev('td');
                           var $select = $inputTd.find('select');
                           var $input = $inputTd.find('input');

                           if ($select.length > 0) $select.val('');
                           if ($input.length > 0) $input.val('');

                           $grid[0].triggerToolbar();
                       });


                       $grid.data('toolbar_created', true);
                   },

                   postData: {
                       start_date : formatDateOnly(startDate),
                       end_date: formatDateOnly(endDate)
                   }
               }, null, {
                   sms_cnt: {
                       formatter: function (cellValue) {
                           return cellValue + "/" + cellValue;
                       }
                   },
                   alarm_lvl_cd: {
                       formatter: function (cellValue, options, rowObject) {
                           // const alarmLevel = +rowObject?.alarm_lvl_cd;
                           if (cellValue === 'ARM001') {
                               return "관심"
                           } else if (cellValue === 'ARM002') {
                               return "주의"
                           } else if (cellValue === 'ARM003') {
                               return "경계"
                           } else if (cellValue === 'ARM004') {
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
                           const standard = rowObject?.alarm_lvl_cd;
                           if (standard === 'ARM001') {
                               return rowObject.min1 + " ~ " + rowObject.max1
                           }
                           else if (standard === 'ARM002') {
                               return rowObject.min2 + " ~ " + rowObject.max2
                           }
                           else if (standard === 'ARM003') {
                               return rowObject.min3 + " ~ " + rowObject.max3
                           }
                           else if (standard === 'ARM004') {
                               return rowObject.min4 + " ~ " + rowObject.max4
                           }
                           else {
                               return "-"
                           }
                       }
                   },
                   /* 알람이력이 남는 시점 자체가 데이터 수신이 기본이라서 아래와 같이 고정 처리 */
                   net_err_yn: {
                       formatter: function (cellValue, options, rowObject) {
                           return '수신';
                       }
                   }
               })

               function formatDate(date) {
                   const year = date.getFullYear();
                   const month = String(date.getMonth() + 1).padStart(2, '0');
                   const day = String(date.getDate()).padStart(2, '0');
                   return year + "-" + month + "-" + day;
               }

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
                           start_date: $('#start-date').val(),
                           end_date: $('#end-date').val()
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

                        const startDateValue = $('#start-date').val();
                        const endDateValue = $('#end-date').val();
                        const $smsModal = $('#lay-sensor-message');

                        $smsModal.attr('data-start-date', startDateValue);
                        $smsModal.attr('data-end-date', endDateValue);
                        $('#sms-start-date').val(startDateValue);
                        $('#sms-end-date').val(endDateValue);

                        if (typeof window.reloadSmsDetailsGridByDate === 'function') {
                            window.reloadSmsDetailsGridByDate();
                        }

                        popFancy('#lay-sensor-message')
                    }
                );

           })

        });

        function formatLocalDateTime(date) {
            const pad = (n) => n.toString().padStart(2, '0');
            const year = date.getFullYear();
            const month = pad(date.getMonth() + 1);
            const day = pad(date.getDate());
            const hours = pad(date.getHours());
            const minutes = pad(date.getMinutes());
            return year + "-" + month + "-" + day + "T" + hours + ":" + minutes;
        }

        $(function () {
            function formatDateOnly(date) {
                const pad = (n) => n.toString().padStart(2, '0');
                const year = date.getFullYear();
                const month = pad(date.getMonth() + 1);
                const day = pad(date.getDate());
                return year + "-" + month + "-" + day;
            }

            const today = new Date();

            // 종료일 = 오늘
            const endDate = new Date(today);

            // 시작일 = 한 달 전
            const startDate = new Date(today);
            startDate.setMonth(startDate.getMonth() - 1);

            $('#start-date').val(formatDateOnly(startDate));
            $('#end-date').val(formatDateOnly(endDate));

            $("#search-btn").click(() => {
                const startDate = $('#start-date').val();
                const endDate = $('#end-date').val();

                const $grid = $("#jq-grid"); // jqGrid 객체 참조

                // postData 갱신 + reloadGrid 실행
                $grid.setGridParam({
                    page: 1,
                    postData: {
                        ...$grid.jqGrid('getGridParam', 'postData'), // 기존 파라미터 유지
                        start_date: $('#start-date').val(),
                        end_date: $('#end-date').val()
                    }
                }).trigger("reloadGrid", [{ page: 1 }]);
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
                <div class="contents_header">
                    <h3 class="txt">알람이력조회</h3>
                    <div class="search-top">
                        <div>
                            <p class="search-top-label">조회기간</p>
                            <input id="start-date" type="date"/>
                        </div>
                        <div>
                            <p class="search-top-label">~</p>
                            <input id="end-date" type="date"/>
                        </div>
                    </div>
                    <div class="search-top_">
                        <a id="search-btn" class="btns" >조회</a>
                        <a id="open-modal" class="pop-modaㅣ btns btn_large">문자 전송 상세내역</a>
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
