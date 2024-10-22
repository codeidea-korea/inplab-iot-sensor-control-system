<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>
    <style>
        /* 검색 행의 input 필드에 border 추가 */
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
            justify-content: space-between;
        }

        .filter-area .select_filter .search-top-label {
            padding: 0;
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
        }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

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
        $(document).ready(function () {
            const currentYear = new Date().getFullYear();

            const startDate = new Date(currentYear, 0, 1); // 0은 1월
            $('#start-date').val(startDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

            const endDate = new Date(currentYear, 11, 31, 23, 59); // 11은 12월
            $('#end-date').val(endDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

            const chartDataArray = []; // 모든 데이터를 저장할 배열 추가

            $("#view-chart").click(() => {
                if (selectArrary.length === 0) {
                    alert('조회할 데이터를 선택해 주세요.');
                    return;
                }
                popFancy('#chart-popup')
                $("#graph-search-btn").trigger('click');
            });

            $("#graph-search-btn").click(() => {
                const startDateTime = $('#start-date').val();
                const endDateTime = $('#end-date').val();
                chartDataArray.length = 0; // 배열 초기화
                const requests = selectArrary.map((item) => {
                    return getChartData(item.sens_no, startDateTime, endDateTime);
                });

                // 모든 요청이 완료된 후 차트를 그립니다.
                Promise.all(requests).then(() => {
                    updateChart(chartDataArray); // 차트 업데이트 함수 호출
                }).catch(() => {
                    alert('데이터를 가져오는 중 오류가 발생했습니다.');
                });
            });

            function getChartData(sens_no, startDateTime, endDateTime) {
                return new Promise((resolve, reject) => {
                    $.ajax({
                        url: '/sensor-grouping/chart' + '?sens_no=' + sens_no + '&start_date_time=' + startDateTime + '&end_date_time=' + endDateTime,
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

            const ctx = document.getElementById('myChart').getContext('2d');
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
                                unit: 'hour' // 단위: 시간
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

            function updateChart(data) {
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
                    label: item[0].sens_nm, // 센서 이름
                    data: item.map(i => i.formul_data), // 센서 데이터
                    borderColor: 'hsl(' + (index * 60) + ', 100%, 50%)', // 센서마다 다른 색상
                    fill: false,
                    pointRadius: 0, // 꼭지점 원 크기 제거
                    borderWidth: 0.5, // 선 두께 줄이기
                }));

                myChart.data.labels = labels;
                myChart.data.datasets = datasets;

                // 기존의 annotation을 초기화
                myChart.options.plugins.annotation.annotations = {};

                // 각 센서 데이터에서 최대 레벨 값을 가져와 점선을 추가
                data.forEach(item => {
                    const maxLevels = [parseFloat(item[0].lvl_max1), parseFloat(item[0].lvl_max2), parseFloat(item[0].lvl_max3), parseFloat(item[0].lvl_max4)];
                    const colors = ['#EFDDCB', '#CBEFD8', '#F0DD7F', '#A3B4ED'];

                    maxLevels.forEach((maxLevel, index) => {
                        if (!isNaN(maxLevel)) {
                            myChart.options.plugins.annotation.annotations['line' + item[0].sens_no + '_' + index] = {
                                type: 'line',
                                yMin: maxLevel,
                                yMax: maxLevel,
                                borderColor: colors[index],
                                borderWidth: 1.5,
                                borderDash: [5, 4]
                            };

                            // 라벨 이름을 "센서이름 1차 Deg" 형식으로 설정
                            const labelName = item[0].sens_nm + ' ' + (index + 1) + '차 경고';

                            myChart.options.plugins.annotation.annotations['label' + item[0].sens_no + '_' + index] = {
                                type: 'label',
                                xValue: 0.4, // x 위치를 조정할 수 있습니다.
                                yValue: maxLevel,
                                backgroundColor: colors[index],
                                content: [labelName], // 수정된 라벨 내용
                                font: {
                                    size: 8
                                }
                            };
                        }
                    });
                });
                myChart.update(); // 차트 업데이트
            }
        });
    </script>
</head>
<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="common/include_top.jsp" flush="true"></jsp:include>
    <div id="global-menu">
        <jsp:include page="common/include_sidebar.jsp" flush="true"></jsp:include>
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
        <div class="contents_header">
            <h3 class="txt">차트</h3>
            <div class="filter-area" style="margin-right: 150px">
                <div style="display:flex;">
                    <p class="search-top-label">조회기간</p>
                    <input id="start-date" type="datetime-local"/>
                </div>
                <div style="display:flex;">
                    <p class="search-top-label">~</p>
                    <input id="end-date" type="datetime-local"/>
                </div>
                <div class="btn-group" style="margin-right: 50px">
                    <a id="graph-search-btn" data-fancybox data-src="">조회</a>
                </div>
            </div>
        </div>
        <div class="layer-base-conts min bTable">
            <div>
                <canvas id="myChart"></canvas>
            </div>
        </div>
    </div>
</section>
</body>
</html>
