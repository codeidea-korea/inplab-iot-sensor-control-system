jQuery.fn.serializeObject = function () {
    var obj = null;
    try {
        var arr = this.serializeArray();
        if (arr) {
            obj = {};
            $.each(arr, function () {
                obj[this.name] = this.value;
            });
        }
    } catch (e) {
        alert(e.message);
    } finally {
    }

    return obj;
};

function verify_email(fieldValue) {
    var emailReg = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$/;
    if (!emailReg.test(fieldValue)) {
        return false;
    }
    return true;
}

function verify_no_special_char(fieldValue) {
    var charReg = /^[a-zA-Z0-9]+$/;
    if (!charReg.test(fieldValue)) {
        return false;
    }
    return true;
}

function verify_tel(fieldValue) {
    var telReg = /^[0-9+-/(/)]+$/;
    if (!telReg.test(fieldValue)) {
        return false;
    }
    return true;
}

/**
 * 세자리 콤마 찍기
 */
function commify(nStr) {
    nStr += "";
    let x = nStr.split(".");
    let x1 = x[0];
    let x2 = x.length > 1 ? "." + x[1] : "";
    let rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, "$1" + "," + "$2");
    }
    return x1 + x2;
}

function setRangePicker($el, applyCallback) {
    $el.daterangepicker({
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
    });
    $el.on('show.daterangepicker', function (ev, picker) {
        $el.val('');
    });
    $el.on('apply.daterangepicker', function (ev, picker) {
        $el.val(picker.startDate.format('YYYY-MM-DD') + ' ~ ' + picker.endDate.format('YYYY-MM-DD'));
        applyCallback($el.val());
    });
}

