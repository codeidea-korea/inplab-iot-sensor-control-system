<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript">
    let $alarmGrid, $sensorGrid, $cctvGrid, $deviceGrid, $alarmHistoryGrid, $setInterval0, $setInterval1, $setInterval2;

    // const alarmInterval = function () {
    //     loadAlarmCount();           // 알람현황 횟수
    // }

    const startInterval = function () {
        loadAlarmCount();           // 알람현황 횟수
        loadSystemCount()           // 시스템 상태
        loadAlarmHistory();         // 알람 이력
    };

    const weatherInterval = function () {
        loadSpecialWeatherInfo();   // 금일 기상특보 현황
        loadWeatherInfo();          // 현재 기상현황
    }

    $(function () {
        google.charts.setOnLoadCallback(drawChart);

        // alarmInterval();
        startInterval();
        weatherInterval();
        // $setInterval0 = setInterval(alarmInterval, ALARM_LATENCY); // 30초 마다
        $setInterval1 = setInterval(startInterval, LATENCY); // 60초 마다
        $setInterval2 = setInterval(weatherInterval, 60 * 60 * 1000); // 60분 마다

        // 각 알람 현황 클릭시
        $('.overall-status-area .donutty-area li').off().on('click', function () {
            let level = $(this).attr('level');
            // console.log(level);

            if (typeof $alarmGrid != 'undefined') {
                $alarmGrid.destroy();
            }

            setTimeout(() => {
                $.get('/alarmDataByLevel/columns' , function (res) {
                    //애초에 레벨에 맞게 리스트를 보여줌, 필요없는 컬럼
                    delete res.risk_level;
                    res.zone_id.width = 150;
                    res.asset_kind_name.width = 150;
                    res.asset_name.width = 150;
                    $alarmGrid = jqgridUtil($('.gridAlarm'), {
                        listPathUrl: "/alarmDataByLevel",
                        risk_level: level,
                        view_flag : 'Y'
                    }, res, true, null, null);

                    $alarmGrid.jqGrid('setGridParam', {
                        beforeRequest: function() {
                            let currentParams = {
                                listPathUrl: "/alarmDataByLevel",
                                risk_level: level,
                                view_flag : 'Y'
                            };

                            let p = Object.assign($alarmGrid.jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                                return !!this.value;
                            }).serializeObject());

                            $alarmGrid.setGridParam({
                                postData: Object.assign(p, currentParams)
                            });
                        },
                        ondblClickRow: function (rowId) {
                            $alarmGrid.find('tr').removeClass('custom_selected');
                            var rowData = $(this).getRowData(rowId);
                            // console.log(rowData);
                            openSensorInfo(rowData);
                        }
                    });
                    $alarmGrid.trigger('reloadGrid');
                });
            }, 100);

            popFancy('#lay-alarm-info', { dragToClose : false, touch : false });
        });

        $('.overall-status-area .hang.status-number dl').off().on('click', function () {
            alert('개발진행 중입니다');
        });

        //시스템 상태 > 계측기 상태 클릭시
        $('.sensor.status-number dl').off().on('click', function () {
            let status = $(this).attr('status');
            // console.log(status);
            if (status === "1") {
                $('#lay-sensor-status-list .layer-base-title').html("수신 센서 리스트");
            } else if (status === "2") {
                $('#lay-sensor-status-list .layer-base-title').html("미수신 센서 리스트");
            } else {
                $('#lay-sensor-status-list .layer-base-title').html("전체 센서 리스트");
            }

            if (!!$sensorGrid) {
                $sensorGrid.destroy();
            }

            setTimeout(() => {
                $.get('/admin/sensorByChannelList/columns', function (res) {
                    res.zone_name.width = 90;
                    res.ch_collect_date.width = 300;
                    res.collect_date.type = 'hidden';
                    res.real_value.type = 'hidden';
                    $sensorGrid = jqgridUtil($('.gridSensor'), {
                        listPathUrl: "/admin/sensorByChannelList",
                        status: status
                    }, res, true, null, null);
                    $sensorGrid.jqGrid('setGridParam', {
                        beforeRequest: function () {
                            let currentParams = {
                                listPathUrl: "/admin/sensorByChannelList",
                                status: status
                            };

                            let p = Object.assign($sensorGrid.jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                                return !!this.value;
                            }).serializeObject());

                            $sensorGrid.setGridParam({
                                postData: Object.assign(p, currentParams)
                            });
                        },
                        ondblClickRow: function (rowId) {
                            $sensorGrid.find('tr').removeClass('custom_selected');
                            var rowData = $(this).getRowData(rowId);
                            // console.log(rowData);
                            openSensorInfo(rowData);
                        }
                    });
                    $sensorGrid.trigger('reloadGrid');
                });
            }, 100);

            popFancy('#lay-sensor-status-list', { dragToClose : false, touch : false });
        });

        //시스템 상태 > CCTV 상태 클릭시
        $('.cctv.status-number dl').off().on('click', function () {
            let status = $(this).attr('status');
            // console.log($(this).attr('column-id'));
            if (status === "1") {
                $('#lay-cctv-status-list .layer-base-title').html("수신 CCTV 리스트");
            } else if (status === "2") {
                $('#lay-cctv-status-list .layer-base-title').html("미수신 CCTV 리스트");
            } else {
                $('#lay-cctv-status-list .layer-base-title').html("전체 수신 CCTV 리스트");
            }

            if (typeof $cctvGrid != 'undefined') {
                $cctvGrid.destroy();
            }

            setTimeout(() => {
                $.get('/cctv/columns', function (res) {
                    delete res.collect_date;
                    delete res.real_value;
                    res.etc1.width = 535;
                    $cctvGrid = jqgridUtil($('.gridCCTV'), {
                        listPathUrl: "/cctv",
                        status: status
                    }, res, true, null, null);
                    $cctvGrid.jqGrid('setGridParam', {
                        beforeRequest: function () {
                            let currentParams = {
                                listPathUrl: "/cctv",
                                status: status
                            };

                            let p = Object.assign($cctvGrid.jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                                return !!this.value;
                            }).serializeObject());

                            $cctvGrid.setGridParam({
                                postData: Object.assign(p, currentParams)
                            });
                        },
                        ondblClickRow: function (rowId) {
                            var rowData = $(this).getRowData(rowId);
                            // console.log(rowData);
                            openCctvPopup({label:rowData.name, etc1:rowData.etc1});
                        }
                    });
                    $cctvGrid.trigger('reloadGrid');
                });
            }, 100);

            popFancy('#lay-cctv-status-list', { dragToClose : false, touch : false });
        });

        // 알람 이력 클릭시
        $('.overall-status_re .alarm-list').off().on('click', function () {
            if (typeof $alarmHistoryGrid != 'undefined') {
                $alarmHistoryGrid.destroy();
            }

            setTimeout(()=>{
                $.get('/alarmList/columns' , function (res) {
                    res.zone_id.width = 100;
                    res.risk_level.width = 100;
                    res.asset_kind_name.width = 100;
                    res.asset_name.width = 140;
                    $alarmHistoryGrid = jqgridUtil($('.gridAlarmHistory'), {
                        listPathUrl: "/alarmList"
                    }, res, true, null, null);
                    $alarmHistoryGrid.jqGrid('setGridParam', {
                        ondblClickRow: function (rowId) {
                            $alarmHistoryGrid.find('tr').removeClass('custom_selected');
                            var rowData = $(this).getRowData(rowId);
                            openSensorInfo(rowData);
                        }
                    });
                });
            }, 100)

            popFancy('#lay-alarm-history', { dragToClose : false, touch : false });
        });

        $(document).on('click', '.weather-api', function() {
            popFancy('#lay-weather-area', { dragToClose : false, touch : false });
        });
        $(document).on('click', '.weather-comment', function() {
            popFancy('#lay-weather-area2', { dragToClose : false, touch : false });
        });
    });

    // 장비현황 차트
    function drawChart() {
        $.get('/deviceCount', function (res) {
            var data = google.visualization.arrayToDataTable([
                ['title', 'number', 'key'],
                ['CCTV', res.cctv_count, '8'],
                ['구조물경사계', res.tm_count, '2'],
                ['지표변위계', res.tw_count, '3'],
                ['강우계', res.wr_count, '4']
                // ['기타', res.etc_count, '9']
            ]);

            var options = {
                backgroundColor: '#28293b',
                pieHole: 0.5,
                tooltip: {
                    trigger: 'focus',
                    ignoreBounds : true,
                    textStyle: {
                        fontSize: 13
                    }
                },
                pieSliceBorderColor: '#28293b',
                colors: ['#464ef7', '#63e578', '#f4bd25', '#dd2ac8', '#2ae8d9'],
                chartArea: { width: "90%", height: "90%" },
                legend: { textStyle: { color: '#fff', fontSize: 13, fontName: 'Pretendard' }, width: 144, position: 'outside' },
                pieSliceText: 'value',
            };

            var chart = new google.visualization.PieChart(document.getElementById('piechart'));
            chart.draw(data, options);

            // 이벤트 리스너 추가
            // google.visualization.events.addListener(chart, 'onmouseout', function() {
            //     //the built-in tooltip
            //     var tooltip = document.querySelector('.google-visualization-tooltip:not([clone])');
            //     console.log('tooltip', tooltip);
            // });
            google.visualization.events.addListener(chart, 'ready', function() {
                const svg = document.querySelector("#piechart div > svg");
                svg.style.overflow = "visible";
            });

            google.visualization.events.addListener(chart, 'select', function() {
                var selectedItem = chart.getSelection()[0];

                if (selectedItem) {
                    var selectedValue = data.getValue(selectedItem.row, 2);
                    // alert('선택된 항목: ' + selectedValue);
                    $.get('/admin/assetList/columns', function (res) {
                        delete res.asset_kind_id;
                        delete res.collect_date;
                        delete res.etc1;
                        delete res.etc2;
                        delete res.etc3;
                        res.zone_id.width = 220;
                        res.name.width = 220;
                        res.install_date.width = 220;
                        res.status.width = 220;
                        res.real_value.width = 220;
                        $deviceGrid = jqgridUtil($('.gridDevice'), {
                            listPathUrl: "/admin/assetList",
                            asset_kind_id : selectedValue
                        }, res, true, null, null);
                        $deviceGrid.jqGrid('setGridParam', {
                            beforeRequest: function () {
                                let currentParams = {
                                    listPathUrl: "/admin/assetList",
                                    asset_kind_id : selectedValue
                                };

                                let p = Object.assign($deviceGrid.jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                                    return !!this.value;
                                }).serializeObject());

                                $deviceGrid.setGridParam({
                                    postData: Object.assign(p, currentParams)
                                });
                            },
                            ondblClickRow: function (rowId) {
                                $deviceGrid.find('tr').removeClass('custom_selected');
                                var rowData = $(this).getRowData(rowId);
                                openSensorInfo(rowData);
                            }
                        });
                        $deviceGrid.trigger('reloadGrid');
                    });
                    // 툴팁이 있으면 숨김
                    var tooltip = document.querySelector('.google-visualization-tooltip');
                    if(!!tooltip){
                        tooltip.style.display = "none";
                    }

                    if(!!$deviceGrid){
                        $deviceGrid.destroy();
                    }

                    popFancy('#lay-equipment-area', { dragToClose : false, touch : false });
                }
            });
        });

    }

    // 알림현황 카운트
    function loadAlarmCount() {
        $.get('/alarmList/alarmCount', function (res) {
            var totalLength = 314.1592653589793;
            var values = [
                res.interest_cnt,
                res.notice_cnt,
                res.warning_cnt,
                res.danger_cnt
            ];

            function updateDonutChart(index, value) {
                // if (value > 0) {
                //     $('.overall-status-area .donutty-area li:eq(' + index + ')').css("cursor", "pointer");
                // } else {
                //     $('.overall-status-area .donutty-area li:eq(' + index + ')').off('click');
                // }
                $('.overall-status-area .donutty-area li:eq(' + index + ')').css("cursor", "pointer");
                $('.overall-status-area .donutty-area li:eq(' + index + ') div').attr('data-value', value);
                var offset = totalLength - (totalLength * (value / 100));
                $('.overall-status-area .donutty-area li:eq(' + index + ') .donut-fill').css('stroke-dashoffset', offset);
            }

            for (var i = 0; i < values.length; i++) {
                updateDonutChart(i, values[i]);
            }
        });
    }

    // 시스템 상태
    function loadSystemCount() {
        $.get('/systemCount', function (res) {
                $.each(res, function (i) {
                    if (res.length > 0) $('.overall-status_re .status-number .conts').css("cursor", "pointer");
                    // console.log(res[i]);
                    if (res[i].grouped_asset_kind_id === '2-7') {
                        $('.sensor.status-number dt:eq(0)').html(res[i].total_count);
                        $('.sensor.status-number dt:eq(1)').html(res[i].status_1_count);
                        $('.sensor.status-number dt:eq(2)').html(res[i].status_2_count);
                    } else if (res[i].grouped_asset_kind_id === '8') {
                        $('.cctv.status-number dt:eq(0)').html(res[i].total_count);
                        $('.cctv.status-number dt:eq(1)').html(res[i].status_1_count);
                        $('.cctv.status-number dt:eq(2)').html(res[i].status_2_count);
                    }
                });
        });
    }

    // 지역 날씨
    function loadWeatherInfo() {
        $.get('/weather/today/4375035000', function (res) {
            // console.log(res);
            if (res.wfKor == '구름 많음') {
                $('.weather-img img').attr('src', 'images/weather/mostlycloudy.png');
            } else if (res.wfKor == '비/눈') {
                $('.weather-img img').attr('src', 'images/weather/rainsnow.png');
            } else if (res.wfKor == '빗방울/눈날림') {
                $('.weather-img img').attr('src', 'images/weather/rainsnowdrifting.png');
            } else if (res.wfKor == '눈날림') {
                $('.weather-img img').attr('src', 'images/weather/snowdrifting.png');
            } else {
                $('.weather-img img').attr('src', 'images/weather/' + res.wfEn.toLowerCase() + '.png');
            }

            $('.weather-img span').html(res.temp + ' ℃');

            let detail = res.wfKor + ', 습도 ' + res.reh + ' %<br/>바람 ' + res.wdKor + ' ' 
                + parseFloat(res.ws.substring(0, 4)) + ' m/s';
            
            if (parseFloat(res.pcp) > 0)
                detail += '<br/>시간당 예상 강수량 ' + res.pcp + ' mm';

            $('.weather-detail').html(detail);
        });
    }

    function loadSpecialWeatherInfo() {
        $.get('/weather/special/진천군', function (res) {                        // 기상청 API 허브
            // console.log(res);
            let today = getToday();
            let result = '';
            // $.each(res, function () {
            //     if (res.indexOf(today) > -1) {                                  // 금일 경보만을 출력
            //         result = this.split(',');
            //         return false;
            //     }
            // });

            if (res.length > 0)
                result = res[0].split(',');

            if (result == '') {
                $('.weather-comment').html('현재 발효된 특보가 없습니다.');
            } else if (result.length > 0 ) {
                console.log(result);
                let raisedate = result[4].trim();

                $('.weather-comment').html(raisedate.substring(0, 4) + '년 ' + raisedate.substring(4, 6) +  '월 ' + raisedate.substring(6, 8) +  '일 ' + raisedate.substring(8, 10) +  '시 '
                    + '<br/>' + result[1].trim() + ' ' + result[3].trim() + ' ' + result[6].trim() + ' ' + result[7].trim() + ' ' + (result[8].trim() == '변경' ? '특보' : result[8].trim()));
            } else {
                $('.weather-comment').html('기상 특보 팝업 보기');
            }
        }).fail(function () {
            $('.weather-comment').html('기상 특보 팝업 보기');
        });
    }

    function getToday() {
        var today = new Date();
        var year = today.getFullYear();
        var month = ("0" + (today.getMonth() + 1)).slice(-2);
        var day = ("0" + today.getDate()).slice(-2);

        var date = year + month + day;
    }

    function loadAlarmHistory() {
        $.get('/alarmList/alarmHistory', function (res) {
            if (typeof res != 'undefined') $('.overall-status_re .alarm-list li').empty();
            if (res.length > 0) $('.overall-status_re .alarm-list').css("cursor", "pointer");
            $.each(res, function (idx){
                let contents = '<div style="padding: 1.5rem 0; display: block;">';
                let level = res[idx].risk_level;
                if (level === '1') {
                    contents += '<p class="cate" bc_step1>관심</p>';
                } else if (level === '2') {
                    contents += '<p class="cate" bc_step2>주의</p>';
                } else if (level === '3') {
                    contents += '<p class="cate" bc_step3>경계</p>';
                } else if (level === '4') {
                    contents += '<p class="cate" bc_step4>심각</p>';
                }
                contents += '<p class="title">' + res[idx].asset_name + " " + res[idx].alarm_kind_name + '</p>';
                contents += '<p class="title">' + res[idx].area_name + '</p>';
                contents += '<p class="day">' + res[idx].reg_date + '</p>';
                contents += '</div>';

                $('.overall-status_re .alarm-list li:eq(' + idx + ')').html(contents);
            });
        });
    }

    function openSensorInfo(data) {
        // console.log(data);
        $.get('/popup/sensorInfo', {
            asset_id : data.asset_id
        }, function(layout) {
            $('#lay-sensor-info').html(layout);
            popFancy('#lay-sensor-info', { dragToClose : false, touch : false });
        });
    }

    function downloadExcel(fileName, url) {
        <%--"${path}/excel?start=" + searchDate.start + "&end=" + searchDate.end;--%>
        if (url === undefined || url === null) url = "${path}/excel";
        url = url + '/' + fileName;
        console.log(url);

        var hiddenIFrameId = 'hiddenDownloader';
        var iframe = document.getElementById(hiddenIFrameId);
        if (iframe === null) {
            iframe = document.createElement('iframe');
            iframe.id = hiddenIFrameId;
            iframe.style.display = 'none';
            document.body.appendChild(iframe);
        }
        iframe.src = url;
    }

