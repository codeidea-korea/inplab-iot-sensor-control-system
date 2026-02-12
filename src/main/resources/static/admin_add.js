// 각 행에 체크박스를 추가하는 코드
const addCheckboxToGrid = () => {
    const ids = $("#jqGrid").jqGrid('getDataIDs');
    for (let i = 0; i < ids.length; i++) {
        const id = ids[i];
        $("#jqGrid").jqGrid('setRowData', id, {
            checkbox: "<input type='checkbox' class='row-checkbox' data-id='" + id + "'>"
        });
    }
};

const onSelectRow = (rowId) => {
    // 모든 체크박스를 먼저 해제합니다.
    $('input[type="checkbox"]').prop('checked', false);

    // 클릭된 row의 첫 번째 체크박스를 체크합니다.
    let $checkbox = $('#' + rowId).find('input[type="checkbox"]').first();
    $checkbox.prop('checked', true);
};

const gridComplete = () => {
    // 헤더에 체크박스 추가
    const $grid = $("#jqGrid");
    const $headerCheckbox = $('<input type="checkbox" id="header-checkbox"/>');
    $grid.closest(".ui-jqgrid-view")
        .find("th:first")
        .html($headerCheckbox);

    // 헤더 체크박스 클릭 시 모든 행의 체크박스를 선택 또는 해제
    $headerCheckbox.on('click', function() {
        const isChecked = $(this).is(':checked');
        const rowIds = $grid.jqGrid('getDataIDs');
        for (let i = 0; i < rowIds.length; i++) {
            let rowId = rowIds[i];
            // 행의 체크박스에 체크 또는 해제
            $("#jqGrid").find("tr[id='" + rowId + "']").find("input[type='checkbox']").prop('checked', isChecked);
        }
    });
};

const actFormattedData = (data, keyArray) => {
    return data.map(item => {
        // keyArray의 각 키를 사용하여 id를 생성
        const id = keyArray.map(key => item[key]).join('_');
        return {
            id: id, // 결합된 키 값을 id로 설정
            ...item
        };
    });
};

