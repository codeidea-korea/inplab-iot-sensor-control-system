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
            --left-grow: 2.6;            /* 왼쪽 가중치 */
            --right-grow: 5.4;           /* 오른쪽 가중치 */
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

    </style>
    <script type="text/javascript" src="/jqgrid.js"></script>
    <script>
        $(function () {

            $.when(
                $.get('adminAdd/common/code/sensorType')
            ).done(function(typeRes){


                function makeJqGridSelectByName(list){
                    var str = ':전체';
                    $.each(list, function(i,v){

                        str += ";" + v.name + ":" + v.name;
                    });
                    return str;
                }

                var typeStr = makeJqGridSelectByName(typeRes);


            const $districtSelect = $('#district-select');

            const $grid = $("#jq-grid");
            const path = "/sensor-grouping";


            initGrid($grid, path, $('#grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                custom: {
                    useFilterToolbar: false,
                    multiSelect: true,
                },
                loadComplete : function(){
                    var $grid = $("#jq-grid");
                    if ($grid.data('toolbar_created')) return;


                    $grid.jqGrid('setColProp', 'sens_tp_nm', {
                        stype: 'select',
                        searchoptions: { value: typeStr, sopt: ['eq'] }
                    });


                    $grid.jqGrid('filterToolbar', {
                        stringResult: false,
                        searchOnEnter: true,
                        defaultSearch: "eq",
                        ignoreCase: true

                    });

                    $('.clearsearchclass').off('click').on('click', function () {
                        var $this = $(this);

                        var $inputTd = $this.closest('td').prev('td');
                        var $select = $inputTd.find('select');
                        var $input = $inputTd.find('input');

                        if ($select.length > 0) $select.val('');
                        if ($input.length > 0) $input.val('');

                        $grid[0].triggerToolbar();
                    });


                    $grid.data('toolbar_created', true);
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
                last_apply_dt: {
                    formatter: (cellValue, _options, _rowObject) => {
                        if (cellValue) {
                            const text = moment(cellValue).format("YYYY-MM-DD HH:mm:ss");
                            if(_rowObject.comm_status === '미수신'){
                                return '<span style="color: red">' + text + '</span>';
                            }else{
                                return text;
                            }
                        } else {
                            return "";
                        }
                    }
                }
            }, {maint_sts_cd: "MTN001:정상;MTN002:망실;MTN003:점검;MTN004:철거"});

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

            const isVisibleAlarmLevel = (value) => Number.isFinite(value) && Math.abs(value) !== 10000;
            const chartDataArray = []; // 모든 데이터를 저장할 배열 추가
            const groupAlarmLabelOverlayPlugin = {
                id: 'groupAlarmLabelOverlay',
                afterDatasetsDraw(chart, _args, pluginOptions) {
                    const items = (pluginOptions && Array.isArray(pluginOptions.items)) ? pluginOptions.items : [];
                    if (!items.length) return;

                    const xScale = chart.scales.x;
                    const {ctx, chartArea} = chart;
                    if (!xScale || !chartArea) return;

                    ctx.save();
                    ctx.beginPath();
                    ctx.rect(chartArea.left, chartArea.top, chartArea.right - chartArea.left, chartArea.bottom - chartArea.top);
                    ctx.clip();

                    // Draw alarm lines directly in canvas for multi-axis stability (grouping chart).
                    const drawnLineKeys = new Set();
                    items.forEach((item) => {
                        const yScale = chart.scales[item.yScaleID];
                        if (!yScale) return;

                        const y = yScale.getPixelForValue(item.yValue);
                        if (!Number.isFinite(y)) return;

                        const key = String(item.yScaleID) + '|' + Number(item.yValue).toFixed(6) + '|' + (item.borderColor || '');
                        if (drawnLineKeys.has(key)) return;
                        drawnLineKeys.add(key);

                        ctx.save();
                        ctx.strokeStyle = item.borderColor || '#666';
                        ctx.lineWidth = 2;
                        ctx.setLineDash([5, 4]);
                        ctx.beginPath();
                        ctx.moveTo(chartArea.left, y);
                        ctx.lineTo(chartArea.right, y);
                        ctx.stroke();
                        ctx.restore();
                    });

                    ctx.restore();

                    ctx.save();
                    ctx.textBaseline = 'middle';
                    ctx.textAlign = 'left';
                    ctx.font = '10px sans-serif';

                    items.forEach((item) => {
                        const yScale = chart.scales[item.yScaleID];
                        if (!yScale) return;

                        const rawX = Number(item.xValue);
                        const baseX = Number.isFinite(rawX) ? xScale.getPixelForValue(rawX) : chartArea.left;
                        const baseY = yScale.getPixelForValue(item.yValue);
                        if (!Number.isFinite(baseX) || !Number.isFinite(baseY)) return;

                        const xAdjust = Number(item.xAdjust || 0);
                        const yAdjust = Number(item.yAdjust || 0);
                        const lines = Array.isArray(item.content) ? item.content.map(v => String(v)) : [String(item.content ?? '')];
                        const lineHeight = 11;
                        const padX = 4;
                        const padY = 3;
                        const boxWidth = Math.max(...lines.map(line => ctx.measureText(line).width), 0) + padX * 2;
                        const boxHeight = (lines.length * lineHeight) + padY * 2;

                        let x = baseX + xAdjust;
                        let yTop = (baseY + yAdjust) - (boxHeight / 2);

                        x = Math.max(chartArea.left + 2, Math.min(x, chartArea.right - boxWidth - 2));
                        yTop = Math.max(chartArea.top + 2, Math.min(yTop, chartArea.bottom - boxHeight - 2));

                        ctx.fillStyle = item.backgroundColor || 'rgba(255,255,255,0.9)';
                        ctx.fillRect(x, yTop, boxWidth, boxHeight);
                        ctx.strokeStyle = item.borderColor || 'rgba(0,0,0,0.15)';
                        ctx.lineWidth = 0.8;
                        ctx.strokeRect(x, yTop, boxWidth, boxHeight);

                        ctx.fillStyle = '#222';
                        lines.forEach((line, idx) => {
                            ctx.fillText(line, x + padX, yTop + padY + (lineHeight / 2) + (idx * lineHeight));
                        });
                    });

                    ctx.restore();
                }
            };

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

                let selectType = 'hour';
                const conditionVal = $("#select-condition").val();
                if (conditionVal === "minute") {
                    selectType = 'minute';
                } else if (conditionVal === "daily") {
                    selectType = 'day';
                } else if (conditionVal === "hourly") {
                    selectType = 'hour';
                }

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
                        return getChartData(item.sens_no, startDateTime, endDateTime, item.sens_chnl_id, selectType);
                    });

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
                }
            });

            function getChartData(sens_no, startDateTime, endDateTime, sensChnlId, selectType) {
                return new Promise((resolve) => {
                    $.ajax({
                        url: '/sensor-grouping/chart' + '?sens_no=' + sens_no + '&start_date_time=' + startDateTime + '&end_date_time=' + endDateTime + "&sens_chnl_id=" + sensChnlId + "&selectType=" + selectType + "&init_base=raw&measure_base=raw&diff_direction=init_minus_meas&minute_bucket=raw",
                        type: 'GET',
                        success: function (res) {
                            if (Array.isArray(res)) {
                                if (res[0]) {
                                    res[0].sens_chnl_id = sensChnlId // 채널 ID 추가
                                }
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

            function getRandomHSL() {
                const hue = Math.floor(Math.random() * 360); // 0~359 범위의 색상
                const saturation = 100; // 채도 고정
                const lightness = 50; // 밝기 고정
                return 'hsl(' + hue + ', ' + saturation + '%, ' + lightness + '%)';
            }

            let chartInstance = null;
            let isUpdating = false;

            async function updateChart(data) {
                if (data.length === 0) {
                    alert('조회 결과가 존재하지 않습니다.');
                    return;
                }

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

                    const senstypeList = {
                        '013': '구조물경사계',
                        '017': '지표경사계',
                        '016': '지표변위계',
                        '001': '강우량계',
                        '015': 'GPS'
                    };
                    const unitMap = {
                        '구조물경사계': 'mm',
                        '지표경사계': 'mm',
                        '지표변위계': 'mm',
                        '강우량계': 'mm'
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

                    const aggregationType = $("#select-condition").val();
                    if (aggregationType === "hourly") {
                        xUnit = 'hour';
                    } else if (aggregationType === "daily") {
                        xUnit = 'day';
                    } else if (aggregationType === "minute") {
                        xUnit = 'minute';
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

                    const axisMap = {};

                    data.forEach((sensorItem, i) => {
                        const yId = axisMap[sensorItem[0].senstype_no] || 'y' + i;
                        const color = getRandomHSL();
                        const senstype = senstypeList[sensorItem[0].senstype_no] || sensorItem[0].senstype_no;
                        const isRain = sensorItem[0].senstype_no === '001' || (senstype || '').includes('강우');

                        if (!axisMap[sensorItem[0].senstype_no]) {
                            const sameTypeSeries = data.filter(series =>
                                series && series.length > 0 && series[0].senstype_no === sensorItem[0].senstype_no
                            );
                            const vals = sameTypeSeries
                                .flatMap(series => series.map(p => Number(p.formul_data)))
                                .filter(v => Number.isFinite(v));
                            const alarmVals = sameTypeSeries
                                .flatMap(series => ([
                                    Number(series[0].lvl_min1),
                                    Number(series[0].lvl_min2),
                                    Number(series[0].lvl_min3),
                                    Number(series[0].lvl_min4),
                                    Number(series[0].lvl_max1),
                                    Number(series[0].lvl_max2),
                                    Number(series[0].lvl_max3),
                                    Number(series[0].lvl_max4)
                                ]))
                                .filter(isVisibleAlarmLevel);
                            const axisCandidates = [...vals, ...alarmVals, 0];
                            const absMax = Math.max(...axisCandidates.map(v => Math.abs(v || 0)), 0.1);
                            const axisPadding = Math.max(absMax * 0.1, 0.1);
                            let yAxisTitle = senstype;
                            if (unitMap[senstype]) {
                                yAxisTitle = senstype + ' (' + unitMap[senstype] + ')';
                            }

                            scales[yId] = {
                                id: yId,
                                type: 'linear',
                                position: 'left',
                                display: true,
                                grid: {
                                    drawOnChartArea: i === 0,
                                    color: 'rgba(0,0,0,0.05)',
                                },
                                border: { color: '#000', width: 1 },
                                ticks: {
                                    color: '#000',
                                    font: { size: 10 },
                                    callback: v => Number(v.toFixed(2))
                                },
                                title: {
                                    display: true,
                                    text: yAxisTitle,
                                    color: '#000',
                                    font: { size: 10 }
                                },

                                min: isRain ? 0 : -(absMax + axisPadding),
                                max: absMax + axisPadding,

                                grid: {
                                    color: ctx => ctx.tick.value === 0 ? 'rgba(255,0,0,0.6)' : 'rgba(0,0,0,0.05)',
                                    lineWidth: ctx => ctx.tick.value === 0 ? 1.5 : 0.5,
                                    drawOnChartArea: i === 0
                                }
                            };

                            axisMap[sensorItem[0].senstype_no] = yId;
                        }



                        datasets.push({
                            label: sensorItem[0].sens_nm + (sensorItem[0].sens_chnl_id ? "-" + sensorItem[0].sens_chnl_id : ""),
                            type: isRain ? 'bar' : 'line',
                            data: sensorItem.map(p => ({
                                x: new Date(p.meas_dt),
                                y: Number.isFinite(Number(p.formul_data)) ? Number(p.formul_data) : null
                            })),
                            alarmLevels: [
                                Number(sensorItem[0].lvl_min1),
                                Number(sensorItem[0].lvl_min2),
                                Number(sensorItem[0].lvl_min3),
                                Number(sensorItem[0].lvl_min4),
                                Number(sensorItem[0].lvl_max1),
                                Number(sensorItem[0].lvl_max2),
                                Number(sensorItem[0].lvl_max3),
                                Number(sensorItem[0].lvl_max4)
                            ],
                            borderColor: color,
                            backgroundColor: color,
                            fill: false,
                            pointRadius: 0,
                            borderWidth: isRain ? 0 : 1,
                            barThickness: isRain ? 8 : undefined,
                            xAxisID: 'x',
                            yAxisID: axisMap[sensorItem[0].senstype_no] // 공통축 사용
                        });
                    });

                    const alarmLabelItems = buildAlarmLabelItems(data, minDate, axisMap);
                    const ctx = document.getElementById('myChart').getContext('2d');
                    chartInstance = new Chart(ctx, {
                        plugins: [groupAlarmLabelOverlayPlugin],
                        type: 'line',
                        data: { datasets },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales,
                            plugins: {
                                legend: {
                                    display: true,
                                    onClick: (e, legendItem, legend) => {
                                        const ci = legend.chart;
                                        const index = legendItem.datasetIndex;
                                        const meta = ci.getDatasetMeta(index);

                                        meta.hidden = meta.hidden === null ? !ci.data.datasets[index].hidden : null;

                                        const activeDatasets = ci.data.datasets.filter((d, idx) => !ci.getDatasetMeta(idx).hidden);

                                        Object.keys(ci.options.scales).forEach(yId => {
                                            if (yId === 'x') return;

                                            const activeForAxis = activeDatasets.filter(d => d.yAxisID === yId);
                                            const vals = activeForAxis
                                                .flatMap(d => d.data.map(p => Number(p.y)))
                                                .filter(v => Number.isFinite(v));
                                            const alarmVals = activeForAxis
                                                .flatMap(d => Array.isArray(d.alarmLevels) ? d.alarmLevels : [])
                                                .filter(isVisibleAlarmLevel);

                                            if (vals.length || alarmVals.length) {
                                                const axisCandidates = [...vals, ...alarmVals, 0];
                                                const absMax = Math.max(...axisCandidates.map(v => Math.abs(v || 0)), 0.1);
                                                const axisPadding = Math.max(absMax * 0.1, 0.1);
                                                const isRainAxis = activeForAxis.some(d => d.type === 'bar');

                                                ci.options.scales[yId].min = isRainAxis ? 0 : -(absMax + axisPadding); // 강우량계면 0으로 고정
                                                ci.options.scales[yId].max = absMax + axisPadding;
                                            }
                                        });

                                        ci.update();
                                    }
                                },
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
                                annotation: { annotations: buildAnnotations(data, minDate, maxDate, axisMap) },
                                groupAlarmLabelOverlay: { items: alarmLabelItems }
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
            function buildAnnotations(data, minDate, maxDate, axisMap) {
                const annotations = {};
                data.forEach((sensorItem, i) => {
                    const colors = ['#c88a55', '#4ea96d', '#c9a100', '#4f6ed8'];
                    const minLevels = [
                        parseFloat(sensorItem[0].lvl_min1),
                        parseFloat(sensorItem[0].lvl_min2),
                        parseFloat(sensorItem[0].lvl_min3),
                        parseFloat(sensorItem[0].lvl_min4)
                    ];
                    const maxLevels = [
                        parseFloat(sensorItem[0].lvl_max1),
                        parseFloat(sensorItem[0].lvl_max2),
                        parseFloat(sensorItem[0].lvl_max3),
                        parseFloat(sensorItem[0].lvl_max4)
                    ];
                    const yScaleId = (axisMap && axisMap[sensorItem[0].senstype_no]) ? axisMap[sensorItem[0].senstype_no] : ('y' + i);
                    const firstTs = sensorItem[0]?.meas_dt ? new Date(sensorItem[0].meas_dt).getTime() : minDate;
                    const lastTs = sensorItem[sensorItem.length - 1]?.meas_dt ? new Date(sensorItem[sensorItem.length - 1].meas_dt).getTime() : firstTs;
                    const lineXMin = Number.isFinite(minDate) ? minDate : firstTs;
                    const lineXMax = Number.isFinite(maxDate) ? maxDate : lastTs;

                    const addAlarmAnnotation = (levelValue, idx, levelType) => {
                        if (!isVisibleAlarmLevel(levelValue)) {
                            return;
                        }

                        const lineId = 'line-' + levelType + '-' + sensorItem[0].sens_no + '-' + (sensorItem[0].sens_chnl_id || 'none') + '-' + idx + '-' + i;
                        annotations[lineId] = {
                            type: 'line',
                            xScaleID: 'x',
                            yScaleID: yScaleId,
                            xMin: lineXMin,
                            xMax: lineXMax,
                            yMin: levelValue,
                            yMax: levelValue,
                            borderColor: colors[idx],
                            borderWidth: 2,
                            borderDash: [5, 4],
                            drawTime: 'afterDraw',
                            z: 5
                        };

                    };

                    minLevels.forEach((minLevel, idx) => addAlarmAnnotation(minLevel, idx, 'min'));
                    maxLevels.forEach((maxLevel, idx) => addAlarmAnnotation(maxLevel, idx, 'max'));
                });
                return annotations;
            }

            function buildAlarmLabelItems(data, minDate, axisMap) {
                const items = [];
                data.forEach((sensorItem, i) => {
                    if (!sensorItem || sensorItem.length === 0) {
                        return;
                    }

                    const colors = ['#f0dfd1', '#d4eddc', '#f4e7a3', '#cfd8fb'];
                    const lineColors = ['#c88a55', '#4ea96d', '#c9a100', '#4f6ed8'];
                    const minLevels = [
                        parseFloat(sensorItem[0].lvl_min1),
                        parseFloat(sensorItem[0].lvl_min2),
                        parseFloat(sensorItem[0].lvl_min3),
                        parseFloat(sensorItem[0].lvl_min4)
                    ];
                    const maxLevels = [
                        parseFloat(sensorItem[0].lvl_max1),
                        parseFloat(sensorItem[0].lvl_max2),
                        parseFloat(sensorItem[0].lvl_max3),
                        parseFloat(sensorItem[0].lvl_max4)
                    ];
                    const firstTs = sensorItem[0]?.meas_dt
                        ? new Date(sensorItem[0].meas_dt).getTime()
                        : minDate;
                    if (!Number.isFinite(firstTs)) {
                        return;
                    }

                    const yScaleId = (axisMap && axisMap[sensorItem[0].senstype_no]) ? axisMap[sensorItem[0].senstype_no] : ('y' + i);
                    const labelTextBase = sensorItem[0].sens_nm + (sensorItem[0].sens_chnl_id ? '-' + sensorItem[0].sens_chnl_id : '');
                    const labelXOffset = 72 + ((i % 6) * 18);
                    const labelYOffsetSeed = (Math.floor(i / 6) % 4) * 6;

                    const pushLabel = (levelValue, idx, levelType) => {
                        if (!isVisibleAlarmLevel(levelValue)) {
                            return;
                        }

                        const directionOffset = (i % 2 === 0 ? 1 : -1) * (6 + labelYOffsetSeed);
                        const levelStackOffset = (idx + 1) * 10;
                        items.push({
                            xValue: firstTs,
                            yValue: levelValue,
                            yScaleID: yScaleId,
                            xAdjust: labelXOffset + (idx * 6),
                            yAdjust: (levelType === 'min' ? -(8 + levelStackOffset) : (8 + levelStackOffset)) + directionOffset,
                            backgroundColor: colors[idx],
                            borderColor: lineColors[idx],
                            content: [
                                labelTextBase,
                                (idx + 1) + '차 ' + (levelType === 'min' ? '최소' : '최대') + ' 경고'
                            ]
                        });
                    };

                    minLevels.forEach((level, idx) => pushLabel(level, idx, 'min'));
                    maxLevels.forEach((level, idx) => pushLabel(level, idx, 'max'));
                });
                return items;
            }
        })
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
                <div class="contents_header">
                    <h3 class="txt">센서 그룹핑</h3>
                    <div class="btn-group">
                        <p class="search-top-label">현장명</p>
                        <select id="district-select">
                            <option value="">선택</option>
                        </select>
                    </div>
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
                            <div style="display:flex;">
                                <p class="search-top-label">조회조건</p>
                                <select id="select-condition">
                                    <option value="hourly">시간별</option>
                                    <option value="minute">상세</option>
                                    <option value="daily">일별</option>
                                </select>
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