</script>

<div id="overall-status">
    <button type="button" class="overall-status-btn">
        <span class="f_arr">←</span>
    </button>
    <div class="overall-status-area">
        <div class="title" data-fancybox data-src="#lay-disaster-broadcast">종합 현황 내역</div>
        <!--[s] 내역 반복 박스 -->
        <div class="overall-status_re">
            <div class="title">알람 현황(최근 1분 기준)</div>
            <div class="conts">
                <ul class="donutty-area">
                    <li level="1">
                        <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl" data-anchor="top" data-bg="#37474f" data-color="#90da00" data-value="0"></div>
                        <p class="chart-donutty-title">관심</p>
                    </li>
                    <li level="2">
                        <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl" data-anchor="top" data-bg="#37474f" data-color="#ffd200" data-value="0"></div>
                        <p class="chart-donutty-title">주의</p>
                    </li>
                    <li level="3">
                        <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl" data-anchor="top" data-bg="#37474f" data-color="#ff9600" data-value="0"></div>
                        <p class="chart-donutty-title">경계</p>
                    </li>
                    <li level="4">
                        <div class="chart-donutty" data-donutty data-thickness="25" data-padding="0" dir="rtl" data-anchor="top" data-bg="#37474f" data-color="#ff0000" data-value="0"></div>
                        <p class="chart-donutty-title">심각</p>
                    </li>
                </ul>
            </div>
        </div>
        <!--[e] 내역 반복 박스 -->

        <div class="overall-status_re">
            <div class="title">행안부 전송 상태</div>
            <div class="on-off">
                <button type="button" class="on"></button>
                <button type="button" class="off"></button>
            </div>
            <div class="conts">
                <!--[s] 상태 반복 -->
                <div class="hang status-number">
                    <div class="title">행안부 전송</div>
                    <div class="conts">
                        <dl class="box">
                            <dt>0</dt>
                            <dd>전체</dd>
                        </dl>
                        <dl class="box">
                            <dt>0</dt>
                            <dd>수신</dd>
                        </dl>
                        <dl class="box">
                            <dt>0</dt>
                            <dd>미수신</dd>
                        </dl>
                    </div>
                </div>
                <!--[e] 상태 반복 -->
            </div>
        </div>

        <div class="overall-status_re">
            <div class="title">시스템 상태</div>
            <div
                class="conts">
                <!--[s] 상태 반복 -->
                <div class="sensor status-number">
                    <div class="title">계측기 상태</div>
                    <div class="conts">
                        <dl class="box" status="">
                            <dt>0</dt>
                            <dd>전체</dd>
                        </dl>
                        <dl class="box" status="1">
                            <dt>0</dt>
                            <dd>수신</dd>
                        </dl>
