<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--
    ${asset}
-->
<div class="layer-base-btns asset_${asset.asset_id}">
    <!-- <a href="javascript:void(0);"><img src="/images/btn_lay_full.png" data-fancybox-full alt="전체화면"/></a> -->
    <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
</div>
<div class="layer-base-title icon">
    센서정보
    <span class="point">${asset.asset_kind_name} ${asset.name}</span>
</div>
<div class="layer-base-conts min">
    <ul class="bul-sensor">
        <li>
            <strong>센서명</strong>
            ${asset.name}
        </li>
        <li>
            <strong>계측종류</strong>
            ${asset.asset_kind_desc}
        </li>
        <li>
            <strong>설치일자</strong>
            ${asset.install_date}
        </li>
        <li blue>
            <strong>설치위치</strong>
            ${asset.zone_name} (${asset.area_name}, ${asset.area_etc2})
        </li>
    </ul>
</div>

<div class="layer-base-conts body">
    <p class="layer-base-tit">조회조건</p>
    <div class="search-area">
        <div class="search-form">
            <!-- <select name="selectDate" class="selectDate">
                <option value="">금일</option>
                <option value="7">주</option>
                <option value="30">월</option>
            </select> -->
            <input type="text" class="searchDate" name="searchDate" value="" placeholder=""/>
        </div>
        <div class="search-btns">
            <a href="javascript:void(0);" class="search">조회</a>
            <a href="javascript:void(0);" class="download">다운로드</a>
        </div>
    </div>

    <div class="piechart-area">
        <div class="chart-sensor" style="height: 350px;">
        </div>
    </div>
</div>

<script>
    $(function() {
        let today = formatDateToString(new Date());
        let $pop = $('.layer-base-btns.asset_${asset.asset_id}').closest('#lay-sensor-info');
        let chart;
        let interval = 'minute';
        let asset_kind_id = `${asset.asset_kind_id}`;

        // $pop.find('.searchDate').flatpickr({
        //     locale: "ko",
        //     mode: "range",
        //     dateFormat: "Y-m-d",
        //     onClose: function (selectedDates, dateStr, instance) {
        //         console.log(instance);
        //         $(instance._input).attr('start_date', formatDateToString(selectedDates[0]));
        //         $(instance._input).attr('end_date', formatDateToString(selectedDates[1]));
        //     },
        //     // onChange : function (selectedDates, dateStr, instance) {
        //     //     $(instance._input).attr('start_date', formatDateToString(selectedDates[0]));
        //     //     $(instance._input).attr('end_date', formatDateToString(selectedDates[1]));
        //     // }
        // });



        // setRangePicker($pop.find('.searchDate'), function() {
        //     $pop.find('input.searchDate').attr('start_date', start.format('YYYY-MM-DD'));
        //     $pop.find('input.searchDate').attr('end_date', end.format('YYYY-MM-DD'));
        // });

        $pop.find('.searchDate').daterangepicker({
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
            $pop.find('.searchDate').val(start.format('YYYY-MM-DD') + ' ~ ' + end.format('YYYY-MM-DD'));
            $pop.find('.searchDate').attr('start_date', start.format('YYYY-MM-DD'));
            $pop.find('.searchDate').attr('end_date', end.format('YYYY-MM-DD'));
        });

        $pop.find('.search-btns a.search').on('click', function() {
            drawChart();
        });

        $('.download').off().on('click', function () {
            let param = {
                asset_ids : JSON.stringify(['${asset.asset_id}']),
                start_date : $pop.find('.searchDate').attr('start_date'),
                end_date : $pop.find('.searchDate').attr('end_date'),
                valueType: 'calc',
                itv : interval
            };
            excelDownload('/excel/센서차트', param);
        });

        // $pop.find('select.selectDate').on('change', function() {
        //     var days = $(this).val();
        //     var pastDate = getPastDate(days);

        //     $pop.find('input.searchDate').attr('start_date', pastDate);
        //     $pop.find('input.searchDate').attr('end_date', today);
        //     $pop.find('input.searchDate').val(pastDate + ' ~ ' + today);
        // });

        function drawChart() {
            let sdate = $pop.find('.searchDate').attr('start_date');            // 2023-11-01
            let edate = $pop.find('.searchDate').attr('end_date');

            let diffDay = countDaysBetweenDates(sdate, edate);
            let xformat = '{value:%Y-%m-%d %H:%M}';
            let min;

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

            let param = {
                asset_ids : JSON.stringify(['${asset.asset_id}']), 
                min : min,
                start_date : sdate,
                end_date : edate,
                valueType: 'calc',
                itv : interval
            };

            if (typeof chart != 'undefined') {
                chart.showLoading('데이터 로딩 중 입니다...');
            }

            $.get('/getSensorChartRealData', param, function(res) {
                if (res == null || res.length == 0) {
                    alert('데이터가 없습니다.');
                    return;
                }

                let guideLine = [];                                             // 루프를 돌리면서 자산 종류별로 가이드 라인 array 를 만들어서 plotLine 데이터를 생성                
                let lastKind = '';

                $.each(res, function() {
                    if (res.asset_kind_id != lastKind) {
                        guideLine.push(getPlotLine('#FF0000', this.max4, this.asset_kind_name + ' 4차 (' + this.max4 + ')'));
                        guideLine.push(getPlotLine('#FF9600', this.max3, this.asset_kind_name + ' 3차 (' + this.max3 + ')'));
                        guideLine.push(getPlotLine('#FFD200', this.max2, this.asset_kind_name + ' 2차 (' + this.max2 + ')'));
                        guideLine.push(getPlotLine('#90DA00', this.max1, this.asset_kind_name + ' 1차 (' + this.max1 + ')'));
                        guideLine.push(getPlotLine('#FF0000', this.min4, this.asset_kind_name + ' 4차 (' + this.min4 + ')'));
                        guideLine.push(getPlotLine('#FF9600', this.min3, this.asset_kind_name + ' 3차 (' + this.min3 + ')'));
                        guideLine.push(getPlotLine('#FFD200', this.min2, this.asset_kind_name + ' 2차 (' + this.min2 + ')'));
                        guideLine.push(getPlotLine('#90DA00', this.min1, this.asset_kind_name + ' 1차 (' + this.min1 + ')'));

                        lastKind = res.asset_kind_id;
                    }
                });

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

                // console.log(seriesData);
                // console.log(guideLine);

                chart = drawLineChart($('.chart-sensor'), seriesData, guideLine, xformat);

                try {
                    chart.hideLoading();
                } catch(e) {
                }
            });
        }

        $pop.find('.searchDate').attr('start_date', today);
        $pop.find('.searchDate').attr('end_date', today);
        $pop.find('.searchDate').val(today);

        // 전광판일 경우, 정보만 보여줌
        if (asset_kind_id === '10') {
            $('.layer-base-conts.body').hide();
        } else {
            $('.layer-base-conts.body').show();
            drawChart();
        }
    });
</script>