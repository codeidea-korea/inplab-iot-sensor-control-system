<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--

${zone}

-->
<style>
    .device-list, .alarm-list, .emer-list, .maintenance-details-list {
        max-height: 200px;
        overflow-y: auto;
    }

    .maintenance-details-list table thead th,
    .alarm-list table thead th,
    .emer-list table thead th,
    .device-list table thead th {
        position: sticky;
        top: 0;
    }

</style>
<div class="close-btns">
    <img src="/images/btn_lay_close.png" alt="닫기">
</div>
<div class="title">상세정보</div>
<div class="conts">
    <div class="site-status-details_re">
        <div class="title">정보</div>
        <div class="conts">
            <div class="txt-info">
                <dl>
                    <dt>현장명 :</dt>
                    <dd>${zone.area_name}</dd>
                </dl>
                <dl>
                    <dt>지구명 :</dt>
                    <dd>${zone.zone_name}</dd>
                </dl>
                <dl>
                    <dt>시공사 :</dt>
                    <dd>${zone.constructor}</dd>
                </dl>
                <dl>
                    <dt>현장종류 :</dt>
                    <dd>${zone.type}</dd>
                </dl>
                <dl>
                    <dt>계측사 :</dt>
                    <dd>${zone.measures}</dd>
                </dl>
                <dl>
                    <dt>현장 주소 :</dt>
                    <dd class="addressText"></dd>
                </dl>
            </div>
        </div>
    </div>

    <div class="site-status-details_re" two="">
        <div class="title">알람 현황(최근 1분 기준)</div>
        <div class="conts">
            <ul class="donutty-area">
                <li level="1">
                    <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl"
                         data-anchor="top" data-bg="#37474f" data-color="#90da00" data-value="0"></div>
                    <p class="chart-donutty-title">관심</p>
                </li>
                <li level="2">
                    <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl"
                         data-anchor="top" data-bg="#37474f" data-color="#ffd200" data-value="0"></div>
                    <p class="chart-donutty-title">주의</p>
                </li>
                <li level="3">
                    <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl"
                         data-anchor="top" data-bg="#37474f" data-color="#ff9600" data-value="0"></div>
                    <p class="chart-donutty-title">경계</p>
                </li>
                <li level="4">
                    <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl"
                         data-anchor="top" data-bg="#37474f" data-color="#ff0000" data-value="0"></div>
                    <p class="chart-donutty-title">심각</p>
                </li>
            </ul>
        </div>
    </div>

    <div class="site-status-details_re" two="">
        <div class="title">장비 현황</div>
        <div class="conts">
            <div class="bTable device-list">
                <table>
                    <thead>
                    <tr>
                        <th>센서타입명</th>
                        <th>전체</th>
                        <th>센서이상</th>
                        <th>통신이상</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr data-kind="2">
                        <td>구조물경사계</td>
                        <td class="all-cnt">0</td>
                        <td class="sens-err">0</td>
                        <td class="network-err">0</td>
                    </tr>
                    <tr data-kind="3">
                        <td>지표변위계</td>
                        <td class="all-cnt">0</td>
                        <td class="sens-err">0</td>
                        <td class="network-err">0</td>
                    </tr>
                    <tr data-kind="4">
                        <td>강우계</td>
                        <td class="all-cnt">0</td>
                        <td class="sens-err">0</td>
                        <td class="network-err">0</td>
                    </tr>
                    <tr data-kind="8">
                        <td>CCTV</td>
                        <td class="all-cnt">0</td>
                        <td class="sens-err">0</td>
                        <td class="network-err">0</td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <%--            <ul class="equipment-list">--%>
            <%--                <li kind="2"><span>구조물경사계</span> <strong>0개</strong></li>--%>
            <%--                <li kind="3"><span>지표변위계</span> <strong>0개</strong></li>--%>
            <%--                <li kind="4"><span>강우계</span> <strong>0개</strong></li>--%>
            <%--                <li kind="8"><span>CCTV</span> <strong>0개</strong></li>--%>
            <%--                <li fc_step5 asset_id=""><span>기타</span> <strong>1개</strong></li>--%>
            <%--            </ul>--%>
        </div>
    </div>

    <div class="site-status-details_re">
        <div class="title">알람 이력</div>
        <div class="conts">
            <div class="bTable alarm-list">
                <table>
                    <thead>
                    <tr>
                        <th>알람레벨</th>
                        <th>현장</th>
                        <th>센서종류</th>
                        <th>센서</th>
                        <th>알람종류</th>
                        <th>일자</th>
                        <th>알람발생시간</th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="site-status-details_re">
        <div class="title">유지보수 이력</div>
        <div class="conts">
            <div class="bTable maintenance-details-list">
                <table>
                    <thead>
                    <tr>
                        <th>센서타입</th>
                        <th>센서(장치)</th>
                        <th>작업결과</th>
                        <th>작업시작일자</th>
                        <th>작업종료일자</th>
                        <th>작업업체</th>
                        <th>담당자</th>
                        <th>연락처</th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <%--    <div class="site-status-details_re" two="">--%>
    <%--        <div class="title">시스템 상태</div>--%>
    <%--        <div class="conts">--%>
    <%--            <ul class="system-status">--%>
    <%--                <li kind="2">--%>
    <%--                    <p class="tit">구조물경사계</p>--%>
    <%--                    <div class="conts">--%>
    <%--                        <a href="javascript:void(0);" status=""><span>전체</span><strong>0</strong></a>--%>
    <%--                        <a href="javascript:void(0);" status="1"><span>정상</span><strong>0</strong></a>--%>
    <%--                        <a href="javascript:void(0);" status="2"><span>비정상</span><strong>0</strong></a>--%>
    <%--                    </div>--%>
    <%--                </li>--%>
    <%--                <li kind="3">--%>
    <%--                    <p class="tit">지표변위계</p>--%>
    <%--                    <div class="conts">--%>
    <%--                        <a href="javascript:void(0);" status=""><span>전체</span><strong>0</strong></a>--%>
    <%--                        <a href="javascript:void(0);" status="1"><span>정상</span><strong>0</strong></a>--%>
    <%--                        <a href="javascript:void(0);" status="2"><span>비정상</span><strong>0</strong></a>--%>
    <%--                    </div>--%>
    <%--                </li>--%>
    <%--                <li kind="4">--%>
    <%--                    <p class="tit">강우량계</p>--%>
    <%--                    <div class="conts">--%>
    <%--                        <a href="javascript:void(0);" status=""><span>전체</span><strong>0</strong></a>--%>
    <%--                        <a href="javascript:void(0);" status="1"><span>정상</span><strong>0</strong></a>--%>
    <%--                        <a href="javascript:void(0);" status="2"><span>비정상</span><strong>0</strong></a>--%>
    <%--                    </div>--%>
    <%--                </li>--%>
    <%--                <li kind="8">--%>
    <%--                    <p class="tit">CCTV</p>--%>
    <%--                    <div class="conts">--%>
    <%--                        <a href="javascript:void(0);" status=""><span>전체</span><strong>0</strong></a>--%>
    <%--                        <a href="javascript:void(0);" status="1"><span>정상</span><strong>0</strong></a>--%>
    <%--                        <a href="javascript:void(0);" status="2"><span>비정상</span><strong>0</strong></a>--%>
    <%--                    </div>--%>
    <%--                </li>--%>
    <%--            </ul>--%>
    <%--        </div>--%>
    <%--    </div>--%>

    <div class="site-status-details_re">
        <div class="title">비상 연락망</div>
        <div class="conts">
            <div class="bTable emer-list">
                <table>
                    <thead>
                    <tr>
                        <th>역할</th>
                        <th>소속</th>
                        <th>이름</th>
                        <th>연락처</th>
                        <th>이메일</th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!--시스템 상태 팝업 -->
    <div id="lay-system-status-list" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
        </div>
        <div class="layer-base-title">전체 시스템 상태 리스트</div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table class="gridSystem"></table>
            </div>
        </div>
    </div>

    <!--유지보수 이력 팝업 -->
    <div id="lay-maintenance-list" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
        </div>
        <div class="layer-base-title">유지보수 이력 조회</div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table class="gridMaintenance"></table>
            </div>
        </div>
    </div>