<%--                        <dl class="box" data-fancybox data-src="#lay-sensor-status-list_origin">--%>
                        <dl class="box" status="2">
                            <dt>0</dt>
                            <dd>미수신</dd>
                        </dl>
                    </div>
                </div>
                <!--[e] 상태 반복 -->

                <!-- <div class="status-number">
                    <div class="title">수집장치 상태</div>
                    <div class="conts">
                        <dl class="box">
                            <dt>0</dt>
                            <dd>전체</dd>
                        </dl>
                        <dl class="box">
                            <dt>0</dt>
                            <dd>수신</dd>
                        </dl>
                        <dl class="box" data-fancybox data-src="#lay-sensor-status-list">
                            <dt>0</dt>
                            <dd>미수신</dd>
                        </dl>
                    </div>
                </div> -->

                <div class="cctv status-number">
                    <div class="title">CCTV 상태</div>
                    <div class="conts">
                        <dl class="box" status="">
                            <dt>0</dt>
                            <dd>전체</dd>
                        </dl>
                        <dl class="box" status="1">
                            <dt>0</dt>
                            <dd>수신</dd>
                        </dl>
<%--                        <dl class="box" data-fancybox data-src="#lay-cctv-status-list">--%>
                        <dl class="box" status="2">
                            <dt>0</dt>
                            <dd>미수신</dd>
                        </dl>
                    </div>
                </div>
            </div>
        </div>

        <div class="overall-status_re">
            <div class="title">기상 정보</div>
            <div class="conts">
                <div class="weather-api" data-fancybox data-src="#lay-weather-area">
                    <div class="weather-img">
                        <img src=""/>
                        <span></span>
                    </div>
                    <div class="weather-detail">
                        <!-- 기온: 31.6℃ 최저-최고31℃ 체감(31.3℃)
                        어제보다 3℃ 높아요
                        습도 52 %
                        바람 남 3.2 m/s
                        1시간강수량- mm -->
                    </div>
                </div>
                <div class="weather-comment" data-fancybox data-src="#lay-weather-area2"></div>
            </div>
        </div>

        <div class="overall-status_re" style="overflow: visible">
            <div class="title">장비현황</div>
            <div class="conts">
                <div class="piechart-area">
                    <div id="piechart" style="width:288px; height:134px;"></div>
                </div>
            </div>
        </div>

        <div class="overall-status_re">
            <div class="title">알람 이력</div>
            <div class="conts">
                <ul class="alarm-list">
                    <!--[s] 알람 이력 반복 -->
                    <li></li>
                    <li></li>
                    <li></li>
                    <li></li>
                    <!--[e] 알람 이력 반복 -->
                </ul>
            </div>
        </div>

        <!--[s] 알람현황  팝업 -->
        <div id="lay-alarm-info" class="layer-base">
            <div class="layer-base-btns">
                <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
            </div>
            <div class="layer-base-title">알람 조회</div>
            <div class="layer-base-conts">
                <div class="bTable">
                    <table class="gridAlarm"></table>
                </div>
            </div>
        </div>
        <!--[e] 알람현황  팝업 -->
        <!--알람 이력 조회 팝업 -->
        <div id="lay-alarm-history" class="layer-base">
            <div class="layer-base-btns">
                <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
            </div>
            <div class="layer-base-title">알람 이력 조회</div>
            <div class="layer-base-conts">
                <div class="bTable">
                    <table class="gridAlarmHistory"></table>
                </div>
            </div>
        </div>
        <!--[e] 알람 이력 조회 팝업 -->

        <!--[s] 센서 리스트 팝업 -->
        <div id="lay-sensor-status-list" class="layer-base">
            <div class="layer-base-btns">
                <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
            </div>
            <div class="layer-base-title">전체 센서 리스트</div>
            <div class="layer-base-conts">
