<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js@1.12.0/src/toastify.min.css">
    <jsp:include page="common/include_head.jsp" flush="true"/>
    <style>
        .toast-fixed {
            background: #0b0166 !important; /* 배경색 */
            color: #fff !important;
            width: 400px;        /* 폭 고정 */
            min-width: 400px;
            max-width: 400px;
            white-space: normal; /* 여러 줄 허용 */
        }

        .toast-fixed .cate {
            width: 4.5rem;
            height: 2rem;
            font-weight: 500;
            font-size: 1.2rem;
            line-height: 1;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 0.9rem;
        }

        .ui-search-toolbar input {
            border: 1px solid #ccc;
            padding: 2px;
        }

        .ui-search-toolbar th:first-child {
            border-left: none !important;
        }

        .ui-jqgrid tr.ui-search-toolbar th {
            border: 1px solid #d3d3d3;
        }

        .filter-area .select_filter .search-top-label {
            padding: 0;
        }

        .modal-header {
            display: flex;
            flex-direction: column;
            align-items: start;
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

        #map {
            width: 100%;
            height: calc(100vh - 7.3rem);
            margin-top: 7.3rem;
        }

        .zoneSelected, .site-status-details {
            display: none;
        }

        .roadView {
            width: 100%;
            height: 100%;
            background-color: #888;
        }

        #road-map {
            width: 50vw;
            height: calc(100vh - 7.3rem);
            position: fixed;
            right: -50vw;
            top: 7.3rem;
            z-index: 6;
            box-shadow: -2rem 0 2rem rgba(0, 0, 0, 0.2);
        }

        .marker.zone {
            width: 32px;
            height: 50px;
            top: 50px;
            position: relative;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
        }

        .marker.asset {
            width: 32px;
            height: 50px;
            top: 32px;
            position: relative;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
        }

        .marker.zone span.count {
            position: relative;
            display: block;
            height: 36px;
            top: -34px;
            line-height: 36px;
            color: #111;
            text-align: center;
            font-size: 14px;
        }

        .marker span.title {
            position: relative;
            display: block;
            height: 22px;
            top: -31px;
            padding: 0 5px;
            line-height: 22px;
            color: #111;
            text-align: center;
            font-size: 13px;
            background: #fff;
            border-radius: 5px;
            border: 1px solid #ccc;
            width: max-content;
        }

        .marker.asset span.title {
            top: 5px;
        }

        .marker.zone:hover {
            z-index: 1;
        }

        .marker.rvPoint {
            width: 32px;
            height: 32px;
        }

        .marker.rvPoint img {
            margin-top: 16px;
        }

        .status-container {
            display: flex;
            align-items: center;
        }

        .status-container > .title:before {
            content: "";
            width: 11.6rem;
            height: 3px;
            background-color: #6685ff;
            display: inline-block;
            position: absolute;
            left: 0;
            bottom: -2px;
        }

        .status-container .title {
            padding: 0 0 1.5rem 1.8rem;
            border-bottom: 1px solid #b4c0ef;
            font-weight: bold;
            font-size: 1.9rem;
            line-height: 1;
            color: #fff;
            position: relative;
        }

        .rain-info {
            display: flex;
            align-items: center;
            padding-left: 40px;
            padding-bottom: 12px;
        }

        .rain-info img {
            width: 24px;
            height: auto;
        }

        .rain-info span {
            font-weight: bold;
            color: #cfd4e2;
            padding-left: 5px;
            font-size: 1.2rem;
        }

        .ui-jqgrid .ui-search-toolbar select {
            background: #fff !important;
            color: #000;
        }
    </style>
