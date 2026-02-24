<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--

${district}

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

    .site-status-details_re .conts {
        height: 100%; /* 또는 고정 px 단위 예: 200px */
    }

    .site-status-details_re .conts .donutty-area {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 80%; /* 또는 고정 px 단위 예: 200px */
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
                    <dd>${district.district_nm}</dd>
                </dl>
<%--                <dl>--%>
<%--                    <dt>지구명 :</dt>--%>
<%--                    <dd>${district.zone_name}</dd>--%>
<%--                </dl>--%>
                <dl>
                    <dt>시공사 :</dt>
                    <dd>${district.inst_comp_nm1}</dd>
                </dl>
<%--                <dl>--%>
<%--                    <dt>현장종류 :</dt>--%>
<%--                    <dd>${district.type}</dd>--%>
<%--                </dl>--%>
                <dl>
                    <dt>계측사 :</dt>
                    <dd>${district.meas_comp_nm1}</dd>
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
                        <th>COUNT</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr data-kind="TM">
                        <td>구조물경사계</td>
                        <td class="cnt">0</td>
                    </tr>
                    <tr data-kind="TTW">
                        <td>지표변위계</td>
                        <td class="cnt">0</td>
                    </tr>
                    <tr data-kind="TTM">
                        <td>지표경사계</td>
                        <td class="cnt">0</td>
                    </tr>
                    <tr data-kind="RAIN">
                        <td>강우계</td>
                        <td class="cnt">0</td>
                    </tr>
                    <tr data-kind="GNSS">
                        <td>GPS</td>
                        <td class="cnt">0</td>
                    </tr>
                    <tr data-kind="CCTV">
                        <td>CCTV</td>
                        <td class="cnt">0</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="site-status-details_re">
        <div class="title">알람 이력</div>
        <div class="conts">
            <div class="bTable alarm-list">
                <table>
                    <thead>
                    <tr>
                        <th>알람상태</th>
                        <th>센서타입</th>
                        <th>센서명(채널명)</th>
                        <th>계측값</th>
                        <th>발생일시</th>
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

    <div class="site-status-details_re">
        <div class="title">비상 연락망</div>
        <div class="conts">
            <div class="bTable emer-list">
                <table>
                    <thead>
                    <tr>
                        <th>소속</th>
                        <th>역할</th>
                        <th>이름</th>
                        <th>연락처 1</th>
                        <th>연락처 2</th>
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
        let param = {"district_no": "${district.district_no}"};
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
            lat: ${district.dist_lat},
            lng: ${district.dist_lon}
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

        const columnDevice = [
            {
                name: 'checkbox', index: 'checkbox', width: 10, align: 'center',
                sortable: false, hidden: false, formatter: checkboxFormatter
            },
            { name: 'district_nm', index: 'district_nm', width: 220, align: 'center', hidden: false },
            { name: 'equipment_nm', index: 'equipment_nm', width: 220, align: 'center', hidden: false },
            { name: 'inst_ymd', index: 'inst_ymd', width: 220, align: 'center', hidden: false },
            {
                name: 'sens_status', index: 'sens_status', width: 220, align: 'center', hidden: false,
                formatter: (v) => ({ MTN001:'정상', MTN002:'망실', MTN003:'점검', MTN004:'철거' }[v] || v || '')
            },
            { name: 'formul_data', index: 'formul_data', width: 220, align: 'center', hidden: false }
        ];

        const headerDevice = [
            '', '현장', '장비명', '설치일자', '상태', '계측값'
        ];

        const gridCompleteDevice = () => {
            if ($("#gridDevice").closest(".ui-jqgrid-view").find(".ui-search-toolbar").length === 0) {
                let $thead = $("#gridDevice").closest(".ui-jqgrid-view").find(".ui-jqgrid-htable thead");
                const $searchRow = $('<tr class="ui-search-toolbar"></tr>');
                let distinctDistrict = [];
                let distinctSensType = [];

                const filters = {groupOp: "AND", rules: []};

                getDistinct().then((res) => {
                    distinctDistrict = res.district;
                    distinctSensType = res.sensor_type;

                    $("#gridDevice").jqGrid('getGridParam', 'colModel').forEach(function (col, index) {
                        let $cell = setFilterControls(col, index, distinctDistrict, distinctSensType, filters, "gridDevice");
                        $searchRow.append($cell);
                    });
                    $thead.append($searchRow);
                }).catch((fail) => {
                    console.log('getDistinct fail > ', fail);
                });
            }
        };

        const getEquipment = (obj) => new Promise((resolve, reject) => {
            $.ajax({
                type: 'GET',
                url: '/admin/assetList/getEquipmentList',
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                async: true,
                data: obj
            }).done(resolve).fail((err) => {
                reject(err);
                alert2('장비 정보를 가져오는데 실패했습니다.', function(){});
            });
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
                    district_no: "${district.district_no}",
                    view_flag: 'Y'
                }, res, true, null, null);

                $alarmGrid.jqGrid('setGridParam', {
                    beforeRequest: function () {
                        let currentParams = {
                            listPathUrl: "/alarmDataByLevel",
                            risk_level: level,
                            zone_id: zone_id,
                            district_no: "${district.district_no}",
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
            let selectedValue = $(this).attr('data-kind');
            const gridId = 'gridDevice';
            const $g = $('#' + gridId);
            const keyArray = ['district_nm', 'sens_chnl_nm'];

            getEquipment({ limit, offset, key: selectedValue, district_no: `${district.district_no}` }).then((res) => {
                const rows = res || [];

                // 기존 그리드 있으면 재사용, 없으면 생성
                if ($g[0] && $g[0].grid) {
                    const addData = actFormattedData(rows, keyArray);
                    $g.jqGrid('clearGridData', true);
                    addData.forEach(row => $g.jqGrid('addRowData', row.id, row));

                    // 기존 필터 유지
                    const currentFilters = $g.jqGrid('getGridParam','postData').filters;
                    $g.jqGrid('setGridParam', {
                        search: !!currentFilters,
                        postData: { filters: currentFilters || '', key: selectedValue },
                        page: 1
                    }).trigger('reloadGrid');
                } else {
                    // 최초 생성 (알람 이력과 동일한 setJqGridTable 사용)
                    setJqGridTable(
                        rows,                       // data
                        columnDevice,               // columns
                        headerDevice,               // headers
                        gridCompleteDevice,         // gridComplete
                        null,                       // onSelectRow 등 필요 없으면 null
                        keyArray,                   // key array
                        gridId,                     // table id
                        limit,                      // paging
                        offset,                     // paging
                        getEquipment,               // reload function
                        null,                       // footerCallback 등
                        null                        // extra
                    );

                    $g.jqGrid('setGridParam', {
                        beforeRequest: function () {
                            let p = Object.assign(
                                $g.jqGrid('getGridParam','postData'),
                                $('.ui-search-input input').filter(function(){ return !!this.value; }).serializeObject()
                            );
                            $g.setGridParam({ postData: Object.assign(p, { key: selectedValue }) });
                        },
                        ondblClickRow: function (rowId) {
                            $g.find('tr').removeClass('custom_selected');
                            const rowData = $(this).getRowData(rowId);
                            openSensorInfo(rowData);
                        }
                    });
                }

                // 팝업 오픈 & 크기 맞춤
                popFancy('#lay-equipment-area', {
                    dragToClose: false, touch: false,
                    afterShow: function () {
                        const $wrap = $g.closest('.bTable');
                        const $cont = $g.closest('.layer-base-conts');
                        const h = Math.max(300, ($cont.innerHeight() || 520) - 120);
                        $g.jqGrid('setGridWidth', $wrap.width());
                        $g.jqGrid('setGridHeight', h);
                    }
                });
            }).catch((e) => console.log('getEquipment fail > ', e));
        });

        /* 20251103 - 해당 현장의 알람 이력 전체 조회인데 선택 기능 대한 의미가 없으므로 주석처리함 */
        // 알람 이력 클릭시
        // $('.site-status-details_re .alarm-list').off().on('click', function () {
        //     $.get('/alarmList/columns', function (res) {
        //         res.zone_id.width = 100;
        //         res.risk_level.width = 100;
        //         res.asset_kind_name.width = 100;
        //         res.asset_name.width = 140;
        //
        //         $alarmHistoryGrid = jqgridUtil($('.gridAlarmHistory'), {
        //             listPathUrl: "/alarmList",
        //             zone_id: zone_id
        //         }, res, true, null, null);
        //         $alarmHistoryGrid.jqGrid('setGridParam', {
        //             ondblClickRow: function (rowId) {
        //                 $alarmHistoryGrid.find('tr').removeClass('custom_selected');
        //                 let rowData = $(this).getRowData(rowId);
        //                 openSensorInfo(rowData);
        //             }
        //         });
        //     });
        //     popFancy('#lay-alarm-history');
        // });

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
                    TM: res.tm_count,
                    TTW: res.ttw_count,
                    TTM: res.ttm_count,
                    RAIN: res.rain_count,
                    GNSS: res.gnss_count,
                    CCTV: res.cctv_count
                };

                $('.device-list tbody tr').each(function () {
                    let kind = $(this).data('kind');
                    if (counts[kind] !== undefined) {
                        $(this).find('.cnt').text(counts[kind]);

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
            $.get('/alarmHistory', param, function (res) {
                if (typeof res != 'undefined') $('.site-status-details_re .alarm-list tbody').empty();
                let contents = '';
                if (res.length > 0) {
                    $('.site-status-details_re .alarm-list').css("cursor", "pointer")
                }else{
                    contents = '<td colspan="5">데이터 없음</td>'
                    $('.site-status-details_re .alarm-list tbody').append(contents);
                }
                $.each(res, function (idx) {
                    let level = res[idx].alarm_lvl_cd;
                    contents = '<tr>';
                    if (level === 'ARM001') {
                        contents += '<td><div class="level" fc_step1=""><strong>관심</strong></div></td>';
                    } else if (level === 'ARM002') {
                        contents += '<td><div class="level" fc_step2=""><strong>주의</strong></div></td>';
                    } else if (level === 'ARM003') {
                        contents += '<td><div class="level" fc_step3=""><strong>경계</strong></div></td>';
                    } else if (level === 'ARM004') {
                        contents += '<td><div class="level" fc_step4=""><strong>심각</strong></div></td>';
                    }
                    contents += '<td>' + res[idx].sens_tp_nm + '</td>';
                    contents += '<td>' + res[idx].sens_chnl_nm + '</td>';
                    contents += '<td>' + res[idx].formul_data + '</td>';
                    contents += '<td>' + fmtKST(res[idx].meas_dt) + '</td>';
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
                });
            });
        }

        function loadMaintenance() {
            $.ajax({
                url: '/maintenance/details/list' + '?rows=1000&page=1&district_no=${district.district_no}',
                type: 'GET',
                data: param,
                success: function (res) {
                    let contents = '';
                    if (res.rows.length > 0) {
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

                            contents = '<tr>';
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
                    }else{
                        contents = '<td colspan="8">데이터 없음</td>'
                        $('.site-status-details_re .maintenance-details-list tbody').append(contents);
                    }
                },
                error: function () {
                    alert('알 수 없는 오류가 발생했습니다.');
                }
            });
        }

        function loadEmergency() {
            $.get('/emergencyInfo', param, function (res) {
                if (typeof res != 'undefined') $('.site-status-details_re .emer-list tbody').empty();
                let contents = '';
                if (res.length > 0) {
                    $('.site-status-details_re .emer-list').css("cursor", "pointer")
                }else{
                    contents = '<td colspan="6">데이터 없음</td>'
                    $('.site-status-details_re .emer-list tbody').append(contents);
                }
                $.each(res, function (idx) {
                    contents = '<tr>';
                    contents += '<td>' + res[idx].partner_comp_nm + '</td>';
                    contents += '<td>' + res[idx].emerg_chgr_role + '</td>';
                    contents += '<td>' + res[idx].emerg_chgr_nm + '</td>';
                    contents += '<td>' + res[idx].emerg_recv_ph + '</td>';
                    contents += '<td>' + res[idx].emerg_tel + '</td>';
                    contents += '<td>' + res[idx].e_mail + '</td>';
                    contents += '</tr>';

                    $('.site-status-details_re .emer-list tbody').append(contents);
                });
            });
        }
    }); // jquery init end
</script>