const setFilterControls = (col, index, distinctDistrict, distinctSensType, filters, gridId, distinctPartnerComp, distinctLogger, distinctSection) => {
    let $cell = $('<th></th>');

   
    if (!col.hidden && index > 0) {
        if (col.name === "district_nm") {
            let $select = $('<select style="width: 98%; box-sizing: border-box;"><option value="">전체</option></select>');
            distinctDistrict.forEach(function (item) {
                $select.append('<option value="' + item.district_nm + '">' + item.district_nm + '</option>');
            });
            $select.on("change", function () {
                const colName = $(`#${gridId}`).jqGrid("getGridParam", "colModel")[index].name;
                const searchValue = $(this).val();
                filters.rules = filters.rules.filter(rule => rule.field !== colName);
                if (searchValue) {
                    filters.rules.push({
                        field: colName,
                        op: "eq",
                        data: searchValue
                    });
                }
                $(`#${gridId}`).jqGrid("setGridParam", {
                    postData: { filters: JSON.stringify(filters) },
                    search: true,
                    page: 1
                }).trigger("reloadGrid");
            });
            $cell.append($select);
        } else if (col.name === "sens_tp_nm") {
            let $select = $('<select style="width: 98%; box-sizing: border-box;"><option value="">전체</option></select>');
            distinctSensType.forEach(function (item) {
                $select.append('<option value="' + item.sens_tp_nm + '">' + item.sens_tp_nm + '</option>');
            });
            $select.on("change", function () {
                const colName = $(`#${gridId}`).jqGrid("getGridParam", "colModel")[index].name;
                const searchValue = $(this).val();
                filters.rules = filters.rules.filter(rule => rule.field !== colName);
                if (searchValue) {
                    filters.rules.push({
                        field: colName,
                        op: "eq",
                        data: searchValue
                    });
                }
                $(`#${gridId}`).jqGrid("setGridParam", {
                    postData: { filters: JSON.stringify(filters) },
                    search: true,
                    page: 1
                }).trigger("reloadGrid");
            });
            $cell.append($select);
        }else if (col.name === "logr_nm" && distinctLogger && distinctLogger.length > 0) {
            let $select = $('<select style="width: 98%; box-sizing: border-box;"><option value="">전체</option></select>');
            distinctLogger.forEach(function (item) {
                $select.append('<option value="' + item.logr_nm + '">' + item.logr_nm + '</option>');
            });
            $select.on("change", function () {
                const colName = $(`#${gridId}`).jqGrid("getGridParam", "colModel")[index].name;
                const searchValue = $(this).val();
                filters.rules = filters.rules.filter(rule => rule.field !== colName);
                if (searchValue) {
                    filters.rules.push({ field: colName, op: "eq", data: searchValue });
                }
                $(`#${gridId}`).jqGrid("setGridParam", { postData: { filters: JSON.stringify(filters) }, search: true, page: 1 }).trigger("reloadGrid");
            });
            $cell.append($select);
        }else if(col.name === "sect_no" && distinctSection && distinctSection.length > 0){
            let $select = $('<select style="width: 98%; box-sizing: border-box;"><option value="">전체</option></select>');
            distinctSection.forEach(function (item) {
                $select.append('<option value="' + item.sect_no + '">' + item.sect_no + '</option>');
            });
            $select.on("change", function () {
                const colName = $(`#${gridId}`).jqGrid("getGridParam", "colModel")[index].name;
                const searchValue = $(this).val();
                filters.rules = filters.rules.filter(rule => rule.field !== colName);
                if (searchValue) {
                    filters.rules.push({ field: colName, op: "eq", data: searchValue });
                }
                $(`#${gridId}`).jqGrid("setGridParam", { postData: { filters: JSON.stringify(filters) }, search: true, page: 1 }).trigger("reloadGrid");
            });
            $cell.append($select);
        }else if (col.name === "partner_comp_nm" && distinctPartnerComp && distinctPartnerComp.length > 0) {
            let $select = $('<select style="width: 98%; box-sizing: border-box;"><option value="">전체</option></select>');
            distinctPartnerComp.forEach(function (item) {
                $select.append('<option value="' + item.partner_comp_nm + '">' + item.partner_comp_nm + '</option>');
            });
            $select.on("change", function () {
                const colName = $(`#${gridId}`).jqGrid("getGridParam", "colModel")[index].name;
                const searchValue = $(this).val();
                filters.rules = filters.rules.filter(rule => rule.field !== colName);
                if (searchValue) {
                    filters.rules.push({
                        field: colName,
                        op: "eq",
                        data: searchValue
                    });
                }
                $(`#${gridId}`).jqGrid("setGridParam", {
                    postData: { filters: JSON.stringify(filters) },
                    search: true,
                    page: 1
                }).trigger("reloadGrid");
            });
            $cell.append($select);
        } else if (col.name === "rtsp_status") {
            let $select = $('<select style="width: 98%; box-sizing: border-box;"><option value="">전체</option></select>');
            $select.append('<option value="Y">정상</option>');
            $select.append('<option value="N">에러</option>');
            $select.on("change", function () {
                const colName = $(`#${gridId}`).jqGrid("getGridParam", "colModel")[index].name;
                const searchValue = $(this).val();
                filters.rules = filters.rules.filter(rule => rule.field !== colName);
                if (searchValue) {
                    filters.rules.push({
                        field: colName,
                        op: "eq",
                        data: searchValue
                    });
                }
                $(`#${gridId}`).jqGrid("setGridParam", {
                    postData: { filters: JSON.stringify(filters) },
                    search: true,
                    page: 1
                }).trigger("reloadGrid");
            });
            $cell.append($select);
        } else if (col.name === "maint_sts_cd") {
            let $select = $('<select style="width: 98%; box-sizing: border-box;"><option value="">전체</option></select>');
            $select.append('<option value="MTN001">정상</option>');
            $select.append('<option value="MTN002">망실</option>');
            $select.append('<option value="MTN003">점검</option>');
            $select.append('<option value="MTN004">철거</option>');
            $select.on("change", function () {
                const colName = $(`#${gridId}`).jqGrid("getGridParam", "colModel")[index].name;
                const searchValue = $(this).val();
                filters.rules = filters.rules.filter(rule => rule.field !== colName);
                if (searchValue) {
                    filters.rules.push({
                        field: colName,
                        op: "eq",
                        data: searchValue
                    });
                }
                $(`#${gridId}`).jqGrid("setGridParam", {
                    postData: { filters: JSON.stringify(filters) },
                    search: true,
                    page: 1
                }).trigger("reloadGrid");
            });
            $cell.append($select);
        } else if (col.name === "inst_ymd" || col.name === "meas_dt") {
            $(`#${gridId}`).jqGrid('setColProp', col.name, {
                sorttype: "date",
                formatoptions: { srcformat: "Y-m-d", newformat: "Y-m-d" }
            });

            let $input = $('<input type="text" style="width: 98%; box-sizing: border-box;" />');
            $input.daterangepicker({
                ranges: {
                    '금일': [moment(), moment()],
                    '지난 1주': [moment().subtract(6, 'days'), moment()],
                    '지난 1개월': [moment().subtract(29, 'days'), moment()],
                    '지난 3개월': [moment().subtract(3, 'month'), moment()],
                    '지난 6개월': [moment().subtract(6, 'month'), moment()],
                    '1년': [moment().subtract(1, 'year').startOf('year'), moment().subtract(1, 'year').endOf('year')]
                },
                locale: {
                    format: 'YYYY-MM-DD',
                    separator: ' ~ ',
                    applyLabel: '적용',
                    cancelLabel: '취소',
                    fromLabel: 'From',
                    toLabel: 'To',
                    customRangeLabel: '사용자 정의',
                    daysOfWeek: ['일', '월', '화', '수', '목', '금', '토'],
                    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
                },
                alwaysShowCalendars: true,
                autoUpdateInput: false,
                opens: 'right'
            }, function (start, end, label) {
                $input.val(start.format('YYYY-MM-DD') + ' ~ ' + end.format('YYYY-MM-DD'));

                filters.rules = filters.rules.filter(rule => rule.field !== col.name);
                filters.rules.push({
                    field: col.name,
                    op: "ge",
                    data: start.format('YYYY-MM-DD')
                });
                filters.rules.push({
                    field: col.name,
                    op: "le",
                    data: end.format('YYYY-MM-DD')
                });

                $(`#${gridId}`).jqGrid("setGridParam", {
                    postData: { filters: JSON.stringify(filters) },
                    search: true,
                    page: 1
                }).trigger("reloadGrid");
            });
            $cell.append($input);
        } else {
            let $input = $('<input type="text" style="width: 98%; box-sizing: border-box;" />');
            $input.on("keydown", function (e) {
                if (e.key !== 'Enter') return;
                const colName = $(`#${gridId}`).jqGrid("getGridParam", "colModel")[index].name;
                const searchValue = $(this).val();
                filters.rules = filters.rules.filter(rule => rule.field !== colName);
                if (searchValue) {
                    filters.rules.push({
                        field: colName,
                        op: "cn",
                        data: searchValue
                    });
                }
                $(`#${gridId}`).jqGrid("setGridParam", {
                    postData: { filters: JSON.stringify(filters) },
                    search: true,
                    page: 1
                }).trigger("reloadGrid");
            });
            $cell.append($input);
        }
    }
    return $cell;
};

