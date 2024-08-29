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
/*
const onSelectRow = (rowId) => {
    // 모든 체크박스를 먼저 해제합니다.
    $('input[type="checkbox"]').prop('checked', false);

    // 클릭된 row의 첫 번째 체크박스를 체크합니다.
    let $checkbox = $('#' + rowId).find('input[type="checkbox"]').first();
    $checkbox.prop('checked', true);
};
*/
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

const actFormattedData = (data, key) => {
    return data.map(item => ({
        id: item[key], // cctv_no 값을 id로 설정
        ...item
    }));
};

const setJqGridTable = (data, column, header, gridComplete, onSelectRow, key, gridId, limit, offset, getFunction, groupHeader) => {

    const formattedData = actFormattedData(data, key);

    $(`#${gridId}`).jqGrid({
        datatype: "local",
        data: formattedData,
        height: $('.contents-in').height() - 50,
        width: '100%',
        autowidth: true,
        shrinkToFit: true,
        scroll: true,
        loadtext: "로딩중...",
        colNames : header,
        colModel:column,
        gridComplete: gridComplete,
        onSelectRow: onSelectRow,
    });

    $(`#${gridId}`).closest(".ui-jqgrid-bdiv").on("scroll", function() {
        const $grid = $(this);
        // 스크롤이 맨 아래에 도달했는지 확인
        if ($grid.scrollTop() + $grid.innerHeight() >= $grid[0].scrollHeight) {
            // 스크롤을 빠르게 이동시 랜더링 꼬임 이슈로 setTimeout 사용
            setTimeout(() => {
                offset += limit;
                getFunction({limit : limit, offset : offset}).then((res) => {
                    console.log('res > ', res);
                    if (res.rows.length === 0) {
                        offset -= limit;
                    }
                    $(`#${gridId}`).jqGrid('addRowData', key, res.rows);
                    //addCheckboxToGrid();
                }).catch((fail) => {
                    console.log('setJqGridTable fail > ', fail);
                });
            }, 500);
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

    // 멀티 헤더 설정
    if (Array.isArray(groupHeader)) {
        $(`#${gridId}`).jqGrid('setGroupHeaders', {
            useColSpanStyle: true, // 이 옵션을 true로 설정해야 그룹 컬럼을 제대로 사용할 수 있음
            groupHeaders: groupHeader
        });
    }
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

const isFunctionEmpty = (func) => {
    if (typeof func !== 'function') {
        throw new Error('The provided argument is not a function');
    }

    const funcStr = func.toString().replace(/\s+/g, ''); // 모든 공백 제거
    return funcStr === 'function(){}' || funcStr === '(){}' || funcStr === 'functionempty(){}';
};

$(window).on('resize', function() {
    const gridWidth = $('#gbox_jqGrid').width();  // jqGrid가 포함된 컨테이너의 너비
    $('#jqGrid').jqGrid('setGridWidth', gridWidth); // 그리드의 너비를 설정
});