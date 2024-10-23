`<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>
    <style>
        h3.txt {
            margin: 0;
            width: 15rem;
        }

        .contents_header {
            display: flex;
            align-items: center;
            /*justify-content: space-between;*/
        }

        .search-top {
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
            height: auto;
            padding: 3rem;
            margin-top: 3rem;
        }

        .filter-area .select_filter .search-top-label {
            padding: 0;
        }

        .cctv_area .contents-in {
            height: auto !important;
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

        .contents_header {
            display: flex;
            align-items: center;
            justify-content: space-between;
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

        .search-top-label {
            color: #ffffff76;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            padding: 1rem;
        }
    </style>
</head>

<script>
    $(function () {
        const $grpGrid = $("#measure-details-grid");
        const $detailsGrid = $("#measure-details-data-grid");

        $.ajax({
            url: '/adminAdd/districtInfo/all',
            type: 'GET',
            success: function (res) {
                res.forEach((item) => {
                    $('#district-no').append(
                        "<option value='" + item.district_no + "'>" + item.district_nm + "</option>"
                    );
                });
            },
            error: function () {
                alert('알 수 없는 오류가 발생했습니다.');
            }
        });

        $("#district-no").on('change', function () {
            $grpGrid.setGridParam({
                postData: {
                    ...$grpGrid.jqGrid('getGridParam', 'postData'),
                    district_no: $('#district-no').val()
                }
            }, true);
            $grpGrid.trigger('reloadGrid');
        });

        $("#search-btn").on('click', function () {
            const targetArr = getSelectedCheckData($grpGrid);
            if (targetArr.length > 1) {
                alert('조회할 데이터를 1건만 선택해주세요.');
                return;
            } else if (targetArr.length === 0) {
                alert('조회할 데이터를 선택해주세요.');
                return;
            } else {
                $detailsGrid.setGridParam({
                    postData: {
                        ...$detailsGrid.jqGrid('getGridParam', 'postData'),
                        sens_no: targetArr[0].sens_no
                    }
                }, true);
                $detailsGrid.trigger('reloadGrid');
                $("#district_nm").text($('#district-no option:selected').text());
                $("#sens_tp_nm").text(targetArr[0].sens_tp_nm);
                $("#sens_nm").text(targetArr[0].sens_nm);
            }
        });

        const currentYear = new Date().getFullYear();

        const startDate = new Date(currentYear, 0, 1); // 0은 1월
        $('#start-date').val(startDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

        const endDate = new Date(currentYear, 11, 31, 23, 59); // 11은 12월
        $('#end-date').val(endDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

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

        $("#view-chart").click(() => {
            const targetArr = getSelectedCheckData($grpGrid);
            if (targetArr.length > 1) {
                alert('조회할 데이터를 1건만 선택해주세요.');
                return;
            } else if (targetArr.length === 0) {
                alert('조회할 데이터를 선택해주세요.');
                return;
            }
            popFancy('#chart-popup')
            $("#graph-search-btn").trigger('click');
        });

        const chartDataArray = []; // 모든 데이터를 저장할 배열 추가

        $("#graph-search-btn").click(() => {
            const startDateTime = $('#start-date').val();
            const endDateTime = $('#end-date').val();
            chartDataArray.length = 0; // 배열 초기화

            const targetArr = getSelectedCheckData($grpGrid);

            const requests = targetArr.map((item) => {
                let sensChnlId = ''
                if (item.sens_chnl_nm) {
                    sensChnlId = item.sens_chnl_nm.slice(-1)
                }
                return getChartData(item.sens_no, startDateTime, endDateTime, sensChnlId);
            });

            // 모든 요청이 완료된 후 차트를 그립니다.
            Promise.all(requests).then(() => {
                updateChart(chartDataArray); // 차트 업데이트 함수 호출
            }).catch(() => {
                alert('데이터를 가져오는 중 오류가 발생했습니다.');
            });
        });

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

        function getRandomHSL() {
            const hue = Math.floor(Math.random() * 360); // 0~359 범위의 색상
            const saturation = 100; // 채도 고정
            const lightness = 50; // 밝기 고정
            return 'hsl(' + hue + ', ' + saturation + '%, ' + lightness + '%)';
        }

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
                borderColor: getRandomHSL(),
                fill: false,
                pointRadius: 0, // 꼭지점 원 크기 제거
                borderWidth: 1, // 선 두께 줄이기
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


<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="common/include_top.jsp" flush="true"></jsp:include>
    <div id="global-menu">
        <jsp:include page="common/include_sidebar.jsp" flush="true"></jsp:include>
    </div>

    <!--[s] 컨텐츠 영역 -->
    <div id="container">
        <h2 class="txt">
            관리자 전용
            <span class="arr">데이터 관리</span>
            <span class="arr">계측기 데이터 관리</span>
        </h2>
        <div id="contents">
            <div class="contents-re" style="width: 40%">
                <div class="contents_header">
                    <h3 class="txt">센서 계측 현황</h3>
                    <div class="search-top">
                        <p class="search-top-label">현장명</p>
                        <select id="district-no">
                            <option value="">선택</option>
                        </select>
                        <div class="search-btn-wrapper">
                            <a id="search-btn">조회</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <div class="bTable">
                        <jsp:include page="./measure-details-grid.jsp" flush="true"/>
                    </div>
                </div>
            </div>

            <div class="contents-re cctv_area">
                <div class="contents_header">
                    <h3 class="txt">데이터값 수정</h3>
                    <div class="btn-group-2" style="display: flex; gap: 2px; align-items: start">
                        <a id="district_nm">현장명</a>
                        <a id="sens_tp_nm">센서타입</a>
                        <a id="sens_nm">센서명</a>
                    </div>
                    <div class="search-btn-wrapper" style="margin-left: auto">
                        <a id="view-chart">차트조회</a>
                    </div>
                </div>

                <div class="contents-in">
                    <div class="bTable">
                        <jsp:include page="./measure-details-data-grid.jsp" flush="true"/>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!--[e] 컨텐츠 영역 -->
    <div id="chart-popup" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_full.png" data-fancybox-full alt="전체화면"></a>
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="contents_header" style="margin-bottom: 10px">
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
`