const setJqGridTable = (data, column, header, gridComplete, onSelectRow, keyArray, gridId, limit, offset, getFunction, groupHeader, loadComplete) => {

    const formattedData = actFormattedData(data, keyArray);

    const $gridEl = $(`#${gridId}`);
    const $cont   = $gridEl.closest('.layer-base-conts');
    const contH   = ($cont.length ? $cont.innerHeight() : 0)
        || ($('.contents-in').length ? $('.contents-in').innerHeight() : 0)
        || 520;
    const gridH = Math.max(300, contH - 120);

    let settingObj = {
        datatype: "local",
        data: formattedData,
        height: gridH,
        width: '100%',
        autowidth: true,
        shrinkToFit: true,
        scroll: false,
        rowNum: 10000,
        loadtext: "로딩중...",
        colNames : header,
        colModel:column,
        gridComplete: gridComplete,
        onSelectRow: onSelectRow,
        loadComplete: loadComplete,
    };

    if (gridId !== 'jqGrid-2') {
        settingObj.reorderColumns = true;
        settingObj.sortable = true;
    }

    $(`#${gridId}`).jqGrid(settingObj);

    // 멀티 헤더 설정
    if (Array.isArray(groupHeader)) {
        $(`#${gridId}`).jqGrid('setGroupHeaders', {
            useColSpanStyle: true, // 이 옵션을 true로 설정해야 그룹 컬럼을 제대로 사용할 수 있음
            groupHeaders: groupHeader
        });
    }

    let lastScrollTop = 0; // 마지막 스크롤 위치 저장
    let isFetching = false; // 데이터 요청 중인지 여부를 확인
    let wheelCount = 0;
    let wheelResetTimer = null;  // 휠 이벤트 리셋 타이머
    const $gridWrapper = $(`#${gridId}`).closest(".ui-jqgrid-bdiv");

    $gridWrapper.on("scroll", function() {
        const $grid = $(this);
        const currentScrollTop = $grid.scrollTop();
        const maxScrollTop = $grid[0].scrollHeight - $grid.innerHeight();

        // 스크롤이 맨 아래에 도달했는지 확인
        if (currentScrollTop >= maxScrollTop) {
            lastScrollTop = currentScrollTop;
        }
    });

    $gridWrapper.on("wheel", function(event) {
        const $grid = $(this);
        const currentScrollTop = $grid.scrollTop();
        const maxScrollTop = $grid[0].scrollHeight - $grid.innerHeight();

        // 스크롤이 맨 아래에 도달했고, 휠을 아래로 돌렸을 때만 실행
        if (currentScrollTop >= maxScrollTop && event.originalEvent.deltaY > 0) {
            // 이벤트 버블링 및 기본 동작 차단
            event.preventDefault();
            event.stopPropagation();

            // 휠 이벤트 카운트 증가
            wheelCount++;

            // 연속 휠 카운트를 일정 시간 후 리셋하기 위한 타이머 설정
            if (wheelResetTimer) {
                clearTimeout(wheelResetTimer);
            }

            wheelResetTimer = setTimeout(() => {
                wheelCount = 0;  // 일정 시간 후 휠 카운트 리셋
            }, 300);  // 300ms 이내에 3번 이상 발생해야 동작

            // 휠 카운트가 3번 이상일 때만 동작
            if (wheelCount >= 3) {
                wheelCount = 0;  // 카운트를 초기화

                if (!isFetching) {  // 이미 데이터를 가져오는 중이면 실행하지 않음
                    isFetching = true;

                    offset += limit;
                    getFunction({ limit: limit, offset: offset }).then((res) => {
                        console.log('res > ', res);

                        if (res.rows.length === 0) {
                            offset -= limit;
                        }

                        // 고유 식별자가 추가된 데이터를 jqGrid에 추가
                        const addFormattedData = actFormattedData(res.rows, keyArray);
                        addFormattedData.forEach(row => {
                            $(`#${gridId}`).jqGrid('addRowData', row.id, row); // id는 keyArray로 생성한 고유한 값
                        });

                        // 필터가 적용되어 있으면 필터 재적용
                        const currentFilters = $(`#${gridId}`).jqGrid('getGridParam', 'postData').filters;
                        if (currentFilters !== undefined && JSON.parse(currentFilters).rules.length > 0) {
                            $(`#${gridId}`).jqGrid("setGridParam", {
                                search: true,
                                postData: {
                                    filters: currentFilters
                                },
                                page: 1
                            }).trigger("reloadGrid");
                        }

                        // 추가적인 동작이 필요한 경우
                        if (getFunction.name === 'getSensor') {
                            $(`#${gridId}`).parent().height($(`#${gridId}`).height() + 10);
                        }

                        isFetching = false;  // 데이터 로드 완료 시 플래그 해제
                    }).catch((fail) => {
                        console.log('setJqGridTable fail > ', fail);
                        isFetching = false;  // 실패 시에도 플래그 해제
                    });
                }
            }
            isFetching = false;  // 데이터 로드 완료 시 플래그 해제
        }
    });

    $(`#${gridId}`).on('click', 'input[type="checkbox"]', function() {
        const $this = $(this);
        if (!$this.prop('checked')) {
            $this.prop('checked', false);
            $(`#${gridId}`).jqGrid('resetSelection');
        } else {
            $(`#${gridId}`+' input[type="checkbox"]').prop('checked', false);
            $this.prop('checked', true);
            $(`#${gridId}`).jqGrid('setSelection', $(this).val(), true);
        }
    });
};