function setTimeRangePicker($el, applyCallback) {
    $el.daterangepicker({
        ranges: {
            '금일': [moment().startOf('day'), moment().endOf('day')],
            '지난 1주': [moment().subtract(6, 'days').startOf('day'), moment()],
            '지난 1개월': [moment().subtract(29, 'days').startOf('day'), moment()],
            // '지난 3개월': [moment().subtract(3, 'month'), moment()],
            '지난 6개월': [moment().subtract(6, 'month').startOf('day'), moment()],
            '1년': [moment().subtract(1, 'year').startOf('year').startOf('day'), moment().subtract(1, 'year').endOf('year')]
        },
        startDate: moment(),
        // endDate : moment().add(14, 'days').add(2,'hours'),
        endDate: moment().add(1, 'days').endOf('day'),
        timePicker: true,
        timePicker24Hour: true,
        timePickerSeconds: true,
        // timePickerIncrement: 30,
        locale: {
            format: 'YYYY-MM-DD HH:mm:ss',
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
    });
    $el.on('show.daterangepicker', function (ev, picker) {
        $el.val('');
    });
    $el.on('apply.daterangepicker', function (ev, picker) {
        $el.val(picker.startDate.format('YYYY-MM-DD HH:mm:ss') + ' ~ ' + picker.endDate.format('YYYY-MM-DD HH:mm:ss'));

        try {
            applyCallback();
        } catch (e) {
        }
    });
}

$(function () {
    // $("[datetimepicker]").flatpickr({
    //     locale: "ko",
    //     mode: "range",
    //     dateFormat: "Y-m-d",
    //     onClose: function (selectedDates, dateStr, instance) {},
    // });

    $("[datetimepicker]").daterangepicker({
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
        opens: 'right'
    });


    $(".datetimepickerOne").daterangepicker({
        singleDatePicker: true, // 단일 날짜 선택 모드
        showDropdowns: true, // 연도와 월을 드롭다운으로 선택 가능
        locale: {
            format: 'YYYY-MM-DD',
            cancelLabel: '취소',
            applyLabel: '적용',
            daysOfWeek: [
                "일", "월", "화", "수", "목", "금", "토"
            ],
            monthNames: [
                "1월", "2월", "3월", "4월", "5월", "6월",
                "7월", "8월", "9월", "10월", "11월", "12월"
            ],
        },
        alwaysShowCalendars: true,
        opens: 'right'
    }, function (start, end, label) {
        // 날짜 선택 후 실행될 함수
        // $(".datetimepickerOne").val(start.format('YYYY-MM-DD'));
        $(this).val(start.format('YYYY-MM-DD'));
    });

});

function popFancy(name) {
    Fancybox.show([{ src: name, type: "inline" }], {
        backdropClick: false, // 배경 클릭 시 닫힘 방지
        clickOutside: false,  // Fancybox 영역 바깥 클릭 시 닫힘 방지
    });
}



function popFancy(name, param) {
    Fancybox.show([{src: name, type: "inline"}], Object.assign({
        backdropClick: false, // 배경 클릭 시 닫힘 방지
        clickOutside: false,  // Fancybox 영역 바깥 클릭 시 닫힘 방지
    }, param));
}

// 개별 팝업 닫기 popFancyClose('#lay-form-write'); 와 같이 사용
function popFancyClose(target) {
    if (typeof target == 'undefined') {
        Fancybox.close();
    } else {
        // 팝업닫기
        $(target).find('[data-fancybox-close]').trigger('click');
    }
}

function alert(msg, callbackYes) {
    $("#alert").remove();
    $("body").append(
        '<div id="alert" class="layer-alarm"><div class="layer-alarm-btns"><a href="#" data-fancybox-close><img src="/images/btn_lay_close.png" alt="닫기" /></a></div><div class="layer-base-title">안내</div><div class="layer-alarm-conts"><p class="txt">' +
        msg +
        '</p><p class="btn"><a href="#" blue data-fancybox-close class="confirm">확인</a></p></div></div>'
    );
    popFancy("#alert");

    $("#alert .confirm").on("click", function () {
        try {
            callbackYes();
        } catch (e) {
        }
    });
}

function confirm(msg, callbackYes) {
    $("#alert").remove();
    $("body").append(
        '<div id="alert" class="layer-alarm"><div class="layer-alarm-btns"><a href="#" data-fancybox-close><img src="/images/btn_lay_close.png" alt="닫기" /></a></div><div class="layer-base-title">안내</div><div class="layer-alarm-conts"><p class="txt">' +
        msg +
        '</p><p class="btn"><a href="#" blue class="confirm" data-fancybox-close>확인</a><a href="#" class="close" data-fancybox-close>취소</a></p></div></div>'
    );
    popFancy("#alert");

    $("#alert .confirm").on("click", function () {
        try {
            callbackYes();
        } catch (e) {
        }

        $(this).closest(".btn").find("a.close").trigger("click");
    });
}

// form 의 serialize 와 같은 역할을 일반 태그에서 하기위한 함수
function getSerialize(el) {
    var data = {};
    $(el).find('input, select, textarea').each(function () {
        data[$(this).attr('name')] = $(this).val();
    });

    return data;
}

// serialize 의 반대
function setSerialize(el, dataObj) {
    $.each(dataObj, function (key, value) {
        $(el).find('input, select, textarea').each(function () {
            // console.log(value);
            // todo : select 인 경우 option을 선택하는 로직 추가해야함
            if ($(this).attr('name') == key) {
                $(this).val(value);
                return false;
            }
        });
    });
}

// 타임스탬프 값을 일시 문자열 형태로
function formatTimestamp(timestamp) {
    var date = new Date(timestamp);
    var year = date.getFullYear();
    var month = date.getMonth() + 1;  // 월은 0부터 시작하므로 1을 더합니다.
    var day = date.getDate();
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var seconds = date.getSeconds();

    // 월, 일, 시, 분, 초가 한 자리 수일 경우 앞에 '0'을 붙입니다.
    month = (month < 10) ? '0' + month : month;
    day = (day < 10) ? '0' + day : day;
    hours = (hours < 10) ? '0' + hours : hours;
    minutes = (minutes < 10) ? '0' + minutes : minutes;
    seconds = (seconds < 10) ? '0' + seconds : seconds;

    // yyyy-mm-dd hh:mm:ss 형식의 문자열로 반환
    return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
}

function formatDateToString(date) {
    if (typeof date == 'undefined')
        return '';

    var year = date.getFullYear();
    var month = date.getMonth() + 1;  // 월은 0부터 시작하므로 1을 더합니다.
    var day = date.getDate();

    // 월과 일이 한 자리 수일 경우 앞에 '0'을 붙입니다.
    var formattedMonth = (month < 10) ? '0' + month : month;
    var formattedDay = (day < 10) ? '0' + day : day;

    // yyyy-mm-dd 형식의 문자열로 반환
    return year + '-' + formattedMonth + '-' + formattedDay;
}

function initRoadView($el, lat, lng, callback) { // 로드뷰 객체를 생성 
    var roadviewContainer = $el[0]; // 로드뷰를 표시할 div
    var roadview = new kakao.maps.Roadview(roadviewContainer); // 로드뷰 객체
    var roadviewClient = new kakao.maps.RoadviewClient();
    // 좌표로부터 로드뷰 파노라마ID를 가져올 로드뷰 helper객체

    // 좌표 객체를 생성 (위도, 경도)
    var position = new kakao.maps.LatLng(lat, lng);

    // 좌표로부터 로드뷰 파노라마ID를 가져온다.
    roadviewClient.getNearestPanoId(position, 50, function (panoId) { // 가져온 파노라마ID로 로드뷰를 표시
        roadview.setPanoId(panoId, position);

        try {
            callback(roadview);
        } catch (e) {
        }
    });

    $el.show();
}

function countDaysBetweenDates(startDate, endDate) {
    const oneDay = 24 * 60 * 60 * 1000; // 하루의 밀리초 수
    const start = new Date(startDate);
    const end = new Date(endDate);

    const difference = Math.abs(end - start); // 두 날짜의 차이(밀리초)
    return Math.round(difference / oneDay); // 밀리초를 일 단위로 변환
}

function getPastDate(days) {
    var currentDate = new Date();
    if (days) {
        currentDate.setDate(currentDate.getDate() - parseInt(days, 10));
    }
    return currentDate.toISOString().split('T')[0];
}

function getPlotLine(color, value, text) {
    return {
        color: color,
        value: value,
        width: 1.5,
        label: {
            text: text,
            align: 'left',
            style: {
                fontSize: '12px',
                color: color
            }
        }
    }
}

function drawLineChart($el, seriesData, guideLine, xAxisFormat) {
    // 값을 추출한다.
    const data = seriesData.flatMap(d => d?.data.map(dt => parseFloat(dt[1])));
    // 중복값 제거한 list 만들기
    const uniqueData = [...new Set(data)];
    const guide = guideLine.map(d => parseFloat(d.value)).sort((a, b) => a - b);

    // 전체 값 중에 max, min 값을 구한다.
    let max = Math.max(...uniqueData) || 0;
    let min = Math.min(...uniqueData) || 0;

    const maxClosest = findClosest(guide, max);
    const minClosest = findClosest(guide, min);

    // 비교 해서 더 큰 수
    if (max < maxClosest) {
        max = maxClosest;
    } else {
        if (guide.findIndex(d => d == maxClosest) != -1) {
            max = guide[guide.findIndex(d => d == maxClosest) + 1] || max;
        } else {
            max = Math.max(...uniqueData, guide[guide.length - 1]);
        }
    }

    // 비교 해서 더 작은 수
    if (min > minClosest) {
        min = minClosest;
    } else {
        if (guide.findIndex(d => d == minClosest) != -1) {
            min = guide[guide.findIndex(d => d == minClosest) - 1] || min;
        } else {
            min = Math.min(...uniqueData, guide[0]);
        }
    }

    guideLine = guideLine.filter(c => {
        // max 보다 크고 min 보다 작으면 가이드라인에서 없애기
        return !(max < Number(c.value) || Number(c.value) < min);
    });

    console.log(min, minClosest, max, maxClosest);
    // $.each(guideLine, function() {
    //     console.log(this);
    //     if (parseInt(this.value) > max) {
    //         max = parseInt(this.value);
    //     } else if (parseInt(this.value) < min) {
    //         min = parseInt(this.value);
    //     }
    // });

    return Highcharts.chart($el[0], {
        chart: {
            height: (parseInt($el.height()) * 0.95) + 'px',
            zoomType: 'x'
        },
        title: {
            text: null
        },
        legend: {
            enabled: false // Remove series label
        },
        tooltip: {
            xDateFormat: '%Y-%m-%d %H:%M:%S',
            // useHTML: true,
            // formatter() {
            //     return '<small>' + formatTimestamp(this.x) + '</small><table>' +
            //         '<tr><td style="color: ' + this.series.color + '">' + this.series.name + ': </td>' +
            //         '<td style="text-align: right"><b>' + this.y + '</b></td></tr>';
            // },
            shared: true,
            // split: false,
            enabled: true,
            style: {
                fontSize: '12px'
            }
        },
        xAxis: {
            type: 'datetime',
            tickInterval: "auto",
            // dateTimeLabelFormats: {
            //     hour: '%m-%d %H:%M',
            //     day: '%y-%m-%d %H:%M',
            //     minute: '%H:%M'
            // },
            labels: {
                style: {
                    fontSize: '10px',
                    whiteSpace: "nowrap"
                },
                format: xAxisFormat,
                // rotation: 0, // 라벨을 수평으로
                // formatter: function() {
                //     return formatTimestamp(this.value);
                // }
            }
        },
        yAxis: {
            title: {
                text: null
            },
            labels: {
                style: {
                    fontSize: '11px'
                }
            },
            tickInterval: "auto",
            plotLines: guideLine,
            min: min * 1.3,
            max: max * 1.3
        },
        series: seriesData
    });
}

function drawCandleChart($el, seriesData, guideLine, xAxisFormat) {

    // 값을 추출한다.
    const data = seriesData.flatMap(d => d?.data.flatMap(dt => dt?.filter((dtt, idx) => idx !== 0).map(dtt => dtt)));
    // 중복값 제거한 list 만들기
    const uniqueData = [...new Set(data)];
    const guide = guideLine.map(d => parseFloat(d.value)).sort((a, b) => a - b);

    // 전체 값 중에 max, min 값을 구한다.
    let max = Math.max(...uniqueData) || 0;
    let min = Math.min(...uniqueData) || 0;
    let defaultInterval = 5;

    const maxClosest = findClosest(guide, max);
    const minClosest = findClosest(guide, min);

    // 비교 해서 더 큰 수
    if (max < maxClosest) {
        max = maxClosest;
    } else {
        if (guide.findIndex(d => d === maxClosest) !== -1) {
            max = guide[guide.findIndex(d => d === maxClosest) + 1] || max;
        } else {
            max = Math.max(...uniqueData, guide[guide.length - 1]);
        }
    }

    // 비교 해서 더 작은 수
    if (min > minClosest) {
        min = minClosest;
    } else {
        if (guide.findIndex(d => d === minClosest) !== -1) {
            min = guide[guide.findIndex(d => d === minClosest) - 1] || min;
        } else {
            min = Math.min(...uniqueData, guide[0]);
        }
    }
    console.log(min, minClosest, max, maxClosest);
    console.log(seriesData);
    console.log(guideLine);

    let yAxis = {
        title: {
            text: null
        },
        labels: {
            style: {
                fontSize: '11px'
            }
        },
        tickInterval: "auto",
    };

    if (guideLine != null) {

        guideLine = guideLine.filter(c => {
            // max 보다 크고 min 보다 작으면 가이드라인에서 없애기
            return !(max < Number(c.value) || Number(c.value) < min);
        });

        yAxis = Object.assign(yAxis, {
            plotLines: guideLine,
            min: min * 1.3,
            max: max * 1.3
        });
    } else {
        yAxis = Object.assign(yAxis, {
            // min : -defaultInterval,
            // max : defaultInterval
        });
    }

    return Highcharts.stockChart($el[0], {
        chart: {
            height: (parseInt($el.height()) * 0.95) + 'px'
        },
        title: {
            text: null
        },
        rangeSelector: {
            buttons: [{
                type: 'hour',
                text: '1시간'
            }, {
                type: 'day',
                text: '24시간'
            }, {
                type: 'month',
                text: '1개월'
            }],
            selected: 1,
            inputEnabled: false
        },
        // plotOptions: {
        //     candlestick: {
        //         pointPadding: 0,
        //         groupPadding: 0
        //     }
        // },
        // legend: {
        //     enabled: false // Remove series label
        // },
        tooltip: {
            xDateFormat: '%Y-%m-%d %H:%M:%S',
            shared: true,
            style: {
                fontSize: '12px'
            },
            useHTML: true,
            formatter: function () {
                let tooltipHtml = '<b>' + Highcharts.dateFormat('%Y-%m-%d %H:%M', this.x) + '</b><br/>';
                this.points.forEach(function (point) {
                    const pointData = point.point;
                    tooltipHtml += '<div style="margin-top: 5px;"><span style="color:' + point.series.color + '">●</span> <strong>' + point.series.name +
                        '</strong></div>&nbsp;&nbsp;시작: <b>' + pointData.open + '</b>, ' +
                        '종료: <b>' + pointData.close + '</b>, ' +
                        '최고: <b>' + pointData.high + '</b>, ' +
                        '최저: <b>' + pointData.low + '</b><br/>';
                });
                return tooltipHtml;
            }
        },
        xAxis: {
            type: 'datetime',
            tickInterval: "auto",
            labels: {
                style: {
                    fontSize: '10px',
                    whiteSpace: "nowrap"
                },
                format: xAxisFormat,
            }
        },
        yAxis: yAxis,
        series: seriesData
    });
}

function excelDownload(filePathName, params) {
    // JSON 객체를 쿼리 스트링으로 변환
    var queryParams = new URLSearchParams(params).toString();

    // 쿼리 스트링을 URL에 추가
    var url = filePathName + '?' + queryParams;

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

function generateUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

// 가장 가까운 값 찾기
function findClosest(arr, target) {
    return arr.reduce((prev, curr) => {
        return (Math.abs(curr - target) < Math.abs(prev - target) ? curr : prev);
    });
}

function debounce(func, wait) {
    let timeout;
    return function () {
        const context = this, args = arguments;
        clearTimeout(timeout);
        timeout = setTimeout(() => {
            func.apply(context, args);
        }, wait);
    };
}

function openDaumPostcode(zonecode_col, jibunAddress_col, roadAddress_col) {
    console.log(zonecode_col);
    new daum.Postcode({
        oncomplete: function (data) {
            $('input[name="' + zonecode_col + '"]').val(data.zonecode);
            $('input[name="' + jibunAddress_col + '"]').val(data.jibunAddress);
            $('input[name="' + roadAddress_col + '"]').val(data.roadAddress);
        }
    }).open();
}