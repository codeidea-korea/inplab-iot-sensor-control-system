/**
 * jquery 기반 jqgrid 
 * 
 * $gridElement : 그리드로 전환시 사용될 컨테이너 jquery 엘리먼트
 * params : 그리드내부 전송할 파라메터 객체 params.listPathUrl 필수 (jqgrid 뷰 컨트롤러 경로)
 * columnsJson : 그리드 헤더 정보
 * visiblePage : 그리드의 페이징 부분 표시 여부
 * 
 */
function jqgridUtil($gridElement, params, columnsJson, visiblePage, callback, callback2) {
    var _columns = columnsJson;
    var _labels = [];
    var _names = [];
    var _widths = [];
    var _types = [];
    var _order = [];
    var _sortable = [];
    var _search = [];

    var _rowList = [15, 30, 60];
    var jqgridModify;

    var pageCount = 5; // 한 페이지에 보여줄 페이지 수 (ex:1 2 3 4 5)

    // let $parentContainer = $gridElement.parent();

    var columnData = {
        model: []
    };

    if (typeof params.listPathUrl == 'undefined' || params.listPathUrl == null || params.listPathUrl == '') {
        alert('그리드와 연결할 뷰 컨트롤러를 설정해주세요.');
        
        return;
    }

    var $grid = $gridElement;

    $.each(_columns, function () {
        _names.push(this.columnName);
        _labels.push(this.title);
        _widths.push(this.width);
        _types.push(this.type);
    });

    $.getDocHeight = function () {
        var doc = document;
        return Math.max(Math.max(doc.body.scrollHeight, doc.documentElement.scrollHeight), Math.max(doc.body.offsetHeight, doc.documentElement.offsetHeight), Math.max(doc.body.clientHeight, doc.documentElement.clientHeight));
    };

    function numFormat(cellvalue, options, rowObject) {
        if (typeof cellvalue == 'undefined') {
            return '0';
        }
        cellvalue = String(cellvalue);
        return cellvalue.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    }

    function numUnformat(cellvalue, options, rowObject) {
        if (typeof cellvalue == 'undefined') {
            return '0';
        }
        cellvalue = String(cellvalue);
        return cellvalue.replace(/[^\d]+/g, '');
    }

    function timestampFormat(cellvalue, options, rowObject) { // console.log(cellvalue, options, rowObject);
        if (typeof cellvalue == 'undefined' || !cellvalue) {
            return "";
        }

        cellvalue = new Date(cellvalue);
        return cellvalue.toLocaleString("ko-KR");
    }

    // 그리드에 존재하는 select 형태 컬럼을 멀티 필터로 교체한다
    // 백앤드단도 like 가 아닌 in 검색형태로 쿼리 수정 필요
    // 콘트롤러에서는 escape 처리를 해결해야함 StringEscapeUtils.unescapeHtml
    function selectToMultiFilter(columnName) {
        var $target;
        if (typeof columnName == 'undefined') {
            $target = $('.ui-search-input select');
        } else {
            $target = $('.ui-search-input select[name=' + columnName + ']');
        }

        $.each($target, function () {
            $(this).hide();
            $(this).closest('td').append('<input type="text" role="textbox" searchopermenu="true" clearsearch="true" class="ui-widget-content ui-corner-all multi-select" readonly><input type="hidden" name="arr_' + $(this).attr('name') + '"/>'); // input으로 모양을 변경한후

            var selectorBox = '<div class="ui-multi-filter" style="width:' + $(this).closest('td').width() + 'px"><ul>';
            $.each($(this).find('option'), function () {
                selectorBox += '<li><span>' + $(this).html() + '</span><input type="checkbox" value="' + $(this).val() + '" class="chkbox-value"/></li>';
            });
            selectorBox += '</ul></div>';
            $(this).closest('td').append(selectorBox); // 체크박스 모양을 미리 넣어두고
            var $filter = $(this).closest('td').find('.ui-multi-filter');
            $filter.hide();

            $(this).closest('td').on('hover', function () {
                if ($filter.css('display') == 'none') {
                    $filter.show();
                } else {
                    $filter.hide();

                    if (jqgridModify) {
                        reloadJqGrid($grid);
                    }
                }
            });

            // 체크박스 클릭시 value
            $(this).closest('td').find('.ui-multi-filter input.chkbox-value').on('click', function () {
                var selectValue = '';
                var selectName = '';
                jqgridModify = true;
                $.each($(this).closest('.ui-multi-filter').find('input.chkbox-value'), function () {
                    if ($(this).is(':checked')) {
                        selectValue += ",'" + $(this).val() + "'";
                        selectName += ',' + $(this).closest('li').find('span').html();
                    }
                });
                $(this).closest('td').find('input.multi-select').val(selectName.substring(1));
                $(this).closest('td').find('input[type=hidden]').val(selectValue.substring(1));
            });
            $(this).remove();
        });
    }

    $.jgrid.defaults.width = $grid.parent().width(); // 상위 컨테이너 엘리먼트의 넓이에 맞춤

    var flagCellEdit = false;

    $.each(_names, function (idx) {
        var column = {
            name: this,
            label: _labels[idx],
            width: _widths[idx],
            title: false,
            fixed: true
        };

        if (_types[idx].indexOf('#') > -1) {
            _types[idx] = _types[idx].replace(/#/gi, ";");
            column.stype = 'select';
            column.searchoptions = {
                value: _types[idx]
            };       
            var data = _types[idx].split(";");
            column.formatter = function (cellValue, options, rowObject) {
                var res = '';
                $.each(data, function () {
                    var cell = this.split(':');
                    if (cell[1] === cellValue) {
                        res = cell[1];
                    }
                });
                return res;
            }
        } else if (_types[idx].indexOf(':') > -1) { // 값 고정형 콤보박스
            column.stype = 'select';
            column.searchoptions = {
                value: _types[idx]
            };
            var data = _types[idx].split(";");
            column.formatter = function (cellValue, options, rowObject) { // 그리드 출력시 역으로 값 변환
                var res = '';
                $.each(data, function () {
                    var cell = this.split(':');
                    // console.log("cell::{}", cell);
                    if (cell[0] === cellValue) {
                        res = cell[1];
                    }
                });

                return res;
            }
        }

        if (_types[idx].indexOf('range') > -1) { // 달력
            column.sorttype = 'date';
            column.formatter = 'date';
            // column.srcformat = 'Y-m-d';
            // column.newformat = 'Y/m/d';
            column.formatoptions = {
                srcformat: 'Y/m/d',
                newformat: 'Y-m-d'
            };
            column.searchoptions = {
                dataInit: function (element) {
                    // $(element).dateRangePicker({format: 'YYYY/M/D', autoClose: true, getValue: function () { // console.log($(this).val());
                    //     }});

                    // $(element).on('datepicker-change', function () {
                    //     reloadJqGrid($grid);
                    // });

                    // $(element).flatpickr({
                    //     "locale": "ko",
                    //     mode: "range",
                    //     dateFormat: "Y-m-d",
                    //     onClose: function (selectedDates, dateStr, instance) {
                    //         reloadJqGrid($grid);
                    //     }
                    // });

                    setRangePicker($(element), function() {
                        reloadJqGrid($grid);
                    });
                }
            }
        }

        if (_types[idx].indexOf('date') > -1) {
            // 달력
            // console.log('달력');
            column.sorttype = 'date';
            column.formatter = 'date';
            // column.srcformat = 'Y-m-d';
            // column.newformat = 'n/j/Y';
            // column.newformat = 'Y/m/d';
            column.formatoptions = {
                srcformat: 'Y-m-d',
                newformat: 'Y/m/d'
            };
            column.searchoptions = {
                dataInit: function (element) {
                    // $(element).datepicker({
                    //     autoclose: true,
                    //     format: 'YYYY/M/D',
                    //     orientation: 'auto',
                    //     onSelect: function (dt) {
                    //         reloadJqGrid($grid);
                    //     }
                    // });

                    $(element).flatpickr({
                        "locale": "ko",
                        dateFormat: "Y-m-d",
                        onClose: function (selectedDates, dateStr, instance) {
                            reloadJqGrid($grid);
                        }
                    });
                }
            }
        }

        if (_types[idx].indexOf('num') > -1) {
            column.sorttype = 'number';
            column.align = 'right';
            column.formatter = numFormat;
            column.unformat = numUnformat
        }

        if (_types[idx].indexOf('timestamp') > -1) {
            column.sorttype = 'date';
            column.formatter = timestampFormat;
            // column.formatoptions =  {srcformat: 'u/1000', newformat:'Y-m-d h:i:s'}
            // column.formatoptions =  {srcformat: 'u', newformat:'Y/m/d H:i:s'}
        }

        if (_types[idx].indexOf('hidden') > -1 || _types[idx].indexOf('password') > -1) { // if (_types[idx].indexOf('hidden') > -1) {
            column.hidden = true;
        }
        if (_types[idx].indexOf('editable') > -1) {
            column.editable = true;
            flagCellEdit = true;
        }
        columnData.model.push(column);
    });

    if (typeof window.jqgridOption == 'undefined') {
        window.jqgridOption = {};
    }

    var jqGridOption = Object.assign({}, {
        url: params.listPathUrl + '/list',
        mtype: "GET",
        datatype: "json",
        // page: 0,
        colModel: columnData.model,
        formatter: "actions",
        sortIconsBeforeText: true,
        idPrefix: 'g' + $('.ui-jqgrid').length + '_',
        // clearSearch: true,
        formatoptions: {
            keys: true,
            delOptions: {
                serializeDelData: function (postData) {
                    return JSON.stringify(postData);
                },
                ajaxDelOptions: {
                    contentType: "application/json"
                }
            }
        },
        beforeRequest: function (e) {
            var p = Object.assign($grid.jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                return !!this.value;
            }).serializeObject());

            $grid.setGridParam({
                postData: Object.assign(p, params)
            });

            console.log('beforeRequest');
        },
        loadComplete: function (rowId) { 
			
            // console.log(rowId);
            // var rowData = jQuery(this).getRowData(rowId);            
            $('.ui-jqgrid .ui-search-table input').attr('autocomplete', 'new-password');
            
            jqgridModify = false;

            if (visiblePage) {
                if ($grid.parent().find('.paginate').length > 0) {
                    $pager = $grid.parent().find('.paginate');
                } else {
                    $pager = $('<div class="paginate"></div>');
                    $pager.insertAfter($grid);
                }
                initPage($grid, $pager, true, "TOT", pageCount);
            }

            // $grid[0].clearToolbar();
        },
        gridComplete: function () {
            $('.loading').hide();
            
            if(callback2 != undefined) callback2();
            
        },
        ondblClickRow: function (rowId) { // 더블클릭시 색상해제
            $grid.find('tr').removeClass('custom_selected');
            // var rowData = jQuery(this).getRowData(rowId);
        },
        afterEditCell: function (rowid, cellname, value, iRow, iCol) {
            // var retVal = Object.assign($grid.jqGrid('getRowData', rowid), {
            //     cell: {
            //         id: rowid,
            //         cellname: cellname,
            //         value: value,
            //         iRow: iRow,
            //         iCol: iCol
            //     }
            // });
            // $(window).trigger('afterEditCell', retVal);

            $("#" + iRow + "_" + cellname.valueOf()).bind('blur', function () {
                $grid.saveCell(iRow, iCol);
            });
        },
        afterSaveCell: function (rowid, cellname, value, iRow, iCol) {
            // var retVal = Object.assign($grid.jqGrid('getRowData', rowid), {
            //     cell: {
            //         id: rowid,
            //         cellname: cellname,
            //         value: value,
            //         iRow: iRow,
            //         iCol: iCol
            //     }
            // });
            // $(window).trigger('afterSaveCell', retVal);
        },
        onSelectRow: function (rowId) { // add 2019.08.19
            $('.ui-jqgrid-btable tr').removeClass('custom_selected');
            $('.ui-jqgrid-btable tr[aria-selected=true]').addClass('custom_selected');

            // var rowData = jQuery(this).getRowData(rowId);
            // $(window).trigger('onSelectRow', rowData);
            
            var rowData = {rowId, ...jQuery(this).getRowData(rowId)} ;
            rowData.currentTarget = $(this).find('tr[id=' + rowId + ']')[0];

            if ($(this).find('tr[id=' + rowId + ']').find('.cbox').length > 0) {
                const selected = $(this).find('tr[id=' + rowId + ']').find('.cbox').is(':checked');
                rowData = Object.assign(rowData, {
                    selected : selected
                });
            }
            $(window).trigger('onSelectRow', rowData);
            if(callback != undefined) callback(rowData);
        },
        loadonce: false,
        viewrecords: true,
        emptyrecords: '조회된 데이터가 없습니다',
        height: 'auto',
        rowNum: _rowList[0],
        rowList: _rowList,
    }, window.jqgridOption);

    if (visiblePage) {
        jqGridOption = Object.assign(jqGridOption, {
            loadonce: false,
            viewrecords: true,
            rowNum: _rowList[0],
            rowList: _rowList,
        });
    } else {
        jqGridOption = Object.assign(jqGridOption, {
            pgbuttons: false,
            pginput: false,
            viewrecords: false,
            scroll: 1,
        });
    }

    if (flagCellEdit) {
        jqGridOption = Object.assign(jqGridOption, {
            cellEdit: true,
            cellsubmit: 'clientArray',
            cellurl: params.listPathUrl + '/cell',
            beforeSubmitCell: function (rowid, cellname, value) { // submit 전
                console.log({"id": rowid, "cellName": cellname, "cellValue": value});
                return {"id": rowid, "cellName": cellname, "cellValue": value}
            },
            afterSubmitCell: function (res) { // 변경 후
                var aResult = $.parseJSON(res.responseText);
                var userMsg = "";
                if ((aResult.msg == "success")) {
                    userMsg = "데이터가 변경되었습니다.";
                }
                return [
                    (aResult.msg == "success") ? true : false,
                    userMsg
                ];
            }
        });
    }

    $grid.jqGrid(jqGridOption);
    // activate the toolbar searching
    $grid.jqGrid('filterToolbar');

    $grid.closest('.ui-jqgrid').find('.ui-search-toolbar input').on('keyup', function (e) {
        if (e.keyCode == 13) {
            reloadJqGrid($grid);
        }
    });

    // select 태그 동작때문에 기존 click 이벤트를 unbind 해야함 (안그러면 beforeRequest 이벤트가 먼저 실행되어 초기화된 데이터가 반영되질 않음)
    $grid.closest('.ui-jqgrid').find('.ui-jqgrid-htable a.clearsearchclass').off('click').on('click', function () {        
        $(this).closest('tr').find('select option:eq(0)').prop('selected', true);
        $grid[0].clearToolbar();
        reloadJqGrid($grid);
    });

    $grid.jqGrid('navGrid', ".jqGridPager", {
        search: false, // show search button on the toolbar
        add: false,
        edit: false,
        del: false,
        refresh: false
    });
 
    $grid.destroy = function() {
        let tableClassName = this[0].getAttribute("class");
        let $container = $(this[0]).closest('.ui-jqgrid').parent();
        
        if ($container.length == 0)
            return;

        $(this[0]).closest('.ui-jqgrid').empty().remove();
        $container.append('<table class="' + tableClassName + '"></table>');
    };

    return $grid;
};

