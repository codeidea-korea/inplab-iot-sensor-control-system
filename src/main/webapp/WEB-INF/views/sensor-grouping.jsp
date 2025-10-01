<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="common/include_head.jsp" flush="true"/>
    <style>
        h3.txt {
            margin: 0;
            width: 15rem;
        }

        .contents_header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .search-top {
            position: static;
        }

        .btn-group {
            position: static;
        }

        #contents .contents-re {
            position: static;
        }

        .search-top-label {
            color: #ffffff76;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            padding: 1rem;
        }

        #contents .contents-re {
            padding: 3rem;
            width: 40rem;
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

        .search-top {
            align-items: center;
            flex-wrap: wrap;
            gap: 0.5rem
        }

        .search-top > div {
            display: flex;
            flex-direction: row;
        }

        .search-top div:nth-child(2) > p {
            margin-right: 1rem;
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

        #district-select {
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
    </style>
    <script type="text/javascript" src="/jqgrid.js"></script>
    <script>
        $(function () {
            const $districtSelect = $('#district-select');

            const $grid = $("#jq-grid");
            const path = "/sensor-grouping";
            initGrid($grid, path, $('#grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                custom: {
                    useFilterToolbar: true,
                    multiSelect: true,
                }
            }, null, {
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
            }, {maint_sts_cd: "MTN001:정상;MTN002:망실;MTN003:점검;MTN004:철거"});

            // const currentYear = new Date().getFullYear();
            //
            // const startDate = new Date(currentYear, 0, 1, 23, 59); // 0은 1월
            // $('#start-date').val(startDate.toISOString().slice(0, 16)); // ISO 형식으로 설정
            //
            // const endDate = new Date(currentYear, 11, 31, 23, 59); // 11은 12월
            // $('#end-date').val(endDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

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
            startDate.setMonth(startDate.getMonth() - 1);
            startDate.setHours(0, 0, 0, 0);

            $('#start-date').val(formatLocalDateTime(startDate));
            $('#end-date').val(formatLocalDateTime(endDate));

            const chartDataArray = []; // 모든 데이터를 저장할 배열 추가

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
                $grid.setGridParam({
                    page: 1,
                    postData: {
                        ...$grid.jqGrid('getGridParam', 'postData'),
                        district_no: value
                    }
                }).trigger('reloadGrid', [{page: 1}]);
            });

            $("#graph-search-btn").click(() => {
                let checkedData = getSelectedCheckData($grid);
                if (checkedData.length === 0) {
                    alert('선택된 데이터가 없습니다.');
                    return;
                } else if ($('#start-date').val() === '' || $('#end-date').val() === '') {
                    alert('조회기간을 입력해주세요.');
                    return;
                } else {
                    const case_ = ['', 'X', 'Y', 'Z'];

                    checkedData = case_.flatMap((item) => {
                        return checkedData.map((data) => {
                            return {
                                ...data,
                                sens_chnl_id: item
                            };
                        });
                    });

                    const startDateTime = $('#start-date').val();
                    const endDateTime = $('#end-date').val();

                    chartDataArray.length = 0; // 배열 초기화
                    const requests = checkedData.map((item) => {
                        return getChartData(item.sens_no, startDateTime, endDateTime, item.sens_chnl_id);
                    });

                    Promise.all(requests).then((d) => {
                        updateChart(chartDataArray.filter((item) => item.length > 0));
                    }).catch((e) => {
                        console.log('error', e);
                        alert('조회할 수 없는 데이터 입니다.');
                    });
                }
            });

            function getChartData(sens_no, startDateTime, endDateTime, sensChnlId) {
                return new Promise((resolve, reject) => {
                    $.ajax({
                        url: '/sensor-grouping/chart' + '?sens_no=' + sens_no + '&start_date_time=' + startDateTime + '&end_date_time=' + endDateTime + "&sens_chnl_id=" + sensChnlId,
                        type: 'GET',
                        success: function (res) {
                            if (res) {
                                if (res[0]) {
                                    res[0].sens_chnl_id = sensChnlId // 채널 ID 추가
                                }
                                chartDataArray.push(res); // 데이터 추가
                            }
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
                    maintainAspectRatio: false, // 비율을 유지하지 않음 (높이 채우기)
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
                            type: 'time',
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
                            beginAtZero: true, // 0에서 시작
                            ticks: {
                                autoSkip: false // 모든 눈금을 표시
                            }
                        }
                    }
                }
            });


            function getRandomHSL() {
                const hue = Math.floor(Math.random() * 360); // 0~359 범위의 색상
                const saturation = 100; // 채도 고정
                const lightness = 50; // 밝기 고정
                return 'hsl(' + hue + ', ' + saturation + '%, ' + lightness + '%)';
            }

            function updateChart(data) {
                myChart.resetZoom(); // 차트 줌 초기화

                // --- X축 시간 단위 동적 결정 로직 시작 ---
                let xUnit = 'hour'; // 기본값은 '시(hour)'
                let displayFormats = {
                    minute: 'YYYY-MM-DD HH:mm', // 분 단위 표시 형식
                    hour: 'YYYY-MM-DD HH:00',   // 시 단위 표시 형식
                    day: 'YYYY-MM-DD',          // 일 단위 표시 형식
                    month: 'YYYY-MM'            // 월 단위 표시 형식 추가
                };

                // 모든 센서 데이터 중 가장 빠른 날짜와 가장 늦은 날짜를 찾아 전체 데이터 기간을 계산
                let minDate = Infinity;
                let maxDate = -Infinity;

                data.forEach(sensorData => {
                    if (sensorData && sensorData.length > 0) {
                        sensorData.forEach(point => {
                            if (point.meas_dt) {
                                const date = new Date(point.meas_dt).getTime();
                                if (date < minDate) minDate = date;
                                if (date > maxDate) maxDate = date;
                            }
                        });
                    }
                });

                if (minDate !== Infinity && maxDate !== -Infinity) {
                    const firstDate = new Date(minDate);
                    const lastDate = new Date(maxDate);
                    const diffDays = Math.abs(lastDate - firstDate) / (1000 * 60 * 60 * 24); // 일수 차이 계산

                    if (diffDays > 90) { // 3개월 이상이면 '월' 단위로
                        xUnit = 'month';
                    } else if (diffDays > 30) { // 한 달 이상이면 '일' 단위로
                        xUnit = 'day';
                    } else if (diffDays > 1) { // 하루 이상이면 '시' 단위로
                        xUnit = 'hour';
                    } else { // 그 외 (하루 이내)는 '분' 단위로
                        xUnit = 'minute';
                    }
                }

                // 차트의 X축 시간 단위를 업데이트합니다.
                myChart.options.scales.x.time.unit = xUnit;
                myChart.options.scales.x.time.displayFormats = displayFormats;
                // 어댑터 설정 (필요시)
                if (!myChart.options.scales.x.adapters) {
                    myChart.options.scales.x.adapters = {};
                }
                if (!myChart.options.scales.x.adapters.date) {
                    myChart.options.scales.x.adapters.date = {};
                }
                // --- X축 시간 단위 동적 결정 로직 끝 ---

                // 데이터셋 구성
                const datasets = data.map(function(sensorItem) { // 화살표 함수 대신 function 키워드 사용
                    // 각 센서의 데이터를 {x: Date객체, y: 값} 형태로 변환
                    const formattedData = sensorItem.map(function(point) { // 화살표 함수 대신 function 키워드 사용
                        return {
                            x: new Date(point.meas_dt), // X축은 Date 객체
                            y: point.formul_data // Y축은 계측 값
                        };
                    });

                    return {
                        label: sensorItem[0].sens_nm + (sensorItem[0].sens_chnl_id ? "-" + sensorItem[0].sens_chnl_id : ""),
                        data: formattedData,
                        borderColor: getRandomHSL(),
                        fill: false,
                        pointRadius: 0,
                        borderWidth: 1,
                    };
                });

                // Chart.js의 time 스케일은 labels 배열이 필수는 아니므로 빈 배열로 둡니다.
                myChart.data.labels = [];
                myChart.data.datasets = datasets;
                myChart.options.plugins.annotation.annotations = {}; // 기존 annotation 초기화

                // --- 상한선(annotation) 추가 로직 시작 ---
                data.forEach(function(sensorItem) { // 화살표 함수 대신 function 키워드 사용
                    const colors = ['#EFDDCB', '#CBEFD8', '#F0DD7F', '#A3B4ED'];
                    const maxLevels = [
                        parseFloat(sensorItem[0].lvl_max1),
                        parseFloat(sensorItem[0].lvl_max2),
                        parseFloat(sensorItem[0].lvl_max3),
                        parseFloat(sensorItem[0].lvl_max4)
                    ];

                    maxLevels.forEach(function(maxLevel, index) { // 화살표 함수 대신 function 키워드 사용
                        if (!isNaN(maxLevel)) {
                            // 라인 annotation (각 센서 및 채널별 고유 ID 부여)
                            // ID는 각 annotation이 고유하게 식별되도록 충분히 상세하게 만듭니다.
                            const annotationId = 'line-' + sensorItem[0].sens_no + '-' + (sensorItem[0].sens_chnl_id || 'none') + '-' + index;
                            myChart.options.plugins.annotation.annotations[annotationId] = {
                                type: 'line',
                                yMin: maxLevel,
                                yMax: maxLevel,
                                borderColor: colors[index],
                                borderWidth: 1.5,
                                borderDash: [5, 4]
                            };

                            // 라벨 annotation (각 센서 및 채널별 고유 ID 부여)
                            const labelAnnotationId = 'label-' + sensorItem[0].sens_no + '-' + (sensorItem[0].sens_chnl_id || 'none') + '-' + index;
                            // 라벨 위치는 해당 센서 데이터의 첫 번째 측정 시간을 기준으로 하거나, 전체 데이터의 최소 시간을 기준으로 합니다.
                            const labelXValue = sensorItem[0].meas_dt ? new Date(sensorItem[0].meas_dt).getTime() : minDate;

                            myChart.options.plugins.annotation.annotations[labelAnnotationId] = {
                                type: 'label',
                                xValue: labelXValue,
                                yValue: maxLevel,
                                backgroundColor: colors[index],
                                content: [sensorItem[0].sens_nm + (sensorItem[0].sens_chnl_id ? "-" + sensorItem[0].sens_chnl_id : "") + ' ' + (Number(index) + 1) + '차 경고'],
                                font: {
                                    size: 8
                                },
                                // 여러 라벨이 겹치지 않도록 Y축 위치를 약간 조정할 수 있습니다 (필요시 활성화)
                                // yAdjust: (index * 5)
                            };
                        }
                    });
                });
                // --- 상한선(annotation) 추가 로직 끝 ---

                myChart.update(); // 차트 업데이트
            }

        });
    </script>
</head>
<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="common/include_top.jsp" flush="true"/>
    <div id="global-menu">
        <jsp:include page="common/include_sidebar.jsp" flush="true"/>
    </div>
    <div id="container">
        <h2 class="txt">센서 모니터링</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">센서 그룹핑 분석</h3>
                <div class="btn-group">
                    <p class="search-top-label">현장명</p>
                    <select id="district-select">
                        <option value="">선택</option>
                    </select>
                </div>
                <div id="grid-wrapper" class="contents-in">
                    <table id="jq-grid"></table>
                </div>
            </div>

            <div class="contents-re cctv_area">
                <div class="contents_header">
                    <h3 class="txt">그룹핑 차트</h3>
                    <div class="filter-area">
                        <div class="search-top">
                            <div>
                                <p class="search-top-label">조회기간</p>
                                <input id="start-date" type="datetime-local"/>
                            </div>
                            <div>
                                <p class="search-top-label">~</p>
                                <input id="end-date" type="datetime-local"/>
                            </div>
                            <div class="btn-group">
                                <a id="graph-search-btn" data-fancybox data-src="">조회</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <div class="graph-area" style="height: 100%;">
                        <canvas id="myChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
</body>
</html>
