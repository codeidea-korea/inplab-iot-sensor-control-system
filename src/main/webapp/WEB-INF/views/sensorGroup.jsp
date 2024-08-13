<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> <%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
	    <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>
	
	    <style>
            .bTable {
                overflow: auto;
            }
            #contents .contents-in {
                height: 69vh;
            }

            .ui-jqgrid .ui-jqgrid-bdiv {
                overflow: visible;
            }
        </style>

	
        <script>
            window.jqgridOption = {
                multiselect: true,
                multiboxonly: false,
                rowNum: 0
            }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

            let chart, $grid;
            let today = formatDateToString(new Date());
            let interval = 'minute';

            window.jqgridFlag = false;

            $(function() {

                $.get('/sensorGroup/columns', function (res) {
                    // console.log(res);
                    res.zone_name.width = 90;
                    $grid = jqgridUtil($('table.grid'), {
                        listPathUrl: "/sensorGroup"
                    }, res, false);

                    $('.ui-th-div input.cbox').hide();
                });

                // $('.search-form.search-area input.searchDate').flatpickr({
                //     locale: "ko",
                //     mode: "range",
                //     enableTime: true,
                //     plugins : [new confirmDatePlugin({
                //         confirmIcon: "<i class='fa fa-check'></i>", // your icon's html, if you wish to override
                //         confirmText: "",
                //         showAlways: false
                //     })],
                //     dateFormat: "Y-m-d H:i",                    
                //     onClose: function (selectedDates, dateStr, instance) {
                //         $(instance._input).attr('start_date', formatDateToString(selectedDates[0]));
                //         $(instance._input).attr('end_date', formatDateToString(selectedDates[1]));
                //     }
                // });
                
                $('.search-form.search-area input.searchDate').daterangepicker({
                    // "timePicker": true,
                    // "timePicker24Hour": true,
                    ranges: {
                        '금일': [moment(), moment()],
                        '지난 1주': [moment().subtract(6, 'days'), moment()],
                        '지난 1개월': [moment().subtract(29, 'days'), moment()],
                        // '지난 3개월': [moment().subtract(3, 'month'), moment()],
                        '지난 6개월': [moment().subtract(6, 'month'), moment()],
                        '1년': [moment().subtract(1, 'year').startOf('year'), moment().subtract(1, 'year').endOf('year')]
                    },
                    locale: { 
                        format: 'YYYY-MM-DD',
                        "separator": " ~ ",
                        cancelLabel: '취소', 
                        applyLabel: '적용',
                        "customRangeLabel": "사용자 정의",
                        "fromLabel": "From",
                        "toLabel": "To",
                        "daysOfWeek": [
                            "일",
                            "월",
                            "화",
                            "수",
                            "목",
                            "금",
                            "토"
                        ],
                        "monthNames": [
                            "1월",
                            "2월",
                            "3월",
                            "4월",
                            "5월",
                            "6월",
                            "7월",
                            "8월",
                            "9월",
                            "10월",
                            "11월",
                            "12월"
                        ],
                    },
                    "alwaysShowCalendars": true,
                    opens: 'right',
                    autoUpdateInput: false
                }, function(start, end, label) {
                    $('.search-form.search-area input.searchDate').val(start.format('YYYY-MM-DD') + ' ~ ' + end.format('YYYY-MM-DD'));
                    $('.search-form.search-area input.searchDate').attr('start_date', start.format('YYYY-MM-DD'));
                    $('.search-form.search-area input.searchDate').attr('end_date', end.format('YYYY-MM-DD'));
                });

                // setRangePicker($('.search-form.search-area input.searchDate'));

                $('.searchGroup .selectBtn').on('click', function() {
                    if(!$('.ui-common-table .cbox').is(":checked")){
                        alert("센서를 선택해주세요.");
                        return false;
                    }

                    let $target = $('.contents-re .tab-three a.active');

                    if($target.data("kind") === "candle"){
                        drawChartCandle();
                    }else if($target.data("kind") === "line") {
                        drawChartLine();
                    }
                });

                $('.searchGroup .excelBtn').on('click', function() {
                    if(window.jqgridFlag){
                        excelDownload('/sensorGroup/excel/센서그룹조회', lastParam);
                    }else{
                        alert("데이터가 없습니다.");
                        $('.chart').empty();
                    }
                });

                // 크게 보기(최대화)
                $('.chartGroup').on('click', function() {
                    if ($('#contents .contents-re:eq(0)').hasClass('on')) {
                        $('#contents .contents-re:eq(0)').removeClass('on');
                        $('#contents .contents-re:eq(0)').hide();
                    } else {
                        $('#contents .contents-re:eq(1) .chart').hide();
                        $('#contents .contents-re:eq(0)').show();
                        $('#contents .contents-re:eq(1) .chart').highcharts().chartWidth = $('#contents .contents-re:eq(1) .chart').parent().width()
                        $('#contents .contents-re:eq(1) .chart').highcharts().reflow();
                        $('#contents .contents-re:eq(1) .chart').highcharts().redraw();
                        $('#contents .contents-re:eq(1) .chart').show();
                        $('#contents .contents-re:eq(0)').addClass('on');
                    }                    
                });

                $('.contents-re .tab-three a').on('click', function (e) {
                    if($(this).hasClass("active")){
                        return false;
                    }

                    if(!$('.ui-common-table .cbox').is(":checked")){
                        alert("센서를 선택해주세요.");
                        return false;
                    }

                    $('.contents-re .tab-three a').removeClass("active");
                    $(this).addClass("active");

                    $('.searchGroup .selectBtn').trigger('click');

                });

                // $('.searchArea .selectDate').on('change', function() {
                //     var days = $(this).val();
                //     var pastDate = getPastDate(days);

                //     setSearchDate(pastDate, today);
                // });

                setSearchDate(getPastDate($('.searchArea .selectDate option:selected').val()), today);

                $('.chartGroup').hide();
            });

            function setSearchDate(start, end) {
                $('.search-form.search-area input.searchDate').attr('start_date', start);
                $('.search-form.search-area input.searchDate').attr('end_date', end);
                $('.search-form.search-area input.searchDate').val(start + ' ~ ' + end);
            }

            function clearChart() {
                chart.destroy();
                $('.chartGroup').hide();
            }

            let lastParam = null;

            function drawChartLine() {
                let sdate = $('.search-form.search-area input.searchDate').attr('start_date');            // 2023-11-01
                let edate = $('.search-form.search-area input.searchDate').attr('end_date');

                let valueType = $('.valueType input[type=radio]:checked').val();
                let threshold = $('.toggleThreshold input[type=checkbox]').is(':checked');

                let diffDay = countDaysBetweenDates(sdate, edate);
                let xformat = '{value:%Y-%m-%d %H:%M}';
                let min = 1;
                let asset_ids = [];


                if (valueType == 'raw') {
                    threshold = false;
                }

                if (diffDay >= 89) {
                    min = 60 * 24 * 7;          // 4시간별
                    xformat = '{value:%y-%m-%d %H}';
                    interval = '4hour';
                } else if (diffDay >= 29) {
                    min = 60 * 24;              // 시간별
                    xformat = '{value:%y-%m-%d %H}';
                    interval = 'hour';
                } else if (diffDay >= 6) {      // 5분
                    min = 60;
                    xformat = '{value:%Y-%m-%d %H:%M}';
                    interval = '5min';
                } else {       // 1분
                    min = 1;
                    interval = 'minute';
                }

                $.each(getSelectedCheckData($grid), function() {
                    asset_ids.push(this.asset_id);
                });

                lastParam = {
                    asset_ids : JSON.stringify(asset_ids),
                    min : min,
                    valueType: $('.valueType input[type=radio]:checked').val(),
                    start_date : sdate,
                    end_date : edate,
                    itv : interval
                };

                // console.log(lastParam);

                if (typeof chart != 'undefined') {
                    chart.showLoading('데이터 로딩 중 입니다...');
                }
                $.get('/getSensorChartRealData', lastParam, function(res) {
                    if (res == null || res.length == 0) {
                        alert('데이터가 없습니다.');
                        return;
                    }

                    let guideLine = [];                                             // 루프를 돌리면서 자산 종류별로 가이드 라인 array 를 만들어서 plotLine 데이터를 생성

                    if(threshold) {
                        if(!!res && res.length > 0){
                            const obj = res.find(d => d.real_value == d.tar_value); // type 이 달라서 ==

                            if(!obj)
                                return;

                            guideLine.push(getPlotLine('#FF0000', obj.max4, obj.asset_kind_name + ' 4차 (' + obj.max4 + ')'));
                            guideLine.push(getPlotLine('#FF9600', obj.max3, obj.asset_kind_name + ' 3차 (' + obj.max3 + ')'));
                            guideLine.push(getPlotLine('#FFD200', obj.max2, obj.asset_kind_name + ' 2차 (' + obj.max2 + ')'));
                            guideLine.push(getPlotLine('#90DA00', obj.max1, obj.asset_kind_name + ' 1차 (' + obj.max1 + ')'));
                            guideLine.push(getPlotLine('#FF0000', obj.min4, obj.asset_kind_name + ' 4차 (' + obj.min4 + ')'));
                            guideLine.push(getPlotLine('#FF9600', obj.min3, obj.asset_kind_name + ' 3차 (' + obj.min3 + ')'));
                            guideLine.push(getPlotLine('#FFD200', obj.min2, obj.asset_kind_name + ' 2차 (' + obj.min2 + ')'));
                            guideLine.push(getPlotLine('#90DA00', obj.min1, obj.asset_kind_name + ' 1차 (' + obj.min1 + ')'));
                        }
                    }

                    console.log(guideLine);

                    const data = res.reduce((acc, item) => {
                        let key = item.channel_name;
                        if (!acc[key]) {
                            acc[key] = [];
                        }
                        acc[key].push([item.time_slot, item.real_value]);
                        return acc;
                    }, {});

                    let seriesData = Object.keys(data).map(name => {
                        return {
                            name,
                            data: data[name],
                            showInLegend: false
                        }
                    });

                    try {
                        chart = drawLineChart($('.chart'), seriesData, guideLine, xformat);
                        chart.hideLoading();
                        $('.chartGroup').show();
                        window.jqgridFlag = true;
                    } catch(e) {
                    }
                });
            }

            function drawChartCandle() {
                let sdate = $('.search-form.search-area input.searchDate').attr('start_date');            // 2023-11-01
                let edate = $('.search-form.search-area input.searchDate').attr('end_date');

                let diffDay = countDaysBetweenDates(sdate, edate);
                let xformat = '{value:%Y-%m-%d %H:%M}';
                
                let valueType = $('.valueType input[type=radio]:checked').val();
                let threshold = $('.toggleThreshold input[type=checkbox]').is(':checked');

                let min = 1;

                if (valueType == 'raw') {
                    threshold = false;
                }

                console.log(diffDay);

                // tick 간격 정의 
                if (diffDay >= 89) {
                    min = 60 * 24 * 7;          // 4시간별
                    xformat = '{value:%y-%m-%d %H}';
                    interval = '4hour';                    
                } else if (diffDay >= 29) {
                    min = 60 * 24;              // 시간별
                    xformat = '{value:%y-%m-%d %H}';
                    interval = 'hour';
                } else if (diffDay >= 6) {      // 5분
                    min = 60;
                    xformat = '{value:%Y-%m-%d %H:%M}';
                    interval = '5min';
                } else {       // 1분 
                    min = 1;
                    interval = 'minute';
                }

                let asset_ids = [];
                $.each(getSelectedCheckData($grid), function() {
                    asset_ids.push(this.asset_id);
                });

                lastParam = {
                    asset_ids : JSON.stringify(asset_ids), 
                    min : min,
                    valueType: $('.valueType input[type=radio]:checked').val(),
                    start_date : sdate,
                    end_date : edate,
                    itv : interval
                };

                console.log(lastParam);

                if (typeof chart != 'undefined') {
                    chart.showLoading('데이터 로딩 중 입니다...');
                }

                $.get('/getSensorChartData', lastParam, function(res) {
                    if (res == null || res.length == 0) {
                        alert('데이터가 없습니다.');
                        $('.chart').empty();
                        window.jqgridFlag = false;
                        return;
                    }

                    let guideLine = [];                                             // 루프를 돌리면서 자산 종류별로 가이드 라인 array 를 만들어서 plotLine 데이터를 생성                
                    let lastKind = '';
                    let viewChart = true;

                    if(threshold) {
                        $.each(res, function() {
                            const data = this;
                            if (data.asset_kind_id != lastKind) {
                                if (lastKind === '') {
                                    lastKind = data.asset_kind_id;
                                } else {
                                    alert('캔들차트는 동일한 센서종류에서 조회가 가능합니다. 동일한 센서종류를 선택하세요.');
                                    viewChart = false;
                                    $(".tab-three > a:eq(0)").trigger("click");
                                    return false;
                                }
                            }
                        });

                        if(!!res && res.length > 0){
                            const obj = res.find(d => d.max_value == d.tar_value);

                            if(!obj)
                                return;

                            guideLine.push(getPlotLine('#FF0000', obj.max4, obj.asset_kind_name + ' 4차 (' + obj.max4 + ')'));
                            guideLine.push(getPlotLine('#FF9600', obj.max3, obj.asset_kind_name + ' 3차 (' + obj.max3 + ')'));
                            guideLine.push(getPlotLine('#FFD200', obj.max2, obj.asset_kind_name + ' 2차 (' + obj.max2 + ')'));
                            guideLine.push(getPlotLine('#90DA00', obj.max1, obj.asset_kind_name + ' 1차 (' + obj.max1 + ')'));
                            guideLine.push(getPlotLine('#FF0000', obj.min4, obj.asset_kind_name + ' 4차 (' + obj.min4 + ')'));
                            guideLine.push(getPlotLine('#FF9600', obj.min3, obj.asset_kind_name + ' 3차 (' + obj.min3 + ')'));
                            guideLine.push(getPlotLine('#FFD200', obj.min2, obj.asset_kind_name + ' 2차 (' + obj.min2 + ')'));
                            guideLine.push(getPlotLine('#90DA00', obj.min1, obj.asset_kind_name + ' 1차 (' + obj.min1 + ')'));
                        }
                    }

                    const data = res.reduce((acc, item) => {
                        let key = item.channel_name;
                        if (!acc[key]) {
                            acc[key] = [];
                        }
                        acc[key].push([item.time_slot, item.start_value, item.max_value, item.min_value, item.end_value]);
                        return acc;
                    }, {});

                    let seriesData = Object.keys(data).map(name => {
                        return {
                            name,
                            data: data[name],
                            type: 'candlestick',
                            tooltip: {
                                xDateFormat: '%Y-%m-%d %H:%M:%S'
                            },
                            color: 'blue', // 내리는 경우의 색상
                            lineColor: 'blue', // 내리는 경우의 선 색상
                            upColor: 'red', // 오르는 경우의 색상
                            upLineColor: 'red', // 오르는 경우의 선 색상
                        }
                    });

                    try {
                        chart = drawCandleChart($('.chart'), seriesData, guideLine, xformat);
                        chart.hideLoading();
                        if (!viewChart) {
                            $('.chart').empty();
                            $('.chartGroup').hide();
                            window.jqgridFlag = false;
                        } else {
                            $('.chartGroup').show();
                            window.jqgridFlag = true;
                        }
                    } catch(e) {
                    }
                });
            }
        </script>
	
	</head>

