<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
    </style>
</head>

<script>
    $(function () {
        const currentYear = new Date().getFullYear();

        const startDate = new Date(currentYear, 0, 1); // 0은 1월
        $('#start-date').val(startDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

        const endDate = new Date(currentYear, 11, 31, 23, 59); // 11은 12월
        $('#end-date').val(endDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

        const $grpGrid = $("#sensor-grouping-grid");
        const chartDataArray = []; // 모든 데이터를 저장할 배열 추가

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
            setGridData();
            $grpGrid.trigger('reloadGrid');
        });

        function setGridData() {
            $grpGrid.setGridParam({
                postData: {
                    ...$grpGrid.jqGrid('getGridParam', 'postData'),
                    district_no: $('#district-no').val()
                }
            }, true);
        }

        $("#graph-search-btn").click(() => {
            const checkedData = getSelectedCheckData($grpGrid);
            if (checkedData.length === 0) {
                alert('선택된 데이터가 없습니다.');
                return;
            } else if ($('#start-date').val() === '' || $('#end-date').val() === '') {
                alert('조회기간을 입력해주세요.');
                return;
            } else {
                const startDateTime = $('#start-date').val();
                const endDateTime = $('#end-date').val();
                chartDataArray.length = 0; // 배열 초기화
                const requests = checkedData.map((item) => {
                    return getChartData(item.sens_no, startDateTime, endDateTime);
                });

                // 모든 요청이 완료된 후 차트를 그립니다.
                Promise.all(requests).then(() => {
                    updateChart(chartDataArray); // 차트 업데이트 함수 호출
                }).catch(() => {
                    alert('데이터를 가져오는 중 오류가 발생했습니다.');
                });
            }
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
            type: 'line', // 차트 종류 (예: 'line', 'bar' 등)
            data: {
                labels: [], // 초기 레이블
                datasets: [] // 초기 데이터셋
            },
            options: {
                responsive: true,
                // 기타 옵션
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
        <h2 class="txt">센서 모니터링</h2>
        <div id="contents">
            <div class="contents-re" style="width: 40%">
                <div class="contents_header">
                    <h3 class="txt">센서 그룹핑 분석</h3>
                    <div class="search-top">
                        <p class="search-top-label">현장명</p>
                        <select id="district-no">
                            <option value="">선택</option>
                        </select>
                    </div>
                </div>
                <div class="contents-in">
                    <div class="bTable">
                        <jsp:include page="sensor-grouping-grid.jsp" flush="true"></jsp:include>
                    </div>
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
<%--                            <div class="">--%>
<%--                                <p class="search-top-label">조회조건</p>--%>
<%--                                <select name="selectFilter" id="dateSelect">--%>
<%--                                    <option value="">상세</option>--%>
<%--                                    <option value="">일별</option>--%>
<%--                                    <option value="">시간별</option>--%>
<%--                                </select>--%>
<%--                            </div>--%>
                            <div class="btn-group">
                                <a id="graph-search-btn" data-fancybox data-src="">조회</a>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="contents-in">
                    <div class="graph-area">
                        <canvas id="myChart"></canvas>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <!--[e] 컨텐츠 영역 -->

</section>
</body>
</html>