<%--                <div class="down-btn">--%>
<%--                    <a href="javascript:downloadExcel('sensorList', '/admin/sensorByChannelList/excel')">다운로드</a>--%>
<%--                </div>--%>
                <div class="bTable">
                    <table class="gridSensor"></table>
                </div>
            </div>
        </div>
        <!--[e] 센서 리스트 팝업 -->
        <!--[s] CCTV 리스트 팝업 -->
        <div id="lay-cctv-status-list" class="layer-base">
            <div class="layer-base-btns">
                <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
            </div>
            <div class="layer-base-title">미수신 CCTV 리스트</div>
            <div class="layer-base-conts">
<%--                <div class="down-btn">--%>
<%--                    <a href="javascript:downloadExcel('cctvList', '/cctv/excel')">다운로드</a>--%>
<%--                </div>--%>
                <div class="bTable">
                    <table class="gridCCTV"></table>
                </div>
            </div>
        </div>
        <!--[e] CCTV 리스트 팝업 -->
        <!--[s] 장비 현황 팝업 -->
        <div id="lay-equipment-area" class="layer-base">
            <div class="layer-base-btns">
                <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
            </div>
            <div class="layer-base-title">장비 목록</div>
            <div class="layer-base-conts">
                <div class="bTable">
                    <table class="gridDevice"></table>
                </div>
            </div>
        </div>
        <!--[e] 센서 목록 팝업 -->

    </div>
</div>