<body data-pgcode="0000">
<section
        id="wrap">
    <!--[s] 상단 -->
    <jsp:include page="common/include_top.jsp" flush="true"></jsp:include>
    <!--[e] 상단 -->

    <!--[s] 왼쪽 메뉴 -->
    <div id="global-menu">
        <!--[s] 주 메뉴 -->
        <jsp:include page="common/include_sidebar.jsp" flush="true"></jsp:include>
        <!--[e] 주 메뉴 -->
    </div>
    <!--[e] 왼쪽 메뉴 -->

	<!--[s] 컨텐츠 영역 -->
		<div id="container">
            <div class="search-form search-area searchArea">
                <h2 class="txt">센서 조회</h2>
                <div class="toggleThreshold inputBox" style="margin-right: 20px">
                    <p class="check-box" notxt="" small=""><input type="checkbox" checked="" id="check_tit01_0" name="check_tit01_0" value=""><label for="check_tit01_0"><span class="graphic"></span></label></p>
                    <span class="labelText">임계치 표시</span>
                </div>

                <div class="valueType inputBox" style="margin-right: 20px">
                    <p class="check-box">
                        <input type="radio" id="check01" name="valueType" value="calc" checked/>
                        <label for="check01"><span class="graphic"></span>계산값</label>
                    </p>
                    <p class="check-box">
                        <input type="radio" id="check02" name="valueType" value="raw"/>
                        <label for="check02"><span class="graphic"></span>Raw Value</label>
                    </p>
                </div>

                <!-- <select name="selectDate" class="selectDate" tabindex="0">
                    <option value="7">주</option>
                    <option value="30">월</option>
                    <option value="365">년</option>
                </select> -->
                <input type="text" class="searchDate" name="searchDate" value="" readonly="readonly" start_date="" end_date="" tabindex="0">

                <div class="searchGroup">
                    <a class="selectBtn">조회</a>
                    <a class="excelBtn">다운로드</a>
                </div>
            </div>

			<div id="contents">
				<div class="contents-re on" style="flex: 5">
					<h3 class="txt">센서 그룹 조회</h3>
					<div class="contents-in">
                        <div class="bTable">
                            <table class="grid"></table>
                        </div>
					</div>
				</div>
                <div class="contents-re" style="flex: 6; display: grid; grid-template-rows: auto 1fr;">
                    <div class="tab-three" style="margin-top:3px;height: 43px;">
                        <a href="#" class="active" data-kind="line">라인차트</a>
                        <a href="#" data-kind="candle">캔들차트</a>
                    </div>
                    <div class="chartGroup"><i class="fa-regular fa-window-maximize btnMaximize"></i></div>
                    <div class="chart" style="border-radius: 10px;background: white; padding: 2px;display: flex; justify-content: center; align-items: center;">

                    </div>
                </div>
			</div>
		</div>
	<!--[e] 컨텐츠 영역 -->
</section>
</body>
</html>
