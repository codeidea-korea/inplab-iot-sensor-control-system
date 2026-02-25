<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="./common/include_head.jsp" flush="true"/>
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

        .ui-search-toolbar input {
            border: 1px solid #ccc; /* 원하는 border 색상 */
            padding: 2px;
        }

        .ui-search-toolbar th:first-child {
            border-left: none !important;
        }

        .ui-jqgrid tr.ui-search-toolbar th {
            border: 1px solid #d3d3d3;
        }

        .ui-jqgrid .ui-jqgrid-htable {
            table-layout: fixed;
            margin: 0;
            border-collapse: collapse;
        }

        .contents_header {
            display: flex;
            align-items: center;
        }

        .filter-area .select_filter .search-top-label {
            padding: 0;
        }

        .modal-header {
            display: flex;
            flex-direction: column;
            align-items: start;
        }

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

        .filter-area {
            display: flex;
        }

        .search-top-label {
            color: #ffffff76;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            padding: 1rem;
        }
    </style>
    <script type="text/javascript" src="/admin_add.js"></script>
    <script>
        window.jqgridOption = {
            multiselect: true,
            multiboxonly: false
        };

        let $grid;
        const limit = 50;
        let offset = 0;
        let selectArrary = [];

        const checkboxFormatter = (cellValue, options, rowObject) => {
            return '<input type="checkbox" class="row-checkbox" value="' + rowObject.district_nm + "_" + rowObject.sens_chnl_nm + '">';
        };

        const formatSensStatus = (cellValue) => {
            if (cellValue === 'MTN001') {
                return '<span>정상</span>';
            } else if (cellValue === 'MTN002') {
                return '<span>망실</span>';
            } else if (cellValue === 'MTN003') {
                return '<span>점검</span>';
            } else if (cellValue === 'MTN004') {
                return '<span>철거</span>';
            } else {
                return '<span>-</span>';
            }
        }

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
        }

        const column = [
            {
                name: 'checkbox',
                index: 'checkbox',
                width: 35,
                align: 'center',
                sortable: false,
                hidden: false,
                formatter: checkboxFormatter
            },
            {name: 'district_nm', index: 'district_nm', width: 100, align: 'center', hidden: false},
            {name: 'sens_tp_nm', index: 'sens_tp_nm', width: 100, align: 'center', hidden: false},
            {name: 'sens_nm', index: 'sens_nm', width: 100, align: 'center', hidden: false},
            {name: 'sens_chnl_nm', index: 'sens_chnl_nm', width: 100, align: 'center', hidden: false},
            {name: 'logr_nm', index: 'logr_nm', width: 100, align: 'center', hidden: false},
            {name: 'sect_no', index: 'sect_no', width: 50, align: 'center', hidden: false},
            {name: 'inst_ymd', index: 'inst_ymd', width: 100, align: 'center', hidden: false},
            {
                name: 'latest_meas_dt',
                index: 'latest_meas_dt',
                width: 120,
                align: 'center',
                hidden: false,
                formatter: formatDateTime
            },
            {
                name: 'sens_status',
                index: 'sens_status',
                width: 70,
                align: 'center',
                hidden: false,
                formatter: formatSensStatus
            },
            {
                name: 'comm_status',
                index: 'comm_status',
                width: 70, align: 'center',
                hidden: false,
                formatter: formatCommStatus
            },
            {name: 'raw_data', index: 'raw_data', width: 70, align: 'right', hidden: false},
            {name: 'disp_val', index: 'disp_val', width: 70, align: 'right', hidden: false, formatter: 'number', formatoptions: {decimalPlaces: 2, thousandsSeparator: ""}},
            {name: 'formul_data', index: 'formul_data', width: 70, align: 'right', hidden: true},
            {name: 'senstype_no', index: 'senstype_no', width: 100, align: 'center', hidden: true},
            {name: 'sens_no', index: 'sens_no', width: 100, align: 'center', hidden: true},
            {name: 'logr_no', index: 'logr_no', width: 100, align: 'center', hidden: true},
            {name: 'multi_sens_yn', index: 'multi_sens_yn', width: 100, align: 'center', hidden: true},
            {name: 'disp_prior_yn', index: 'disp_prior_yn', width: 100, align: 'center', hidden: true},
            {name: 'multi_senstype_no', index: 'multi_senstype_no', width: 100, align: 'center', hidden: true},
            {name: 'multi_sens_no', index: 'multi_sens_no', width: 100, align: 'center', hidden: true},
            {name: 'nonrecv_limit_min', index: 'nonrecv_limit_min', width: 100, align: 'center', hidden: true},
            {name: 'alarm_use_yn', index: 'alarm_use_yn', width: 100, align: 'center', hidden: true},
            {name: 'sms_snd_yn', index: 'sms_snd_yn', width: 100, align: 'center', hidden: true},
            {name: 'sens_disp_yn', index: 'sens_disp_yn', width: 100, align: 'center', hidden: true},
            {name: 'maint_sts_cd', index: 'maint_sts_cd', width: 100, align: 'center', hidden: true},
            {name: 'sens_lon', index: 'sens_lon', width: 100, align: 'center', hidden: true},
            {name: 'sens_lat', index: 'sens_lat', width: 100, align: 'center', hidden: true},
            {name: 'sens_maker', index: 'sens_maker', width: 100, align: 'center', hidden: true},
            {name: 'model_nm', index: 'model_nm', width: 100, align: 'center', hidden: true},
            {name: 'logger_maint_sts_cd', index: 'logger_maint_sts_cd', width: 100, align: 'center', hidden: true},
            {name: 'formul_data', index: 'formul_data', width: 100, align: 'center', hidden: true},
            {name: 'reg_dt', index: 'reg_dt', width: 100, align: 'center', hidden: true},
            {name: 'mod_dt', index: 'mod_dt', width: 100, align: 'center', hidden: true},

        ];

        const header = [
            '', '현장명', '센서타입명', '센서명', '채널명', '로거명', '단면번호', '설치일자', '최종계측일시', '센서상태', '통신상태', 'RawData', '변위값',
            '', '', '', '', '', '', '', '', '', '',
            '', '', '', '', '', '', '', '', '', '',''
        ];

        const gridComplete2 = () => {
            // 검색 행 추가
            if ($("#jqGrid").closest(".ui-jqgrid-view").find(".ui-search-toolbar").length === 0) {
                let $thead = $("#jqGrid").closest(".ui-jqgrid-view").find(".ui-jqgrid-htable thead");
                let $searchRow = $('<tr class="ui-search-toolbar"></tr>');

                let distinctDistrict = [];
                let distinctSensType = [];
                let distinctLogger = [];
                let distinctSection = [];

                // 현재 필터링 조건을 저장할 객체
                let filters = {
                    groupOp: "AND",
                    rules: []
                };

                getDistinct().then((res) => {
                    distinctDistrict = res.district;
                    distinctSensType = res.sensor_type;
                    distinctLogger = res.logger;
                    distinctSection = res.section;

                    $("#jqGrid").jqGrid('getGridParam', 'colModel').forEach(function (col, index) {
                        let $cell = setFilterControls(col, index, distinctDistrict, distinctSensType, filters, "jqGrid", null, distinctLogger, distinctSection);
                        $searchRow.append($cell);
                    });
                    $thead.append($searchRow);
                }).catch((fail) => {
                    console.log('getDistinct fail > ', fail);
                });
            }
        };

        const onSelectRow2 = (rowId, status, e) => {
            const data = $("#jqGrid").jqGrid('getRowData', rowId);
            let isExist;

            selectArrary.some(select => select.district_nm + '_' + select.sens_chnl_nm === rowId) ? isExist = true : isExist = false;

            selectArrary = selectArrary.filter((select) => select.district_nm + '_' + select.sens_chnl_nm !== data.district_nm + '_' + data.sens_chnl_nm);

            if (isExist) {

                $('tr[id="' + rowId + '"] input[type=checkbox]').prop("checked", false);
            } else {

                $('input.row-checkbox').prop('checked', false); 
                selectArrary = [];

                selectArrary.push(data);
                $('tr[id="' + rowId + '"] input[type=checkbox]').prop("checked", true); 
            }
        };


        const loadComplete2 = () => {
            selectArrary.map((select) => {
                $('tr[id="' + select.district_nm + '_' + select.sens_chnl_nm + '"] input[type=checkbox]').prop("checked", true);
            });
        };

        const getSensor = (obj) => {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: 'GET',
                    url: `/modify/sensor/sensor`,
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

        $(function () {

            getSensor({limit: limit, offset: offset}).then((res) => {
                setJqGridTable(res.rows, column, header, gridComplete2, onSelectRow2, ['district_nm', 'sens_chnl_nm'], 'jqGrid', limit, offset, getSensor, null, loadComplete2);
            }).catch((fail) => {
                console.log('setJqGridTable fail > ', fail);
            });

            // row 의 체크박스를 해제하기 위해 클릭했을때 onselectrow 이 반응하지 않기에 추가된 이벤트
            $(document).on('change', '#jqGrid input[type=checkbox]', function (e) {
                e.stopImmediatePropagation(); // 현재 이벤트가 다른 이벤트 핸들러로 전파되는 것을 방지
                const isChecked = $(this).is(':checked');
                const rowId = $(this).closest('tr').attr('id');

                // row클릭시 selectArray 에 등록되고 동작해야한다
                loadComplete2();

                if (!isChecked) {
                    onSelectRow2(rowId, isChecked, e);
                }
            });
        });
    </script>
    <script>
        $(function () {
            $('.tab-button').click(function () {
                let selectedSensorType = $("#sensor-type-select").val();
                $('.tab-button').removeClass('active');
                $(this).addClass('active');
                $('.chart-content').removeClass('active').hide();
                $('#' + $(this).data('chart')).addClass('active').show();
            });
            $('#chart1').show();

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

            function formatLocalDateTime(date) {
                const pad = (n) => n.toString().padStart(2, '0');
                const year = date.getFullYear();
                const month = pad(date.getMonth() + 1);
                const day = pad(date.getDate());
                const hours = pad(date.getHours());
                const minutes = pad(date.getMinutes());
                return year + "-" + month + "-" + day + "T" + hours + ":" + minutes;
            }

            const today = new Date();

            // 종료일 = 오늘 23:59 (한국시간 기준)
            const endDate = new Date(today);
            endDate.setHours(23, 59, 0, 0);

            // 시작일 = 한 달 전 00:00 (한국시간 기준)
            const startDate = new Date(today);
            startDate.setDate(startDate.getDate() - 1);
            startDate.setHours(0, 0, 0, 0);

            $('#start-date').val(formatLocalDateTime(startDate));
            $('#end-date').val(formatLocalDateTime(endDate));


            $("#view-chart").click(() => {
                if (selectArrary.length > 1) {
                    alert('조회할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (selectArrary.length === 0) {
                    alert('조회할 데이터를 선택해주세요.');
                    return;
                }
                popFancy('#chart-popup')
                setChartModal(selectArrary[0].district_nm, selectArrary[0].senstype_no, selectArrary[0].sens_no)
                $("#sensor-name-select").val(selectArrary[0].sens_no).trigger('change');
                $("#graph-search-btn").trigger('click');
            });

            const chartDataArray = []; // 모든 데이터를 저장할 배열 추가

            async function setChartModal(district_nm, senstype_no, sens_no) {
                let district_no = '';

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
                        $("#chart-district-select option").filter(function () {
                            return $(this).text() === district_nm;
                        }).prop('selected', true);

                        district_no = $("#chart-district-select").val();
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
                        $("#sensor-type-select").val(senstype_no);
                    }
                });

                await getSensors(district_no, senstype_no);
                $("#sensor-name-select option").filter(function () {
                    return $(this).text().includes(sens_no);
                }).prop('selected', true);
            }

            /*$("#graph-search-btn").click(() => {
                const startDateTime = $('#start-date').val();
                const endDateTime = $('#end-date').val();
                let selectSensor = $("#sensor-name-select").val();

                let selectType = '';
                if($("#select-condition").val() === "minute"){
                    selectType = 'minute'
                }else if($("#select-condition").val() === "hourly"){
                    selectType = 'hour';
                }else{
                    selectType = 'day';
                }

                const case_ = ['', 'X', 'Y'];

                const baseArray = [...selectArrary];

                const expandedArray = case_.flatMap((item) => {
                    return baseArray.map((data) => ({
                        ...data,
                        sens_chnl_id: item
                    }));
                });

                chartDataArray.length = 0; // 배열 초기화

                const requests = expandedArray.map((item) => {
                    let sensChnlId = '';
                    if (item.sens_chnl_nm) {
                        const tempSensChnlId = item.sens_chnl_nm.split("-").pop();
                        if (tempSensChnlId.length === 1) {
                            sensChnlId = tempSensChnlId;
                        }
                    }

                    const targetSensor = (!selectSensor || selectSensor === 'null' || selectSensor === '')
                        ? item.sens_no
                        : selectSensor;

                    return getChartData(targetSensor, startDateTime, endDateTime, item.sens_chnl_id, selectType);
                });

                // 차트 업데이트
                Promise.all(requests)
                    .then((responses) => {
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
                    })
                    .catch((e) => {
                        console.log('error', e);
                        alert('조회할 수 없는 데이터 입니다.');
                    });
            });*/

            $("#graph-search-btn").click(() => {
                const startDateTime = $('#start-date').val();
                const endDateTime = $('#end-date').val();
                let selectSensor = $("#sensor-name-select").val();

                let selectType = '';
                if($("#select-condition").val() === "minute"){
                    selectType = 'minute'
                }else if($("#select-condition").val() === "hourly"){
                    selectType = 'hour';
                }else{
                    selectType = 'day';
                }

                const baseArray = [...selectArrary];
                chartDataArray.length = 0;
                const requests = [];

                baseArray.forEach((item) => {
                    const targetSensor = (!selectSensor || selectSensor === 'null' || selectSensor === '')
                        ? item.sens_no
                        : selectSensor;


                    let isXYType = false;
                    if (item.sens_chnl_nm && (item.sens_chnl_nm.toUpperCase().endsWith('-X') || item.sens_chnl_nm.toUpperCase().endsWith('-Y'))) {
                        isXYType = true;
                    }

                    if (isXYType) {
                        requests.push(getChartData(targetSensor, startDateTime, endDateTime, 'X', selectType));
                        requests.push(getChartData(targetSensor, startDateTime, endDateTime, 'Y', selectType));
                    } else {
                        // 단일 센서: 기존처럼 1번만 요청
                        let singleChnlId = '';
                        if (item.sens_chnl_nm) {
                            const temp = item.sens_chnl_nm.split("-").pop();
                            if (temp.length === 1) singleChnlId = temp;
                        }
                        requests.push(getChartData(targetSensor, startDateTime, endDateTime, singleChnlId, selectType));
                    }
                });

                // 차트 업데이트 (기존과 동일)
                Promise.all(requests)
                    .then((responses) => {
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
                    })
                    .catch((e) => {
                        console.log('error', e);
                        alert('조회할 수 없는 데이터 입니다.');
                    });
            });


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

            async function getSensors(district_no, senstype_no) {
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
                        })
                    }
                });
            }

            function getChartData(sens_no, startDateTime, endDateTime, sensChnlId, selectType) {
                return new Promise((resolve) => {
                    $.ajax({
                        url: '/sensor-grouping/chart' + '?sens_no=' + sens_no + '&start_date_time=' + startDateTime + '&end_date_time=' + endDateTime + "&sens_chnl_id=" + sensChnlId + "&selectType=" + selectType + "&init_base=raw&diff_direction=init_minus_meas",
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

            // 상세(분단위)에서 min=max인 경우 캔들이 0높이가 되므로 '-' 형태를 직접 그려준다.
            const flatRangeDashPlugin = {
                id: 'flatRangeDashPlugin',
                afterDatasetsDraw(chart) {
                    if (!chart || chart.canvas.id !== 'myChart2') {
                        return;
                    }

                    const {ctx} = chart;
                    chart.data.datasets.forEach((dataset, datasetIndex) => {
                        const meta = chart.getDatasetMeta(datasetIndex);
                        if (!meta || meta.hidden || meta.type !== 'bar') {
                            return;
                        }

                        meta.data.forEach((element, dataIndex) => {
                            const raw = dataset.data && dataset.data[dataIndex];
                            if (!raw || !raw.isFlat) {
                                return;
                            }

                            const x = element.x;
                            const y = element.y;
                            const width = Math.max((element.width || 12) * 0.7, 10);

                            if (!Number.isFinite(x) || !Number.isFinite(y)) {
                                return;
                            }

                            ctx.save();
                            ctx.strokeStyle = dataset.borderColor || '#333';
                            ctx.lineWidth = Math.max(Number(dataset.borderWidth) || 1, 2);
                            ctx.beginPath();
                            ctx.moveTo(x - (width / 2), y);
                            ctx.lineTo(x + (width / 2), y);
                            ctx.stroke();
                            ctx.restore();
                        });
                    });
                }
            };

            const ctxBar = document.getElementById("myChart2").getContext("2d");
            const myBarChart = new Chart(ctxBar, {
                plugins: [flatRangeDashPlugin],
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
                                    const min = Number(value.minValue);
                                    const max = Number(value.maxValue);
                                    if (Number.isFinite(min) && Number.isFinite(max)) {
                                        return "Min: " + min + ", Max: " + max;
                                    }
                                    if (value && Array.isArray(value.y)) {
                                        return "Min: " + value.y[0] + ", Max: " + value.y[1];
                                    }
                                    return "";
                                }
                            }
                        },
                        annotation: {
                            annotations: {}
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
                            beginAtZero: false,
                            grid: {
                                color: function (ctx) {
                                    const tickValue = Number(ctx && ctx.tick ? ctx.tick.value : NaN);
                                    if (Number.isFinite(tickValue) && tickValue === 0) {
                                        return 'rgba(60, 90, 160, 0.55)';
                                    }
                                    return 'rgba(0, 0, 0, 0.06)';
                                },
                                lineWidth: function (ctx) {
                                    const tickValue = Number(ctx && ctx.tick ? ctx.tick.value : NaN);
                                    return (Number.isFinite(tickValue) && tickValue === 0) ? 1.4 : 1;
                                }
                            }
                        }
                    }
                }
            });

            function preprocessDataForBarChart(data) {
                const labels = data.map(item => item.meas_dt);
                const ranges = data.map(item => {
                    let min = Number(item.min_data);
                    let max = Number(item.max_data);

                    if (!Number.isFinite(min) || !Number.isFinite(max)) {
                        return null;
                    }

                    if (min > max) {
                        const temp = min;
                        min = max;
                        max = temp;
                    }

                    return {
                        x: new Date(item.meas_dt),
                        y: [min, max],
                        minValue: min,
                        maxValue: max,
                        isFlat: min === max,
                        label: item.sens_nm + (item.sens_chnl_id ? "-" + item.sens_chnl_id : "")
                    };
                }).filter(item => item !== null);

                return {labels, ranges};
            }

            function getRandomHSL() {
                const hue = Math.floor(Math.random() * 360); // 0~359 범위의 색상
                const saturation = 100; // 채도 고정
                const lightness = 50; // 밝기 고정
                return 'hsl(' + hue + ', ' + saturation + '%, ' + lightness + '%)';
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
                const seriesColors = data.map(() => getRandomHSL());

                // 라인 차트를 위한 레이블 및 데이터셋 구성
                // Chart.js의 time 스케일은 labels 배열이 필수는 아니며, datasets 내부의 x 값을 통해 처리합니다.
                const labels = data[0].map(item => new Date(item.meas_dt)); // Date 객체를 직접 넘겨줍니다.

                const datasets = data.map((item, index) => ({
                    label: item[0].sens_nm + (item[0].sens_chnl_id ? "-" + item[0].sens_chnl_id : ""), // 센서 이름
                    data: item.map(i => {
                        const value = Number(i.formul_data);
                        return {x: new Date(i.meas_dt), y: Number.isFinite(value) ? value : null};
                    }), // 변위차 기준 {x, y}
                    borderColor: seriesColors[index], // 랜덤 색상
                    fill: false, // 선 아래를 채우지 않음
                    pointRadius: 0, // 꼭짓점 원 크기 제거
                    borderWidth: 1, // 선 두께 줄이기
                }));

                const barDatasets = data.map((series, index) => {
                    const processed = preprocessDataForBarChart(series);
                    const baseColor = seriesColors[index];
                    return {
                        type: 'bar',
                        label: series[0].sens_nm + (series[0].sens_chnl_id ? "-" + series[0].sens_chnl_id : ""),
                        data: processed.ranges,
                        backgroundColor: baseColor.replace('hsl(', 'hsla(').replace(')', ', 0.20)'),
                        borderColor: baseColor,
                        borderWidth: 1.5,
                        borderSkipped: false,
                        borderRadius: 0,
                        barPercentage: 0.42,
                        categoryPercentage: 0.8,
                        maxBarThickness: 18
                    };
                });

                myChart.data.labels = labels;
                myChart.data.datasets = datasets;
                if (!myChart.options.plugins.annotation) {
                    myChart.options.plugins.annotation = {annotations: {}};
                }
                myChart.options.plugins.annotation.annotations = {}; // 기존 annotation 초기화

                myBarChart.data.labels = [];
                myBarChart.data.datasets = barDatasets;
                if (!myBarChart.options.plugins.annotation) {
                    myBarChart.options.plugins.annotation = {annotations: {}};
                }
                myBarChart.options.plugins.annotation.annotations = {}; // 기존 annotation 초기화

                const dataValues = data
                    .flatMap(d => d.map(p => Number(p.formul_data)))
                    .filter(v => Number.isFinite(v));
                const alarmValues = data
                    .flatMap(item => ([
                        Number(item[0].lvl_min1),
                        Number(item[0].lvl_min2),
                        Number(item[0].lvl_min3),
                        Number(item[0].lvl_min4),
                        Number(item[0].lvl_max1),
                        Number(item[0].lvl_max2),
                        Number(item[0].lvl_max3),
                        Number(item[0].lvl_max4)
                    ]))
                    .filter(v => Number.isFinite(v));

                const axisCandidates = [...dataValues, ...alarmValues, 0];
                const baseMin = Math.min(...axisCandidates);
                const baseMax = Math.max(...axisCandidates);
                const axisSpan = Math.max(baseMax - baseMin, 0.1);
                const axisPadding = Math.max(axisSpan * 0.1, 0.1);

                let selectedSensorType = ($("#sensor-type-select option:selected").text() || '').trim();

                const unitMap = {
                    '지표경사계': 'mm',
                    '지표변위계': 'mm',
                    '강우량계': 'mm',
                };

                const sensorTypeRaw = selectedSensorType;
                let yAxisTitle = (sensorTypeRaw === '선택' || sensorTypeRaw === '') ? 'Value' : sensorTypeRaw;
                const unit = unitMap[sensorTypeRaw];
                const isRainType = sensorTypeRaw.includes('강우');

                if (unit) {
                    yAxisTitle = sensorTypeRaw + ' (' + unit + ')';
                }

                const lineAbsMax = Math.max(...axisCandidates.map(v => Math.abs(v || 0)), 0.1);
                const linePadding = Math.max(lineAbsMax * 0.1, 0.1);
                const lineMin = isRainType ? 0 : -(lineAbsMax + linePadding);
                const lineMax = lineAbsMax + linePadding;

                myChart.options.scales.y = {
                    beginAtZero: false,
                    suggestedMin: lineMin,
                    suggestedMax: lineMax,
                    grid: {
                        color: function (ctx) {
                            const tickValue = Number(ctx && ctx.tick ? ctx.tick.value : NaN);
                            return tickValue === 0 ? 'rgba(255,0,0,0.35)' : 'rgba(0,0,0,0.05)';
                        },
                        lineWidth: function (ctx) {
                            const tickValue = Number(ctx && ctx.tick ? ctx.tick.value : NaN);
                            return tickValue === 0 ? 1.2 : 1;
                        }
                    },
                    ticks: {
                        color: '#555',
                        callback: v => Number(v.toFixed(2))
                    },
                    title: {
                        display: true,
                        text: yAxisTitle,
                        color: '#555'
                    }
                };

                const candleRangeValues = data
                    .flatMap(series => series.flatMap(point => [Number(point.min_data), Number(point.max_data)]))
                    .filter(v => Number.isFinite(v));
                const candleCandidates = [...candleRangeValues, 0];
                const candleMin = Math.min(...candleCandidates);
                const candleMax = Math.max(...candleCandidates);
                const candleSpan = Math.max(candleMax - candleMin, 0.1);
                const candlePadding = Math.max(candleSpan * 0.1, 0.1);

                myBarChart.options.scales.y = {
                    beginAtZero: false,
                    suggestedMin: Math.min(candleMin, 0) - candlePadding,
                    suggestedMax: Math.max(candleMax, 0) + candlePadding,
                    grid: {
                        color: function (ctx) {
                            const tickValue = Number(ctx && ctx.tick ? ctx.tick.value : NaN);
                            if (Number.isFinite(tickValue) && tickValue === 0) {
                                return 'rgba(60, 90, 160, 0.55)';
                            }
                            return 'rgba(0, 0, 0, 0.06)';
                        },
                        lineWidth: function (ctx) {
                            const tickValue = Number(ctx && ctx.tick ? ctx.tick.value : NaN);
                            return (Number.isFinite(tickValue) && tickValue === 0) ? 1.4 : 1;
                        }
                    },
                    ticks: {
                        color: '#555',
                        callback: v => Number(v.toFixed(2))
                    },
                    title: {
                        display: true,
                        text: yAxisTitle,
                        color: '#555'
                    }
                };

                // --- 경보선(annotation) 추가 로직 시작 ---
                data.forEach((item, i) => {
                    if (!item || item.length === 0) {
                        return;
                    }

                    const colors = ['#EFDDCB', '#CBEFD8', '#F0DD7F', '#A3B4ED']; // 각 상한선의 색상
                    const minLevels = [
                        parseFloat(item[0].lvl_min1),
                        parseFloat(item[0].lvl_min2),
                        parseFloat(item[0].lvl_min3),
                        parseFloat(item[0].lvl_min4)
                    ];
                    const maxLevels = [
                        parseFloat(item[0].lvl_max1),
                        parseFloat(item[0].lvl_max2),
                        parseFloat(item[0].lvl_max3),
                        parseFloat(item[0].lvl_max4)
                    ];

                    const firstX = Date.parse(item[0].meas_dt);
                    const labelTextBase = item[0].sens_nm + (item[0].sens_chnl_id ? "-" + item[0].sens_chnl_id : "");

                    const addAlarmAnnotation = (levelValue, index, levelType) => {
                        if (isNaN(levelValue)) {
                            return;
                        }

                        const lineKey = 'line_' + levelType + '_' + item[0].sens_no + '_' + (item[0].sens_chnl_id || 'single') + '_' + index + '_' + i;
                        const labelKey = 'label_' + levelType + '_' + item[0].sens_no + '_' + (item[0].sens_chnl_id || 'single') + '_' + index + '_' + i;

                        [myChart, myBarChart].forEach((targetChart, chartIdx) => {
                            const annotations = targetChart.options.plugins.annotation.annotations;
                            const chartLineKey = lineKey + '_' + chartIdx;
                            const chartLabelKey = labelKey + '_' + chartIdx;

                            annotations[chartLineKey] = {
                                type: 'line',
                                yMin: levelValue,
                                yMax: levelValue,
                                borderColor: colors[index],
                                borderWidth: 1.5,
                                borderDash: [5, 4]
                            };

                            if (Number.isFinite(firstX)) {
                                annotations[chartLabelKey] = {
                                    type: 'label',
                                    xValue: firstX,
                                    yValue: levelValue,
                                    xAdjust: 72, // 좌측 경계에서 라벨이 잘리지 않도록 안쪽으로 이동
                                    backgroundColor: colors[index],
                                    content: [
                                        labelTextBase,
                                        (Number(index) + 1) + '차 ' + (levelType === 'min' ? '최소' : '최대') + ' 경고'
                                    ],
                                    font: {
                                        size: 8
                                    }
                                };
                            }
                        });
                    };

                    minLevels.forEach((minLevel, index) => addAlarmAnnotation(minLevel, index, 'min'));
                    maxLevels.forEach((maxLevel, index) => addAlarmAnnotation(maxLevel, index, 'max'));
                });
                // --- 경보선(annotation) 추가 로직 끝 ---

                // 차트 업데이트
                myChart.update();
                myBarChart.update();
            }
        });

        function messageTest() {
            return new Promise((resolve, reject) => {
                $.ajax({
                    url: '/message/test',
                    type: 'GET',
                    success: function (res) {
                        console.log(res)
                        resolve();
                    },
                    error: function () {
                        reject();
                    }
                });
            });
        }
    </script>
</head>
<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="common/include_top.jsp" flush="true"/>
    <div id="global-menu">
        <jsp:include page="common/include_sidebar.jsp" flush="true"/>
    </div>
    <div id="container">
        <h2 class="txt">센서모니터링</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">센서현황
                    <div class="visionBtn" id="view-chart">차트조회</div>
                </h3>
                <div class="contents-in">
                    <table id="jqGrid"></table>
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
                        <option value="minute">상세</option>
                        <option value="daily">일별</option>
                        <option value="hourly">시간별</option>
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
