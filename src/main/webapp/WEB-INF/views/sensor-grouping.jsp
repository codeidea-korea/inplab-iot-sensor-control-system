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
                useFilterToolbar: true,
            })

            const currentYear = new Date().getFullYear();

            const startDate = new Date(currentYear, 0, 1, 23, 59); // 0은 1월
            $('#start-date').val(startDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

            const endDate = new Date(currentYear, 11, 31, 23, 59); // 11은 12월
            $('#end-date').val(endDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

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
                myChart.resetZoom();

                const allLabels = [];
                const labelIndexMap = {};
                const datasets = [];

                data.forEach((item) => {
                    item.forEach((subItem) => {
                        const date = new Date(subItem.meas_dt);
                        const label = date.getFullYear() + '-' +
                            (date.getMonth() + 1).toString().padStart(2, '0') + ' ' +
                            date.getDate().toString().padStart(2, '0') + ' ' +
                            date.getHours().toString().padStart(2, '0') + ':' +
                            date.getMinutes().toString().padStart(2, '0') + ':' +
                            date.getSeconds().toString().padStart(2, '0');

                        if (!labelIndexMap[label]) {
                            labelIndexMap[label] = allLabels.length; // 인덱스 저장
                            allLabels.push(label); // 중복 없는 레이블 추가
                        }
                    });
                });

                data.forEach((item, index) => {
                    const mappedData = Array(allLabels.length).fill(null); // 모든 값을 null로 초기화

                    item.forEach((subItem) => {
                        const date = new Date(subItem.meas_dt);
                        const label = date.getFullYear() + '-' +
                            (date.getMonth() + 1).toString().padStart(2, '0') + ' ' +
                            date.getDate().toString().padStart(2, '0') + ' ' +
                            date.getHours().toString().padStart(2, '0') + ':' +
                            date.getMinutes().toString().padStart(2, '0') + ':' +
                            date.getSeconds().toString().padStart(2, '0');

                        const labelIndex = labelIndexMap[label];
                        if (labelIndex !== undefined) {
                            mappedData[labelIndex] = subItem.formul_data; // 데이터 매핑
                        }
                    });

                    datasets.push({
                        label: item[0].sens_nm + (item[0].sens_chnl_id ? "-" + item[0].sens_chnl_id : ""),
                        data: mappedData,
                        borderColor: getRandomHSL(),
                        fill: false,
                        pointRadius: 0,
                        borderWidth: 1,
                    });
                });

                myChart.data.labels = allLabels;
                myChart.data.datasets = datasets;
                myChart.options.plugins.annotation.annotations = {};

                data.forEach((item) => {
                    const colors = ['#EFDDCB', '#CBEFD8', '#F0DD7F', '#A3B4ED'];
                    const maxLevels = [
                        parseFloat(item[0].lvl_max1),
                        parseFloat(item[0].lvl_max2),
                        parseFloat(item[0].lvl_max3),
                        parseFloat(item[0].lvl_max4)
                    ];

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
                        }
                    });
                });
                myChart.update();
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