</div>


<script>

    $(function () {
        let zone_id = ${zone.zone_id};
        let param = {"zone_id": zone_id};
        let $alarmGrid, $systemGrid, $maintenanceGrid, $deviceGrid, $alarmHistoryGrid;
        const startInterval = function () {
            loadAlarmCount();           // 알람현황 횟수
            loadDeviceCount();          // 장비현황 횟수
            loadAlarmHistory();         // 알람 이력
            loadSystemCount();          // 시스템 상태
            loadMaintenance();          // 유지보수 이력
            loadEmergency();            // 비상 연락망
        };

        $('.site-status-details [data-donutty]').donutty();

        window.zoneDetail = setInterval(startInterval, LATENCY); // 60 초 마다

        startInterval();

        $.get('/common/getAddress', {
            lat: ${zone.lat},
            lng: ${zone.lng}
        }, function (res) {
            // console.log(res);

            if (res.response.status == 'OK') {
                try {
                    let address = res.response.result[0];
                    $('.addressText').html(address.text);
                } catch (e) {
                }
            }
        });

        // 각 알람 현황 클릭시
        $('.site-status-details_re .donutty-area li').off().on('click', function () {
            let level = $(this).attr('level');
            $.get('/alarmDataByLevel/columns', function (res) {
                delete res.risk_level;
                res.zone_id.width = 150;
                res.asset_kind_name.width = 150;
                res.asset_name.width = 150;
                $alarmGrid = jqgridUtil($('.gridAlarm'), {
                    listPathUrl: "/alarmDataByLevel",
                    risk_level: level,
                    zone_id: zone_id,
                    view_flag: 'Y'
                }, res, true, null, null);

                $alarmGrid.jqGrid('setGridParam', {
                    beforeRequest: function () {
                        let currentParams = {
                            listPathUrl: "/alarmDataByLevel",
                            risk_level: level,
                            zone_id: zone_id,
                            view_flag: 'Y'
                        };

                        let p = Object.assign($alarmGrid.jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                            return !!this.value;
                        }).serializeObject());

                        $alarmGrid.setGridParam({
                            postData: Object.assign(p, currentParams)
                        });
                    },
                    ondblClickRow: function (rowId) {
                        $alarmGrid.find('tr').removeClass('custom_selected');
                        let rowData = $(this).getRowData(rowId);
                        openSensorInfo(rowData);
                    }
                });
                $alarmGrid.trigger('reloadGrid');
            });
            popFancy('#lay-alarm-info');
        });

        // 장비 현황 클릭시
        $('.device-list tbody tr').off().on('click', function () {
            let assetKindId = $(this).attr('data-kind');
            $.get('/admin/assetList/columns', function (res) {
                delete res.asset_kind_id;
                delete res.collect_date;
                delete res.etc1;
                delete res.etc2;
                delete res.etc3;
                res.zone_id.width = 220;
                res.name.width = 220;
                res.install_date.width = 220;
                res.status.width = 220;
                res.real_value.width = 220;
                $deviceGrid = jqgridUtil($('.gridDevice'), {
                    listPathUrl: "/admin/assetList",
                    asset_kind_id: assetKindId,
                    zone_id: zone_id
                }, res, true, null, null);
                $deviceGrid.jqGrid('setGridParam', {
                    beforeRequest: function () {
                        let currentParams = {
                            listPathUrl: "/admin/assetList",
                            asset_kind_id: assetKindId,
                            zone_id: zone_id
                        };

                        let p = Object.assign($deviceGrid.jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                            return !!this.value;
                        }).serializeObject());

                        $deviceGrid.setGridParam({
                            postData: Object.assign(p, currentParams)
                        });
                    },
                    ondblClickRow: function (rowId) {
                        $deviceGrid.find('tr').removeClass('custom_selected');
                        let rowData = $(this).getRowData(rowId);
                        openSensorInfo(rowData);
                    }
                });
                $deviceGrid.trigger('reloadGrid');
            });
            popFancy('#lay-equipment-area');
        });

        // 알람 이력 클릭시
        $('.site-status-details_re .alarm-list').off().on('click', function () {
            $.get('/alarmList/columns', function (res) {
                res.zone_id.width = 100;
                res.risk_level.width = 100;
                res.asset_kind_name.width = 100;
                res.asset_name.width = 140;

                $alarmHistoryGrid = jqgridUtil($('.gridAlarmHistory'), {
                    listPathUrl: "/alarmList",
                    zone_id: zone_id
                }, res, true, null, null);
                $alarmHistoryGrid.jqGrid('setGridParam', {
                    ondblClickRow: function (rowId) {
                        $alarmHistoryGrid.find('tr').removeClass('custom_selected');
                        let rowData = $(this).getRowData(rowId);
                        openSensorInfo(rowData);
                    }
                });
            });
            popFancy('#lay-alarm-history');
        });

        //시스템 상태 클릭
        $('.site-status-details_re .system-status li a').off().on('click', function () {
            var assetKindId = $(this).closest('li').attr('kind');
            var status = $(this).attr('status');
            // console.log(assetKindId);
            // console.log(status);
            if (status === "1") {
                $('#lay-system-status-list .layer-base-title').html("수신 시스템 리스트");
            } else if (status === "2") {
                $('#lay-system-status-list .layer-base-title').html("미수신 시스템 리스트");
            } else {
                $('#lay-system-status-list .layer-base-title').html("전체 시스템 상태 리스트");
            }

            $.get('/admin/assetList/columns', function (res) {
                console.log(res);
                delete res.real_value;
                delete res.asset_kind_id;
                delete res.etc1;
                delete res.etc2;
                delete res.etc3;
                res.install_date.width = 250;
                res.collect_date.width = 250;
                res.status.width = 250;
                $systemGrid = jqgridUtil($('.gridSystem'), {
                    listPathUrl: "/admin/assetList",
                    asset_kind_id: assetKindId,
                    status: status,
                    zone_id: zone_id
                }, res, true, null, null);
                $systemGrid.jqGrid('setGridParam', {
                    beforeRequest: function () {
                        let currentParams = {
                            listPathUrl: "/admin/assetList",
                            asset_kind_id: assetKindId,
                            status: status,
                            zone_id: zone_id
                        };

                        let p = Object.assign($systemGrid.jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                            return !!this.value;
                        }).serializeObject());

                        $systemGrid.setGridParam({
                            postData: Object.assign(p, currentParams)
                        });
                    },
                    ondblClickRow: function (rowId) {
                        $systemGrid.find('tr').removeClass('custom_selected');
                        let rowData = $(this).getRowData(rowId);
                        openSensorInfo(rowData);
                    }
                });
                $systemGrid.trigger('reloadGrid');
            });
            popFancy('#lay-system-status-list');
        });

        // 유지보수 이력 클릭
        $('.site-status-details_re .maintenance-list tbody').off().on('click', function () {
            $.get('/maintenance/columns', function (res) {
                // console.log(res);
                delete res.zone_id;
                res.reg_day.width = 120;
                res.reg_time.width = 120;
                res.manager_name.width = 80;
                res.description.width = 180;
                $maintenanceGrid = jqgridUtil($('.gridMaintenance'), {
                    listPathUrl: "/maintenance",
                    zone_id: zone_id
                }, res, true, null, null);
                $maintenanceGrid.jqGrid('setGridParam', {
                    beforeRequest: function () {
                        let currentParams = {
                            listPathUrl: "/maintenance",
                            zone_id: zone_id
                        };

                        let p = Object.assign($maintenanceGrid.jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                            return !!this.value;
                        }).serializeObject());

                        $maintenanceGrid.setGridParam({
                            postData: Object.assign(p, currentParams)
                        });
                    }
                });
                $maintenanceGrid.trigger('reloadGrid');
            });
            popFancy('#lay-maintenance-list');
        });

        // 알림현황 카운트
        function loadAlarmCount() {
            $.get('/alarmList/alarmCount', param, function (res) {
                // console.log(res);
                let totalLength = 314.1592653589793;
                let values = [
                    res.interest_cnt,
                    res.notice_cnt,
                    res.warning_cnt,
                    res.danger_cnt
                ];

                function updateDonutChart(index, value) {
                    if (value > 0) {
                        $('.site-status-details_re .donutty-area li:eq(' + index + ')').css("cursor", "pointer");
                    } else {
                        $('.site-status-details_re .donutty-area li:eq(' + index + ')').off('click');
                    }
                    $('.site-status-details_re .donutty-area li:eq(' + index + ') div').attr('data-value', value);
                    let offset = totalLength - (totalLength * (value / 100));
                    $('.site-status-details_re .donutty-area li:eq(' + index + ') .donut-fill').css('stroke-dashoffset', offset);
                }

                for (let i = 0; i < values.length; i++) {
                    updateDonutChart(i, values[i]);
                }
            });
        }

        function loadDeviceCount() {
            $.get('/deviceCount', param, function (res) {
                // 서버에서 받은 카운트 값
                let counts = {
                    2: res.tm_count,   // 구조물경사계
                    3: res.tw_count,   // 지표변위계
                    4: res.wr_count,   // 강우계
                    8: res.cctv_count   // CCTV
                };

                $('.device-list tbody tr').each(function () {
                    let kind = $(this).data('kind');
                    if (counts[kind] !== undefined) {
                        $(this).find('.all-cnt').text(counts[kind]);

                        if (counts[kind] > 0) {
                            $(this).css("cursor", "pointer");
                        } else {
                            $(this).css("cursor", "default");
                        }
                    }
                });
            });
        }


        // 알람 이력
        function loadAlarmHistory() {
            $.get('/alarmList/alarmHistory', param, function (res) {
                if (typeof res != 'undefined') $('.site-status-details_re .alarm-list tbody').empty();
                if (res.length > 0) $('.site-status-details_re .alarm-list').css("cursor", "pointer");
                $.each(res, function (idx) {
                    let level = res[idx].risk_level;
                    let contents = '<tr>';
                    if (level === '1') {
                        contents += '<td><div class="level" fc_step1=""><strong>관심</strong></div></td>';
                    } else if (level === '2') {
                        contents += '<td><div class="level" fc_step2=""><strong>주의</strong></div></td>';
                    } else if (level === '3') {
                        contents += '<td><div class="level" fc_step3=""><strong>경계</strong></div></td>';
                    } else if (level === '4') {
                        contents += '<td><div class="level" fc_step4=""><strong>심각</strong></div></td>';
                    }
                    contents += '<td>' + res[idx].area_name + '</td>';
                    contents += '<td>' + res[idx].asset_kind_name + '</td>';
                    contents += '<td>' + res[idx].asset_name + '</td>';
                    contents += '<td>' + res[idx].alarm_kind_name + '</td>';
                    contents += '<td>' + res[idx].reg_day + '</td>';
                    contents += '<td>' + res[idx].reg_time + '</td>';
                    contents += '</tr>';

                    $('.site-status-details_re .alarm-list tbody').append(contents);
                });
            });
        }

        function loadSystemCount() {
            $.get('/detailSystemCount', param, function (res) {
                $.each(res, function (i) {
                    let listItem = $('.site-status-details_re .system-status li:eq(' + i + ')');
                    listItem.find('strong:eq(0)').html(res[i].total_count);
                    listItem.find('strong:eq(1)').html(res[i].status_1_count);
                    listItem.find('strong:eq(2)').html(res[i].status_2_count);

                    // if (res[i].total_count > 0 || res[i].status_1_count > 0 || res[i].status_2_count > 0) {
                    //     listItem.css("cursor", "pointer");
                    // } else {
                    //     listItem.off('click');
                    // }
                });
            });
        }

        function loadMaintenance() {
            $.ajax({
                url: '/maintenance/details/list' + '?rows=1000&page=1',
                type: 'GET',
                data: param,
                success: function (res) {
                    console.log(res.rows)
                    if (res.rows) {
                        $('.site-status-details_re .maintenance-details-list tbody').empty();
                        if (res.rows.length > 0) $('.site-status-details_re .maintenance-list').css("cursor", "pointer");
                        $.each(res.rows, function (idx) {

                            let maintenanceResult = '-';
                            switch (res.rows[idx].maint_rslt_cd) {
                                case 'MTN001':
                                    maintenanceResult = '정상';
                                    break;
                                case 'MTN002':
                                    maintenanceResult = '망실';
                                    break;
                                case 'MTN003':
                                    maintenanceResult = '점검';
                                    break;
                                case 'MTN004':
                                    maintenanceResult = '철거';
                                    break;
                            }

                            let contents = '<tr>';
                            contents += '<td>' + res.rows[idx].sens_tp_nm + '</td>';
                            contents += '<td>' + res.rows[idx].sens_nm + '</td>';
                            contents += '<td>' + maintenanceResult + '</td>';
                            contents += '<td>' + res.rows[idx].maint_str_ymd + '</td>';
                            contents += '<td>' + res.rows[idx].maint_end_ymd + '</td>';
                            contents += '<td>' + res.rows[idx].maint_comp_nm + '</td>';
                            contents += '<td>' + res.rows[idx].maint_chgr_nm + '</td>';
                            contents += '<td>' + res.rows[idx].maint_chgr_ph + '</td>';
                            contents += '</tr>';
                            $('.site-status-details_re .maintenance-details-list tbody').append(contents);
                        });
                    }


                },
                error: function () {
                    alert('알 수 없는 오류가 발생했습니다.');
                }
            });
        }

        function loadEmergency() {
            $.get('/emergencyInfo', param, function (res) {
                // console.log(res);
                if (typeof res != 'undefined') $('.site-status-details_re .emer-list tbody').empty();
                $.each(res, function (idx) {
                    let contents = '<tr>';
                    contents += '<td>' + res[idx].role + '</td>';
                    contents += '<td>' + res[idx].company_name + '</td>';
                    contents += '<td>' + res[idx].name + '</td>';
                    contents += '<td>' + res[idx].tel1 + '</td>';
                    contents += '<td>' + res[idx].email + '</td>';
                    contents += '</tr>';

                    $('.site-status-details_re .emer-list tbody').append(contents);
                });
            });
        }
    }); // jquery init end
</script>