<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>

    <style>
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

        /* #site-status.view .site-status-details {
            display: initial;
        } */

        .rv_marker {
            display: none;
            width: 40px;
            height: 44px;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 40px;
            height: 44px;
            pointer-events: none;
        }

        .marker.weather {
            font-size: 13px;
            background: rgba(255, 255, 255, 0.8);
            padding: 10px;
            border-radius: 5px;
            color: #000;
            border: 1px solid #ccc;
        }

        .marker.zone {
            width: 32px;
            height: 50px;
            top: 50px;
            position: relative;
            /* margin-left: -5px; */
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
            /* margin-left: -5px; */
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

        .ol-overlay-container.ol-selectable {
            z-index: 0;
            -ms-user-select: none;
            -moz-user-select: -moz-none;
            -khtml-user-select: none;
            -webkit-user-select: none;
            user-select: none;
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
    </style>

</head>
<script>
    // const ALARM_LATENCY = 30 * 1000; // 30초 마다
    const LATENCY = 60 * 1000; // 1분마다
    const ALARM_EFFECT_TIME = 500;
    const MARKER_CHANGE_LEVEL = 17.5;
    let wsUrl = 'ws://localhost:8080';
    let cctvWs; // cctv websocket

    if (window.location.href.indexOf('106.245') > -1) { // 테스트서버
        wsUrl = 'ws://106.245.95.116:6099';
    } else if (window.location.href.indexOf('121.159') > -1) { // 진천서버
        wsUrl = 'ws://121.159.33.107:9090';
    }

    // let _weatherCode = [
    //     { "name" : "감포읍", "lat" : 35.806238	, "lng" : 129.478526, "code" : 4713025000},
    //     { "name" : "안강읍", "lat" : 35.981397	, "lng" : 129.184153, "code" : 4713025300},
    //     { "name" : "건천읍", "lat" : 35.831737	, "lng" : 129.103245, "code" : 4713025600},
    //     { "name" : "외동읍", "lat" : 35.712278	, "lng" : 129.313413, "code" : 4713025900},
    //     { "name" : "양북면", "lat" : 35.798579	, "lng" : 129.413944, "code" : 4713031000},
    //     { "name" : "양남면", "lat" : 35.704082	, "lng" : 129.417765, "code" : 4713032000},
    //     { "name" : "내남면", "lat" : 35.7476	, "lng" : 129.174754, "code" : 4713033000},
    //     { "name" : "산내면", "lat" : 35.749125	, "lng" : 129.037357, "code" : 4713034000},
    //     { "name" : "서면",  "lat" : 35.896736	, "lng" : 129.065466, "code" : 4713035000},
    //     { "name" : "현곡면", "lat" : 35.896781	, "lng" : 129.169965, "code" : 4713036000},
    //     { "name" : "강동면", "lat" : 35.995421	, "lng" : 129.272166, "code" : 4713037000},
    //     { "name" : "천북면", "lat" : 35.90431	, "lng" : 129.27671,  "code" : 4713038000},
    //     { "name" : "중부동", "lat" : 35.842076	, "lng" : 129.206254, "code" : 4713051500},
    //     { "name" : "황오동", "lat" : 35.84208	, "lng" : 129.220168, "code" : 4713053000},
    //     { "name" : "성건동", "lat" : 35.851076	, "lng" : 129.204785, "code" : 4713055000},
    //     { "name" : "황남동", "lat" : 35.834096	, "lng" : 129.212884, "code" : 4713057000},
    //     { "name" : "선도동", "lat" : 35.84364	, "lng" : 129.174852, "code" : 4713059000},
    //     { "name" : "월성동", "lat" : 35.836542	, "lng" : 129.219651, "code" : 4713060500},
    //     { "name" : "용강동", "lat" : 35.871726	, "lng" : 129.232205, "code" : 4713061500},
    //     { "name" : "황성동", "lat" : 35.868609	, "lng" : 129.215182, "code" : 4713062100},
    //     { "name" : "동천동", "lat" : 35.850882	, "lng" : 129.237196, "code" : 4713063000},
    //     { "name" : "불국동", "lat" : 35.775237	, "lng" : 129.300534, "code" : 4713065000},
    //     { "name" : "보덕동", "lat" : 35.834681	, "lng" : 129.287448, "code" : 4713066000}
    // ];

    try {
        // 공통코드 자산종류 가져오기
        var _assetKind = ${assetKind};
        var _areaInfo = ${areaInfo};
    } catch (e) {
    }

    window.isRoadView = false;
    window.marker = {};
    window.marker.zone = [];
    window.marker.asset = [];
    window.marker.risk = [];
    window.zoneDetail = {};

    // [s] jquery
    $(function () {
        const autoLogin = JSON.parse(localStorage.getItem('autoLogin'));

        if (autoLogin) {
            localStorage.setItem('loginSuccess', true);
        }
        window.vworld = new vwutil({
            mapId: "map",
            initPosition: {
                center: [
                    // 126.88624657982738, 37.480957215573261
                    // 129.31891142635524, 35.82755842582624
                    // 127.449482276989, 36.9317789946793
                    _areaInfo.lng, _areaInfo.lat
                ],
                zoom: _areaInfo.zoom,
                // zoom: 15,
                rotation: 0.5
            }
        });

        window.vworld.vwmap2d();

        $(document).on('click', '.map-2d-btn', function () {
            if (window.vworld.map.type == '2D') {
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

        $(document).on("click", ".right-utill .roadview", function () {           // 로드뷰 열기/닫기
                                                                                  // if (window.vworld.map.type != '2D') {
                                                                                  //     alert('로드뷰 기능은 2D 맵에서만 사용하실 수 있습니다.');
                                                                                  //     $(this).removeClass("active");
                                                                                  //     $(".roadViewContainer").removeClass("open");
                                                                                  //     return;
                                                                                  // }

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

            clearInterval(window.zoneDetail);
        });

        function getToggleStatus(uid) {
            let assetId = null;
            $.each(window.vworld.overlays, function () {
                if (this.uid == uid) {
                    assetId = this.asset_id;
                    return false;
                }
            });

            return $('.site-zone-list li[asset_id=' + assetId + '] p.check-box input').is(':checked');
        }

        $(document).on('map_action_end', debounce(function (e) {
            if ($('.roadview').hasClass('active')) {
                window.isRoadView = true;
            }

            if ($('.site-status-list select.selectZone option:selected').val() == '') {
                $.each(window.marker.zone, function () {
                    window.vworld.visibleOverlay(this, true);
                });

                $.each(window.marker.asset, function () {
                    window.vworld.visibleOverlay(this, false);
                });
            } else {
                if (window.vworld.getZoom() >= MARKER_CHANGE_LEVEL) {
                    $.each(window.marker.zone, function () {
                        window.vworld.visibleOverlay(this, false);
                    });

                    $.each(window.marker.asset, function () {
                        if (getToggleStatus(this)) {
                            window.vworld.visibleOverlay(this, true);
                        }
                    });
                } else {
                    $.each(window.marker.zone, function () {
                        window.vworld.visibleOverlay(this, true);
                    });

                    $.each(window.marker.asset, function () {
                        window.vworld.visibleOverlay(this, false);
                    });
                }
            }

            if (window.vworld.map.type == '2D') {
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
            // console.log(data);

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

        $(document).on('overlay_click', function (e, data) {
            if ($("#wrap").hasClass("editMode"))
                return;

            if (data.type == 'sensor') {                // 센서 선택시
                openSensorInfo(data);
            } else if (data.type == 'cctv') {           // cctv 선택시
                openCctvPopup(data);
            } else {
                if ($(data.htmlContent).hasClass('zone')) {                 // 지구 아이콘 선택시
                    // console.log(data);
                    $('.site-status-list select.selectZone option[value=' + data.zone_id + ']').prop('selected', true);
                    $('.site-status-list select.selectZone').trigger('change');
                    //      window.vworld.setPanBy(data.coords, 18);
                }
            }
        });

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

        // 지구현황 자산 리스트 클릭시
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

        // 알람판 클릭시,
        $(document).on('click', '.right-alarm_re p.icon, .right-alarm_re dl', function () {
            const coords = $(this).closest('div.right-alarm_re').data('coords').split(',');
            const zoneId = $(this).closest('div.right-alarm_re').data('zoneid');
            const assetId = $(this).closest('div.right-alarm_re').data('assetid');

            console.log('right-alram', coords, zoneId, assetId);

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

        initDashboard();
    });

    // [e] jquery

    function markerVisible(asset_id, visible) {
        $.each(window.vworld.overlays, function () {
            if (typeof this['asset_id'] != 'undefined') {
                if (this.asset_id == asset_id) {
                    window.vworld.visibleOverlay(this.uid, visible);
                    return false;
                }
            }
        });
    }

    function editMode(type) { // editMode 열고 닫기
        let markers = window.vworld.getMap().getOverlays().getArray();

        if (type === "open") {
            popFancyClose();
            $("#wrap").addClass("editMode");
            $(".right-utill .editmode").addClass("active");

            $.each(markers, function () {
                let m = this;

                $(m.getElement()).on('mousedown', function (evt) {
                    $(m.getElement()).addClass('positionChange');

                    $(m.getElement()).on('dragstart', function (evt) {
                        evt.preventDefault();  // 기본 dragstart 동작 방지
                    });

                    function move(evt) {
                        m.setPosition(window.vworld.getMap().getEventCoordinate(evt));
                    }

                    function end(evt) {
                        window.removeEventListener('mousemove', move);
                        window.removeEventListener('mouseup', end);

                        $(m.getElement()).off('dragstart');
                    }

                    window.addEventListener('mousemove', move);
                    window.addEventListener('mouseup', end);
                });
            });
        } else if (type == "close") {
            $("#wrap").removeClass("editMode");
            $(".right-utill .editmode").removeClass("active");

            // 위치의 원복
            $.each(window.vworld.overlays, function () {
                let o = this;
                window.vworld.setPositionOverlay(o.uid, o.coords);
            });

            $.each(markers, function () {
                $(this.getElement()).off('mousedown');
            });

            alert("취소 되었습니다.");
        } else if (type == "save") {
            $("#wrap").removeClass("editMode");
            $(".right-utill .editmode").removeClass("active");

            let totalCnt = $('div.positionChange').length;
            let saveCnt = 0;

            // 위치의 저장
            // vwutil overlay 의 값을 현재 오버레이들의 위치로 변경하고 DB에 저장
            $.each($('div.marker.zone.positionChange'), function () {
                let $m = $(this);
                let coords = window.vworld.getPositionOverlay($m.attr('uid'));

                $.get('/setZoneLocation', {
                    zone_id: $m.attr('zoneid'),
                    lat: coords[1],
                    lng: coords[0]
                }, function (res) {
                    // console.log(res);

                    $.each(window.vworld.overlays, function () {
                        if (this.uid == $m.attr('uid')) {
                            this.coords = coords;
                        }
                    });

                    saveCnt++;

                    if (saveCnt >= totalCnt) {
                        alert('저장 되었습니다.');
                    }
                });
            });

            $.each($('div.marker.asset.positionChange'), function () {
                let $m = $(this);
                let coords = window.vworld.getPositionOverlay($m.attr('uid'));

                $.get('/setAssetLocation', {
                    asset_id: $m.attr('assetid'),
                    lat: coords[1],
                    lng: coords[0]
                }, function (res) {
                    // console.log(res);

                    $.each(window.vworld.overlays, function () {
                        if (this.uid == $m.attr('uid')) {
                            this.coords = coords;
                        }
                    });

                    saveCnt++;

                    if (saveCnt >= totalCnt) {
                        alert('저장 되었습니다.');
                    }
                });
            });

            $.each(markers, function () {
                $(this.getElement()).off('mousedown');
            });
        }
    }

    // function refrashDongWeather() {
    //     $.each(_weatherCode, function() {
    //         try {
    //             let area = this;
    //             $.get('/weather/today/' + area.code, function(res) {
    //                 // console.log(res);
    //                 area = Object.assign(area, res);
    //             }).error(function(jqXHR, textStatus, errorThrown) {
    //                 console.log('ERROR - ' + textStatus);
    //             });
    //         } catch(e) {
    //             console.log('ERROR - ' + area);
    //         }
    //     });     // 동별 날씨정보 가져오기
    // }

    function initDashboard() {
        initZoneSelect();                   // 현장내 지구 리스트
        initSiteZone();

        // refrashDongWeather();
        // setInterval(function() {
        //     refrashDongWeather();
        // }, 300 * 1000);

        loadAlarm();
    }

    function initZoneSelect() {
        $.get('/getZoneList', {use_flag: 'Y'}, function (res) {
            $('select.selectZone').empty();
            $('select.selectZone').append('<option value="">지구 선택</option>');

            // 지구 마커 표시
            $.each(res, function () {
                $('select.selectZone').append('<option value="' + this.zone_id + '" lat="' + this.lat + '" lng="' + this.lng + '">' + this.name + '</option>');

                let zone = this;
                $.get('/getAssetList', {zone_id: zone.zone_id}, function (res) {
                    window.marker.zone.push(window.vworld.addOverlay(
                        '<div class="marker zone" zoneid="' + zone.zone_id
                        + '"><img src="/images/icon_area1.png"/><span class="count">' + res.length
                        + '</span><span class="title">' + zone.name + '</span></div>', [zone.lng, zone.lat],
                        '/images/icon_area1.png', zone.name, res.length, {type: 'area', zone_id: zone.zone_id}));
                    redrawMarker();
                });

                loadMarker(zone.zone_id, [zone.lng, zone.lat]);
            });

            // 지구 선택시
            // 해당 지구으로 지도 이동 후 줌 처리하고
            // 상세 표기 버튼 활성화 시킨다
            // 지구 선택시 해당 지구의 강우량 표기
            $('select.selectZone').off().on('change', function () {
                let $selected = $("option:selected", this);
                const zoneId = $selected.val();

                $('.rain-info').hide();

                if ($selected.index() > 0) {
                    $('.rain-info').show();
                    $('.site-status-toggle').addClass('active')

                    $.get('/getAssetList', {zone_id: zoneId}, function (res) {
                        $('.zoneSelected').data('zoneid', zoneId);

                        $('.site-zone-list li .site-zone-conts ul').empty();

                        $.each(res, function (idx, ele) {
                            // console.log(res);
                            if (ele.asset_kind_id === '4') {
                                // console.log(ele.real_value);
                                $('.rain-info span').html(ele.real_value + " mm");
                            }


                            let status = window.marker.risk.find(r => r.zone_id == zoneId && r.asset_id == ele.asset_id);

                            let fc_step = !!status?.risk_level ? 'fc_step' + status.risk_level : '';

                            // console.log(status, ele);

                            let html = '';

                            html += '<li ' + fc_step + ' asset_id="' + ele.asset_id + '">';
                            html += '<a href="javascript:void(0);" data-coords="' + ele.x + ',' + ele.y + '">' + ele.name + '</a>' +
                                '<div><i class="fa-regular fa-eye"></i>　' +
                                '<p class="check-box" notxt="" small=""><input type="checkbox" id="check_conts01_' + idx + '" name="check_conts01_' + idx + '" value="" checked>';
                            html += '<label for="check_conts01_' + idx + '"><span class="graphic"></span></label></p></div></li>';

                            console.log(ele.name, ele.asset_kind_id);
                            $('.site-zone-list li[kind=' + ele.asset_kind_id + '] .site-zone-conts ul').append(html);
                        });

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

                if ($('div.site-status-toggle.active > button').hasClass("show") && $selected.val() > 0) {
                    getZoneDetail();
                }
            });
        });
    }

    // 자산 종류 출력
    function initSiteZone() {
        $('.site-zone-area ul.site-zone-list').empty();

        $.each(_assetKind, function (idx) {
            let html = '<li kind="' + this.code + '"><div class="site-zone-title"><strong><i id="arrow-up" class="fa-solid fa-arrow-up fa-xl arrow-up" style="color: #ffffff; margin-right: 10px; cursor: pointer;"></i>' + this.name + '</strong><p class="check-box" notxt="" small="">';
            html += '<input type="checkbox" checked id="check_tit01_' + idx + '" name="check_tit01_' + idx + '" value=""><label for="check_tit01_' + idx + '"><span class="graphic"></span></label></p></div>';
            html += '<div class="site-zone-conts"><ul></ul></div></li>';
            $('.site-zone-area ul.site-zone-list').append(html);
        });
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

    function loadMarker(zone_id, default_coords) {
        $.get('/getMarkerList', {zone_id: zone_id}, function (res) {
            $.each(res, function (idx) {
                let img = '';
                let type = 'sensor';

                if (this.name == '구조물경사계') {
                    img = 'icon_sensor_tm.png';
                } else if (this.name == '강우량계') {
                    img = 'icon_sensor_p.png';
                } else if (this.name == '지표변위계') {
                    img = 'icon_sensor_s.png';
                } else if (this.name == 'CCTV') {
                    img = 'icon_cctv.png';
                    type = 'cctv';
                } else if (this.name == '재난방송') {
                    img = 'icon_speaker.png';
                    type = 'speaker';
                } else if (this.name == '전광판') {
                    img = 'icon_text.png';
                    // type = 'display';
                } else if (this.name.indexOf('지하수위계') > -1) {
                    img = 'icon_sensor_ttw.png';
                }

                let coords;
                if (this.x == null && this.y == null) {
                    coords = default_coords;
                } else {
                    coords = [this.x, this.y];
                }

                let uid = window.vworld.addOverlay(
                    '<div class="marker asset" zoneid="' + this.zone_id + '" assetid="' + this.asset_id
                    + '"><img src="/images/' + img + '"/><span class="title">' + this.asset_name
                    + '</span></div>', coords,
                    '/images/' + img, this.asset_name, null, {
                        type: type,
                        asset_id: this.asset_id,
                        zone_id: this.zone_id,
                        etc1: this.etc1
                    });

                window.marker.asset.push(uid);
                window.vworld.visibleOverlay(uid, false);
            });
        });
    }

    function getAlarmCard(item) {
        // 0: 안전, 1: 관심, 2: 주의, 3: 경계, 4: 심각
        let html = '<div class="right-alarm_re" step' + item.risk_level + '="" data-zoneid="' + item.zone_id + '" data-coords="' + item.x + ',' + item.y + '" data-assetid="' + item.asset_id + '">';
        html += '<button type="button" class="close-alarm"><img src="/images/close-alarm.png" alt="close"></button>';

        let icon_name = '';

        // sensor, alarm, cctv, warning, disaster, maintenance, admin, dashboard
        if (item.alarm_type == '통신이상') {
            icon_name = 'disaster';
        } else {
            icon_name = 'alarm';
        }

        html += '<p class="icon"><span data-type="' + icon_name + '"></span></p><dl>';
        html += '<dt>' + item.alarm_type + '<br/>' + item.zone_name + '</dt><dd>' + item.asset_kind_name + ' ' + item.asset_name + '<br/><span point="">' + item.alarm_desc + '</span>';
        html += '<p class="small">' + formatTimestamp(item.reg_date) + '</p></dd></dl></div>';
        return html;
    }

    function loadAlarm() {
        if (typeof window.lastAlarmDate == 'undefined') {
            window.lastAlarmDate = ((new Date()).getTime()) - LATENCY;
        }

        $.get('/getAlarm', {
            reg_date: window.lastAlarmDate
        }, function (res) {
            // console.log(res);

            if (res.length > 0) {
                window.lastAlarmDate = res[0].reg_date;
                $.each(res, function () {
                    let $card = $(getAlarmCard(this)).hide();
                    $('.alarmContainer').prepend($card);
                    $card.fadeIn(ALARM_EFFECT_TIME);
                    $card.timer = setTimeout(function () {
                        $card.find('button.close-alarm').trigger('click');
                    }, LATENCY);      // 1분후
                });

                removeAlarmCard();
            }

            redrawMarker();
        }).always(function () {
            window.lastAlarmDate = (new Date()).getTime();
            setTimeout(loadAlarm, LATENCY); // 60 초마다
        });
    }

    // 지구 현황에 리스트 컬러 변경
    function redrawAssetRiskLevelList() {
        if ($('.zoneSelected').is(":visible") && window.marker.risk.length > 0) {
            const zoneId = $('.zoneSelected').data('zoneid');
            $.each($('.zoneSelected > .site-zone-area > ul.site-zone-list div.site-zone-conts li'), function (idx, ele) {
                $ele = $(ele);
                $ele.removeAttr('fc_step1 fc_step2 fc_step3 fc_step4');

                let status = window.marker.risk.find(r => r.zone_id == zoneId && r.asset_id == $ele.attr('asset_id'));

                if (!!status?.risk_level) {
                    $(ele).attr('fc_step' + status.risk_level, '');
                }

                // console.log(ele, status);
            });
        }

    }

    let redrawMarker = debounce(() => {
        console.log('redrawMarker');
        $.get('/getAssetAlarm', {reg_date: window.lastAlarmDate}, function (res) {
            window.marker.risk = res;

            let zoneArea = {};

            function updateLabelStyle(target, riskLevel) {
                const color = riskLevel !== undefined ? getRiskColor(riskLevel) : {fc: '#000000', bg: '#ffffff'};
                window.vworld.setLabelStyle(target.uid, color.fc, color.bg, 1.0);
            }

            $.each(res, function () {
                let alarm = this;
                $.each(window.vworld.overlays, function () {
                    if (this.asset_id === alarm.asset_id) {
                        updateLabelStyle(this, alarm.risk_level);
                    } else if (alarm.zone_id === this.zone_id && this.type === 'area') {
                        if (alarm.risk_level !== undefined) {
                            const currentRiskLevel = parseInt(zoneArea['area_' + alarm.zone_id]?.risk_level || 0);
                            const alarmRiskLevel = parseInt(alarm.risk_level);
                            if (alarmRiskLevel > currentRiskLevel) {
                                zoneArea['area_' + alarm.zone_id] = {
                                    zone_id: alarm.zone_id,
                                    risk_level: alarm.risk_level
                                };
                            }
                        } else {
                            updateLabelStyle(this, undefined); // 정상일때
                        }
                    }
                });
            });

            $.each(window.vworld.overlays, function () {
                if (this.type === 'area') {
                    let zoneKey = 'area_' + this.zone_id;
                    if (zoneArea[zoneKey] && 'risk_level' in zoneArea[zoneKey]) {
                        updateLabelStyle(this, zoneArea[zoneKey].risk_level);
                    } else {
                        updateLabelStyle(this, undefined); // 정상일때
                    }
                }
            });

            redrawAssetRiskLevelList();
        });
    }, 250);

    function getRiskColor(risk_level) {
        let bgcolor = '#ffffff';
        let fontColor = '#000000';
        if (risk_level == '1') {
            bgcolor = '#90da00';
        } else if (risk_level == '2') {
            bgcolor = '#ffd200';
        } else if (risk_level == '3') {
            bgcolor = '#ff9600';
        } else if (risk_level == '4') {
            bgcolor = '#ff0000';
            fontColor = '#ffffff';
        } else {
            bgcolor = '#ffffff';
            fontColor = '#000000';
        }

        return {bg: bgcolor, fc: fontColor};
    }

    function removeAlarmCard() {
        if ($('.alarmContainer div').length > 5) {
            let $lastCard = $('.alarmContainer div:last');
            $lastCard.fadeOut(ALARM_EFFECT_TIME, function () {
                $lastCard.remove();

                removeAlarmCard();
            });
        }
    }

    function getZoneDetail() {
        // 상세 보기 에서 시간 맞추기 위해 초기화
        clearInterval($setInterval1);
        clearInterval(window.zoneDetail);
        $setInterval1 = setInterval(startInterval, LATENCY); // 60초마다

        $.get('/popup/zoneDetail', {
            zone_id: $('.site-status-list select.selectZone option:selected').val()
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

    // cctv 팝업
    function openCctvPopup(data) {
        $('#lay-cctv-view .layer-base-conts img').hide();
        $('#lay-cctv-view .layer-base-title').html(data.label);

        cctvWs = new WebSocket(wsUrl + '/video/stream?url=' + data.etc1);
        // console.log(cctvWs);
        cctvWs.onerror = function (event) {
            $('#lay-cctv-view .layer-base-conts img.nosignal').show();

        };
        cctvWs.onmessage = function (event) {
            let blob = new Blob([event.data], {type: "image/jpeg"});
            let url = URL.createObjectURL(blob);
            let video = $('#lay-cctv-view .layer-base-conts img')[0];
            video.src = url;

            if (!$('#lay-cctv-view .layer-base-conts img').is(':visible')) {
                $('#lay-cctv-view .layer-base-conts img').show();
            }

            try {
                video.src = url;
                // 객체 URL을 해제하여 메모리 누수 방지
                setTimeout(() => {
                    URL.revokeObjectURL(url);
                }, 100);
            } catch (e) {
                console.log('socket close');
            }
        };

        // backdropClick 배경을 눌렀을 때 발생하는 event
        popFancy('#lay-cctv-view', {dragToClose: false, touch: false, backdropClick: false});
    }
</script>

<body data-pgcode="0000">
<section
        id="wrap">
    <!-- [s] 상단 -->
    <jsp:include page="common/include_top.jsp" flush="true"></jsp:include>
    <!--[e] 상단 -->

    <!--[s] 왼쪽 메뉴 -->
    <div
            id="global-menu">
        <!--[s] 주 메뉴 -->
        <jsp:include page="common/include_sidebar.jsp" flush="true"></jsp:include>
        <!--[e] 주 메뉴 -->

        <!--[s] 종합 현황 내역 -->
        <jsp:include page="layout/total_status.jsp" flush="true"></jsp:include>
        <!--[e] 종합 현황 내역 -->

        <!--[s] 현장 현황 부분 -->
        <div id="site-status">
            <!--[s] 현장 현황 -->
            <div class="site-status-list">
                <div class="status-container">
                    <div class="title">
                        <span>지구 현황</span>
                    </div>
                    <div class="rain-info" style="display: none">
                        <img src="images/weather/rain_ic.png"/>
                        <span></span>
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
            <!--[s] 토글 버튼 -->
            <div class="site-status-toggle">
                <button type="button" class="overall-status-btn">
                    <span class="f_arr">←</span>
                </button>
            </div>
            <!--[e] 토글 버튼 -->
            <!--[e] 현장 현황 -->

            <div class="site-status-details">
            </div>
        </div>
        <!--[e] 현장 현황 부분 -->
    </div>
    <!--[e] 왼쪽 메뉴 -->

    <!--[s] 우측 알람 -->
    <div id="right-alarm" class="alarmContainer">

    </div>
    <!-- [e] 우측 알람 -->

    <!-- [s] 맵 영역 -->
    <div id="map"></div>
    <div class="map_typecontrol">
                <span id="btnSatmap" class="btn map-sat-btn"><img src="/images/map_sky.jpg" alt=""/><i>항공 지도</i>
                </span>
        <span id="btnRoadmap" class="selected_btn map-2d-btn"><img src="/images/map_2d.jpg" alt=""/><i>2D 지도</i>
                </span>
        <span id="btnSkyview" class="btn map-3d-btn"><img src="/images/map_3d.jpg" alt=""/><i>3D 지도</i>
                </span>
    </div>

    <!-- 로드뷰 -->
    <div class="roadViewContainer" id="road-map">
        <button type="button" class="road-map-close">
            <img src="/images/btn_lay_close.png" alt="닫기"/>
        </button>
        <div class="roadView"></div>
        <!-- <img src="/images/img_roadmap.jpg" class="road-map" alt=""/> -->
    </div>
    <!-- [e] 맵 영역 -->

    <!--[s] 오늘의 날씨 팝업 -->
    <div id="lay-weather-area" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
        </div>
        <div class="layer-base-title">오늘의 날씨</div>
        <div
                class="layer-base-conts" style="height: 700px;">
            <!-- api 불러와 주세요 -->
            <!-- <img src="/images/img_weather_lay.png" alt="오늘의 날씨"/> -->
            <iframe src="https://www.weather.go.kr/w/weather/forecast/short-term.do?nolayout=Y#dong/4375035000"
                    width="100%" height="100%" frameborder="0" style="padding: 10px">
            </iframe>
        </div>
    </div>
    <!--[e] 오늘의 날씨 팝업 -->

    <!--[s] 기상특보 팝업 -->
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
    <!--[e] 기상특보 팝업 -->

    <!--[s] 센서정보 팝업 -->
    <div id="lay-sensor-info" class="layer-base">
        <div class="layer-base-btns">
            <!-- <a href="javascript:void(0);"><img src="/images/btn_lay_full.png" data-fancybox-full alt="전체화면"/></a> -->
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
        </div>
        <div class="layer-base-title icon">
            센서정보
        </div>
    </div>
    <!--[e] 센서정보 팝업 -->

    <!--[s] [맵 클릭] CCTV 팝업 -->
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
    <!--[e] [맵 클릭] CCTV 팝업 -->

    <!--[s] [맵 클릭] 재난 방송 시스템 -->
    <div id="lay-disaster-broadcast" class="layer-base">
        <div class="layer-base-btns">
            <!-- <a href="javascript:void(0);"><img src="/images/btn_lay_full.png" data-fancybox-full alt="전체화면"/></a> -->
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
    <!--[e] [맵 클릭] 재난 방송 시스템 -->

    <!--[s] EDIT MODE 팝업 -->
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
    <!--[e] EDIT MODE 팝업 -->

    <!--[s] EDIT MODE 사용중 -->
    <div class="edit-mode-use">
        <p class="tit">Edit Mode를 사용중입니다.</p>
        <p class="btn">
            <a href="javascript:editMode('save');" blue>저장</a>
            <a href="javascript:editMode('close');">취소</a>
        </p>
    </div>
    <!--[e] EDIT MODE 사용중 -->
</section>
</body>

</html>