/**
 * 그리드 관련 global 함수 ******************************************************************************************
*/

function getSelectedData($grid) {
    if (typeof $grid == 'undefined') {
        $grid = $('.jqGrid');
    }

    let selrow = $grid.jqGrid('getGridParam', 'selrow');

    if (selrow == null)
        return null;

    return $grid.jqGrid('getRowData', selrow);
}


function getSelectedCheckData($grid) {
    if (typeof $grid == 'undefined') {
        $grid = $('.jqGrid');
    }

    let selarrrow = $grid.jqGrid('getGridParam', 'selarrrow');
    let result = [];
    $.each(selarrrow, function () {
        result.push($grid.jqGrid('getRowData', this));
    });

    return result;
}

function excelDownload(filePathName) {
    var url = filePathName;

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

function reloadJqGrid($grid) {
    if (typeof $grid == 'undefined') {
        $grid = $('.jqGrid');
    }

    $grid[0].triggerToolbar();
    $grid.trigger('reloadGrid');

    console.log('reloadJqGrid');
}

/**
 * 그리드 페이징 
 * 
 * @param gridId
 * @param pagerId
 * @param pI : 페이지 정보를 나타낼 것인지 / boolean / 생략시 false
 * @param pit : 페이지 정보의 종류 (pI : true 일때) : <br/>
 *   TOT = 총 페이지수 / 갯수 (현재 페이지의 시작 레코드 ~ 현재 페이지의 마지막 레코드) <=== 기본값 <br/>
 *  TOTP = 총 페이지수 / 갯수 <br/>
 *  PSE = (현재 페이지의 시작 레코드 ~ 현재 페이지의 마지막 레코드) <br/>
 */
function initPage($grid, $pager, pI, pit, pageCount) {
    var customPageInfo = ""; // 페이지 정보를 나타낼 것인지 / boolean / 생략시 false
    var customPageInfoType = ""; // 페이지 정보의 종류
    
    if (pI == null || pI == "") {
        customPageInfo = false;
    } else {
        customPageInfo = true;
    }

    if (pit != "TOTP" && pit != "PSE") {
        customPageInfoType = "TOT";
    } else {
        customPageInfoType = pit;
    }

    // 현재 페이지
    var currentPage = $grid.getGridParam('page');
    // 전체 리스트 수

    var totalSize = $grid.getGridParam('records');
    // 그리드 데이터 전체의 페이지 수
    var totalPage = Math.ceil(totalSize / $grid.getGridParam('rowNum'));

    // 전체 페이지 수를 한화면에 보여줄 페이지로 나눈다.
    var totalPageList = Math.ceil(totalPage / pageCount);
    // 페이지 리스트가 몇번째 리스트인지
    var pageList = Math.ceil(currentPage / pageCount);
    // alert("currentPage="+currentPage+"/ totalPage="+totalSize);
    // alert("pageCount="+pageCount+"/ pageList="+pageList);


    // 페이지 리스트가 1보다 작으면 1로 초기화
    if (pageList < 1) {
        pageList = 1;
    }

    // 페이지 리스트가 총 페이지 리스트보다 커지면 총 페이지 리스트로 설정
    if (pageList > totalPageList) 
        pageList = totalPageList;

    // 시작 페이지
    var startPageList = ((pageList - 1) * pageCount) + 1;
    // 끝 페이지
    var endPageList = startPageList + pageCount - 1;

    // alert("startPageList="+startPageList+"/ endPageList="+endPageList);

    // 시작 페이지와 끝페이지가 1보다 작으면 1로 설정
    // 끝 페이지가 마지막 페이지보다 클 경우 마지막 페이지값으로 설정
    if (startPageList < 1) {
        startPageList = 1;
    }

    if (endPageList > totalPage) {
        endPageList = totalPage;
    } 

    if (endPageList < 1) {
        endPageList = 1;
    }
    
    // 페이징 DIV에 넣어줄 태그 생성변수
    var pageInner = "";

    if (currentPage > 5) {
        pageInner += "<span class='customPageMoveBtn'><button class='prev5 pg_page' title='이전 5페이지'><i class='fa-solid fa-angles-left'></i></button></span>";
    }

    if (currentPage == 1) {
        pageInner += "<span class='customPageMoveBtn'><button class='pre pg_page prev' href='#' target='_top' title='이전 페이지'><i class='fa-solid fa-angle-left'></i></button></span>";
    } else {
        pageInner += "<span class='customPageMoveBtn'><button class='pre pg_page prev prevPage' title='이전 페이지'><i class='fa-solid fa-angle-left'></i></button></span>";
    }

    // 페이지 숫자를 찍으며 태그생성 (현재페이지는 강조태그)
    for (var i = startPageList; i <= endPageList; i++) {
        var titleGoPage = i + "페이지로 이동";

        if (i == currentPage) {
            pageInner = pageInner + "<span class='customPageNumberBtn current'><button target='_top' href='#' num='" + (
            i) + "' title='" + titleGoPage + "'><strong>" + (
            i) + "</strong></button></span>";
        } else {
            pageInner = pageInner + "<span class='customPageNumberBtn'><button target='_top' href='#' num='" + (
            i) + "' title='" + titleGoPage + "'>" + (
            i) + "</button></span>";
        }
    }

    if (currentPage >= totalPage) {
        pageInner += "<span class='customPageMoveBtn'><button class='next pg_page' target='_top' href='#' title='다음 페이지'><i class='fa-solid fa-angle-right'></i></button></span>";
    } else {
        pageInner += "<span class='customPageMoveBtn'><button class='next pg_page nextPage' target='_top' title='다음 페이지'><i class='fa-solid fa-angle-right'></i></button></span>";
    }

    if (currentPage + 5 <= totalPage) {
        pageInner += "<span class='customPageMoveBtn'><button class='next5 pg_page' title='다음 5페이지'><i class='fa-solid fa-angles-right'></i></button></span>";
    }

    // 페이지 정보 셋팅
    var pageInfoText = ""; // 페이지 정보를 담을 변수
    if (customPageInfo) { // ////////////////////////////////////////////////////////////////////////////////////////
        var base = parseInt(currentPage, 10) - 1;
        if (base < 0) {
            base = 0;
        }
        base = base * parseInt($grid.getGridParam('rowNum'), 10);
        var from = base + 1;
        var to = base + $grid.getGridParam('reccount');
        // ////////////////////////////////////////////////////////////////////////////////////////

        if (totalSize == 0) {
            pageInfoText = "표시할 데이터가 없습니다";
        } else {
            var totpTxt = "총 " + commify(totalPage) + " 페이지"; // + " / " + commify(totalSize) + " 건";
            var pseTxt = "( " + commify(from) + " ~ " + commify(to) + " )";
            var totTxt = totpTxt; // + " " + pseTxt;
            if (customPageInfoType == "TOTP") {
                pageInfoText = totpTxt;
            } else if (customPageInfoType == "PSE") {
                pageInfoText = pseTxt;
            } else {
                pageInfoText = totTxt;
            }
        }
    }

    var table = "";
    table += "<table width='100%' class='paging_all'>";
    table += "<tr>";
    table += "<td width='29%' class='navLeft'>";
    table += "</td>";
    table += "<td align='center' class='navCenter'>";
    table += pageInner;
    table += "</td>";
    table += "<td width='29%' align='right' class='navRight'>";
    table += customPageInfo ? pageInfoText + " " : "";
    table += "</td>";
    table += "</tr>";
    table += "</table>";

    // 페이징할 DIV태그에 우선 내용을 비우고 페이징 태그삽입
    $pager.html("");
    // 페이징 html 추가
    $pager.append(table);
    // 페이징 클래스 추가
    $pager.addClass("customPaginateBar");

    $pager.find('.prevPage').on('click', function () {
        var currentPage = $grid.getGridParam('page');
        currentPage--;
        $grid.jqGrid('setGridParam', {page: currentPage}).trigger("reloadGrid");
    });

    $pager.find('.nextPage').on('click', function () {
        var currentPage = $grid.getGridParam('page');
        currentPage++;
        $grid.jqGrid('setGridParam', {page: currentPage}).trigger("reloadGrid");
    });

    $pager.find('.prev5').on('click', function () {
        var newPage = Math.max(1, currentPage - 5);
        $grid.jqGrid('setGridParam', {page: newPage}).trigger("reloadGrid");
    });

    $pager.find('.next5').on('click', function () {
        var newPage = Math.min(totalPage, currentPage + 5);
        $grid.jqGrid('setGridParam', {page: newPage}).trigger("reloadGrid");
    });

    $pager.find('.customPageNumberBtn button').on('click', function () {
        $grid.jqGrid('setGridParam', {page: $(this).attr('num')}).trigger("reloadGrid");
    });
}