const alert2 = (msg, callbackYes) => {
    $("div[id=alert]").each(function () {
        $(this).remove();
    });
    $("body").append(
        '<div id="alert" class="layer-alarm"><div class="layer-alarm-btns"><a href="#" data-fancybox-close><img src="/images/btn_lay_close.png" alt="닫기" /></a></div><div class="layer-base-title">안내</div><div class="layer-alarm-conts"><p class="txt">' +
        msg +
        '</p><p class="btn"><a href="#" blue data-fancybox-close class="confirm">확인</a></p></div></div>'
    );
    popFancy("#alert");

    $("#alert .confirm").on("click", function () {
        try {
            callbackYes();
        } catch (e) {}
    });
};

const confirm2 = (msg, callbackYes) => {
    $("div[id=alert]").each(function () {
        $(this).remove();
    });
    $("body").append(
        '<div id="alert" class="layer-alarm"><div class="layer-alarm-btns"><a href="#" data-fancybox-close><img src="/images/btn_lay_close.png" alt="닫기" /></a></div><div class="layer-base-title">안내</div><div class="layer-alarm-conts"><p class="txt">' +
        msg +
        '</p><p class="btn"><a href="#" blue class="confirm" data-fancybox-close>확인</a><a href="#" class="close" data-fancybox-close>취소</a></p></div></div>'
    );
    popFancy("#alert");

    $("#alert .confirm").on("click", function () {
        try {
            callbackYes();
        } catch (e) {}

        $(this).closest(".btn").find("a.close").trigger("click");
    });
};