</head>
<script type="text/javascript" src="/admin_add.js"></script>
<script src="https://cdn.jsdelivr.net/npm/toastify-js@1.12.0/src/toastify.min.js"></script>
<script>
    const LATENCY = 60 * 1000;
    const ALARM_EFFECT_TIME = 500;
    const MARKER_CHANGE_LEVEL = 17.5;
    let wsUrl = "wss://goldencity.codeidea.io";
    let cctvWs;
    const _assetTypes = ${assetTypes};
    const _areaInfo = ${areaInfo};
    window.isRoadView = false;
    window.markers = {};
    window.markers.districts = [];
    window.markers.assets = [];
    window.markers.risks = [];

    function getZoneDetail() {
        // 상세 보기 에서 시간 맞추기 위해 초기화
        clearInterval($setInterval1);
        clearInterval(window.zoneDetail);
        $setInterval1 = setInterval(startInterval, LATENCY); // 60초마다

        $.get('/popup/zoneDetail', {
            district_no: $('.site-status-list select.selectZone option:selected').val()
        }, function (html) {
            $('.site-status-details').html(html);
            $('.site-status-details').show();
            setTimeout(function () {
                if (!$("#site-status").hasClass("view")) {
                    $("#site-status").addClass("view");
                }
            }, 50);
        });
    }

    function editMode(type) {
        const markers = window.vworld.getMap().getOverlays().getArray();
        const $wrap = $("#wrap");
        const $editmode = $(".right-utill .editmode");

        if (type === "open") {
            popFancyClose();
            $wrap.addClass("editMode");
            $editmode.addClass("active");

            $.each(markers, (_i, maker) => {
                $(maker.getElement()).on('mousedown', () => {
                    $(maker.getElement()).addClass('positionChange');
                    $(maker.getElement()).on('dragstart', (evt) => {
                        evt.preventDefault();
                    });

                    window.addEventListener('mousemove', move);
                    window.addEventListener('mouseup', end);

                    function move(evt) {
                        maker.setPosition(window.vworld.getMap().getEventCoordinate(evt));
                    }

                    function end() {
                        window.removeEventListener('mousemove', move);
                        window.removeEventListener('mouseup', end);
                        $(maker.getElement()).off('dragstart');
                    }
                });
            });
        } else if (type === "close") {
            $wrap.removeClass("editMode");
            $editmode.removeClass("active");
            $.each(window.vworld.overlays, (_i, overlay) => {
                window.vworld.setPositionOverlay(overlay.uid, overlay.coords);
            });
            $.each(markers, (_i, maker) => {
                $(maker.getElement()).off('mousedown');
            });
            alert("취소 되었습니다.");
        } else if (type === "save") {
            $wrap.removeClass("editMode");
            $editmode.removeClass("active");
            const changedDistricts = $('div.marker.zone.positionChange');
            const changedAssets = $('div.marker.asset.positionChange');

            $.each(changedDistricts, (_i, maker) => {
                const $maker = $(maker);
                const coords = window.vworld.getPositionOverlay($maker.attr('uid'));
                $.ajax({
                    method: 'put',
                    url: '/api/districts/update-position',
                    data: JSON.stringify({
                        districtNo: $maker.attr('zoneid'),
                        distLat: coords[1],
                        distLon: coords[0]
                    }),
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    success: () => {
                        alert('저장되었습니다.');
                    },
                    error: () => {
                        alert('저장에 실패하였습니다.');
                    }
                });
            });

            $.each(changedAssets, (_i, maker) => {
                const isCCTV = $(maker).data('is-cctv');
                const $maker = $(maker);
                const coords = window.vworld.getPositionOverlay($maker.attr('uid'));

                if (isCCTV) {
                    $.ajax({
                        method: 'put',
                        url: '/api/sensors/cctv/update-position',
                        data: JSON.stringify({
                            cctvNo: $maker.attr('assetid'),
                            cctvLat: coords[1],
                            cctvLon: coords[0]
                        }),
                        dataType: 'json',
                        contentType: 'application/json; charset=utf-8',
                        success: () => {
                            alert('저장되었습니다.');
                        },
                        error: () => {
                            alert('저장에 실패하였습니다.');
                        }
                    });
                } else {
                    $.ajax({
                        method: 'put',
                        url: '/api/sensors/update-position',
                        data: JSON.stringify({
                            sensNo: $maker.attr('assetid'),
                            sensLat: coords[1],
                            sensLon: coords[0]
                        }),
                        dataType: 'json',
                        contentType: 'application/json; charset=utf-8',
                        success: () => {
                            alert('저장되었습니다.');
                        },
                        error: () => {
                            alert('저장에 실패하였습니다.');
                        }
                    });
                }
            });

            $.each(markers, (_i, maker) => {
                $(maker.getElement()).off('mousedown');
            });
        }
    }

    $(function () {
        init();
        if (window.location.href.indexOf('106.245') > -1) { // 테스트서버
            wsUrl = 'ws://106.245.95.116:6099';
        } else if (window.location.href.indexOf('121.159') > -1) { // 진천서버
            wsUrl = 'ws://121.159.33.107:9090';
        }

        const autoLogin = JSON.parse(localStorage.getItem('autoLogin'));

        if (autoLogin) {
            localStorage.setItem('loginSuccess', true);
        }
        window.vworld = new vwutil({
            mapId: "map",
            initPosition: {
                center: [
                    _areaInfo.lng, _areaInfo.lat
                ],
                zoom: _areaInfo.zoom,
                rotation: 0.5
            }
        });
        window.vworld.vwmap2d();

        $(document).on('click', '.map-2d-btn', function () {
            if (window.vworld.map.type === '2D') {
                window.vworld.getMap().getLayers().clear();
                window.vworld.getMap().addLayer(Base);
            } else {
                window.vworld.vwmap2d();
                $(document).trigger('map_action_end');
            }
        });

        $(document).on('click', '.map-3d-btn', function () {
            $("#wrap").removeClass("editMode");
            $(".right-utill .editmode").removeClass("active");
            window.vworld.vwmap3d();
        });

        $(document).on('click', '.map-sat-btn', function () {
            window.vworld.vwmap2d();
            window.vworld.getMap().getLayers().clear();
            window.vworld.getMap().addLayer(Satellite);
            window.vworld.getMap().addLayer(Hybrid);
        });

        $(document).on('click', '#overall-status .overall-status-btn', function () {     // 종합 상황 내역
            if (!$("#overall-status").hasClass("close")) {
                $("#overall-status").addClass("close");
            } else {
                $("#overall-status").removeClass("close");
            }
        });

        $(document).on("click", ".right-utill .iconlayer", function () {// 레이어 열기/닫기
            if (!$(this).hasClass("active")) {
                $(this).addClass("active");
                $(".right-utill .map-option").show();
            } else {
                $(this).removeClass("active");
                $(".right-utill .map-option").hide();
            }
        });

        $(document).on("click", ".right-utill .roadview", function () {
            if (!$(this).hasClass("active")) {
                $(this).addClass("active");
                window.isRoadView = true;
            } else {
                $(this).removeClass("active");
                $(".roadViewContainer").removeClass("open");
                window.isRoadView = false;
                if (typeof window.roadViewMarkerUid != 'undefined') {
                    window.vworld.removeOverlay(window.roadViewMarkerUid);
                }
            }
        });

        $(document).on("click", ".roadViewContainer .road-map-close", function () {// 로드뷰 열기/닫기
            if ($(".roadViewContainer").hasClass("open")) {
                $(".roadViewContainer").removeClass("open");
                $(".right-utill .roadview").removeClass("active");
                window.isRoadView = false;
                if (typeof window.roadViewMarkerUid != 'undefined') {
                    window.vworld.removeOverlay(window.roadViewMarkerUid);
                }
            }
        });

        $(document).on("click", "div.site-status-toggle > button", function () {               // 현장 현황 => 상세정보 열기

            if ($(this).hasClass("show")) {
                $('.site-status-details .close-btns').trigger('click');
            } else {
                $(this).addClass("show");
                getZoneDetail();
            }
        });

        $(document).on("click", ".site-status-details .close-btns", function () { // 현장 현황 => 상세정보 닫기
            if ($("#site-status").hasClass("view")) {
                $("#site-status").removeClass("view");
            }

            if ($("div.site-status-toggle > button").hasClass("show")) {
                $("div.site-status-toggle > button").removeClass("show");
            }

            setTimeout(function () {
                $('.site-status-details').hide();
            }, 300);
        });

        $(document).on('map_action_end', debounce(function (e) {
            if ($('.roadview').hasClass('active')) {
                window.isRoadView = true;
            }

            if ($('.site-status-list select.selectZone option:selected').val() === '') {
                $.each(window.markers.districts, function () {
                    window.vworld.visibleOverlay(this, true);
                });

                $.each(window.markers.assets, function () {
                    window.vworld.visibleOverlay(this, false);
                });
            } else {
                if (window.vworld.getZoom() >= MARKER_CHANGE_LEVEL) {
                    $.each(window.markers.districts, function () {
                        window.vworld.visibleOverlay(this, false);
                    });
                    $.each(window.markers.assets, function () {
                        // if (getToggleStatus(this)) {
                        window.vworld.visibleOverlay(this, true);
                        // }
                    });
                } else {
                    $.each(window.markers.districts, function () {
                        window.vworld.visibleOverlay(this, true);
                    });
                    $.each(window.markers.assets, (_index, item) => {
                        window.vworld.visibleOverlay(item, false);
                    });
                }
            }

            if (window.vworld.map.type === '2D') {
                $('button.editmode').closest('li').show();
            } else {
                $('button.editmode').closest('li').hide();
            }
        }, 100));

        $(document).on('mouseover', '.marker', function () {
            $('.marker').css('z-index', 0);
            $(this).css('z-index', 1);

            if ($(this).parent().hasClass('ol-overlay-container')) {
                $('.ol-overlay-container').css('z-index', 0);
                $(this).parent().css('z-index', 1);
            }
        });

        $(document).on('map_click', function (e, data) {
            if (window.isRoadView) {
                if (typeof window.roadViewMarkerUid != 'undefined') {
                    window.vworld.removeOverlay(window.roadViewMarkerUid);
                }

                window.roadViewMarkerUid = window.vworld.addOverlay(
                    '<div class="marker rvPoint"><img src="/images/marker_roadview2.png"></div>', [data.cartographic.longitude, data.cartographic.latitude],
                    '/images/marker_roadview2.png', '');

                loadRoadView(data.cartographic.latitude, data.cartographic.longitude);
            }
        });

        const currentYear = new Date().getFullYear();

        const startDate = new Date(currentYear, 0, 1, 23, 59); // 0은 1월
        $('#start-date').val(startDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

        const endDate = new Date(currentYear, 11, 31, 23, 59); // 11은 12월
        $('#end-date').val(endDate.toISOString().slice(0, 16)); // ISO 형식으로 설정

        const chartDataArray = []; // 모든 데이터를 저장할 배열 추가
        let sensNo = ''

        $(document).on('overlay_click', function (e, data) {
            if ($("#wrap").hasClass("editMode"))
                return;
            if (data.type === 'sensor') {                // 센서 선택시
                sensNo = $(data.htmlContent).attr('assetid');
                $("#graph-search-btn").click();
                openSensorPopup();
            } else if (data.type === 'cctv') {           // cctv 선택시
                openCctvPopup(data);
            } else {
                if ($(data.htmlContent).hasClass('zone')) {                 // 지구 아이콘 선택시
                    $('.site-status-list select.selectZone option[value=' + data.zone_id + ']').prop('selected', true);
                    $('.site-status-list select.selectZone').trigger('change');
                }
            }
        });

        $("#graph-search-btn").click(() => {
            const case_ = ['', 'X', 'Y', 'Z'];
            let checkedData = case_.flatMap((item) => {
                return {
                    sens_no: sensNo,
                    sens_chnl_id: item
                };
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

            data.forEach((item) => {
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


        function openSensorPopup() {
            popFancy('#chart-popup', {dragToClose: false, touch: false});
        }

        function openCctvPopup(data) {
            $('#lay-cctv-view .layer-base-conts img').hide();
            $('#lay-cctv-view .layer-base-title').html(data.label);

            cctvWs = new WebSocket(wsUrl + '/video/stream?url=' + data.etc1);
            cctvWs.onerror = function () {
                $('#lay-cctv-view .layer-base-conts img.nosignal').show();

            };
            cctvWs.onmessage = function (event) {
                const blob = new Blob([event.data], {type: "image/jpeg"});
                const url = URL.createObjectURL(blob);
                const video = $('#lay-cctv-view .layer-base-conts img')[0];
                video.src = url;

                if (!$('#lay-cctv-view .layer-base-conts img').is(':visible')) {
                    $('#lay-cctv-view .layer-base-conts img').show();
                }

                try {
                    video.src = url;
                    setTimeout(() => {
                        URL.revokeObjectURL(url);
                    }, 100);
                } catch (e) {
                    console.log('socket close');
                }
            };
            popFancy('#lay-cctv-view', {dragToClose: false, touch: false, backdropClick: false});
        }

        $('#lay-cctv-view .fullscreen').on('click', function () {
            if ($(this).closest('#lay-cctv-view').hasClass('full')) {
                $(this).closest('#lay-cctv-view').removeClass('full');
            } else {
                $(this).closest('#lay-cctv-view').addClass('full');
            }
        });

        $('#lay-cctv-view .closeCctv').on('click', function () {
            try {
                cctvWs.send(JSON.stringify({type: "close"}));
                cctvWs.close();
                $(this).closest('#lay-cctv-view').removeClass('full');
            } catch (e) {
                console.log(e);
            }
        });

        $("body").on("click", ".right-utill .editmode", function () {// Edit Mode 열기
            if (!$("#wrap").hasClass("editMode")) {
                popFancy('#lay-edit-mode', {dragToClose: false, touch: false});
            } else {
                alert("Edit Mode 실행 중입니다.")
            }
        });

        $(document).on('click', '.right-alarm_re button.close-alarm', function () {
            let $lastCard = $(this).closest('.right-alarm_re');
            $lastCard.fadeOut(1000, function () {
                $lastCard.remove();
            });
        });

        $(document).on('click', '.zoneSelected > .site-zone-area > ul.site-zone-list div.site-zone-conts li > a', function () {
            $('div[uid] span').css({
                'color': '#000000'
            });
            $('div[uid]').parent().css({
                'z-index': 0
            });

            const coords = $(this).data('coords').split(',');
            let asset_id = $(this).closest('li').attr('asset_id');
            if (coords[0] == 'undefined' || coords[0] == 'null') {
                alert('이동할 위치 정보가 없습니다.');
            } else {
                // 위치로 이동
                window.vworld.setPanBy(coords, 19);
                $.each(window.vworld.overlays, function () {
                    if (this.asset_id == asset_id) {
                        window.vworld.setLabelStyle(this.uid, '#DA9616', '#ffffff', 1.0);
                        $('div[uid=' + this.uid + ']').parent().css('z-index', 9999);
                        return false;
                    }
                });
            }
        });

        $(document).on('click', '.right-alarm_re p.icon, .right-alarm_re dl', function () {
            const coords = $(this).closest('div.right-alarm_re').data('coords').split(',');
            const zoneId = $(this).closest('div.right-alarm_re').data('zoneid');
            const assetId = $(this).closest('div.right-alarm_re').data('assetid');

            $.get('/getAssetList', {zone_id: zoneId}, function (res) {
                $('.zoneSelected').data('zoneid', zoneId);

                $('.site-zone-list li .site-zone-conts ul').empty();

                $.each(res, function (idx, ele) {
                    let status = window.marker.risk.find(r => r.zone_id == zoneId && r.asset_id == ele.asset_id);

                    let fc_step = !!status ? 'fc_step' + status.risk_level : '';

                    let html = '';
                    html += '<li ' + fc_step + ' asset_id="' + ele.asset_id + '">';
                    html += '<a href="javascript:void(0);" data-coords="' + ele.x + ',' + ele.y + '">' + ele.name + '</a>' +
                        '<div><i class="fa-regular fa-eye"></i>　' +
                        '<p class="check-box" notxt="" small=""><input type="checkbox" id="check_conts01_' + idx + '" name="check_conts01_' + idx + '" value="" checked>';
                    html += '<label for="check_conts01_' + idx + '"><span class="graphic"></span></label></p></div></li>';

                    $('.site-zone-list li[kind=' + ele.asset_kind_id + '] .site-zone-conts ul').append(html);
                });
            });

            if (coords[0] == 'undefined' || coords[0] == 'null') {
                alert('이동할 위치 정보가 없습니다.');
            } else {
                $.each(window.vworld.overlays, function () {
                    if (this.asset_id == assetId) {
                        $('div[uid=' + this.uid + ']').parent().css('z-index', 9999);
                        return false;
                    }
                });
                // 위치로 이동
                $('.site-status-list select.selectZone option[value=' + zoneId + ']').prop('selected', true);
                $('.site-status-list select.selectZone').trigger('change');
            }
            // window.vworld.setPanBy(coords, 18);
        });

        // 지구현황 - 자산종류 선택시 (전체 show, hide)
        $(document).on('click', '.site-zone-list li .site-zone-title p.check-box span', function (e) {
            const checked = !$(this).closest('p.check-box').find('input').is(':checked');
            let $this = $(this);
            let toggleFunction = function ($this) {
                $.each($this.closest('li').find('.site-zone-conts li'), function () {
                    $(this).find('p.check-box input').prop('checked', checked);

                    markerVisible($(this).attr('asset_id'), checked);
                });
            }
            if (window.vworld.getZoom() < MARKER_CHANGE_LEVEL) {
                window.vworld.setPanBy(window.vworld.getCenter(), 18, function () {
                    toggleFunction($this);
                });
            } else {
                toggleFunction($this);
            }
        });

        $(document).on('click', '.site-zone-list li .site-zone-conts p.check-box span', function (e) {
            const selectAssetId = $(this).closest('li').attr('asset_id');
            const checked = !$(this).closest('p.check-box').find('input').is(':checked');
            if (window.vworld.getZoom() < MARKER_CHANGE_LEVEL) {
                window.vworld.setPanBy(window.vworld.getCenter(), 18, function () {
                    markerVisible(selectAssetId, checked);
                });
            } else {
                markerVisible(selectAssetId, checked);
            }
        });

        $(document).on('click', 'i.fa-eye', function (e) {
            const selectAssetId = $(this).closest('li').attr('asset_id');
            const data = window.vworld.overlays.find(d => d.asset_id === selectAssetId);
            $(document).trigger('overlay_click', data);
        });

        $('.site-zone-list p.check-box input').prop('checked', true);

        function markerVisible(asset_id, visible) {
            $.each(window.vworld.overlays, function () {
                if (typeof this['asset_id'] != 'undefined') {
                    if (this.asset_id === asset_id) {
                        window.vworld.visibleOverlay(this.uid, visible);
                        return false;
                    }
                }
            });
        }

        function init() {
            initDistrictSelectZone();
            initAssetList();
        }

        function initDistrictSelectZone() {
            const $districtSelectZone = $('select.selectZone');
            $.get("/adminAdd/districtInfo/all", (res) => {
                res = res.sort((a, b) => a.district_nm.localeCompare(b.district_nm));
                $districtSelectZone.append('<option value="">현장 선택</option>');
                $.each(res, (_idx, district) => {
                    $districtSelectZone.append('<option value="' + district.district_no + '" lat="' + district.dist_lat + '" lng="' + district.dist_lon + '">' + district.district_nm + '</option>');
                    $.get('/new-dashboard/asset/count', {district_no: district.district_no}, (res) => {
                        window.markers.districts.push(window.vworld.addOverlay(
                            '<div class="marker zone" zoneid="' + district.district_no + '">' +
                            '    <img src="/images/icon_area1.png"/>' +
                            '    <span class="count">' + res + '</span>' +
                            '    <span class="title">' + district.district_nm + '</span>' +
                            '</div>'
                            , [district.dist_lon, district.dist_lat]
                            , '/images/icon_area1.png', district.district_nm, res, {
                                type: 'area',
                                zone_id: district.district_no
                            }))
                    });
                });
            });
        }

        $('select.selectZone').change(function () {
            let $selected = $("option:selected", this);
            const districtNo = $selected.val();
            if ($selected.index() > 0) {
                initDistrictSelectChange(districtNo)

                $.get('/new-dashboard/asset/all', {district_no: districtNo}, (res) => {
                    window.markers.assets.forEach((uid) => {
                        window.vworld.removeOverlay(uid);
                    });
                    window.markers.assets = [];

                    loadSensorMakers(districtNo, res.sensors);
                    loadCctvMakers(districtNo, res.cctvs);

                    $.each(res.sensors, (_idx, sensor) => {
                        const status = window.markers.risks.find(r => r.zone_id === districtNo && r.asset_id === sensor.sens_no);
                        const fcStep = !!status?.risk_level ? 'fc_step' + status.risk_level : '';
                        const html =
                            '<li ' + fcStep + ' asset_id="' + sensor.sens_no + '">' +
                            '    <a href="javascript:void(0);" data-coords="' + sensor.sens_lon + ',' + sensor.sens_lat + '">' + sensor.sens_nm + '</a>' +
                            '    <div>' +
                            '        <i class="fa-regular fa-eye"></i>　' +
                            '        <p class="check-box" notxt="" small="">' +
                            '            <input type="checkbox" id="check_conts01_' + _idx + '" name="check_conts01_' + _idx + '" value="" checked>' +
                            '            <label for="check_conts01_' + _idx + '">' +
                            '                <span class="graphic"></span>' +
                            '            </label>' +
                            '        </p>' +
                            '    </div>' +
                            '</li>';
                        $('.site-zone-list li[kind=' + sensor.senstype_no + '] .site-zone-conts ul').append(html);
                    });

                    $.each(res.cctvs, (_idx, cctv) => {
                        const fcStep = ''
                        const html =
                            '<li ' + fcStep + ' asset_id="' + cctv.cctv_no + '">' +
                            '    <a href="javascript:void(0);" data-coords="' + cctv.cctv_lon + ',' + cctv.cctv_lat + '">' + cctv.cctv_nm + '</a>' +
                            '    <div>' +
                            '        <i class="fa-regular fa-eye"></i>　' +
                            '        <p class="check-box" notxt="" small="">' +
                            '            <input type="checkbox" id="check_conts01_' + _idx + '" name="check_conts01_' + _idx + '" value="" checked>' +
                            '            <label for="check_conts01_' + _idx + '">' +
                            '                <span class="graphic"></span>' +
                            '            </label>' +
                            '        </p>' +
                            '    </div>' +
                            '</li>';
                        $('.site-zone-list li[kind="cctv"] .site-zone-conts ul').append(html);
                    });

                    $('.site-zone-list li input[type="checkbox"]').prop('checked', true);
                    sortAssetsByLength()
                    $(document).trigger('map_action_end');
                });
                $('.zoneSelected').show();
                window.vworld.setPanBy([parseFloat($selected.attr('lng')), parseFloat($selected.attr('lat'))], 18);
            } else {
                $('.zoneSelected').hide();
                $('.site-status-toggle').removeClass('active');
                $('.site-status-details .close-btns').trigger('click');
                $(document).trigger('map_action_end');
            }
            if ($('div.site-status-toggle.active > button').hasClass("show") && $selected.val != '') {
                getZoneDetail();
            }
        });

        function initDistrictSelectChange(districtNo) {
            $('.site-status-toggle').addClass('active')
            $('.zoneSelected').data('zoneid', districtNo);
            $('.site-zone-list li .site-zone-conts ul').empty();
        }

        function sortAssetsByLength() {
            const $liElements = $('.site-zone-list > li');
            $liElements.sort(function (a, b) {
                const aCount = $(a).find('.site-zone-conts ul li').length;
                const bCount = $(b).find('.site-zone-conts ul li').length;
                return bCount - aCount;
            });
            $('.site-zone-list').append($liElements);
        }

        function loadSensorMakers(districtNo, sensors) {
            $.each(sensors, (_idx, sensor) => {
                let img;
                let type = 'sensor';
                if (sensor.sens_tp_nm === '구조물경사계') {
                    img = 'icon_sensor_tm.png';
                } else if (sensor.sens_tp_nm === '강우량계') {
                    img = 'icon_sensor_p.png';
                } else if (sensor.sens_tp_nm === '지표변위계') {
                    img = 'icon_sensor_s.png';
                } else if (sensor.sens_tp_nm === 'CCTV') {
                    img = 'icon_cctv.png';
                    type = 'cctv';
                } else if (sensor.sens_tp_nm === '재난방송') {
                    img = 'icon_speaker.png';
                    type = 'speaker';
                } else if (sensor.sens_tp_nm === '전광판') {
                    img = 'icon_text.png';
                } else if (sensor.sens_tp_nm.indexOf('지하수위계') > -1) {
                    img = 'icon_sensor_ttw.png';
                } else {
                    img = 'icon_sensor_tm.png';
                }
                const position = [sensor.sens_lon, sensor.sens_lat];
                const sensorMaker = window.vworld.addOverlay(
                    '<div class="marker asset" zoneid="' + districtNo + '" assetid="' + sensor.sens_no + '">' +
                    '    <img src="/images/' + img + '"/>' +
                    '    <span class="title">' + sensor.sens_nm + '</span>' +
                    '</div>'
                    , position,
                    '/images/' + img, sensor.sens_nm, null, {
                        type: type,
                        asset_id: sensor.sens_no,
                        zone_id: districtNo,
                    });
                window.markers.assets.push(sensorMaker);
            });
        }

        function loadCctvMakers(districtNo, cctvs) {
            $.each(cctvs, (_idx, cctv) => {
                const img = 'icon_cctv.png';
                const type = 'cctv';
                const position = [cctv.cctv_lon, cctv.cctv_lat];
                const cctvMaker = window.vworld.addOverlay(
                    '<div data-is-cctv="true" class="marker asset" zoneid="' + districtNo + '" assetid="' + cctv.cctv_no + '">' +
                    '    <img src="/images/' + img + '"/>' +
                    '    <span class="title">' + cctv.cctv_nm + '</span>' +
                    '</div>'
                    , position,
                    '/images/' + img, cctv.cctv_nm, null, {
                        type: type,
                        asset_id: cctv.cctv_no,
                        zone_id: districtNo,
                        etc1: cctv.etc1
                    });
                window.markers.assets.push(cctvMaker);
            });
        }

        function initAssetList() {
            $('.site-zone-area ul.site-zone-list').empty();
            let index = 0;
            $.each(_assetTypes, (idx, item) => {
                const asset =
                    '  <li kind="' + item.senstype_no + '">'
                    + '    <div class="site-zone-title">'
                    + '        <strong>'
                    + '            <i id="arrow-up" class="fa-solid fa-arrow-up fa-xl arrow-up" style="color: #ffffff; margin-right: 10px; cursor: pointer;"></i>'
                    + item.sens_tp_nm
                    + '        </strong>'
                    + '        <p class="check-box" notxt="" small="">'
                    + '            <input type="checkbox" checked id="check_tit01_' + idx + '" name="check_tit01_' + idx + '" value="">'
                    + '            <label for="check_tit01_' + idx + '">'
                    + '                <span class="graphic"></span>'
                    + '            </label>'
                    + '        </p>'
                    + '    </div>'
                    + '    <div class="site-zone-conts">'
                    + '        <ul></ul>'
                    + '    </div>'
                    + '</li>';
                $('.site-zone-area ul.site-zone-list').append(asset);
                index += 1;
            });

            $('.site-zone-area ul.site-zone-list').append(
                '  <li kind="cctv">'
                + '    <div class="site-zone-title">'
                + '        <strong>'
                + '            <i id="arrow-up" class="fa-solid fa-arrow-up fa-xl arrow-up" style="color: #ffffff; margin-right: 10px; cursor: pointer;"></i>'
                + 'CCTV'
                + '        </strong>'
                + '        <p class="check-box" notxt="" small="">'
                + '            <input type="checkbox" checked id="check_tit01_' + index + '" name="check_tit01_' + index + '" value="">'
                + '            <label for="check_tit01_' + index + '">'
                + '                <span class="graphic"></span>'
                + '            </label>'
                + '        </p>'
                + '    </div>'
                + '    <div class="site-zone-conts">'
                + '        <ul></ul>'
                + '    </div>'
                + '</li>'
            );
        }

        $(document).on('click', '.arrow-up', function () {
            $(this).toggleClass('fa-arrow-up fa-arrow-down');
            const $ul = $(this).closest('.site-zone-title').next('.site-zone-conts').find('ul');
            var $li = $ul.children('li').get().reverse();
            $ul.empty().append($li);
        });

        function loadRoadView(lat, lng) {
            window.isRoadView = true;

            // let center = ol.proj.transform(window.vworld.getMap().getView().getCenter(), "EPSG:3857", "EPSG:4326");
            initRoadView($('.roadView'), lat, lng, function (rv) {
                // console.log(rv);
                if (rv.getPanoId() == null) {
                    $(".roadViewContainer").removeClass("open");
                    alert('로드뷰를 제공하지 않는 지역입니다');
                } else {
                    $(".roadViewContainer").addClass("open");
                }
            });
        }
    });
</script>
<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="common/include_top.jsp" flush="true"/>
    <div id="global-menu">
        <jsp:include page="common/include_sidebar.jsp" flush="true"/>
        <jsp:include page="layout/total_status.jsp" flush="true"/>
        <div id="site-status">
            <div class="site-status-list">
                <div class="status-container">
                    <div class="title">
                        <span>현장 현황</span>
                    </div>
                    <div class="rain-info" style="display: none">
                        <img src="images/weather/rain_ic.png"/>
                    </div>
                </div>
                <select class="selectZone">
                </select>

                <div class="zoneSelected" data-zoneid="">
                    <div class="site-zone-area">
                        <ul class="site-zone-list">
                        </ul>
                    </div>
                </div>
            </div>
            <div class="site-status-toggle">
                <button type="button" class="overall-status-btn">
                    <span class="f_arr">←</span>
                </button>
            </div>
            <div class="site-status-details">
            </div>
        </div>
    </div>
    <div id="right-alarm" class="alarmContainer">
    </div>

    <div id="map"></div>
    <div class="map_typecontrol">
                <span id="btnSatmap" class="btn map-sat-btn"><img src="/images/map_sky.jpg" alt=""/><i>항공 지도</i>
                </span>
        <span id="btnRoadmap" class="selected_btn map-2d-btn"><img src="/images/map_2d.jpg" alt=""/><i>2D 지도</i>
                </span>
        <span id="btnSkyview" class="btn map-3d-btn"><img src="/images/map_3d.jpg" alt=""/><i>3D 지도</i>
                </span>
    </div>

    <div class="roadViewContainer" id="road-map">
        <button type="button" class="road-map-close">
            <img src="/images/btn_lay_close.png" alt="닫기"/>
        </button>
        <div class="roadView"></div>
    </div>

    <div id="lay-weather-area" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
        </div>
        <div class="layer-base-title">오늘의 날씨</div>
        <div class="layer-base-conts" style="height: 700px;">
            <iframe src="https://www.weather.go.kr/w/weather/forecast/short-term.do?nolayout=Y#dong/4375035000"
                    width="100%" height="100%" frameborder="0" style="padding: 10px">
            </iframe>
        </div>
    </div>

    <div id="lay-weather-area2" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
        </div>
        <div class="layer-base-title">기상특보</div>
        <div class="layer-base-conts" style="height: 700px;">
            <iframe src="https://www.weather.go.kr/w/weather/warning/status.do?nolayout=Y#dong/4375035000" width="100%"
                    height="100%" frameborder="0" style="padding: 10px">
            </iframe>
        </div>
    </div>

    <div id="lay-sensor-info" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
        </div>
        <div class="layer-base-title icon">
            센서정보
        </div>
    </div>

    <div id="lay-disaster-broadcast" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
        </div>
        <div class="layer-base-title icon broadcast">재난 방송 시스템</div>
        <div class="layer-base-conts min">
            <ul class="bul-sensor">
                <li>
                    <strong>센서명</strong>
                    CAST_0001
                </li>
                <li>
                    <strong>종류</strong>
                    재난방송시스템
                </li>
                <li>
                    <strong>설치위치</strong>
                    경감02지구
                </li>
                <li blue>
                    <strong>설치일자</strong>
                    21.11.15 00:00
                </li>
            </ul>
        </div>
        <div class="layer-base-conts">
            <p class="layer-base-tit">방송 안내 문구</p>
            <div class="broadcast-form">
                <div class="broadcast-form-top">
                    <select name="">
                        <option value="">방송 안내 문구를 선택하세요</option>
                        <option value="">전방 급경사 낙석 발생</option>
                        <option value="">안내 방송 테스트입니다</option>
                        <option value="">직접입력</option>
                    </select>
                    <a href="javascript:void(0);" class="btns">방송하기</a>
                </div>

                <textarea name="" placeholder="방송 안내 문구를 입력하세요"></textarea>
            </div>
        </div>
    </div>

    <div id="chart-popup" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_full.png" data-fancybox-full alt="전체화면"></a>
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="modal-header" style="margin-bottom: 10px">
            <div class="filter-area" style="margin-right: 150px; margin-bottom: 10px">
                <div style="display:flex;">
                    <p class="search-top-label">조회기간</p>
                    <input id="start-date" type="datetime-local"/>
                </div>
                <div style="display:flex;">
                    <p class="search-top-label">~</p>
                    <input id="end-date" type="datetime-local"/>
                </div>
                <div class="btn-group3">
                    <a id="graph-search-btn" data-fancybox data-src="">조회</a>
                </div>
            </div>
        </div>
        <div class="layer-base-conts min bTable">
            <div class="graph-area" style="height: 500px">
                <canvas id="myChart"></canvas>
            </div>
        </div>
    </div>

    <div id="lay-cctv-view" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);" class="fullscreen"><img src="/images/btn_lay_full.png" data-fancybox-full
                                                                  alt="전체화면"/></a>
            <a href="javascript:void(0);" class="closeCctv"><img src="/images/btn_lay_close.png" data-fancybox-close
                                                                 alt="닫기"/></a>
        </div>
        <div class="layer-base-title icon cctv"></div>
        <div class="layer-base-conts nosignal">
            <div class="container">
                <div class="title" data-text="No Signal">No Signal</div>
            </div>
            <img src="" alt="CCTV" style="position:relative; z-index: 10;"/>
        </div>
    </div>

    <div id="lay-edit-mode" class="layer-alarm">
        <div class="layer-alarm-btns">
            <a href="javascript:popFancyClose();"><img src="/images/btn_lay_close.png" alt="닫기"/></a>
        </div>
        <div class="layer-alarm-conts">
            <p class="tit">센서 위치관리</p>
            <p class="txt">
                <strong point>EDIT MODE</strong>로 변환 하시겠습니까?
            </p>
            <p class="btn">
                <a href="javascript:editMode('open');" blue>예</a>
                <a href="javascript:popFancyClose();">아니오</a>
            </p>
        </div>
    </div>

    <div class="edit-mode-use">
        <p class="tit">Edit Mode를 사용중입니다.</p>
        <p class="btn">
            <a href="javascript:editMode('save');" blue>저장</a>
            <a href="javascript:editMode('close');">취소</a>
        </p>
    </div>

</section>
</body>
</html>
