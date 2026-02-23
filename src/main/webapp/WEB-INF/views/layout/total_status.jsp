<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript" src="/jqgrid.js"></script>
<script type="text/javascript">
    let $alarmGrid, $sensorGrid, $cctvGrid, $deviceGrid, $alarmHistoryGrid, $setInterval0, $setInterval1, $setInterval2;
    let param = {"view_flag": "N"};

    // const alarmInterval = function () {
    //     loadAlarmCount();           // 알람현황 횟수
    // }

    const startInterval = function () {
        loadAlarmCount();           // 알람현황 횟수
        loadSystemCount()           // 시스템 상태
        loadAlarmHistory();         // 알람 이력
        loadAlarmMessage();         // 토스트 메세지 출력
    };

    const weatherInterval = function () {
        loadSpecialWeatherInfo();   // 금일 기상특보 현황
        loadWeatherInfo();          // 현재 기상현황
    }

    const checkboxFormatter = (cellValue, options, rowObject) => {
        return '';
    };

    const limit = 50;
    let offset = 0;

    $(function () {
        google.charts.setOnLoadCallback(drawChart);

        // alarmInterval();
        startInterval();
        weatherInterval();
        // $setInterval0 = setInterval(alarmInterval, ALARM_LATENCY); // 30초 마다
        $setInterval1 = setInterval(startInterval, LATENCY); // 60초 마다
        $setInterval2 = setInterval(weatherInterval, 60 * 60 * 1000); // 60분 마다

        // 1) 공통 리셋 함수
        function resetGridFilters(gridId){
            const $g = $('#' + gridId);
            const $view = $g.closest('.ui-jqgrid-view');

            $view.find('.ui-search-toolbar input').each(function(){
                if ($(this).val() !== '') {
                    $(this).val('');
                    $(this).trigger('input');
                    $(this).trigger('change');
                }
            });
            $view.find('.ui-search-toolbar select').each(function(){
                if ($(this).val() !== '') {
                    $(this).val('');
                    $(this).trigger('change');
                }
            });

            $g.jqGrid('setGridParam', {
                search: false,
                postData: { filters: '' },
                page: 1
            }).trigger('reloadGrid');
        }

        // 2) 팝업-그리드 매핑
        const POPUPS = [
            { layer: '#lay-sensor-status-list',  grid: 'gridSensor' },
            { layer: '#lay-cctv-status-list',    grid: 'gridCCTV' },
            { layer: '#lay-alarm-info',           grid: 'gridAlarm' },
            { layer: '#lay-alarm-history',        grid: 'gridAlarmHistory' },
            { layer: '#lay-equipment-area',        grid: 'gridDevice' }
        ];

        // 3) 공통 바인딩
        function bindPopupGridReset(pairs){
            $(document).off('mousedown.resetClose');
            $(document).off('afterClose.fb.reset');

            // (A) 닫기 버튼 클릭 시
            pairs.forEach(p => {
                $(document).on('mousedown.resetClose', `${p.layer} img[data-fancybox-close]`, function(){
                    resetGridFilters(p.grid);
                    offset = 0;
                });
            });

            // (B) ESC/오버레이 등 모든 닫힘 경로
            $(document).on('afterClose.fb.reset', function(_e, _instance, slide){
                if (!slide || !slide.src) return;
                pairs.forEach(p => {
                    if (slide.src === p.layer) {
                        resetGridFilters(p.grid);
                        offset = 0;
                    }
                });
            });
        }

        // 4) 호출
        bindPopupGridReset(POPUPS);

        /***********************************************************************************************************************************************************************************************************/
        /********************************************************************************************* 알람 현황 (1분) 조회 *********************************************************************************************/
        /***********************************************************************************************************************************************************************************************************/

        const alarmCdFormatter = (cellValue, options, rowObject) => {
            if (cellValue === 'ARM001') {
                return "관심"
            } else if (cellValue === 'ARM002') {
                return "주의"
            } else if (cellValue === 'ARM003') {
                return "경계"
            } else if (cellValue === 'ARM004') {
                return "심각"
            }
        };

        const maintCdFormatter = (cellValue, options, rowObject) => {
            if (cellValue === 'MTN001') {
                return '정상';
            } else if (cellValue === 'MTN002') {
                return '망실';
            } else if (cellValue === 'MTN003') {
                return '점검';
            } else if (cellValue === 'MTN004') {
                return '철거';
            }
        };

        const column_l = [
            {
                name: 'checkbox',
                index: 'checkbox',
                width: 10,
                align: 'center',
                sortable: false,
                hidden: false,
                formatter: checkboxFormatter
            },
            {name:'district_nm', index:'district_nm', width:100, align:'center', hidden:false},
            {name:'sens_nm', index:'sens_nm', width:100, align:'center', hidden:false},
            {name:'sens_chnl_id', index:'sens_chnl_id', width:100, align:'center', hidden:false},
            {name:'alarm_lvl_cd', index:'alarm_lvl_cd', width:100, align:'center', hidden:false, formatter: alarmCdFormatter},
            {name:'formul_data', index:'formul_data', width:100, align:'center', hidden:false},
            {name:'maint_sts_cd', index:'maint_sts_cd', width:100, align:'center', hidden:false, formatter: maintCdFormatter},
        ];

        const header_l = [
            '', '현장명','센서명','센서채널명','알람 상태','계측값','센서상태'
        ];

        let alarmGridBaseQuery = {};
        const alarmGridKeyArray = ['sens_no', 'sens_chnl_id', 'meas_dt'];

        const replaceAlarmGridRows = (rows) => {
            const $g = $('#gridAlarm');
            if (!$g.length || !$g[0] || !$g[0].grid) {
                return;
            }

            const addData = actFormattedData(rows || [], alarmGridKeyArray);
            const currentFilters = $g.jqGrid('getGridParam', 'postData')?.filters;

            $g.jqGrid('clearGridData', true);
            addData.forEach(row => {
                $g.jqGrid('addRowData', row.id, row);
            });

            $g.jqGrid('setGridParam', {
                search: !!currentFilters,
                postData: { filters: currentFilters || '' },
                page: 1
            }).trigger('reloadGrid');
        };

        const reloadAlarmGridByDistrictNm = (districtNm) => {
            const alarmLevel = alarmGridBaseQuery?.alarmLevel;
            if (!alarmLevel) {
                return;
            }

            offset = 0;
            alarmGridBaseQuery = { alarmLevel: alarmLevel };
            if (districtNm) {
                alarmGridBaseQuery.district_nm = districtNm;
            }

            const req = { limit, offset, alarmLevel };
            if (districtNm) {
                req.district_nm = districtNm;
            }

            getAlarmByLevel(req).then((res) => {
                replaceAlarmGridRows(res || []);
            }).catch((fail) => {
                console.log('reloadAlarmGridByDistrictNm fail > ', fail);
            });
        };

        const bindAlarmGridDistrictSelectFetch = () => {
            const $g = $('#gridAlarm');
            if (!$g.length || !$g[0] || !$g[0].grid) {
                return;
            }

            const colModel = $g.jqGrid('getGridParam', 'colModel') || [];
            const districtColIndex = colModel.findIndex(col => col.name === 'district_nm');
            if (districtColIndex < 0) {
                return;
            }

            const $districtSelect = $g.closest('.ui-jqgrid-view')
                .find('.ui-search-toolbar th').eq(districtColIndex)
                .find('select');
            if ($districtSelect.length === 0) {
                return;
            }

            $districtSelect.off('change.alarmGridDistrictFetch').on('change.alarmGridDistrictFetch', function () {
                reloadAlarmGridByDistrictNm(String($(this).val() || '').trim());
            });
        };

        const getAlarmByLevel = (obj) => {
            const requestData = Object.assign({}, alarmGridBaseQuery, obj);
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: 'GET',
                    url: `/alarmDataByLevel/list_by_level`,
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    async: true,
                    data: requestData
                }).done(function (res) {
                    resolve(res);
                }).fail(function (fail) {
                    reject(fail);
                    console.log('getSensor fail > ', fail);
                    alert2('알람 정보를 가져오는데 실패했습니다.', function () {
                    });
                });
            });
        };

        const gridComplete_l = () => {
            // 검색 행 추가
            if ($("#gridAlarm").closest(".ui-jqgrid-view").find(".ui-search-toolbar").length === 0) {
                let $thead = $("#gridAlarm").closest(".ui-jqgrid-view").find(".ui-jqgrid-htable thead");
                let $searchRow = $('<tr class="ui-search-toolbar"></tr>');
                let distinctDistrict = [];
                let distinctSensType = [];

                // 현재 필터링 조건을 저장할 객체
                let filters = {
                    groupOp: "AND",
                    rules: []
                };

                getDistinct().then((res) => {
                    distinctDistrict = res.district;
                    distinctSensType = res.sensor_type;

                    $("#gridAlarm").jqGrid('getGridParam', 'colModel').forEach(function (col, index) {
                        let $cell = setFilterControls(col, index, distinctDistrict, distinctSensType, filters, "gridAlarm");
                        $searchRow.append($cell);
                    });
                    $thead.append($searchRow);

                    bindAlarmGridDistrictSelectFetch();
                }).catch((fail) => {
                    console.log('getDistinct fail > ', fail);
                });
            }
        };

        // 각 알람 현황 클릭시
        $('.overall-status-area .donutty-area li').off().on('click', function () {
            offset = 0;

            let status = $(this).attr('level');
            let alarmLevel;

            if (status === "1") {
                $('#lay-alarm-info .layer-base-title').html("관심 센서 리스트");
                alarmLevel = 'ARM001';
            } else if (status === "2") {
                $('#lay-alarm-info .layer-base-title').html("주의 센서 리스트");
                alarmLevel = 'ARM002';
            } else if (status === "3") {
                $('#lay-alarm-info .layer-base-title').html("경계 센서 리스트");
                alarmLevel = 'ARM003';
            } else {
                $('#lay-alarm-info .layer-base-title').html("심각 센서 리스트");
                alarmLevel = 'ARM004';
            }

            // 종합현황 알람팝업은 항상 "전체현장" 기준으로 오픈 (현장현황 상세와 분리)
            alarmGridBaseQuery = { alarmLevel: alarmLevel };

            getAlarmByLevel({limit, offset, alarmLevel}).then((res) => {
                let rows = res || [];

                // --- 그리드가 이미 있으면 재사용 / 없으면 생성 ---
                const gridId = 'gridAlarm';
                const $g = $('#' + gridId);
                const keyArray = alarmGridKeyArray;

                if ($g[0] && $g[0].grid) {
                    // 기존 그리드 재사용: 데이터만 교체
                    const addData = actFormattedData(rows, keyArray);
                    $g.jqGrid('clearGridData', true);
                    addData.forEach(row => {
                        $g.jqGrid('addRowData', row.id, row);
                    });

                    // 알람 단계 클릭 시 종합현황 팝업 검색조건은 초기화하고 "전체현장" 기준으로 재조회
                    const $view = $g.closest('.ui-jqgrid-view');
                    $view.find('.ui-search-toolbar input').val('');
                    $view.find('.ui-search-toolbar select').val('');

                    $g.jqGrid('setGridParam', {
                        search: false,
                        postData: { filters: '' },
                        page: 1
                    }).trigger('reloadGrid');
                } else {
                    // 최초 생성
                    setJqGridTable(rows, column_l, header_l, gridComplete_l, null, keyArray, gridId, limit, offset, getAlarmByLevel, null, null);
                }
            }).catch((fail) => {
                console.log('setJqGridTable fail > ', fail);
            });

            popFancy('#lay-alarm-info', {
                dragToClose: false, touch: false,
                afterShow: function () {
                    const $g = $("#gridAlarm");
                    const $wrap = $g.closest('.bTable');
                    const $cont = $g.closest('.layer-base-conts');
                    const h = Math.max(300, ($cont.innerHeight() || 520) - 120);
                    $g.jqGrid('setGridWidth', $wrap.width());
                    $g.jqGrid('setGridHeight', h);
                }
            });
        });

        /***********************************************************************************************************************************************************************************************************/
        /********************************************************************************************* 알람 현황 (1분) 조회 *********************************************************************************************/
        /***********************************************************************************************************************************************************************************************************/

        $('.overall-status-area .hang.status-number dl').off().on('click', function () {
            alert('개발진행 중입니다');
        });

        /***********************************************************************************************************************************************************************************************************/
        /********************************************************************************************* 계측기 상태 조회 *********************************************************************************************/
        /***********************************************************************************************************************************************************************************************************/

        const formatDateTime = (cellValue, _opts, rowObject) => {
            if (cellValue) {
                const text = moment(cellValue).format("YYYY-MM-DD HH:mm:ss");
                if(rowObject.comm_status === '미수신'){
                    return '<span style="color: red">' + text + '</span>';
                }else{
                    return text;
                }
            } else {
                return "";
            }
        };

        const formatCommStatus = (cellValue) => {
            if (cellValue === '미수신') {
                return '<span style="color: red">미수신</span>'
            }else{
                return cellValue;
            }
        };

        const column = [
            {
                name: 'checkbox',
                index: 'checkbox',
                width: 10,
                align: 'center',
                sortable: false,
                hidden: false,
                formatter: checkboxFormatter
            },
            {name:'district_nm', index:'district_nm', width:100, align:'center', hidden:false},
            {name:'sens_tp_nm', index:'sens_tp_nm', width:100, align:'center', hidden:false},
            {name:'sens_nm', index:'sens_nm', width:100, align:'center', hidden:false},
            {name:'inst_ymd', index:'inst_ymd', width:100, align:'center', hidden:false},
            {name:'latest_meas_dt', index:'latest_meas_dt', width:120, align:'center', hidden:false, formatter: formatDateTime},
            {name:'comm_status', index:'comm_status', width:70, align:'center', hidden:false, formatter: formatCommStatus},
        ];

        const header = [
            '', '현장명','센서타입명','센서명','설치일자','최종계측일시','통신상태'
        ];

        const getSensor = (obj) => {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: 'GET',
                    url: `/system/getSensorList`,
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    async: true,
                    data: obj
                }).done(function (res) {
                    resolve(res);
                }).fail(function (fail) {
                    reject(fail);
                    console.log('getSensor fail > ', fail);
                    alert2('센서 정보를 가져오는데 실패했습니다.', function () {
                    });
                });
            });
        };

        const gridComplete2 = () => {
            // 검색 행 추가
            if ($("#gridSensor").closest(".ui-jqgrid-view").find(".ui-search-toolbar").length === 0) {
                let $thead = $("#gridSensor").closest(".ui-jqgrid-view").find(".ui-jqgrid-htable thead");
                let $searchRow = $('<tr class="ui-search-toolbar"></tr>');
                let distinctDistrict = [];
                let distinctSensType = [];

                // 현재 필터링 조건을 저장할 객체
                let filters = {
                    groupOp: "AND",
                    rules: []
                };

                getDistinct().then((res) => {
                    distinctDistrict = res.district;
                    distinctSensType = res.sensor_type;

                    $("#gridSensor").jqGrid('getGridParam', 'colModel').forEach(function (col, index) {
                        let $cell = setFilterControls(col, index, distinctDistrict, distinctSensType, filters, "gridSensor");
                        $searchRow.append($cell);
                    });
                    $thead.append($searchRow);
                }).catch((fail) => {
                    console.log('getDistinct fail > ', fail);
                });
            }
        };

        //시스템 상태 > 계측기 상태 클릭시
        $('.sensor.status-number dl').off().on('click', function () {
            let status = $(this).attr('status');

            if (status === "1") {
                $('#lay-sensor-status-list .layer-base-title').html("수신 센서 리스트");
            } else if (status === "2") {
                $('#lay-sensor-status-list .layer-base-title').html("미수신 센서 리스트");
            } else {
                $('#lay-sensor-status-list .layer-base-title').html("전체 센서 리스트");
            }

            getSensor({limit, offset}).then((res) => {
                let rows = res.rows || [];
                if (status === '1') {
                    rows = rows.filter(r => r.comm_status === '수신');
                } else if (status === '2') {
                    rows = rows.filter(r => r.comm_status === '미수신');
                }

                // --- 그리드가 이미 있으면 재사용 / 없으면 생성 ---
                const gridId = 'gridSensor';
                const $g = $('#' + gridId);
                // 센서 목록은 sens_no 기준으로 유니크 처리해야 동일 현장명 중복 시 누락되지 않음
                const keyArray = ['sens_no'];

                if ($g[0] && $g[0].grid) {
                    // 기존 그리드 재사용: 데이터만 교체
                    const addData = actFormattedData(rows, keyArray);
                    $g.jqGrid('clearGridData', true);
                    addData.forEach(row => {
                        $g.jqGrid('addRowData', row.id, row);
                    });
                    // 기존에 필터가 걸려있으면 유지
                    const currentFilters = $g.jqGrid('getGridParam', 'postData').filters;
                    $g.jqGrid('setGridParam', {
                        search: !!currentFilters,
                        postData: { filters: currentFilters || '' },
                        page: 1
                    }).trigger('reloadGrid');
                } else {
                    // 최초 생성
                    setJqGridTable(rows, column, header, gridComplete2, null, keyArray, gridId, limit, offset, getSensor, null, null);
                }
            }).catch((fail) => {
                console.log('setJqGridTable fail > ', fail);
            });

            popFancy('#lay-sensor-status-list', {
                dragToClose: false, touch: false,
                afterShow: function () {
                    const $g = $("#gridSensor");
                    const $wrap = $g.closest('.bTable');
                    const $cont = $g.closest('.layer-base-conts');
                    const h = Math.max(300, ($cont.innerHeight() || 520) - 120);
                    $g.jqGrid('setGridWidth', $wrap.width());
                    $g.jqGrid('setGridHeight', h);
                }
            });
        });

        /***********************************************************************************************************************************************************************************************************/
        /********************************************************************************************* 계측기 상태 조회 *********************************************************************************************/
        /***********************************************************************************************************************************************************************************************************/


        /***********************************************************************************************************************************************************************************************************/
        /********************************************************************************************* cctv 상태 조회 *********************************************************************************************/
        /***********************************************************************************************************************************************************************************************************/

        const column_c = [
            {
                name: 'checkbox',
                index: 'checkbox',
                width: 10,
                align: 'center',
                sortable: false,
                hidden: false,
                formatter: checkboxFormatter
            },
            {name: 'district_nm', index: 'district_nm', width: 120, align: 'center', hidden: false},
            {name: 'cctv_nm', index: 'cctv_nm', width: 180, align: 'center', hidden: false},
            {name: 'partner_comp_nm', index: 'partner_comp_nm', width: 140, align: 'center', hidden: false},
            {name: 'partner_comp_user_nm', index: 'partner_comp_user_nm', width: 110, align: 'center', hidden: false},
            {
                name: 'partner_comp_user_phone',
                index: 'partner_comp_user_phone',
                width: 140,
                align: 'center',
                hidden: false
            },
            {
                name: 'rtsp_status',
                index: 'rtsp_status',
                width: 100,
                align: 'center',
                hidden: false,
                formatter: (cellValue, _options, _rowObject) => {
                    if (cellValue === 'Y') {
                        return '정상';
                    } else {
                        return '에러';
                    }
                }
            },
            {
                name: 'maint_sts_cd',
                index: 'maint_sts_cd',
                width: 100,
                align: 'center',
                hidden: false,
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
        ];

        const header_c = [
            '', '현장명', 'CCTV명', '계측사', '담당자', '전화번호', 'RTSP 연결', '계측 상태'
        ];

        const gridComplete_c = () => {
            // 검색 행 추가
            if ($("#gridCCTV").closest(".ui-jqgrid-view").find(".ui-search-toolbar").length === 0) {
                let $thead = $("#gridCCTV").closest(".ui-jqgrid-view").find(".ui-jqgrid-htable thead");
                let $searchRow = $('<tr class="ui-search-toolbar"></tr>');
                let distinctDistrict = [];
                let distinctSensType = [];

                // 현재 필터링 조건을 저장할 객체
                let filters = {
                    groupOp: "AND",
                    rules: []
                };

                getDistinct().then((res) => {
                    distinctDistrict = res.district;
                    distinctSensType = res.sensor_type;

                    $("#gridCCTV").jqGrid('getGridParam', 'colModel').forEach(function (col, index) {
                        let $cell = setFilterControls(col, index, distinctDistrict, distinctSensType, filters, "gridCCTV");
                        $searchRow.append($cell);
                    });
                    $thead.append($searchRow);
                }).catch((fail) => {
                    console.log('getDistinct fail > ', fail);
                });
            }
        };

        const getCctv = (obj) => {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: 'GET',
                    url: `/modify/cctv/cctv`,
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    async: true,
                    data: obj
                }).done(function (res) {
                    resolve(res);
                }).fail(function (fail) {
                    reject(fail);
                    alert2('CCTV 정보를 가져오는데 실패했습니다.', function () {
                    });
                });
            });
        };

        //시스템 상태 > CCTV 상태 클릭시
        $('.cctv.status-number dl').off().on('click', function () {
            let status = $(this).attr('status');
            if (status === "1") {
                $('#lay-cctv-status-list .layer-base-title').html("수신 CCTV 리스트");
            } else if (status === "2") {
                $('#lay-cctv-status-list .layer-base-title').html("미수신 CCTV 리스트");
            } else {
                $('#lay-cctv-status-list .layer-base-title').html("전체 수신 CCTV 리스트");
            }

            getCctv({limit, offset}).then((res) => {
                let rows = res.rows || [];
                if (status === '1') {
                    rows = rows.filter(r => r.rtsp_status === 'Y');
                } else if (status === '2') {
                    rows = rows.filter(r => r.rtsp_status === 'N');
                }

                // --- 그리드가 이미 있으면 재사용 / 없으면 생성 ---
                const gridId = 'gridCCTV';
                const $g = $('#' + gridId);
                // CCTV 목록은 cctv_no 기준으로 유니크 처리해야 동일 현장 다건 누락 방지
                const keyArray = ['cctv_no'];

                if ($g[0] && $g[0].grid) {
                    // 기존 그리드 재사용: 데이터만 교체
                    const addData = actFormattedData(rows, keyArray);
                    $g.jqGrid('clearGridData', true);
                    addData.forEach(row => {
                        $g.jqGrid('addRowData', row.id, row);
                    });
                    // 기존에 필터가 걸려있으면 유지
                    const currentFilters = $g.jqGrid('getGridParam', 'postData').filters;
                    $g.jqGrid('setGridParam', {
                        search: !!currentFilters,
                        postData: { filters: currentFilters || '' },
                        page: 1
                    }).trigger('reloadGrid');
                } else {
                    // 최초 생성
                    setJqGridTable(rows, column_c, header_c, gridComplete_c, null, keyArray, gridId, limit, offset, getCctv, null, null);
                }
            }).catch((fail) => {
                console.log('setJqGridTable fail > ', fail);
            });

            popFancy('#lay-cctv-status-list', {
                dragToClose: false, touch: false,
                afterShow: function () {
                    const $g = $("#gridCCTV");
                    const $wrap = $g.closest('.bTable');
                    const $cont = $g.closest('.layer-base-conts');
                    const h = Math.max(300, ($cont.innerHeight() || 520) - 120);
                    // 열 간격/폭이 상태별(전체/정상/에러) 전환 시 깨지지 않도록 고정폭 기준으로 재계산
                    $g.jqGrid('setGridWidth', $wrap.width(), false);
                    $g.jqGrid('setGridHeight', h);
                }
            });
        });

        /***********************************************************************************************************************************************************************************************************/
        /********************************************************************************************* cctv 상태 조회 *********************************************************************************************/
        /***********************************************************************************************************************************************************************************************************/


        /***********************************************************************************************************************************************************************************************************/
        /********************************************************************************************* 알람 이력 조회 *********************************************************************************************/
        /***********************************************************************************************************************************************************************************************************/

        const column_a = [
            {
                name: 'checkbox',
                index: 'checkbox',
                width: 10,
                align: 'center',
                sortable: false,
                hidden: false,
                formatter: checkboxFormatter
            },
            {name: 'meas_dt', index: 'meas_dt', width: 200, align: 'center', hidden: false},
            {name: 'district_nm', index: 'district_nm', width: 100, align: 'center', hidden: false},
            {name: 'sens_nm', index: 'sens_nm', width: 150, align: 'center', hidden: false},
            {name: 'sens_chnl_id', index: 'sens_chnl_id', width: 100, align: 'center', hidden: false},
            {name: 'alarm_lvl_cd', index: 'alarm_lvl_cd', width: 100, align: 'center', hidden: false, formatter: alarmCdFormatter},
            {name: 'formul_data', index: 'formul_data', width: 100, align: 'center', hidden: false},
            {name: 'standard', index: 'standard', width: 100, align: 'center', hidden: false,
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
            {
                name: 'maint_sts_cd',
                index: 'maint_sts_cd',
                align: 'center',
                hidden: false,
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
            { name:'min1', index:'min1', hidden:true },
            { name:'max1', index:'max1', hidden:true },
            { name:'min2', index:'min2', hidden:true },
            { name:'max2', index:'max2', hidden:true },
            { name:'min3', index:'min3', hidden:true },
            { name:'max3', index:'max3', hidden:true },
            { name:'min4', index:'min4', hidden:true },
            { name:'max4', index:'max4', hidden:true }
        ];

        const header_a = [
            '', '발생일시', '현장명', '센서명', '센서채널명', '알람상태', '계측값', '관리기준범위', '센서상태', '', '', '', '', '', '', '', ''
        ];

        const gridComplete_a = () => {
            // 검색 행 추가
            if ($("#gridAlarmHistory").closest(".ui-jqgrid-view").find(".ui-search-toolbar").length === 0) {
                let $thead = $("#gridAlarmHistory").closest(".ui-jqgrid-view").find(".ui-jqgrid-htable thead");
                let $searchRow = $('<tr class="ui-search-toolbar"></tr>');
                let distinctDistrict = [];
                let distinctSensType = [];

                // 현재 필터링 조건을 저장할 객체
                let filters = {
                    groupOp: "AND",
                    rules: []
                };

                getDistinct().then((res) => {
                    distinctDistrict = res.district;
                    distinctSensType = res.sensor_type;

                    $("#gridAlarmHistory").jqGrid('getGridParam', 'colModel').forEach(function (col, index) {
                        let $cell = setFilterControls(col, index, distinctDistrict, distinctSensType, filters, "gridAlarmHistory");
                        $searchRow.append($cell);
                    });
                    $thead.append($searchRow);
                }).catch((fail) => {
                    console.log('getDistinct fail > ', fail);
                });
            }
        };

        const getAlarmHistory = (obj) => {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: 'GET',
                    url: `/sensor/alarm-details/history`,
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    async: true,
                    data: obj
                }).done(function (res) {
                    resolve(res);
                }).fail(function (fail) {
                    reject(fail);
                    alert2('알람 정보를 가져오는데 실패했습니다.', function () {
                    });
                });
            });
        };

        // 알람 이력 클릭시
        $('.overall-status_re .alarm-list').off().on('click', function () {
            getAlarmHistory({limit, offset}).then((res) => {
                let rows = res || [];

                // --- 그리드가 이미 있으면 재사용 / 없으면 생성 ---
                const gridId = 'gridAlarmHistory';
                const $g = $('#' + gridId);
                const keyArray = ['district_nm'];

                if ($g[0] && $g[0].grid) {
                    // 기존 그리드 재사용: 데이터만 교체
                    const addData = actFormattedData(rows, keyArray);
                    $g.jqGrid('clearGridData', true);
                    addData.forEach(row => {
                        $g.jqGrid('addRowData', row.id, row);
                    });
                    // 기존에 필터가 걸려있으면 유지
                    const currentFilters = $g.jqGrid('getGridParam', 'postData').filters;
                    $g.jqGrid('setGridParam', {
                        search: !!currentFilters,
                        postData: { filters: currentFilters || '' },
                        page: 1
                    }).trigger('reloadGrid');
                } else {
                    // 최초 생성
                    setJqGridTable(rows, column_a, header_a, gridComplete_a, null, keyArray, gridId, limit, offset, getAlarmHistory, null, null);
                }
            }).catch((fail) => {
                console.log('setJqGridTable fail > ', fail);
            });

            popFancy('#lay-alarm-history', {
                dragToClose: false, touch: false,
                afterShow: function () {
                    const $g = $("#gridAlarmHistory");
                    const $wrap = $g.closest('.bTable');
                    const $cont = $g.closest('.layer-base-conts');
                    const h = Math.max(300, ($cont.innerHeight() || 520) - 120);
                    $g.jqGrid('setGridWidth', $wrap.width());
                    $g.jqGrid('setGridHeight', h);
                }
            });
        });

        /***********************************************************************************************************************************************************************************************************/
        /********************************************************************************************* 알람 이력 조회 *********************************************************************************************/
        /***********************************************************************************************************************************************************************************************************/

        $(document).on('click', '.weather-api', function() {
            popFancy('#lay-weather-area', { dragToClose : false, touch : false });
        });
        $(document).on('click', '.weather-comment', function() {
            popFancy('#lay-weather-area2', { dragToClose : false, touch : false });
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

        // 장비현황 차트
        function drawChart() {
            /* 차트생성시점 == 테이블생성시점으로 만들어져있어서 고정픽셀로 처리 */
            $("#gridDevice").closest('.bTable').width(1170);
            $.get('/deviceCount', function (res) {
                var data = google.visualization.arrayToDataTable([
                    ['title', 'number', 'key'],
                    ['CCTV', res.cctv_count, 'CCTV'],
                    ['구조물경사계', res.tm_count, 'TM'],
                    ['지표변위계', res.ttw_count, 'TTW'],
                    ['강우계', res.rain_count, 'RAIN'],
                    ['지표경사계', res.ttm_count, 'TTM'],
                    ['GNSS', res.gnss_count, 'GNSS']
                ]);

                var options = {
                    backgroundColor: '#28293b',
                    pieHole: 0.5,
                    tooltip: {
                        trigger: 'focus',
                        ignoreBounds : true,
                        textStyle: {
                            fontSize: 13
                        }
                    },
                    pieSliceBorderColor: '#28293b',
                    colors: ['#464ef7', '#63e578', '#f4bd25', '#dd2ac8', '#2ae8d9','#ff6b6b', '#795548'],
                    chartArea: { width: "90%", height: "90%" },
                    legend: { textStyle: { color: '#fff', fontSize: 13, fontName: 'Pretendard' }, width: 144, position: 'outside' },
                    pieSliceText: 'value',
                };

                var chart = new google.visualization.PieChart(document.getElementById('piechart'));
                chart.draw(data, options);

                google.visualization.events.addListener(chart, 'ready', function() {
                    const svg = document.querySelector("#piechart div > svg");
                    svg.style.overflow = "visible";
                });

                google.visualization.events.addListener(chart, 'select', function () {
                    const selectedItem = chart.getSelection()[0];
                    if (!selectedItem) return;

                    const selectedValue = data.getValue(selectedItem.row, 2);
                    const tooltip = document.querySelector('.google-visualization-tooltip');
                    if (tooltip) tooltip.style.display = "none";

                    const gridId = 'gridDevice';
                    const $g = $('#' + gridId);
                    const keyArray = ['district_nm', 'sens_chnl_nm'];

                    // 먼저 데이터 가져와서
                    getEquipment({ limit, offset, key: selectedValue }).then((res) => {
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
            });
        }
    });

    // 알림현황 카운트
    function loadAlarmCount() {
        $.get('/alarmList/alarmCount', function (res) {
            var totalLength = 314.1592653589793;
            var values = [
                res.interest_cnt,
                res.notice_cnt,
                res.warning_cnt,
                res.danger_cnt
            ];

            function updateDonutChart(index, value) {
                // if (value > 0) {
                //     $('.overall-status-area .donutty-area li:eq(' + index + ')').css("cursor", "pointer");
                // } else {
                //     $('.overall-status-area .donutty-area li:eq(' + index + ')').off('click');
                // }
                $('.overall-status-area .donutty-area li:eq(' + index + ')').css("cursor", "pointer");
                $('.overall-status-area .donutty-area li:eq(' + index + ') div').attr('data-value', value);
                var offset = totalLength - (totalLength * (value / 100));
                $('.overall-status-area .donutty-area li:eq(' + index + ') .donut-fill').css('stroke-dashoffset', offset);
            }

            for (var i = 0; i < values.length; i++) {
                updateDonutChart(i, values[i]);
            }
        });
    }

    // 시스템 상태
    function loadSystemCount() {
        $.get("/cctv/dashboard/count", (res) => {
            $('.cctv.status-number dt:eq(0)').html(res.allCnt);
            $('.cctv.status-number dt:eq(1)').html(res.conCnt);
            $('.cctv.status-number dt:eq(2)').html(res.errCnt);
        })

        $.get("/modify/sensor/dashboard/count", (res) => {
            $('.sensor.status-number dt:eq(0)').html(res.allCnt);
            $('.sensor.status-number dt:eq(1)').html(res.conCnt);
            $('.sensor.status-number dt:eq(2)').html(res.errCnt);
        })
    }

    // 지역 날씨
    function loadWeatherInfo() {
        $.get('/weather/today/4375035000', function (res) {
            // console.log(res);
            if (res.wfKor === '구름 많음') {
                $('.weather-img img').attr('src', 'images/weather/mostlycloudy.png');
            } else if (res.wfKor === '비/눈') {
                $('.weather-img img').attr('src', 'images/weather/rainsnow.png');
            } else if (res.wfKor === '빗방울/눈날림') {
                $('.weather-img img').attr('src', 'images/weather/rainsnowdrifting.png');
            } else if (res.wfKor === '눈날림') {
                $('.weather-img img').attr('src', 'images/weather/snowdrifting.png');
            } else {
                $('.weather-img img').attr('src', 'images/weather/' + res.wfEn.toLowerCase() + '.png');
            }

            $('.weather-img span').html(res.temp + ' ℃');

            let detail = res.wfKor + ', 습도 ' + res.reh + ' %<br/>바람 ' + res.wdKor + ' ' 
                + parseFloat(res.ws.substring(0, 4)) + ' m/s';
            
            if (parseFloat(res.pcp) > 0)
                detail += '<br/>시간당 예상 강수량 ' + res.pcp + ' mm';

            $('.weather-detail').html(detail);

            let rainAmount = res.pcp + 'mm';
            const $rainInfo = $('.rain-info');
            $rainInfo.find('span').remove(); 
            $rainInfo.append('<span>' + rainAmount + '</span>');
        });
    }

    function loadSpecialWeatherInfo() {
        $.get('/weather/special/진천군', function (res) {                        // 기상청 API 허브
            // console.log(res);
            let today = getToday();
            let result = '';
            // $.each(res, function () {
            //     if (res.indexOf(today) > -1) {                                  // 금일 경보만을 출력
            //         result = this.split(',');
            //         return false;
            //     }
            // });

            if (res.length > 0)
                result = res[0].split(',');

            if (result == '') {
                $('.weather-comment').html('현재 발효된 특보가 없습니다.');
            } else if (result.length > 0 ) {
                console.log(result);
                let raisedate = result[4].trim();

                $('.weather-comment').html(raisedate.substring(0, 4) + '년 ' + raisedate.substring(4, 6) +  '월 ' + raisedate.substring(6, 8) +  '일 ' + raisedate.substring(8, 10) +  '시 '
                    + '<br/>' + result[1].trim() + ' ' + result[3].trim() + ' ' + result[6].trim() + ' ' + result[7].trim() + ' ' + (result[8].trim() == '변경' ? '특보' : result[8].trim()));
            } else {
                $('.weather-comment').html('기상 특보 팝업 보기');
            }
        }).fail(function () {
            $('.weather-comment').html('기상 특보 팝업 보기');
        });
    }

    function getToday() {
        var today = new Date();
        var year = today.getFullYear();
        var month = ("0" + (today.getMonth() + 1)).slice(-2);
        var day = ("0" + today.getDate()).slice(-2);

        var date = year + month + day;
    }

    function toMs(v){
        const n = Number(v);
        return n < 1e12 ? n * 1000 : n; // 1e12 미만이면 초 → ms 변환
    }

    function fmtKST(v){
        return moment(toMs(v)).format('YYYY-MM-DD HH:mm:ss'); // 기본 로컬TZ(보통 KST) 사용
    }

    function loadAlarmHistory() {
        $.get('/alarmList/alarmHistory', function (res) {
            if (!Array.isArray(res)) return;

            $('.overall-status_re .alarm-list li').empty();
            $('.overall-status_re .alarm-list').css('cursor', res.length > 0 ? 'pointer' : 'default');

            const now = Date.now();

            $.each(res, function (idx) {
                let contents = '<div style="padding: 1.5rem 0; display: block;">';
                let text = '';
                const level = res[idx].alarm_lvl_cd;

                if (level === 'ARM001') { text = '관심'; contents += '<p class="cate" bc_step1>' + text + '</p>'; }
                else if (level === 'ARM002') { text = '주의'; contents += '<p class="cate" bc_step2>' + text + '</p>'; }
                else if (level === 'ARM003') { text = '경계'; contents += '<p class="cate" bc_step3>' + text + '</p>'; }
                else if (level === 'ARM004') { text = '심각'; contents += '<p class="cate" bc_step4>' + text + '</p>'; }

                contents += '<p class="title">' + res[idx].sens_nm + ' > ' + text + '</p>';
                contents += '<p class="title">' + res[idx].district_nm + '</p>';
                contents += '<p class="day">' + fmtKST(res[idx].reg_dt) + '</p>';
                contents += '</div>';

                $('.overall-status_re .alarm-list li:eq(' + idx + ')').html(contents);
            });
        });
    }

    function loadAlarmMessage() {
        // 이전 알람 전체 제거
        $("#toast-container").remove();

        // 컨테이너 생성
        const container = $(`
        <div id="toast-container">
            <div id="right-alarm"></div>
        </div>
    `).css({
            position: "fixed",
            top: "0px",
            right: "10px",
            display: "flex",
            flexDirection: "column",
            gap: "10px",
            zIndex: 2147483647
        });

        $("body").append(container);

        const wrapper = container.find("#right-alarm");

        if (!document.getElementById("alarm-style")) {
            const style = `
            <style id="alarm-style">
                .right-alarm_re {
                    opacity: 0;
                    transform: translateX(20px);
                    transition: all 0.5s ease-out;
                }
                .right-alarm_re.show {
                    opacity: 1;
                    transform: translateX(0);
                }
            </style>
        `;
            $("head").append(style);
        }

        $.get("/alarmMessage", param, function (res) {
            if (!Array.isArray(res)) return;

            $.each(res, function (idx) {
                let text = "";
                let step = "";
                const level = res[idx].alarm_lvl_cd;

                if (level === "ARM001") text = "관심", step = "step1";
                else if (level === "ARM002") text = "주의", step = "step2";
                else if (level === "ARM003") text = "경계", step = "step3";
                else if (level === "ARM004") text = "심각", step = "step4";


                let contents = "";
                contents += '<div class="right-alarm_re" ' + step + ' data-assetid="' + res[idx].sens_no + '">';
                contents += '  <button type="button" class="close-alarm">';
                contents += '    <img src="/images/close-alarm.png" alt="close">';
                contents += '  </button>';
                contents += '  <p class="icon"><span data-type="sensor"></span></p>';
                contents += '  <dl>';
                contents += '    <dt>' + text + ' / ' + res[idx].district_nm + '</dt>';
                contents += '    <dd>' + res[idx].sens_tp_nm + ' ' + res[idx].sens_nm + '&nbsp;';
                contents += '      <span point>센서값 ' + res[idx].formul_data + '</span>';
                contents += '      <p class="small">' + fmtKST(res[idx].reg_dt) + '</p>';
                contents += '    </dd>';
                contents += '  </dl>';
                contents += '</div>';

                const $node = $(contents);

                $node.find(".close-alarm").on("click", function (e) {
                    e.stopPropagation();
                    updateAlarmViewFlag(res[idx].mgnt_no)
                    $node.fadeOut(200, () => $node.remove());
                });


                $node.on("click", function (e) {
                    e.stopPropagation();

                    let clickAssetId = res[idx].sens_no || res[idx].asset_id;

                    console.log("추출된 센서 ID (clickAssetId):", clickAssetId);

                    if (clickAssetId) {
                        if (typeof window.triggerChartSearch === "function") {
                            window.triggerChartSearch(clickAssetId);
                        } else {
                            console.error("🚨 에러: window.triggerChartSearch 함수가 정의되지 않았습니다!");
                        }
                    } else {
                        alert("차트를 띄우기 위한 센서 정보(ID)가 없습니다.");
                    }
                    updateAlarmViewFlag(res[idx].mgnt_no)
                });

                wrapper.append($node);
                setTimeout(() => $node.addClass("show"), 10);
            });
        });
    }

    function updateAlarmViewFlag(mgntNo) {
        $.ajax({
            url: '/updateViewFlag',
            type: 'POST',
            data: { mgntNo: mgntNo, view_flag: 'Y' },
            success: function (res) {
                console.log('✅ view_flag 업데이트 완료:', res);
            },
            error: function (xhr, status, err) {
                console.error('❌ view_flag 업데이트 실패:', err);
            }
        });
    }

    function openSensorInfo(data) {
        $.get('/popup/sensorInfo', {
            asset_id : data.asset_id
        }, function(layout) {
            $('#lay-sensor-info').html(layout);
            popFancy('#lay-sensor-info', { dragToClose : false, touch : false });
        });
    }

    function downloadExcel(fileName, url) {
        <%--"${path}/excel?start=" + searchDate.start + "&end=" + searchDate.end;--%>
        if (url === undefined || url === null) url = "${path}/excel";
        url = url + '/' + fileName;
        console.log(url);

        var hiddenIFrameId = 'hiddenDownloader';
        var iframe = document.getElementById(hiddenIFrameId);
        if (iframe === null) {
            iframe = document.createElement('iframe');
            iframe.id = hiddenIFrameId;
            iframe.style.display = 'none';
            document.body.appendChild(iframe);
        }
        iframe.src = url;
    }

</script>

<div id="overall-status">
    <button type="button" class="overall-status-btn">
        <span class="f_arr">←</span>
    </button>
    <div class="overall-status-area">
        <div class="title" data-fancybox data-src="#lay-disaster-broadcast">종합 현황 내역</div>
        <!--[s] 내역 반복 박스 -->
        <div class="overall-status_re">
            <div class="title">알람 현황(최근 1분 기준)</div>
            <div class="conts">
                <ul class="donutty-area">
                    <li level="1">
                        <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl" data-anchor="top" data-bg="#37474f" data-color="#90da00" data-value="0"></div>
                        <p class="chart-donutty-title">관심</p>
                    </li>
                    <li level="2">
                        <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl" data-anchor="top" data-bg="#37474f" data-color="#ffd200" data-value="0"></div>
                        <p class="chart-donutty-title">주의</p>
                    </li>
                    <li level="3">
                        <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl" data-anchor="top" data-bg="#37474f" data-color="#ff9600" data-value="0"></div>
                        <p class="chart-donutty-title">경계</p>
                    </li>
                    <li level="4">
                        <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl" data-anchor="top" data-bg="#37474f" data-color="#ff0000" data-value="0"></div>
                        <p class="chart-donutty-title">심각</p>
                    </li>
                </ul>
            </div>
        </div>
        <!--[e] 내역 반복 박스 -->

        <div class="overall-status_re">
            <div class="title">행안부 전송 상태</div>
            <div class="on-off">
                <button type="button" class="on"></button>
                <button type="button" class="off red"></button>
            </div>
            <div class="conts">
                <!--[s] 상태 반복 -->
                <div class="hang status-number">
                    <div class="title">행안부 전송</div>
                    <div class="conts">
                        <dl class="box">
                            <dt>0</dt>
                            <dd>전체</dd>
                        </dl>
                        <dl class="box">
                            <dt>0</dt>
                            <dd>수신</dd>
                        </dl>
                        <dl class="box">
                            <dt>0</dt>
                            <dd>미수신</dd>
                        </dl>
                    </div>
                </div>
                <!--[e] 상태 반복 -->
            </div>
        </div>

        <div class="overall-status_re">
            <div class="title">시스템 상태</div>
            <div
                class="conts">
                <!--[s] 상태 반복 -->
                <div class="sensor status-number">
                    <div class="title">계측기 상태</div>
                    <div class="conts">
                        <dl class="box" status="">
                            <dt>0</dt>
                            <dd>전체</dd>
                        </dl>
                        <dl class="box" status="1">
                            <dt>0</dt>
                            <dd>수신</dd>
                        </dl>
<%--                        <dl class="box" data-fancybox data-src="#lay-sensor-status-list_origin">--%>
                        <dl class="box" status="2">
                            <dt>0</dt>
                            <dd>미수신</dd>
                        </dl>
                    </div>
                </div>
                <!--[e] 상태 반복 -->

                <!-- <div class="status-number">
                    <div class="title">수집장치 상태</div>
                    <div class="conts">
                        <dl class="box">
                            <dt>0</dt>
                            <dd>전체</dd>
                        </dl>
                        <dl class="box">
                            <dt>0</dt>
                            <dd>수신</dd>
                        </dl>
                        <dl class="box" data-fancybox data-src="#lay-sensor-status-list">
                            <dt>0</dt>
                            <dd>미수신</dd>
                        </dl>
                    </div>
                </div> -->

                <div class="cctv status-number">
                    <div class="title">CCTV 상태</div>
                    <div class="conts">
                        <dl class="box" status="">
                            <dt>0</dt>
                            <dd>전체</dd>
                        </dl>
                        <dl class="box" status="1">
                            <dt>0</dt>
                            <dd>정상</dd>
                        </dl>
<%--                        <dl class="box" data-fancybox data-src="#lay-cctv-status-list">--%>
                        <dl class="box" status="2">
                            <dt>0</dt>
                            <dd>에러</dd>
                        </dl>
                    </div>
                </div>
            </div>
        </div>

        <div class="overall-status_re">
            <div class="title">기상 정보</div>
            <div class="conts">
                <div class="weather-api" data-fancybox data-src="#lay-weather-area">
                    <div class="weather-img">
                        <img src=""/>
                        <span></span>
                    </div>
                    <div class="weather-detail">
                        <!-- 기온: 31.6℃ 최저-최고31℃ 체감(31.3℃)
                        어제보다 3℃ 높아요
                        습도 52 %
                        바람 남 3.2 m/s
                        1시간강수량- mm -->
                    </div>
                </div>
                <div class="weather-comment" data-fancybox data-src="#lay-weather-area2"></div>
            </div>
        </div>

        <div class="overall-status_re" style="overflow: visible">
            <div class="title">장비현황</div>
            <div class="conts">
                <div class="piechart-area">
                    <div id="piechart" style="width:288px; height:134px;"></div>
                </div>
            </div>
        </div>

        <div class="overall-status_re">
            <div class="title">알람 이력</div>
            <div class="conts">
                <ul class="alarm-list">
                    <!--[s] 알람 이력 반복 -->
                    <li></li>
                    <li></li>
                    <li></li>
                    <li></li>
                    <!--[e] 알람 이력 반복 -->
                </ul>
            </div>
        </div>

        <!--[s] 알람현황  팝업 -->
        <div id="lay-alarm-info" class="layer-base">
            <div class="layer-base-btns">
                <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
            </div>
            <div class="layer-base-title">알람 조회</div>
            <div class="layer-base-conts">
                <div class="bTable">
                    <table class="gridAlarm" id="gridAlarm"></table>
                </div>
            </div>
        </div>
        <!--[e] 알람현황  팝업 -->
        <!--알람 이력 조회 팝업 -->
        <div id="lay-alarm-history" class="layer-base">
            <div class="layer-base-btns">
                <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
            </div>
            <div class="layer-base-title">알람 이력 조회</div>
            <div class="layer-base-conts">
                <div class="bTable">
                    <table class="gridAlarmHistory" id="gridAlarmHistory"></table>
                </div>
            </div>
        </div>
        <!--[e] 알람 이력 조회 팝업 -->

        <!--[s] 센서 리스트 팝업 -->
        <div id="lay-sensor-status-list" class="layer-base">
            <div class="layer-base-btns">
                <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
            </div>
            <div class="layer-base-title">전체 센서 리스트</div>
            <div class="layer-base-conts">
<%--                <div class="down-btn">--%>
<%--                    <a href="javascript:downloadExcel('sensorList', '/admin/sensorByChannelList/excel')">다운로드</a>--%>
<%--                </div>--%>
                <div class="bTable">
                    <table class="gridSensor" id="gridSensor"></table>
                </div>
            </div>
        </div>
        <!--[e] 센서 리스트 팝업 -->
        <!--[s] CCTV 리스트 팝업 -->
        <div id="lay-cctv-status-list" class="layer-base">
            <div class="layer-base-btns">
                <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
            </div>
            <div class="layer-base-title">미수신 CCTV 리스트</div>
            <div class="layer-base-conts">
<%--                <div class="down-btn">--%>
<%--                    <a href="javascript:downloadExcel('cctvList', '/cctv/excel')">다운로드</a>--%>
<%--                </div>--%>
                <div class="bTable">
                    <table class="gridCCTV" id="gridCCTV"></table>
                </div>
            </div>
        </div>
        <!--[e] CCTV 리스트 팝업 -->
        <!--[s] 장비 현황 팝업 -->
        <div id="lay-equipment-area" class="layer-base">
            <div class="layer-base-btns">
                <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
            </div>
            <div class="layer-base-title">장비 목록</div>
            <div class="layer-base-conts">
                <div class="bTable">
                    <table class="gridDevice" id="gridDevice"></table>
                </div>
            </div>
        </div>
        <!--[e] 센서 목록 팝업 -->

    </div>
</div>
