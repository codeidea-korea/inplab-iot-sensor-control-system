`
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="common/include_head.jsp" flush="true"/>
    <style>
        .tab-container {
            display: flex;
            justify-content: flex-start; /* Align buttons to the left */
            margin-left: 10px;
            overflow: hidden; /* Ensure rounded corners are visible */
        }

        .tab-button {
            padding: 10px 40px; /* Increase padding to make buttons longer */
            cursor: pointer;
            background-color: #555; /* Slightly lighter dark color for unselected buttons */
            color: #fff; /* White text color for better contrast */
            border: none;
            outline: none;
            transition: background-color 0.3s;
            width: 150px; /* Set a fixed width for the buttons */
            text-align: center; /* Center the text */
            border-radius: 10px 10px 0 0; /* Round top corners */
            margin-right: 10px; /* Add spacing between buttons */
            font-size: 1.4rem; /* Increase font size */
        }

        .tab-button.active {
            background-color: #4682B4; /* Slightly darker sky blue color for the active button */
            color: #000; /* Black text color for better contrast */
        }

        .tab-button:hover {
            background-color: #666; /* Slightly lighter dark color for hover effect */
        }

        .chart-content {
            display: none;
            border-radius: 10px; /* Add this line to round the corners */
        }

        .chart-content.active {
            display: block;
            border-radius: 10px; /* Add this line to round the corners */
        }

        h3.txt {
            margin: 0;
            width: 15rem;
        }

        .contents_header {
            display: flex;
            align-items: center;
        }

        .modal-header {
            display: flex;
            flex-direction: column;
            align-items: start;
        }

        #district-select,
        #chart-district-select,
        #sensor-name-select,
        #sensor-type-select,
        #select-condition {
            width: 150px;
            height: 3.6rem;
            padding: 0 1rem;
            background-color: #fff;
            border: 1px solid rgba(0, 0, 0, 0.2);
            font-weight: 300;
            font-size: 1.5rem;
            line-height: 3.4rem;
            color: #47474c;
            display: inline-block;
            vertical-align: top;
        }

        #district-select {
            width: 100px;
        }

        .modal-header input[type="datetime-local"] {
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

        .search-top-label {
            color: #ffffff76;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            padding: 1rem;
        }

        #contents {
            display: flex !important;
            gap: 2rem; 
        }

        #contents .contents-re {
            padding: 3rem;
            width: 90rem !important;
            flex: 0 0 20rem !important;
        }

        #contents .contents-re.cctv_area {
            width: auto !important;
            flex: 1 1 auto !important;
            min-width: 0 !important;
        }

        #contents .contents-in {
            position: static;
            padding: 3rem;
            margin-top: 3rem;
        }

        .filter-area .select_filter .search-top-label {
            padding: 0;
        }

        .cctv_area .contents-in {
            overflow: hidden;
        }

        .search-top > div {
            display: flex;
            flex-direction: row;
        }

        .search-top div:nth-child(2) > p {
            margin-right: 1rem;
        }

        .filter-area .select_filter .search-top-label {
            padding: 0;
        }

        #container input[type="datetime-local"] {
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

        .btn-group-2 > a {
            height: 2.8rem;
            margin-left: 1rem;
            padding: 0 1rem;
            background-color: #237149;
            font-weight: 500;
            font-size: 1.4rem;
            line-height: 1;
            color: #fff; /* text-align:center; */
            border-radius: 99px;
            display: flex;
            align-items: center;
            cursor: text;
            justify-content: center;
            white-space: nowrap;
        }

        .search-btn-wrapper a {
            height: 2.8rem;
            margin-left: 1rem;
            padding: 0 2rem;
            background-color: #6975ac;
            font-weight: 500;
            font-size: 1.4rem;
            line-height: 1;
            color: #fff; /* text-align:center; */
            border-radius: 99px;
            display: flex;
            align-items: center;
            cursor: pointer;
            justify-content: center;
            white-space: nowrap;
        }

        .contents_header input[type="datetime-local"] {
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

        .filter-area {
            display: flex;
        }

        .btn-group3 {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            right: 4rem;
            top: 3.7rem;
        }

        .btn-group3 > a {
            height: 2.8rem;
            margin-left: 1rem;
            padding: 0 2rem;
            background-color: #6975ac;
            font-weight: 500;
            font-size: 1.4rem;
            line-height: 1;
            color: #fff;
            text-align: center;
            border-radius: 99px;
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999; /* 다른 요소들 위에 표시되도록 설정 */
        }

        /* 로딩 스피너 스타일 */
        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 6px solid #ccc;
            border-top: 6px solid #007bff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        /* 로딩 애니메이션 */
        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }
            100% {
                transform: rotate(360deg);
            }
        }

        .search-top {
            position: static;
            align-items: center;
            gap: 0.5rem;
            margin-left: auto;
        }

        .search-top_ {
            margin-bottom: 0;
        }

        #container input[type="date"] {
            width: 80%;
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

        .contents-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .ui-jqgrid .ui-jqgrid-hbox {
            padding-right: 0px;
        }
    </style>
    <script type="text/javascript" src="/jqgrid.js"></script>
    <script src="jquery.loading.js"></script>
    <script>
        $(function () {
            function formatDateOnly(date) {
                const pad = (n) => n.toString().padStart(2, '0');
                const year = date.getFullYear();
                const month = pad(date.getMonth() + 1);
                const day = pad(date.getDate());
                return year + "-" + month + "-" + day;
            }

            $(window).on('beforeLoadGrid', (e, data) => {
                const column = data.model.find(col => col.name === 'district_nm');
                if (column) {
                    column.hidden = true;
                }
                const dateColumn = data.model.find(col => col.name === 'last_apply_dt');
                if (dateColumn) {
                    dateColumn.width = 150;
                    dateColumn.fixed = true;
                }
            });

            const today = new Date();

            const end = new Date(today);

            const start = new Date(today);
            start.setDate(start.getDate() - 1);

            $('#start-date_left').val(formatDateOnly(start));
            $('#end-date_left').val(formatDateOnly(end));

            $('.tab-button').click(function () {
                $('.tab-button').removeClass('active');
                $(this).addClass('active');
                $('.chart-content').removeClass('active').hide();
                $('#' + $(this).data('chart')).addClass('active').show();
            });
            $('#chart1').show();

            const $districtSelect = $('#district-select');

            const $leftGrid = $("#left-jq-grid");
            const leftPath = "/measure-details"

            initGrid($leftGrid, leftPath, $('#left-grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                custom: {
                    useFilterToolbar: true,
                }
            }, () => {
                const allRowIds = $leftGrid.jqGrid('getDataIDs');
                allRowIds.forEach(rowId => {
                    $leftGrid.jqGrid('setCell', rowId, 'district_nm', $('#district-select option:selected').text());
                });
            }, {
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
                }
            }, {maint_sts_cd: "MTN001:정상;MTN002:망실;MTN003:점검;MTN004:철거",
                sens_tp_nm: "변위계:변위계;토양함수비:토양함수비;거리측정기:거리측정기;GNSS:GNSS;지표변위계:지표변위계;적설계:적설계;" +
                    "지하수위계:지하수위계;경사계:경사계;간극수압계:간극수압계;진동계:진동계;지중경사계:지중경사계;하중계:하중계;구조물경사계:구조물경사계;지표경사계:지표경사계;강우량계:강우량계;수위계:수위계"})






            const $rightGrid = $("#right-jq-grid");
            const rightPath = "/measure-details-data"

            const RIGHT_GRID_VALUE_COLUMNS = [
                'raw_data',
                'formul_data',
                'raw_data_x',
                'formul_data_x',
                'raw_data_y',
                'formul_data_y',
                'raw_data_z',
                'formul_data_z'
            ];

            const RIGHT_GRID_DEFAULT_LABELS = {
                meas_dt: '계측일시',
                raw_data: 'Raw Data',
                formul_data: '보정(Deg)',
                raw_data_x: 'Raw Data(X)',
                formul_data_x: 'X 보정(Deg)',
                raw_data_y: 'Raw Data(Y)',
                formul_data_y: 'Y 보정(Deg)',
                raw_data_z: 'Raw Data(Z)',
                formul_data_z: 'Z 보정(Deg)'
            };

            let selectedChartSensor = null;
            let rightGridBaseParams = {
                sens_no: '',
                meas_dt_start: '',
                meas_dt_end: ''
            };

            function getRightGridBaseParamsIfReady() {
                if (!rightGridBaseParams.sens_no) {
                    return {};
                }
                return {
                    sens_no: rightGridBaseParams.sens_no,
                    meas_dt_start: rightGridBaseParams.meas_dt_start,
                    meas_dt_end: rightGridBaseParams.meas_dt_end
                };
            }

            function applyRightGridBaseParams() {
                const postData = $rightGrid.jqGrid('getGridParam', 'postData') || {};
                $rightGrid.jqGrid('setGridParam', {
                    page: 1,
                    postData: {
                        ...postData,
                        ...getRightGridBaseParamsIfReady()
                    }
                });
            }

            function collectRightGridSearchParams() {
                const searchFieldNames = [
                    'meas_dt',
                    'raw_data',
                    'formul_data',
                    'raw_data_x',
                    'formul_data_x',
                    'raw_data_y',
                    'formul_data_y',
                    'raw_data_z',
                    'formul_data_z'
                ];

                const searchParams = {};
                searchFieldNames.forEach(function (fieldName) {
                    searchParams[fieldName] = '';
                });

                const $toolbar = $rightGrid.closest(".ui-jqgrid").find(".ui-jqgrid-hdiv .ui-search-toolbar");
                searchFieldNames.forEach(function (fieldName) {
                    const $field = $toolbar.find("#gs_" + fieldName).first();
                    if ($field.length > 0) {
                        searchParams[fieldName] = String($field.val() || '').trim();
                    }
                });

                return searchParams;
            }

            function performRightGridSearch() {
                const postData = $rightGrid.jqGrid('getGridParam', 'postData') || {};
                $rightGrid.jqGrid('setGridParam', {
                    search: true,
                    page: 1,
                    postData: {
                        ...postData,
                        ...getRightGridBaseParamsIfReady(),
                        ...collectRightGridSearchParams()
                    }
                }).trigger('reloadGrid', [{page: 1}]);
            }

            function setRightGridColumnLabel(columnName, label) {
                $rightGrid.jqGrid('setLabel', columnName, label);
            }

            function getUnitBySensorTypeName(sensorTypeName) {
                return /경사/.test(sensorTypeName || '') ? 'deg' : 'mm';
            }

            function applyRightGridColumnConfig(sensor) {
                Object.keys(RIGHT_GRID_DEFAULT_LABELS).forEach((columnName) => {
                    setRightGridColumnLabel(columnName, RIGHT_GRID_DEFAULT_LABELS[columnName]);
                });

                $rightGrid.jqGrid('showCol', RIGHT_GRID_VALUE_COLUMNS);

                if (!sensor) {
                    return;
                }

                const sensorTypeName = String(sensor.sens_tp_nm || '');
                const sensorName = String(sensor.sens_nm || '채널');
                const unit = getUnitBySensorTypeName(sensorTypeName);
                const isDisplacement = sensorTypeName.includes('변위');
                const isRainGauge = sensorTypeName.includes('강우');
                const isInclinometer = sensorTypeName.includes('경사');
                const isGnss = /gnss/i.test(sensorTypeName);

                let visibleColumns = [...RIGHT_GRID_VALUE_COLUMNS];

                if (isDisplacement || isRainGauge) {
                    visibleColumns = ['raw_data', 'formul_data'];
                    setRightGridColumnLabel('raw_data', sensorName + ' RawData');
                    setRightGridColumnLabel('formul_data', sensorName + ' (' + unit + ')');
                } else if (isInclinometer) {
                    visibleColumns = ['raw_data_x', 'formul_data_x', 'raw_data_y', 'formul_data_y'];
                    setRightGridColumnLabel('raw_data_x', sensorName + '-X RawData');
                    setRightGridColumnLabel('formul_data_x', sensorName + '-X (' + unit + ')');
                    setRightGridColumnLabel('raw_data_y', sensorName + '-Y RawData');
                    setRightGridColumnLabel('formul_data_y', sensorName + '-Y (' + unit + ')');
                } else if (isGnss) {
                    visibleColumns = ['raw_data_x', 'formul_data_x', 'raw_data_y', 'formul_data_y', 'raw_data_z', 'formul_data_z'];
                    setRightGridColumnLabel('raw_data_x', sensorName + '-X RawData');
                    setRightGridColumnLabel('formul_data_x', sensorName + '-X (' + unit + ')');
                    setRightGridColumnLabel('raw_data_y', sensorName + '-Y RawData');
                    setRightGridColumnLabel('formul_data_y', sensorName + '-Y (' + unit + ')');
                    setRightGridColumnLabel('raw_data_z', sensorName + '-Z RawData');
                    setRightGridColumnLabel('formul_data_z', sensorName + '-Z (' + unit + ')');
                } else {
                    setRightGridColumnLabel('raw_data', sensorName + ' RawData');
                    setRightGridColumnLabel('formul_data', sensorName + ' (' + unit + ')');
                    setRightGridColumnLabel('raw_data_x', sensorName + '-X RawData');
                    setRightGridColumnLabel('formul_data_x', sensorName + '-X (' + unit + ')');
                    setRightGridColumnLabel('raw_data_y', sensorName + '-Y RawData');
                    setRightGridColumnLabel('formul_data_y', sensorName + '-Y (' + unit + ')');
                    setRightGridColumnLabel('raw_data_z', sensorName + '-Z RawData');
                    setRightGridColumnLabel('formul_data_z', sensorName + '-Z (' + unit + ')');
                }

                const hideColumns = RIGHT_GRID_VALUE_COLUMNS.filter((columnName) => !visibleColumns.includes(columnName));
                if (hideColumns.length > 0) {
                    $rightGrid.jqGrid('hideCol', hideColumns);
                }
            }

            window.applyMeasureDetailsRightGridColumnConfig = applyRightGridColumnConfig;

            function initRightGridFilterToolbar() {
                if ($rightGrid.data('toolbar_created')) {
                    return;
                }

                $rightGrid.jqGrid('filterToolbar', {
                    stringResult: false,
                    searchOnEnter: true,
                    defaultSearch: "cn",
                    ignoreCase: true,
                    beforeSearch: function () {
                        performRightGridSearch();
                        return false;
                    }
                });

                $rightGrid.closest(".ui-jqgrid")
                    .find(".ui-search-toolbar input, .ui-search-toolbar select")
                    .off("keydown.measureDetailsEnter")
                    .on("keydown.measureDetailsEnter", function (e) {
                        if (e.key === "Enter" || e.keyCode === 13) {
                            e.preventDefault();
                            performRightGridSearch();
                            return false;
                        }
                    });

                $rightGrid.closest(".ui-jqgrid").find('.clearsearchclass').off('click').on('click', function () {
                    const $this = $(this);
                    const $inputTd = $this.closest('td').prev('td');
                    const $select = $inputTd.find('select');
                    const $input = $inputTd.find('input');

                    if ($select.length > 0) {
                        $select.val('');
                    }
                    if ($input.length > 0) {
                        $input.val('');
                    }

                    performRightGridSearch();
                });

                $rightGrid.data('toolbar_created', true);
            }

            initGrid($rightGrid, rightPath, $('#right-grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                custom: {
                    useFilterToolbar: false,
                    multiSelect: true,
                }
            }, () => {
                initRightGridFilterToolbar();
                applyRightGridColumnConfig(selectedChartSensor);
            }, {
                meas_dt: {
                    formatter: (cellValue, _options, _rowObject) => {
                        return moment(cellValue).format("YYYY-MM-DD HH:mm:ss");
                    }
                }
            });

            $.ajax({
                url: '/adminAdd/districtInfo/all',
                type: 'GET',
                success: function (res) {
                    res.forEach((item) => {
                        $districtSelect.append(
                            "<option value='" + item.district_no + "'>" + item.district_nm + "</option>"
                        );
                    });
                },
                error: function () {
                    alert('알 수 없는 오류가 발생했습니다.');
                }
            });

            $districtSelect.on('change', (e) => {
                const value = e.target.value;
                if (value === '') {
                    return
                }
                $leftGrid.setGridParam({
                    page: 1,
                    postData: {
                        ...$leftGrid.jqGrid('getGridParam', 'postData'),
                        district_no: value
                    }
                }).trigger('reloadGrid', [{page: 1}]);
            });

            $("#search-btn").on('click', function () {
                const targetArr = getSelectedCheckData($leftGrid);
                const startD = new Date($('#start-date_left').val());
                const endD = new Date($('#end-date_left').val());

                if (targetArr.length > 1) {
                    alert('조회할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length === 0) {
                    alert('조회할 데이터를 선택해주세요.');
                    return;
                } else if(diffYn(startD, endD)) {
                    alert('조회 가능 기간은 최대 2일입니다.');
                    return;
                } else {
                    selectedChartSensor = targetArr[0];
                    applyRightGridColumnConfig(targetArr[0]);

                    rightGridBaseParams = {
                        sens_no: targetArr[0].sens_no,
                        meas_dt_start: $('#start-date_left').val(),
                        meas_dt_end: $('#end-date_left').val()
                    };

                    $rightGrid.setGridParam({
                        page: 1,
                        postData: {
                            ...$rightGrid.jqGrid('getGridParam', 'postData'),
                            ...rightGridBaseParams
                        }
                    }).trigger('reloadGrid', [{page: 1}]);
                    $("#district_nm").text($('#district-select option:selected').text());
                    $("#sens_tp_nm").text(targetArr[0].sens_tp_nm);
                    $("#sens_nm").text(targetArr[0].sens_nm);
                }
            });

            function popFancy(name) {
                // 팝업 열기
                new Fancybox([{src: name, type: "inline"}], Object.assign({
                    backdropClick: false, // 배경 클릭 시 닫힘 방지
                    clickOutside: false,  // Fancybox 영역 바깥 클릭 시 닫힘 방지
                    dragToClose: false,  // 드래그로 닫기 비활성화
                    animated: false,     // 애니메이션 제거 (선택적)
                    on: {
                        "*": (event, fancybox, slide) => {
                        },
                    },
                    touch: {
                        vertical: false, // 세로 드래그 비활성화
                        momentum: false, // 드래그 후 팝업이 밀리는 현상 방지
                    }
                }));
            }

            function diffYn(startD, endD){
                const diffDays = Math.abs((startD - endD) / (1000 * 60 * 60 * 24));
                return diffDays >= 2;
            }

            function formatLocalDateTime(date) {
                const pad = (n) => n.toString().padStart(2, '0');
                const year = date.getFullYear();
                const month = pad(date.getMonth() + 1);
                const day = pad(date.getDate());
                const hours = pad(date.getHours());
                const minutes = pad(date.getMinutes());
                return year + "-" + month + "-" + day + "T" + hours + ":" + minutes;
            }

            function toChartStartDateTime(dateText) {
                if (!dateText) {
                    return '';
                }
                return dateText + "T00:00";
            }

            function toChartEndDateTime(dateText) {
                if (!dateText) {
                    return '';
                }
                return dateText + "T23:59";
            }

            const chartToday = new Date();
            const chartEndDate = new Date(chartToday);
            chartEndDate.setHours(23, 59, 0, 0);

            const chartStartDate = new Date(chartToday);
            chartStartDate.setMonth(chartStartDate.getMonth() - 1);
            chartStartDate.setHours(0, 0, 0, 0);

            $('#start-date').val(formatLocalDateTime(chartStartDate));
            $('#end-date').val(formatLocalDateTime(chartEndDate));

            $("#view-chart").click(() => {
                const targetArr = getSelectedCheckData($leftGrid);

                if (targetArr.length > 1) {
                    alert('조회할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length === 0) {
                    alert('조회할 데이터를 선택해주세요.');
                    return;
                }

                selectedChartSensor = targetArr[0];
                const currentStartDate = $('#start-date_left').val();
                const currentEndDate = $('#end-date_left').val();

                if (currentStartDate) {
                    $('#start-date').val(toChartStartDateTime(currentStartDate));
                }
                if (currentEndDate) {
                    $('#end-date').val(toChartEndDateTime(currentEndDate));
                }

                const selectedDistrictNo = targetArr[0].district_no || $('#district-select').val();
                const selectedDistrictNm = targetArr[0].district_nm || $('#district-select option:selected').text();
                const selectedSensorTypeNo = targetArr[0].senstype_no;
                const selectedSensorNo = targetArr[0].sens_no;

                popFancy('#chart-popup')
                setChartModal({
                    district_no: selectedDistrictNo,
                    district_nm: selectedDistrictNm,
                    senstype_no: selectedSensorTypeNo,
                    sens_no: selectedSensorNo
                }).then(() => {
                    if (selectedDistrictNo) {
                        $("#chart-district-select").val(selectedDistrictNo);
                    }
                    if (selectedSensorTypeNo) {
                        $("#sensor-type-select").val(selectedSensorTypeNo);
                    }
                    if (selectedSensorNo) {
                        $("#sensor-name-select").val(selectedSensorNo).trigger('change');
                    }
                    $("#graph-search-btn").trigger('click');
                });
            });

            const chartDataArray = []; // 모든 데이터를 저장할 배열 추가

            async function setChartModal(selected) {
                let district_no = '';
                const districtNo = selected && selected.district_no ? selected.district_no : '';
                const districtNm = selected && selected.district_nm ? selected.district_nm : '';
                const sensorTypeNo = selected && selected.senstype_no ? selected.senstype_no : '';
                const sensorNo = selected && selected.sens_no ? selected.sens_no : '';

                await $.ajax({
                    url: '/adminAdd/districtInfo/all',
                    type: 'GET',
                    success: (res) => {
                        $("#chart-district-select").empty();
                        $("#chart-district-select").append(
                            "<option value=''>선택</option>"
                        )
                        res.forEach((item) => {
                            $("#chart-district-select").append(
                                "<option value='" + item.district_no + "'>" + item.district_nm + "</option>"
                            )
                        })

                        if (districtNo) {
                            $("#chart-district-select").val(districtNo);
                        } else if (districtNm) {
                            $("#chart-district-select option").filter(function () {
                                return $(this).text() === districtNm;
                            }).prop('selected', true);
                        }

                        district_no = $("#chart-district-select").val() || districtNo;
                    }
                });

                await $.ajax({
                    url: '/sensor-type',
                    type: 'GET',
                    success: (res) => {
                        $("#sensor-type-select").empty();
                        $("#sensor-type-select").append(
                            "<option value=''>선택</option>"
                        )
                        res.forEach((item) => {
                            $("#sensor-type-select").append(
                                "<option value='" + item.senstype_no + "'>" + item.sens_tp_nm + "</option>"
                            )
                        })
                        if (sensorTypeNo) {
                            $("#sensor-type-select").val(sensorTypeNo);
                        }
                    }
                });

                await getSensors(district_no, sensorTypeNo, sensorNo);
            }

            $("#chart-district-select").on('change', (e) => {
                const district_no = e.target.value;
                const senstype_no = $("#sensor-type-select").val();
                if (district_no === '' || senstype_no === '') {
                    return;
                }
                getSensors(district_no, senstype_no);
            });

            $("#sensor-type-select").on('change', (e) => {
                const district_no = $("#chart-district-select").val();
                const senstype_no = e.target.value;
                if (district_no === '' || senstype_no === '') {
                    return;
                }
                getSensors(district_no, senstype_no);
            });

            async function getSensors(district_no, senstype_no, preferredSensorNo) {
                await $.ajax({
                    url: '/modify/sensor/all' + '?district_no=' + district_no + '&senstype_no=' + senstype_no,
                    type: 'GET',
                    success: (res) => {
                        $("#sensor-name-select").empty();
                        $("#sensor-name-select").append(
                            "<option value=''>선택</option>"
                        )
                        res.forEach((item) => {
                            $("#sensor-name-select").append(
                                "<option value='" + item.sens_no + "'>" + item.sens_nm + "(" + item.sens_no + ")" + "</option>"
                            )
                        });

                        if (preferredSensorNo) {
                            $("#sensor-name-select").val(preferredSensorNo);
                            if (!$("#sensor-name-select").val()) {
                                $("#sensor-name-select option").filter(function () {
                                    return $(this).text().includes(preferredSensorNo);
                                }).prop('selected', true);
                            }
                        } else if (res.length > 0) {
                            $("#sensor-name-select").val(res[0].sens_no);
                        }
                    }
                });
            }

            $("#graph-search-btn").click(() => {
                const startDateTime = $('#start-date').val();
                const endDateTime = $('#end-date').val();
                const selectSensor = $("#sensor-name-select").val();

                let selectType = '';
                if($("#select-condition").val() === "minute"){
                    selectType = 'minute'
                }else if($("#select-condition").val() === "hourly"){
                    selectType = 'hour';
                }else{
                    selectType = 'day';
                }

                if (!selectSensor) {
                    alert('센서명을 선택해주세요.');
                    return;
                }

                const case_ = ['', 'X', 'Y'];
                const targetArr = case_.map((sensChnlId) => ({
                    sens_no: selectSensor,
                    sens_chnl_id: sensChnlId
                }));

                chartDataArray.length = 0; // 배열 초기화
                const requests = targetArr.map((item) => {
                    return getChartData(item.sens_no, startDateTime, endDateTime, item.sens_chnl_id, selectType);
                });

                // 모든 요청이 완료된 후 차트를 그립니다.
                Promise.all(requests).then((responses) => {
                    const hasError = responses.some((item) => !item.ok);
                    const validData = responses
                        .map((item) => item.data)
                        .filter((item) => Array.isArray(item) && item.length > 0);

                    if (validData.length === 0) {
                        alert(hasError ? '조회할 수 없는 데이터 입니다.' : '조회 결과가 존재하지 않습니다.');
                        return;
                    }

                    chartDataArray.length = 0;
                    validData.forEach((item) => chartDataArray.push(item));
                    updateChart(chartDataArray);
                }).catch((e) => {
                    console.log('error', e);
                    alert('조회할 수 없는 데이터 입니다.');
                });
            });

            function getChartData(sens_no, startDateTime, endDateTime, sensChnlId, selectType) {
                return new Promise((resolve) => {
                    $.ajax({
                        url: '/sensor-grouping/chart' + '?sens_no=' + sens_no + '&start_date_time=' + startDateTime + '&end_date_time=' + endDateTime + "&sens_chnl_id=" + sensChnlId + "&selectType=" + selectType,
                        type: 'GET',
                        success: function (res) {
                            if (Array.isArray(res)) {
                                resolve({ok: true, data: res});
                                return;
                            }
                            resolve({ok: true, data: []});
                        },
                        error: function () {
                            resolve({ok: false, data: []});
                        }
                    });
                });
            }

            const ctx = document.getElementById('myChart1').getContext('2d');
            const myChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: [], // 초기 레이블
                    datasets: [] // 초기 데이터셋
                },
                options: {
                    responsive: true,
                    plugins: {
                        zoom: {
                            pan: {
                                enabled: true,
                                mode: 'xy', // x, y축 모두 이동 가능
                                threshold: 10, // 이동을 시작하는 최소 드래그 거리(px)
                            },
                            zoom: {
                                drag: {
                                    enabled: true,
                                    backgroundColor: 'rgba(0, 0, 0, 0.1)',
                                },
                                wheel: {
                                    enabled: true, // 마우스 휠로 줌 가능
                                },
                                pinch: {
                                    enabled: true // 터치로 줌 가능
                                },
                                mode: 'xy', // x, y축 모두 줌 가능
                            }
                        }
                    },
                    scales: {
                        x: {
                            type: 'time', // 시간 축 설정
                            time: {
                                displayFormats: {
                                    minute: 'YYYY-MM-DD HH:mm' // 분 단위까지 표시
                                },
                                unit: 'minute', // 단위를 분(minute)으로 설정
                            },
                            adapters: {
                                date: {} // 어댑터 설정(필요시 사용)
                            }
                        },
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            const ctxBar = document.getElementById("myChart2").getContext("2d");
            const myBarChart = new Chart(ctxBar, {
                type: "bar",
                data: {
                    labels: [],
                    datasets: [{
                        label: "최소-최대 범위",
                        data: [],
                        backgroundColor: "rgba(75, 192, 192, 0.3)",
                        borderColor: "rgba(75, 192, 192, 1)",
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (tooltipItem) {
                                    const value = tooltipItem.raw;
                                    return "Min: " + value.y[0] + ", Max: " + value.y[1];
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            type: 'time', // 시간 축 설정
                            time: {
                                displayFormats: {
                                    minute: 'YYYY-MM-DD HH:mm' // 분 단위까지 표시
                                },
                                unit: 'minute', // 단위를 분(minute)으로 설정
                            },
                            adapters: {
                                date: {} // 어댑터 설정(필요시 사용)
                            }
                        },
                        y: {beginAtZero: true}
                    }
                }
            });

            function getRandomHSL() {
                const hue = Math.floor(Math.random() * 360); // 0~359 범위의 색상
                const saturation = 100; // 채도 고정
                const lightness = 50; // 밝기 고정
                return 'hsl(' + hue + ', ' + saturation + '%, ' + lightness + '%)';
            }

            function preprocessDataForBarChart(data, aggregationType) {
                const processedData = {};

                data.forEach(item => {
                    const date = new Date(item.meas_dt);
                    let key;

                    if (aggregationType === "daily") {
                        key = date.getFullYear() + "-" +
                            (date.getMonth() + 1).toString().padStart(2, "0") + "-" +
                            date.getDate().toString().padStart(2, "0");
                    } else {
                        key = date.getFullYear() + "-" +
                            (date.getMonth() + 1).toString().padStart(2, "0") + "-" +
                            date.getDate().toString().padStart(2, "0") + " " +
                            date.getHours().toString().padStart(2, "0") + ":00:00";
                    }

                    if (!processedData[key]) {
                        processedData[key] = {min: Infinity, max: -Infinity};
                    }

                    const value = item.formul_data;

                    if (value < processedData[key].min) processedData[key].min = value;
                    if (value > processedData[key].max) processedData[key].max = value;
                });

                const labels = Object.keys(processedData);
                const ranges = labels.map(label => ({
                    x: label,
                    y: [processedData[label].min, processedData[label].max]
                }));

                return {labels, ranges};
            }

            async function updateChart(data) {
                const existing = Chart.getChart("myChart");
                if (existing) {
                    existing.destroy();
                    await Promise.resolve();
                }

                if (data.length === 0) {
                    alert('조회 결과가 존재하지 않습니다.');
                    return;
                }

                myChart.resetZoom(); // 차트 줌 초기화

                // '일별' 또는 '시간별' 표시 조건 (바 차트에 사용)
                const aggregationType = $("#select-condition").val() || "daily";

                // --- X축 시간 단위 동적 결정 로직 시작 ---
                let xUnit = 'hour'; // 기본값은 '시(hour)'
                let displayFormats = {
                    minute: 'YYYY-MM-DD HH:mm', // 분 단위 표시 형식
                    hour: 'YYYY-MM-DD HH:00',   // 시 단위 표시 형식
                    day: 'YYYY-MM-DD',          // 일 단위 표시 형식
                };

                if (data && data.length > 0 && data[0].length > 1) {
                    const firstDataPoint = data[0][0];
                    const lastDataPoint = data[0][data[0].length - 1];

                    // 데이터가 없는 경우를 대비하여 meas_dt 속성 확인
                    if (firstDataPoint && lastDataPoint && firstDataPoint.meas_dt && lastDataPoint.meas_dt) {
                        const firstDate = new Date(firstDataPoint.meas_dt);
                        const lastDate = new Date(lastDataPoint.meas_dt);
                        const diffDays = Math.abs(lastDate - firstDate) / (1000 * 60 * 60 * 24); // 일수 차이 계산

                        if (diffDays > 90) { // 3개월 이상이면 '월' 단위로
                            xUnit = 'month';
                            displayFormats.month = 'YYYY-MM';
                        } else if (diffDays > 30) { // 한 달 이상이면 '일' 단위로
                            xUnit = 'day';
                        } else if (diffDays > 1) { // 하루 이상이면 '시' 단위로
                            xUnit = 'hour';
                        } else { // 그 외 (하루 이내)는 '분' 단위로
                            xUnit = 'minute';
                        }
                    }

                    if(aggregationType === "hourly"){
                        xUnit = 'hour';
                    }else if(aggregationType === "daily"){
                        xUnit = 'day';
                    }else if(aggregationType === "minute"){
                        xUnit = 'minute';
                    }

                }

                // 차트의 X축 시간 단위를 업데이트합니다.
                myChart.options.scales.x.time.unit = xUnit;
                myChart.options.scales.x.time.displayFormats = displayFormats;
                myBarChart.options.scales.x.time.unit = xUnit;
                myBarChart.options.scales.x.time.displayFormats = displayFormats;
                // 어댑터 설정 (필요시)
                if (!myChart.options.scales.x.adapters) {
                    myChart.options.scales.x.adapters = {};
                }
                if (!myChart.options.scales.x.adapters.date) {
                    myChart.options.scales.x.adapters.date = {};
                }
                // --- X축 시간 단위 동적 결정 로직 끝 ---


                // 바 차트를 위한 데이터 전처리
                console.log(data)
                const barChartData = preprocessDataForBarChart(data[0]);

                // 라인 차트를 위한 레이블 및 데이터셋 구성
                // Chart.js의 time 스케일은 labels 배열이 필수는 아니며, datasets 내부의 x 값을 통해 처리합니다.
                const labels = data[0].map(item => new Date(item.meas_dt)); // Date 객체를 직접 넘겨줍니다.

                const datasets = data.map((item, index) => ({
                    label: item[0].sens_nm + (item[0].sens_chnl_id ? "-" + item[0].sens_chnl_id : ""), // 센서 이름
                    data: item.map(i => ({x: new Date(i.meas_dt), y: i.formul_data})), // {x, y} 형식으로 데이터 전달
                    borderColor: getRandomHSL(), // 랜덤 색상
                    fill: false, // 선 아래를 채우지 않음
                    pointRadius: 0, // 꼭짓점 원 크기 제거
                    borderWidth: 1, // 선 두께 줄이기
                }));

                myChart.data.labels = labels;
                myChart.data.datasets = datasets;
                myChart.options.plugins.annotation.annotations = {}; // 기존 annotation 초기화

                myBarChart.data.labels = labels;
                myBarChart.data.datasets = datasets;

                const allValues = data.flatMap(d => d.map(p => p.formul_data));
                const absMax = Math.max(...allValues.map(v => Math.abs(v || 0)));

                myChart.options.scales.y = {
                    beginAtZero: false,
                    suggestedMin: -absMax,
                    suggestedMax: absMax,
                    grid: { color: 'rgba(0,0,0,0.05)' },
                    ticks: {
                        color: '#555',
                        callback: v => Number(v.toFixed(2))
                    },
                    title: {
                        display: true,
                        text: 'Value',
                        color: '#555'
                    }
                };

                // --- 상한선(annotation) 추가 로직 시작 ---
                data.forEach((item, i) => {
                    const colors = ['#EFDDCB', '#CBEFD8', '#F0DD7F', '#A3B4ED']; // 각 상한선의 색상
                    const maxLevels = [
                        parseFloat(item[0].lvl_max1),
                        parseFloat(item[0].lvl_max2),
                        parseFloat(item[0].lvl_max3),
                        parseFloat(item[0].lvl_max4)
                    ];

                    // 각 상한선에 대해 annotation 추가
                    maxLevels.forEach((maxLevel, index) => {
                        if (!isNaN(maxLevel)) { // 유효한 값(숫자)만 추가
                            // 라인 annotation
                            myChart.options.plugins.annotation.annotations['line' + item[0].sens_no + '_' + index + '_' + i] = {
                                type: 'line',
                                yMin: maxLevel, // 상한선 위치
                                yMax: maxLevel, // 동일한 값으로 상한선 표시
                                borderColor: colors[index],
                                borderWidth: 1.5,
                                borderDash: [5, 4] // 점선 스타일
                            };

                            // 라벨 annotation
                            myChart.options.plugins.annotation.annotations['label' + item[0].sens_no + '_' + item[0].sens_chnl_id + index + '_' + i] = {
                                type: 'label',
                                // xValue는 Date 객체 또는 타임스탬프여야 합니다.
                                xValue: new Date(item[0].meas_dt).getTime(), // x축 시간 값
                                yValue: maxLevel, // y축 상한선 위치에 표시
                                backgroundColor: colors[index],
                                content: [item[0].sens_nm + (item[0].sens_chnl_id ? "-" + item[0].sens_chnl_id : "") + ' ' + (Number(index) + 1) + '차 경고'], // 라벨 텍스트
                                font: {
                                    size: 8 // 텍스트 크기
                                }
                            };
                        }
                    });
                });
                // --- 상한선(annotation) 추가 로직 끝 ---

                // 차트 업데이트
                myChart.update();
                myBarChart.update();
            }

            // function updateChart(data) {
            //     myChart.resetZoom();
            //
            //     let xUnit = 'hour';
            //     let displayFormats = {
            //         minute: 'YYYY-MM-DD HH:mm',
            //         hour: 'YYYY-MM-DD HH:00',
            //         day: 'YYYY-MM-DD',
            //         month: 'YYYY-MM'
            //     };
            //
            //     const aggregationType = $("#select-condition").val();
            //
            //     let minDate = Infinity;
            //     let maxDate = -Infinity;
            //
            //     data.forEach(sensorData => {
            //         if (sensorData && sensorData.length > 0) {
            //             sensorData.forEach(point => {
            //                 if (point.meas_dt) {
            //                     const date = new Date(point.meas_dt).getTime();
            //                     if (date < minDate) minDate = date;
            //                     if (date > maxDate) maxDate = date;
            //                 }
            //             });
            //         }
            //     });
            //
            //     if(aggregationType === "hourly"){
            //         xUnit = 'hour';
            //     }else if(aggregationType === "daily"){
            //         xUnit = 'day';
            //     }else if(aggregationType === "minute"){
            //         xUnit = 'minute';
            //     }
            //
            //     if (minDate !== Infinity && maxDate !== -Infinity) {
            //         const firstDate = new Date(minDate);
            //         const lastDate = new Date(maxDate);
            //         const diffDays = Math.abs(lastDate - firstDate) / (1000 * 60 * 60 * 24);
            //     }
            //
            //     myChart.options.scales.x.time.unit = xUnit;
            //     myChart.options.scales.x.time.displayFormats = displayFormats;
            //     if (!myChart.options.scales.x.adapters) {
            //         myChart.options.scales.x.adapters = {};
            //     }
            //     if (!myChart.options.scales.x.adapters.date) {
            //         myChart.options.scales.x.adapters.date = {};
            //     }
            //
            //     const datasets = data.map(sensorItem => {
            //         const formattedData = sensorItem.map(point => ({
            //             x: new Date(point.meas_dt),
            //             y: point.formul_data
            //         }));
            //
            //         return {
            //             label: sensorItem[0].sens_nm + (sensorItem[0].sens_chnl_id ? "-" + sensorItem[0].sens_chnl_id : ""),
            //             data: formattedData,
            //             borderColor: getRandomHSL(),
            //             fill: false,
            //             pointRadius: 0,
            //             borderWidth: 1,
            //         };
            //     });
            //
            //     myChart.data.labels = [];
            //     myChart.data.datasets = datasets;
            //     myChart.options.plugins.annotation.annotations = {};
            //
            //     data.forEach(sensorItem => {
            //         const colors = ['#EFDDCB', '#CBEFD8', '#F0DD7F', '#A3B4ED'];
            //         const maxLevels = [
            //             parseFloat(sensorItem[0].lvl_max1),
            //             parseFloat(sensorItem[0].lvl_max2),
            //             parseFloat(sensorItem[0].lvl_max3),
            //             parseFloat(sensorItem[0].lvl_max4)
            //         ];
            //
            //         maxLevels.forEach((maxLevel, index) => {
            //             if (!isNaN(maxLevel)) {
            //                 // 백틱 제거: annotationId 문자열
            //                 const annotationId = 'line-' + sensorItem[0].sens_no + '-' + (sensorItem[0].sens_chnl_id || 'none') + '-' + index;
            //                 myChart.options.plugins.annotation.annotations[annotationId] = {
            //                     type: 'line',
            //                     yMin: maxLevel,
            //                     yMax: maxLevel,
            //                     borderColor: colors[index],
            //                     borderWidth: 1.5,
            //                     borderDash: [5, 4]
            //                 };
            //
            //                 // 백틱 제거: labelAnnotationId 문자열 및 content 문자열
            //                 const labelAnnotationId = 'label-' + sensorItem[0].sens_no + '-' + (sensorItem[0].sens_chnl_id || 'none') + '-' + index;
            //                 const labelXValue = sensorItem[0].meas_dt ? new Date(sensorItem[0].meas_dt).getTime() : minDate;
            //
            //                 myChart.options.plugins.annotation.annotations[labelAnnotationId] = {
            //                     type: 'label',
            //                     xValue: labelXValue,
            //                     yValue: maxLevel,
            //                     backgroundColor: colors[index],
            //                     content: [sensorItem[0].sens_nm + (sensorItem[0].sens_chnl_id ? "-" + sensorItem[0].sens_chnl_id : "") + ' ' + (Number(index) + 1) + '차 경고'],
            //                     font: {
            //                         size: 8
            //                     }
            //                 };
            //             }
            //         });
            //     });
            //
            //     const barChartData = preprocessDataForBarChart(data[0], aggregationType);
            //
            //     // 바 차트 업데이트
            //     myBarChart.data.labels = barChartData.labels;
            //     myBarChart.data.datasets[0].data = barChartData.ranges;
            //
            //     myChart.update();
            //     myBarChart.update();
            // }
        });
    </script>
    <script>
        $(function () {
            const $leftGrid = $("#left-jq-grid");
            const $rightGrid = $("#right-jq-grid");

            $("#download-excel").click(() => {
                downloadExcel('measure-details-data', $rightGrid, "/measure-details-data");
            })

            $('#add-row').click(() => {
                const selectedSensor = getSelectedCheckData($leftGrid);
                if (selectedSensor.length === 0) {
                    alert('센서를 선택해주세요.');
                    return;
                }
                if (typeof window.applyMeasureDetailsRightGridColumnConfig === 'function') {
                    window.applyMeasureDetailsRightGridColumnConfig(selectedSensor[0]);
                }
                addEmptyRow(selectedSensor, $rightGrid)
            });

            function addEmptyRow(sensor, $grid) {
                const newRowId = "new_row_" + new Date().getTime();
                const defaultRowData = {sens_no: sensor[0].sens_no, is_new: true};
                $grid.jqGrid('addRowData', newRowId, defaultRowData, "first");
            }

            $("#save-button").click(() => {
                $.ajax({
                    method: 'post',
                    url: '/measure-details-data/save',
                    traditional: true,
                    data: {jsonData: JSON.stringify($rightGrid.jqGrid('getRowData'))},
                    dataType: 'json',
                    success: function (res) {
                        alert('저장되었습니다.');
                        $rightGrid.trigger('reloadGrid');
                    },
                    error: function () {
                        alert('입력값을 확인해 주세요.');
                    }
                });
            })

            $("#del-row").click(() => {
                const selectedRow = getSelectedCheckData($rightGrid);
                if (selectedRow.length === 0) {
                    alert('삭제할 데이터를 선택해주세요.');
                    return;
                }
                $.ajax({
                    method: 'post',
                    url: '/measure-details-data/del',
                    traditional: true,
                    data: {jsonData: JSON.stringify(selectedRow)},
                    dataType: 'json',
                    success: function (res) {
                        alert('삭제되었습니다.');
                        $rightGrid.trigger('reloadGrid');
                    },
                    error: function () {
                        alert('입력값을 확인해 주세요.');
                    }
                });
            });

            function normalizeHeaderKey(header) {
                return String(header || '')
                    .toLowerCase()
                    .replace(/\s+/g, '')
                    .replace(/[()_\-\/]/g, '');
            }

            function detectAxisFromHeader(header, normalizedHeader) {
                const upperHeader = String(header || '').toUpperCase();
                const normalized = String(normalizedHeader || '');

                if (
                    upperHeader.includes('(X') ||
                    upperHeader.includes('-X') ||
                    upperHeader.includes(' X ') ||
                    upperHeader.includes('X채널') ||
                    normalized.includes('xrawdata') ||
                    normalized.includes('x보정') ||
                    normalized.includes('xdeg') ||
                    normalized.includes('xmm')
                ) {
                    return 'x';
                }

                if (
                    upperHeader.includes('(Y') ||
                    upperHeader.includes('-Y') ||
                    upperHeader.includes(' Y ') ||
                    upperHeader.includes('Y채널') ||
                    normalized.includes('yrawdata') ||
                    normalized.includes('y보정') ||
                    normalized.includes('ydeg') ||
                    normalized.includes('ymm')
                ) {
                    return 'y';
                }

                if (
                    upperHeader.includes('(Z') ||
                    upperHeader.includes('-Z') ||
                    upperHeader.includes(' Z ') ||
                    upperHeader.includes('Z채널') ||
                    normalized.includes('zrawdata') ||
                    normalized.includes('z보정') ||
                    normalized.includes('zdeg') ||
                    normalized.includes('zmm')
                ) {
                    return 'z';
                }

                return '';
            }

            function parseNullableNumber(value) {
                if (value === null || value === undefined || value === '') {
                    return null;
                }

                const parsed = parseFloat(String(value).replace(/,/g, ''));
                return Number.isNaN(parsed) ? null : parsed;
            }

            function toMeasureDateTimeToken(value) {
                if (value === null || value === undefined || value === '') {
                    return null;
                }

                if (Object.prototype.toString.call(value) === '[object Date]' && !isNaN(value.getTime())) {
                    return moment(value).format('YYYY-MM-DD-HH-mm-ss');
                }

                if (typeof value === 'number') {
                    const parsedDate = XLSX.SSF.parse_date_code(value);
                    if (parsedDate && parsedDate.y) {
                        const pad = (n) => String(n).padStart(2, '0');
                        return parsedDate.y + '-' +
                            pad(parsedDate.m) + '-' +
                            pad(parsedDate.d) + '-' +
                            pad(parsedDate.H || 0) + '-' +
                            pad(parsedDate.M || 0) + '-' +
                            pad(parsedDate.S || 0);
                    }
                }

                const text = String(value).trim();
                if (!text) {
                    return null;
                }

                if (/^\d+(\.\d+)?$/.test(text)) {
                    const serialDate = XLSX.SSF.parse_date_code(Number(text));
                    if (serialDate && serialDate.y) {
                        const pad = (n) => String(n).padStart(2, '0');
                        return serialDate.y + '-' +
                            pad(serialDate.m) + '-' +
                            pad(serialDate.d) + '-' +
                            pad(serialDate.H || 0) + '-' +
                            pad(serialDate.M || 0) + '-' +
                            pad(serialDate.S || 0);
                    }
                }

                if (/^\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}$/.test(text)) {
                    return text;
                }

                const formats = [
                    'YYYY-MM-DD HH:mm:ss',
                    'YYYY-MM-DD HH:mm',
                    'YYYY/MM/DD HH:mm:ss',
                    'YYYY/MM/DD HH:mm',
                    'YYYY-MM-DDTHH:mm:ss',
                    'YYYY-MM-DDTHH:mm'
                ];

                const m = moment(text, formats, true);
                if (m.isValid()) {
                    return m.format('YYYY-MM-DD-HH-mm-ss');
                }

                const looseMoment = moment(text, formats, false);
                if (looseMoment.isValid()) {
                    return looseMoment.format('YYYY-MM-DD-HH-mm-ss');
                }

                const normalized = text.replace('T', ' ').replace(/\./g, '-');
                const parts = normalized.split(' ');
                if (parts.length >= 2) {
                    const datePart = parts[0].replace(/\//g, '-');
                    const timePart = parts[1].replace(/:/g, '-');
                    const timeTokens = timePart.split('-').filter(Boolean);

                    if (timeTokens.length === 1) {
                        timeTokens.push('00', '00');
                    } else if (timeTokens.length === 2) {
                        timeTokens.push('00');
                    }

                    if (timeTokens.length >= 3) {
                        return datePart + '-' +
                            String(timeTokens[0]).padStart(2, '0') + '-' +
                            String(timeTokens[1]).padStart(2, '0') + '-' +
                            String(timeTokens[2]).padStart(2, '0');
                    }
                }

                return null;
            }

            function mapExcelRowToMeasureData(item) {
                const mapped = {
                    meas_dt: null,
                    raw_data: null,
                    formul_data: null,
                    raw_data_x: null,
                    formul_data_x: null,
                    raw_data_y: null,
                    formul_data_y: null,
                    raw_data_z: null,
                    formul_data_z: null
                };

                Object.keys(item || {}).forEach((header) => {
                    const value = item[header];
                    if (value === null || value === undefined || value === '') {
                        return;
                    }

                    const normalizedHeader = normalizeHeaderKey(header);

                    if (normalizedHeader.includes('계측일시') || normalizedHeader.includes('measdt')) {
                        mapped.meas_dt = toMeasureDateTimeToken(value);
                        return;
                    }

                    if (normalizedHeader.includes('rawdata')) {
                        const axis = detectAxisFromHeader(header, normalizedHeader);
                        const numberValue = parseNullableNumber(value);
                        if (axis) {
                            mapped['raw_data_' + axis] = numberValue;
                        } else {
                            mapped.raw_data = numberValue;
                        }
                        return;
                    }

                    if (
                        normalizedHeader.includes('보정') ||
                        normalizedHeader.includes('formuldata') ||
                        normalizedHeader.includes('deg') ||
                        normalizedHeader.includes('mm')
                    ) {
                        const axis = detectAxisFromHeader(header, normalizedHeader);
                        const numberValue = parseNullableNumber(value);
                        if (axis) {
                            mapped['formul_data_' + axis] = numberValue;
                        } else {
                            mapped.formul_data = numberValue;
                        }
                    }
                });

                return mapped;
            }

            // 버튼 클릭 시 파일 입력창 열기
            $('#upload-excel').click(function (e) {
                const selectedRow = getSelectedCheckData($leftGrid);
                if (selectedRow.length === 0) {
                    alert('업로드할 데이터를 선택해주세요.');
                    return;
                }

                e.preventDefault();  // 링크의 기본 동작 방지
                $('#excel-file').click();  // 숨겨진 파일 입력 창 열기
            });

            // 파일이 선택되면 처리
            $('#excel-file').on('change', function (e) {
                const file = e.target.files[0];  // 선택한 파일 가져오기
                if (!file) return;

                $('#excel-file').val(''); // 파일 입력 값 초기화

                const reader = new FileReader();
                reader.onload = function (event) {
                    const data = new Uint8Array(event.target.result);
                    const workbook = XLSX.read(data, {type: 'array'});


                    // 첫 번째 시트의 데이터를 JSON 형태로 변환
                    const sheetName = workbook.SheetNames[0];  // 첫 번째 시트 이름 가져오기
                    const sheet = workbook.Sheets[sheetName];
                    const rawRows = XLSX.utils.sheet_to_json(sheet, {defval: null, raw: false});
                    const jsonData = rawRows
                        .map(mapExcelRowToMeasureData)
                        .filter((row) => row.meas_dt);

                    if (jsonData.length === 0) {
                        alert('업로드할 계측 데이터가 없습니다. 엑셀 헤더 및 계측일시 값을 확인해 주세요.');
                        return;
                    }

                    const selectedRow = getSelectedCheckData($leftGrid);

                    $.ajax({
                        method: 'POST',
                        url: '/measure-details-data/excel',
                        contentType: 'application/json',  // JSON 형식으로 전송
                        data: JSON.stringify({jsonData, sensNo: selectedRow[0].sens_no}),  // JSON 데이터 직렬화
                        dataType: 'json',
                        beforeSend: function () {
                            $('#loading').show();
                        },

                        success: function (_res) {
                            alert('저장되었습니다.');
                            $("#search-btn").click();
                        },

                        error: function () {
                            alert('입력값을 확인해 주세요.');
                        },

                        complete: function () {
                            $('#loading').hide();
                        }
                    });
                };
                reader.readAsArrayBuffer(file);  // 파일 읽기
            });
        });
    </script>
</head>
<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="common/include_top.jsp" flush="true"/>
    <div id="global-menu">
        <jsp:include page="common/include_sidebar.jsp" flush="true"/>
    </div>
    <div id="loading" class="loading-overlay" style="display: none;">
        <div class="loading-spinner"></div>
    </div>
    <div id="container">
        <h2 class="txt">관리자 전용
            <span class="arr">데이터 관리</span>
            <span class="arr">계측기 데이터 관리</span>
        </h2>
        <div id="contents">
            <div class="contents-re">
                <div class="contents-header">
                    <h3 class="txt">센서 계측 현황</h3>
                    <div class="search-top">
                        <p class="search-top-label">현장명</p>
                        <select id="district-select">
                            <option value="">선택</option>
                        </select>
                        <div>
                            <p class="search-top-label">조회기간</p>
                            <input id="start-date_left" type="date"/>
                        </div>
                        <div>
                            <p class="search-top-label">~</p>
                            <input id="end-date_left" type="date"/>
                        </div>
                    </div>
                    <div class="search-top_" style="width: 80px">
                        <div class="btn-group">
                            <a id="search-btn">조회</a>
                        </div>
                    </div>
                </div>
                <div id="left-grid-wrapper" class="contents-in">
                    <table id="left-jq-grid"></table>
                </div>
            </div>

            <div class="contents-re cctv_area">
                <div class="contents_header">
                    <h3 class="txt">데이터값 수정</h3>
                    <div class="search-btn-wrapper" style="display: flex; margin-left: auto">
                        <a id="add-row">행추가</a>
                        <a id="del-row">행삭제</a>
                        <a id="save-button">저장</a>
                        <a id="upload-excel">업로드</a>
                        <input type="file" id="excel-file" style="display: none;" accept=".xlsx, .xls"/>
                        <a id="download-excel">다운로드</a>
                        <a id="view-chart">차트조회</a>
                    </div>
                </div>
                <div id="right-grid-wrapper" class="contents-in">
                    <table id="right-jq-grid"></table>
                </div>
            </div>

        </div>
    </div>

    <div id="chart-popup" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_full.png" data-fancybox-full alt="전체화면"></a>
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="modal-header" style="margin-bottom: 10px">
            <div style="margin-bottom: 10px">
                <h3 class="txt">계측 이력 그래프</h3>
            </div>
            <div class="filter-area" style="margin-right: 150px; margin-bottom: 10px">
                <div style="display:flex;">
                    <p class="search-top-label" style="margin-right: 13px;">현장명</p>
                    <select id="chart-district-select">
                        <option value="">선택</option>
                    </select>
                </div>
                <div style="display:flex;">
                    <p class="search-top-label">센서타입</p>
                    <select id="sensor-type-select">
                        <option value="">선택</option>
                    </select>
                </div>
                <div style="display:flex;">
                    <p class="search-top-label">센서명</p>
                    <select id="sensor-name-select">
                        <option value="">선택</option>
                    </select>
                </div>
            </div>
            <div class="filter-area" style="margin-right: 150px; margin-bottom: 10px">
                <div style="display:flex;">
                    <p class="search-top-label">조회기간</p>
                    <input id="start-date" type="datetime-local"/>
                </div>
                <div style="display:flex;">
                    <p class="search-top-label">~</p>
                    <input id="end-date" type="datetime-local"/>
                </div>
                <div style="display:flex;">
                    <p class="search-top-label">조회조건</p>
                    <select id="select-condition">
                        <option value="daily">일별</option>
                        <option value="hourly">시간별</option>
                        <option value="minute">상세</option>
                    </select>
                </div>
                <div class="btn-group3">
                    <a id="graph-search-btn" data-fancybox data-src="">조회</a>
                </div>
            </div>
        </div>
        <div class="tab-container">
            <button class="tab-button active" data-chart="chart1">라인차트</button>
            <button class="tab-button" data-chart="chart2">캔들차트</button>
        </div>
        <div class="layer-base-conts min bTable">
            <div id="chart1" class="chart-content active">
                <canvas id="myChart1"></canvas>
            </div>
            <div id="chart2" class="chart-content">
                <canvas id="myChart2"></canvas>
            </div>
        </div>
    </div>
</section>
</body>
</html>
`