const makeExcelData = (file_name) => {
    let obj = {};
    let headerArray = [];
    let totalRowArray = [];

    $('.ui-common-table').eq(0).find('div[id^=jqgh_jqGrid_]').each(function() {
        headerArray.push($(this).text());
    });

    $('#jqGrid').eq(0).find('tr').each(function(index) {
        if (index === 0) return;
        let rowArray = [];
        $(this).find('td').each(function() {
            if ($(this).attr('aria-describedby') === 'jqGrid_checkbox') return;
            rowArray.push($(this).text());
        });
        totalRowArray.push(rowArray);
    });

    obj = {
        header : headerArray,
        rows : totalRowArray,
        file_name : file_name,
    };

    return obj;
};

const listExcelDown = (obj) => {
    let request = new XMLHttpRequest();
    request.open("POST", "/adminAdd/excel/down", true);
    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    request.responseType = "blob";

    request.onload = function(e) {

        let filename = "";
        let disposition = request.getResponseHeader("Content-Disposition");
        if (disposition && disposition.indexOf("attachment") !== -1) {
            let filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
            let matches = filenameRegex.exec(disposition);
            if (matches != null && matches[1])
                filename = decodeURI( matches[1].replace(/['"]/g, "") );
        }
        console.log("FILENAME: " + filename);

        if (this.status === 200) {
            let blob = this.response;
            if(window.navigator.msSaveOrOpenBlob) {
                window.navigator.msSaveBlob(blob, filename);
            }
            else{
                let downloadLink = window.document.createElement("a");
                let contentTypeHeader = request.getResponseHeader("Content-Type");
                downloadLink.href = window.URL.createObjectURL(new Blob([blob], { type: contentTypeHeader }));
                downloadLink.download = filename;
                document.body.appendChild(downloadLink);
                downloadLink.click();
                document.body.removeChild(downloadLink);
            }
        }
    };
    request.send(JSON.stringify(obj));
};

const getDistrictInfo = () => {
    return new Promise((resolve, reject) => {
        $.ajax({
            type: 'GET',
            url: `/adminAdd/cctv/district`,
            dataType: 'json',
            contentType: 'application/json; charset=utf-8',
            async: true,
        }).done(function(res) {
            resolve(res);
        }).fail(function(fail) {
            reject(fail);
            console.log('getDistrictInfo fail > ', fail);
            alert2('현장 정보를 가져오는데 실패했습니다.', function() {});
        });
    });
};

const getMaintCompInfo = (obj) => {
    return new Promise((resolve, reject) => {
        $.ajax({
            type: 'GET',
            url: `/adminAdd/cctv/maintComp`,
            dataType: 'json',
            contentType: 'application/json; charset=utf-8',
            async: true,
            data: obj
        }).done(function(res) {
            resolve(res);
        }).fail(function(fail) {
            reject(fail);
            console.log('getMaintCompInfo fail > ', fail);
            alert2('유지보수 업체 정보를 가져오는데 실패했습니다.', function() {});
        });
    });
};

const getDistinct = (obj) => {
    return new Promise((resolve, reject) => {
        $.ajax({
            type: 'GET',
            url: `/modify/sensor/distinct`,
            dataType: 'json',
            contentType: 'application/json; charset=utf-8',
            async: true,
            data: obj
        }).done(function(res) {
            resolve(res);
        }).fail(function(fail) {
            reject(fail);
            console.log('getDistinct fail > ', fail);
        });
    });
};

const isFunctionEmpty = (func) => {
    if (typeof func !== 'function') {
        throw new Error('The provided argument is not a function');
    }

    const funcStr = func.toString().replace(/\s+/g, ''); // 모든 공백 제거
    return funcStr === 'function(){}' || funcStr === '(){}' || funcStr === 'functionempty(){}';
};

const isValidTimestamp = (timestamp) => {
    // 정규식으로 'YYYY-MM-DD HH:MM:SS' 형식 검사
    const regex = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/;
    // 형식이 맞는지 확인
    if (!regex.test(timestamp)) {
        return false;
    }
    // 실제 날짜로 변환 가능한지 확인
    const date = new Date(timestamp.replace(' ', 'T')); // Date 객체로 변환
    // 유효한 날짜인지 확인
    return !isNaN(date.getTime());
};

$(window).on('resize', function() {
    const gridWidth = $('#gbox_jqGrid').width();  // jqGrid가 포함된 컨테이너의 너비
    $('#jqGrid').jqGrid('setGridWidth', gridWidth); // 그리드의 너비를 설정
});