<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="./common/include_head.jsp" flush="true" />
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
        const limit = 25;
        let offset = 0;
        let selectArrary = [];

        const checkboxFormatter = (cellValue, options, rowObject) => {
            return '<input type="checkbox" class="row-checkbox" value="' + rowObject.id + '">';
        };

        const netErrorYnFormatter = (cellValue, options, rowObject) => {
            if (cellValue === 'Y') {
                return '<span style="color: red;">오류</span>';
            } else {
                return '<span style="color: green;">수신</span>';
            }
        };

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
            //{ name: 'cb', index: 'cb', width: 50, sortable: false, formatter: 'checkbox', formatoptions: { disabled: false }, align: 'center', title: false },
            {name: 'district_nm', index: 'district_nm', width: 100, align: 'center', hidden: false},
            {name: 'sens_tp_nm', index: 'sens_tp_nm', width: 100, align: 'center', hidden: false},
            {name: 'sens_nm', index: 'sens_nm', width: 100, align: 'center', hidden: false},
            {name: 'sens_chnl_nm', index: 'sens_chnl_nm', width: 100, align: 'center', hidden: false},
            {name: 'logr_nm', index: 'logr_nm', width: 100, align: 'center', hidden: false},
            {name: 'sect_no', index: 'sect_no', width: 50, align: 'center', hidden: false},
            {name: 'inst_ymd', index: 'inst_ymd', width: 100, align: 'center', hidden: false},
            {name: 'meas_dt', index: 'meas_dt', width: 120, align: 'center', hidden: false},
            {name: 'maint_sts_nm', index: 'maint_sts_nm', width: 70, align: 'center', hidden: false},
            {
                name: 'net_err_yn',
                index: 'net_err_yn',
                width: 70,
                align: 'center',
                hidden: false,
                formatter: netErrorYnFormatter
            },
            {name: '', index: '', width: 70, align: 'center', hidden: false},

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
            '', '현장명', '센서타입명', '센서명', '채널명', '로거명', '단면번호', '설치일자', '최종계측일시', '센서상태', '통신상태', '센서값',
            '', '', '', '', '', '', '', '', '', '',
            '', '', '', '', '', '', '', '', '', ''
        ];

        const gridComplete2 = () => {
            // 검색 행 추가
            if ($("#jqGrid").closest(".ui-jqgrid-view").find(".ui-search-toolbar").length === 0) {
                let $thead = $("#jqGrid").closest(".ui-jqgrid-view").find(".ui-jqgrid-htable thead");
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

                    $("#jqGrid").jqGrid('getGridParam', 'colModel').forEach(function (col, index) {
                        let $cell = setFilterControls(col, index, distinctDistrict, distinctSensType, filters, "jqGrid");
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
            let isExist = false;

            selectArrary.some(select => select.sens_no + '_' + select.sens_chnl_nm === rowId) ? isExist = true : isExist = false;
            selectArrary = selectArrary.filter((select) => select.sens_no + '_' + select.sens_chnl_nm !== data.sens_no + '_' + data.sens_chnl_nm);

            if (isExist) {
                $('tr[id=' + rowId + '] input[type=checkbox]').prop("checked", false);
            } else {
                selectArrary.push(data);
                $('tr[id=' + rowId + '] input[type=checkbox]').prop("checked", true);
            }
        };

        const loadComplete2 = () => {
            selectArrary.map((select) => {
                $('tr[id=' + select.sens_no + '_' + select.sens_chnl_nm + '] input[type=checkbox]').prop("checked", true);
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
                console.log('res > ', res);
                setJqGridTable(res.rows, column, header, gridComplete2, onSelectRow2, ['sens_no', 'sens_chnl_nm'], 'jqGrid', limit, offset, getSensor, null, loadComplete2);
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
                $('.tab-button').removeClass('active');
                $(this).addClass('active');
                $('.chart-content').removeClass('active').hide();
                $('#' + $(this).data('chart')).addClass('active').show();
            });
            $('#chart1').show();

            function popFancy(name) {
                // 팝업 열기
                new Fancybox([{src: name, type: "inline"}], Object.assign({
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

            const currentYear = new Date().getFullYear();

            const startDate = new Date(currentYear, 0, 1, 23, 59); // 0은 1월
            $('#start-date').val(startDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

            const endDate = new Date(currentYear, 11, 31, 23, 59); // 11은 12월
            $('#end-date').val(endDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

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

            $("#graph-search-btn").click(() => {
                const startDateTime = $('#start-date').val();
                const endDateTime = $('#end-date').val();
                const popupSensorNo = $("#sensor-name-select").val();
                chartDataArray.length = 0; // 배열 초기화

                const requests = selectArrary.map((item) => {
                    let sensChnlId = ''
                    if (item.sens_chnl_nm) {
                        sensChnlId = item.sens_chnl_nm.slice(-1)
                    }

                    const targetSensorNo = popupSensorNo || item.sens_no;

                    return getChartData(targetSensorNo, startDateTime, endDateTime, sensChnlId);
                });

                // 모든 요청이 완료된 후 차트를 그립니다.
                Promise.all(requests).then(() => {
                    updateChart(chartDataArray); // 차트 업데이트 함수 호출
                }).catch((e) => {
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

            function getChartData(sens_no, startDateTime, endDateTime, sensChnlId) {
                return new Promise((resolve, reject) => {
                    $.ajax({
                        url: '/sensor-grouping/chart' + '?sens_no=' + sens_no + '&start_date_time=' + startDateTime + '&end_date_time=' + endDateTime + "&sens_chnl_id=" + sensChnlId,
                        type: 'GET',
                        success: function (res) {
                            chartDataArray.push(res); // 데이터 추가
                            resolve();
                        },
                        error: function () {
                            reject();
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
                        x: {type: "category"},
                        y: {beginAtZero: true}
                    }
                }
            });

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

            function getRandomHSL() {
                const hue = Math.floor(Math.random() * 360); // 0~359 범위의 색상
                const saturation = 100; // 채도 고정
                const lightness = 50; // 밝기 고정
                return 'hsl(' + hue + ', ' + saturation + '%, ' + lightness + '%)';
            }

            function updateChart(data) {
                myChart.resetZoom();

                const aggregationType = $("#select-condition").val() || "daily";
                // Preprocess data for bar chart
                const barChartData = preprocessDataForBarChart(data[0], aggregationType);

                // 차트 업데이트 로직
                const labels = data[0].map(item => {
                    const date = new Date(item.meas_dt);
                    return date.getFullYear() + '-' +
                        (date.getMonth() + 1).toString().padStart(2, '0') + ' ' + // 월
                        date.getDate().toString().padStart(2, '0') + ' ' + // 일
                        date.getHours().toString().padStart(2, '0') + ':' + // 시간
                        date.getMinutes().toString().padStart(2, '0') + ':' + // 분
                        date.getSeconds().toString().padStart(2, '0'); // 초
                }); // 첫 번째 데이터의 시간

                const datasets = data.map((item, index) => ({
                    label: item[0].sens_nm + (item[0].sens_chnl_id ? "-" + item[0].sens_chnl_id : ""), // 센서 이름
                    data: item.map(i => i.formul_data), // 센서 데이터
                    borderColor: getRandomHSL(),
                    fill: false,
                    pointRadius: 0, // 꼭지점 원 크기 제거
                    borderWidth: 1, // 선 두께 줄이기
                }));

                myChart.data.labels = labels;
                myChart.data.datasets = datasets;
                myChart.options.plugins.annotation.annotations = {};

                myBarChart.data.labels = barChartData.labels;
                myBarChart.data.datasets[0].data = barChartData.ranges;

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
                        if (!isNaN(maxLevel)) { // 유효한 값만 추가
                            myChart.options.plugins.annotation.annotations['line' + item[0].sens_no + '_' + index] = {
                                type: 'line',
                                yMin: maxLevel, // 상한선 위치
                                yMax: maxLevel, // 동일한 값으로 상한선 표시
                                borderColor: colors[index],
                                borderWidth: 1.5,
                                borderDash: [5, 4] // 점선 스타일
                            };

                            // 라벨 추가
                            myChart.options.plugins.annotation.annotations['label' + item[0].sens_no + '_' + item[0].sens_chnl_id + index + i] = {
                                type: 'label',
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

                myChart.update(); // 차트 업데이트
                myBarChart.update();
            }
        });
    </script>
</head>
<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="common/include_top.jsp" flush="true" />
    <div id="global-menu">
        <jsp:include page="common/include_sidebar.jsp" flush="true" />
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
                    <p class="search-top-label">현장명</p>
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
                        <option value="">선택</option>
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
