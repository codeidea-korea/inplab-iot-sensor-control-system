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

        /* 컨테이너는 그대로 풀 화면 채우기 */
        html, body, #wrap, #container { height: 100%; }

        #contents {
            display: flex;
            gap: 2rem;                 /* 패널 간 간격 */
            align-items: stretch;
            height: calc(100vh - 160px);
            min-height: 0;
            flex-wrap: nowrap;         /* 줄바꿈 방지 */
            overflow-x: hidden;        /* 가로 넘침 방지(필요시 auto) */

            /* 비율 조절용 커스텀 프로퍼티 (여기만 바꾸면 비율 변경 가능) */
            --left-grow: 3;            /* 왼쪽 가중치 */
            --right-grow: 5;           /* 오른쪽 가중치 */
        }

        /* 공통: width 고정 제거 + flex 컬럼 + 수축 허용 */
        #contents > .contents-re {
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            min-height: 0;
            min-width: 0;              /* flex 아이템이 내용 때문에 밀리지 않게 */
            /* 기존에 있던 width: 40rem 같은 고정폭 규칙이 아래로 내려오지 않도록 제거/덮어쓰기 */
            width: auto !important;
            max-width: none !important;
        }

        /* 왼쪽 패널: 전체 너비 중 3 비율 */
        #contents > .contents-re:first-child {
            flex: var(--left-grow) 1 0;  /* grow 3, shrink 1, basis 0 */
        }

        /* 오른쪽 패널: 전체 너비 중 5 비율 */
        #contents > .contents-re.cctv_area {
            flex: var(--right-grow) 1 0; /* grow 5, shrink 1, basis 0 */
        }

        /* 내부 컨텐츠가 남은 높이를 꽉 채우도록 */
        #contents .contents-in {
            flex: 1 1 auto;
            min-height: 0;
            overflow: hidden;          /* 스크롤 필요하면 auto */
        }

        /* 차트 영역 100% 채움 */
        .cctv_area .graph-area { width: 100%; height: 100%; }
        #myChart { width: 100% !important; height: 100% !important; display: block; }

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

            function getRandomHSL() {
                const hue = Math.floor(Math.random() * 360); // 0~359 범위의 색상
                const saturation = 100; // 채도 고정
                const lightness = 50; // 밝기 고정
                return 'hsl(' + hue + ', ' + saturation + '%, ' + lightness + '%)';
            }

            let chartInstance = null;
            let isUpdating = false;

            async function updateChart(data) {
                if (isUpdating) return;
                isUpdating = true;

                try {
                    const existing = Chart.getChart("myChart");
                    if (existing) {
                        existing.destroy();
                        await Promise.resolve();
                    }

                    let xUnit = 'hour';
                    const displayFormats = {
                        minute: 'YYYY-MM-DD HH:mm',
                        hour:   'YYYY-MM-DD HH:00',
                        day:    'YYYY-MM-DD',
                        month:  'YYYY-MM'
                    };

                    let minDate = Infinity, maxDate = -Infinity;
                    data.forEach(sensorData => {
                        if (sensorData && sensorData.length > 0) {
                            sensorData.forEach(point => {
                                if (point.meas_dt) {
                                    const t = new Date(point.meas_dt).getTime();
                                    if (t < minDate) minDate = t;
                                    if (t > maxDate) maxDate = t;
                                }
                            });
                        }
                    });

                    if (minDate !== Infinity && maxDate !== -Infinity) {
                        const diffDays = (maxDate - minDate) / (1000 * 60 * 60 * 24);
                        if (diffDays > 90) xUnit = 'month';
                        else if (diffDays > 30) xUnit = 'day';
                        else if (diffDays > 1) xUnit = 'hour';
                        else xUnit = 'minute';
                    }

                    const scales = {
                        x: {
                            type: 'time',
                            time: { unit: xUnit, displayFormats },
                            grid: { display: true },
                            ticks: { display: true },
                            title: { display: true, text: 'Time' }
                        }
                    };

                    const datasets = [];

                    data.forEach((sensorItem, i) => {
                        const yId = 'y' + i;
                        const color = getRandomHSL();
                        const labelText = sensorItem[0].sens_nm +
                            (sensorItem[0].sens_chnl_id ? '-' + sensorItem[0].sens_chnl_id : '');

                        scales[yId] = {
                            id: yId,
                            type: 'linear',
                            position: 'left',
                            beginAtZero: true,
                            display: true,
                            grid: {
                                drawOnChartArea: i === 0,
                                color: 'rgba(0,0,0,0.05)',
                            },
                            border: { color, width: 1 },
                            ticks: {
                                color,
                                font: { size: 10 },
                                callback: v => Number(v.toFixed(1))
                            },
                            title: {
                                display: true,
                                text: labelText,
                                color,
                                font: { size: 10 }
                            },
                            afterFit: scale => {
                                const baseLeft = 10;
                                const spacing = 50;
                                scale.left = baseLeft + (i * spacing);
                                scale.width = 40;
                            }
                        };

                        /* 강우량계는 막대그래프로 표현 */
                        const isRain = sensorItem[0].sens_nm.includes('RAIN');

                        datasets.push({
                            label: labelText,
                            type: isRain ? 'bar' : 'line',
                            data: sensorItem.map(p => ({
                                x: new Date(p.meas_dt),
                                y: p.formul_data
                            })),
                            borderColor: color,
                            backgroundColor: color,
                            fill: false,
                            pointRadius: 0,
                            borderWidth: isRain ? 0 : 1,
                            barThickness: isRain ? 8 : undefined,
                            xAxisID: 'x',
                            yAxisID: yId
                        });
                    });

                    const ctx = document.getElementById('myChart').getContext('2d');
                    chartInstance = new Chart(ctx, {
                        type: 'line',
                        data: { datasets },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales,
                            plugins: {
                                legend: { display: true },
                                zoom: {
                                    pan: { enabled: true, mode: 'xy' },
                                    zoom: {
                                        drag: {
                                            enabled: true,
                                            backgroundColor: 'rgba(0, 0, 0, 0.1)',
                                        },
                                        wheel: { enabled: true },
                                        mode: 'xy'
                                    }
                                },
                                annotation: { annotations: buildAnnotations(data, minDate) }
                            }
                        }
                    });

                } catch (err) {
                    console.error("Chart update failed:", err);
                } finally {
                    isUpdating = false;
                }
            }

            // --- 별도 함수로 분리: annotation 생성 ---
            function buildAnnotations(data, minDate) {
                const annotations = {};
                data.forEach((sensorItem, i) => {
                    const colors = ['#EFDDCB', '#CBEFD8', '#F0DD7F', '#A3B4ED'];
                    const maxLevels = [
                        parseFloat(sensorItem[0].lvl_max1),
                        parseFloat(sensorItem[0].lvl_max2),
                        parseFloat(sensorItem[0].lvl_max3),
                        parseFloat(sensorItem[0].lvl_max4)
                    ];
                    const firstTs = sensorItem[0]?.meas_dt
                        ? new Date(sensorItem[0].meas_dt).getTime()
                        : minDate;

                    maxLevels.forEach((maxLevel, idx) => {
                        if (isNaN(maxLevel)) return;

                        const lineId = `line-${sensorItem[0].sens_no}-${sensorItem[0].sens_chnl_id || 'none'}-${idx}`;
                        annotations[lineId] = {
                            type: 'line',
                            yMin: maxLevel,
                            yMax: maxLevel,
                            borderColor: colors[idx],
                            borderWidth: 1.5,
                            borderDash: [5, 4],
                            yScaleID: 'y' + i
                        };

                        const labelId = `label-${sensorItem[0].sens_no}-${sensorItem[0].sens_chnl_id || 'none'}-${idx}`;
                        annotations[labelId] = {
                            type: 'label',
                            xValue: firstTs,
                            yValue: maxLevel,
                            backgroundColor: colors[idx],
                            content: [
                                sensorItem[0].sens_nm +
                                (sensorItem[0].sens_chnl_id ? '-' + sensorItem[0].sens_chnl_id : '') +
                                ' ' + (idx + 1) + '차 경고'
                            ],
                            font: { size: 8 },
                            xScaleID: 'x',
                            yScaleID: 'y' + i
                        };
                    });
                });
                return annotations;
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
                <h3 class="txt">센서 그룹핑</h3>
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
