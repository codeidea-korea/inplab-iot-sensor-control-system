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

        .search-top-label {
            color: #ffffff76;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            padding: 1rem;
        }
    </style>
    <script type="text/javascript" src="/jqgrid.js"></script>
    <script>
        $(function () {
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
                useFilterToolbar: true,
            }, () => {
                const allRowIds = $leftGrid.jqGrid('getDataIDs');
                allRowIds.forEach(rowId => {
                    $leftGrid.jqGrid('setCell', rowId, 'district_nm', $('#district-select option:selected').text());
                });
            })

            const $rightGrid = $("#right-jq-grid");
            const rightPath = "/measure-details-data"
            initGrid($rightGrid, rightPath, $('#right-grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                useFilterToolbar: true,
            })

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
                if (targetArr.length > 1) {
                    alert('조회할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length === 0) {
                    alert('조회할 데이터를 선택해주세요.');
                    return;
                } else {
                    $rightGrid.setGridParam({
                        page: 1,
                        postData: {
                            ...$rightGrid.jqGrid('getGridParam', 'postData'),
                            sens_no: targetArr[0].sens_no
                        }
                    }).trigger('reloadGrid', [{page: 1}]);
                    $("#district_nm").text($('#district-select option:selected').text());
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
                const targetArr = getSelectedCheckData($leftGrid);
                if (targetArr.length > 1) {
                    alert('조회할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length === 0) {
                    alert('조회할 데이터를 선택해주세요.');
                    return;
                }
                popFancy('#chart-popup')
                setChartModal(targetArr[0].district_nm, targetArr[0].senstype_no, targetArr[0].sens_no)
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
                        $("#chart-district-select option").filter(function() {
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
                $("#sensor-name-select option").filter(function() {
                    return $(this).text().includes(sens_no);
                }).prop('selected', true);
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

            $("#graph-search-btn").click(() => {
                const startDateTime = $('#start-date').val();
                const endDateTime = $('#end-date').val();
                const popupSensorNo = $("#sensor-name-select").val();
                chartDataArray.length = 0; // 배열 초기화

                const targetArr = getSelectedCheckData($leftGrid);

                const requests = targetArr.map((item) => {
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
                        x: { type: "category" },
                        y: { beginAtZero: true }
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
                        processedData[key] = { min: Infinity, max: -Infinity };
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

                return { labels, ranges };
            }

            function updateChart(data) {
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
                    label: item[0].sens_nm, // 센서 이름
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
                myBarChart.update();
            }
        });
    </script>
    <script>
        $(function () {
            const $leftGrid = $("#left-jq-grid");
            const $rightGrid = $("#right-jq-grid");

            $('#add-row').click(() => {
                const selectedSensor = getSelectedCheckData($leftGrid);
                if (selectedSensor.length === 0) {
                    alert('센서를 선택해주세요.');
                    return;
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

                const reader = new FileReader();
                reader.onload = function (event) {
                    const data = new Uint8Array(event.target.result);
                    const workbook = XLSX.read(data, {type: 'array'});


                    // 첫 번째 시트의 데이터를 JSON 형태로 변환
                    const sheetName = workbook.SheetNames[0];  // 첫 번째 시트 이름 가져오기
                    const sheet = workbook.Sheets[sheetName];
                    let jsonData = XLSX.utils.sheet_to_json(sheet);

                    jsonData.forEach((item) => {
                        var parts = item['계측일시'].split(" ");
                        var date = parts[0];
                        var time = parts[1].replace(/:/g, '-'); // ':'를 '-'로 대체

                        item.meas_dt = date + '-' + time;
                        item.raw_data = item['Raw Data'];
                        item.formul_data = item['보정(Deg)'];
                        item.raw_data_x = item['Raw Data(X)'];
                        item.formul_data_x = item['X 보정(Deg)'];
                        item.raw_data_y = item['Raw Data(Y)'];
                        item.formul_data_y = item['Y 보정(Deg)'];
                        item.raw_data_z = item['Raw Data(Z)'];
                        item.formul_data_z = item['Z 보정(Deg)'];

                        // 숫자형 데이터 파싱 (빈 값은 0.0으로 처리)
                        item.raw_data = parseFloat(item['Raw Data']) || 0.0;
                        item.formul_data = parseFloat(item['보정(Deg)']) || 0.0;
                        item.raw_data_x = parseFloat(item['Raw Data(X)']) || 0.0;
                        item.formul_data_x = parseFloat(item['X 보정(Deg)']) || 0.0;
                        item.raw_data_y = parseFloat(item['Raw Data(Y)']) || 0.0;
                        item.formul_data_y = parseFloat(item['Y 보정(Deg)']) || 0.0;
                        item.raw_data_z = parseFloat(item['Raw Data(Z)']) || 0.0;
                        item.formul_data_z = parseFloat(item['Z 보정(Deg)']) || 0.0;


                        delete item['계측일시'];
                        delete item['Raw Data'];
                        delete item['보정(Deg)'];
                        delete item['Raw Data(X)'];
                        delete item['X 보정(Deg)'];
                        delete item['Raw Data(Y)'];
                        delete item['Y 보정(Deg)'];
                        delete item['Raw Data(Z)'];
                        delete item['Z 보정(Deg)'];
                        delete item['__EMPTY'];
                        delete item['__EMPTY_1'];
                        delete item['__EMPTY_2'];
                    });

                    const selectedRow = getSelectedCheckData($leftGrid);

                    $.ajax({
                        method: 'POST',
                        url: '/measure-details-data/excel',
                        contentType: 'application/json',  // JSON 형식으로 전송
                        data: JSON.stringify({jsonData, sensNo: selectedRow[0].sens_no}),  // JSON 데이터 직렬화
                        dataType: 'json',
                        success: function (res) {
                            alert('저장되었습니다.');
                            $rightGrid.trigger('reloadGrid');
                        },
                        error: function () {
                            alert('입력값을 확인해 주세요.');
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
    <div id="container">
        <h2 class="txt">관리자 전용
            <span class="arr">데이터 관리</span>
            <span class="arr">계측기 데이터 관리</span>
        </h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">센서 계측 현황</h3>
                <div class="btn-group">
                    <p class="search-top-label">현장명</p>
                    <select id="district-select">
                        <option value="">선택</option>
                    </select>
                    <a id="search-btn">조회</a>
                </div>
                <div id="left-grid-wrapper" class="contents-in">
                    <table id="left-jq-grid"></table>
                </div>
            </div>

            <div class="contents-re cctv_area">
                <div class="contents_header">
                    <h3 class="txt">데이터값 수정</h3>
                    <div class="btn-group-2" style="display: flex; gap: 2px; margin-right: auto">
                        <a id="district_nm">현장명</a>
                        <a id="sens_tp_nm">센서타입</a>
                        <a id="sens_nm">센서명</a>
                    </div>
                    <div class="search-btn-wrapper" style="display: flex">
                        <a id="add-row">행추가</a>
                        <a id="del-row">행삭제</a>
                        <a id="save-button">저장</a>
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
`