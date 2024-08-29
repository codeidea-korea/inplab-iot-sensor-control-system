<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!--
page include 형태 jqgrid_util.js 필요
-->
<table class="jqGrid"></table>
<div class="gridSpacer"></div>
<div class="paginate"></div>
<!--
window 그리드 발생 이벤트

beforeLoadGrid  : 그리드 화면 출력 이전 발생 이벤트
loadComplete    : 그리드 데이터 로딩완료 후
gridDblClick    : 그리드의 row 더블클릭시
afterEditCell   : 셀의 수정이 발생하면
afterSaveCell   : 셀의 수정이 완료되면
onSelectRow     : row 단위로 사용자가 셀렉트 하는 경우 발생
afterLoadGrid   : 그리드의 로딩 및 출력이 모두 완료된후 발생
-->
<c:set var="path" value="${requestScope['javax.servlet.forward.servlet_path']}"/>

<script>
    var _columns = ${columns};

    $(function() {
        var _labels = [];
        var _names = [];
        var _widths = [];
        var _types = [];
        var _rowList = [15, 30, 60];

        var customPageInfo = "";        // 페이지 정보를 나타낼 것인지 / boolean / 생략시 false
        var customPageInfoType = "";    // 페이지 정보의 종류
        var pageCount = 5;             // 한 페이지에 보여줄 페이지 수 (ex:1 2 3 4 5)

        var columnData = {
            model: []
        };

        var $grid = $(".jqGrid");

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
            if (typeof cellvalue == 'undefined')
                return '0';

            cellvalue = String(cellvalue);
            return cellvalue.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
        }

        function numUnformat(cellvalue, options, rowObject) {
            if (typeof cellvalue == 'undefined')
                return '0';

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
                $(this).closest('td').append('<input type="text" role="textbox" searchopermenu="true" id="' + $(this).attr('id') + '" clearsearch="true" class="ui-widget-content ui-corner-all multi-select" readonly><input type="hidden" name="arr_' + $(this).attr('name') + '"/>'); // input으로 모양을 변경한후

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

                        if (window.jqgridModify)
                            reloadJqGrid();
                    }
                });

                // 체크박스 클릭시 value
                $(this).closest('td').find('.ui-multi-filter input.chkbox-value').on('click', function () {
                    var selectValue = '';
                    var selectName = '';
                    window.jqgridModify = true;
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

        var flagCellEdit = false;
        if (typeof window.jqgridOption == 'undefined') {
            window.jqgridOption = {};
        } else {
            if (window.jqgridOption.columnAutoWidth) {
                window.jqgridOption.autowidth = true;
                window.jqgridOption.shrinkToFit = true;
            }
        }


        $.each(_names, function (idx) {
            var column = {
                name: this,
                label: _labels[idx],
                width: _widths[idx],
                title: false,
                fixed: true
            };

            if (window.jqgridOption.columnAutoWidth) {
                delete column.width;
                delete column.fixed;
            }

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
            } else if (_types[idx].indexOf(':') > -1) {
                // 값 고정형 콤보박스
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
                        if (cell[0] === cellValue)
                            res = cell[1];

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
                        //     reloadJqGrid();
                        // });

                        // $(element).flatpickr({
                        //     "locale": "ko",
                        //     mode: "range",
                        //     dateFormat: "Y-m-d",
                        //     onClose: function(selectedDates, dateStr, instance){
                        //         reloadJqGrid();
                        //     }
                        // });

                        setRangePicker($(element), function() {
                            reloadJqGrid($grid);
                        });
                    }
                }
            }

            if (_types[idx].indexOf('timestamp_range') > -1) { // 달력
                column.sorttype = 'date';
                column.formatter = 'timestampFormat';
                column.formatoptions = {
                    srcformat: 'Y/m/d',
                    newformat: 'Y-m-d'
                };
                column.searchoptions = {
                    dataInit: function (element) {
                        // $(element).dateRangePicker({format: 'YYYY/M/D', autoClose: true, getValue: function () { // console.log($(this).val());
                        //     }});

                        // $(element).on('datepicker-change', function () {
                        //     reloadJqGrid();
                        // });

                        // $(element).flatpickr({
                        //     "locale": "ko",
                        //     mode: "range",
                        //     dateFormat: "Y-m-d",
                        //     onClose: function(selectedDates, dateStr, instance){
                        //         reloadJqGrid();
                        //     }
                        // });

                        $(element).daterangepicker({
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
                        });
                        $(element).on('show.daterangepicker', function(ev, picker) {
                            $(element).val('');
                        });
                        $(element).on('apply.daterangepicker', function(ev, picker) {
                            // todo : 시간 검색 양식?
                            $(element).val(picker.startDate.format('YYYY-MM-DD') + ' ~ ' + picker.endDate.format('YYYY-MM-DD'));
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
                        //         reloadJqGrid();
                        //     }
                        // });

                        $(element).flatpickr({
                            "locale": "ko",
                            dateFormat: "Y-m-d",
                            onClose: function(selectedDates, dateStr, instance){
                                reloadJqGrid();
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

            // if (_types[idx].indexOf('autocomplete') > -1) { // 자동완성인 경우 url에 autocomplete가 포함
            //     column.searchoptions = {
            //         // dataInit is the client-side event that fires upon initializing the toolbar search field for a column
            //         // use it to place a third party control to customize the toolbar
            //         dataInit: function (element) {
            //             $(element).attr("autocomplete", "off").typeahead({
            //                 appendTo: "body",
            //                 source: function (query, process) {
            //                     return $.get(_types[idx] + "/" + _names[idx], {
            //                         term: query
            //                     }, function (result) {
            //                         return process(result.data);
            //                     });

            //                     /*function (query, proxy) {
            //                     $.ajax({
            //                         url: _types[idx] + "/" + _names[idx],
            //                         dataType: "application/json",
            //                         data: {term: query},
            //                         success: proxy
            //                     });*/
            //                 }
            //             });
            //         },
            //         sopt: ['eq', 'cn']
            //     }
            // }
            if (_types[idx].indexOf('hidden') > -1 || _types[idx].indexOf('password') > -1) { // if (_types[idx].indexOf('hidden') > -1) {
                column.hidden = true;
            }
            if (_types[idx].indexOf('editable') > -1) {
                column.editable = true;
                flagCellEdit = true;
            }
            columnData.model.push(column);
        });

        $.jgrid.defaults.width = $grid.parent().width();

        $(window).trigger('beforeLoadGrid', columnData);

        var jqGridOption = Object.assign({}, {
            url: '${path}/list',
            mtype: "GET",
            datatype: "json",
            // page: 0,
            colModel: columnData.model,
            formatter: "actions",
            sortIconsBeforeText: true,
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
                var params = Object.assign($(".jqGrid").jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                    return !!this.value;
                }).serializeObject());

                $(".jqGrid").setGridParam({
                    postData: Object.assign(params, window.gridParam)
                });
            },
            loadComplete: function (rowId) { // console.log(rowId);
                var rowData = jQuery(this).getRowData(rowId);
                $(window).trigger('loadComplete', rowData);
                $('.jqGrid').on('reloadGrid', function (e) { // console.log(e);
                });

                $('.ui-jqgrid .ui-search-table input').attr('autocomplete', 'new-password');
                window.jqgridModify = false;

                initPage($(".jqGrid"), $(".paginate"), true, "TOT", pageCount);
            },
            gridComplete: function() {
                $(window).trigger('gridComplete');

                console.log('gridComplete');

                // if (window.jqgridOption.columnAutoWidth) {
                //     $grid.closest('.ui-jqgrid').css('width', '100%');
                // }
                // $.jgrid.defaults.width = $grid.parent().width();

                if (window.jqgridOption.columnAutoWidth) {
                    $(window).trigger('resize');
                }
            },
            ondblClickRow: function (rowId) { // 더블클릭시 색상해제
                $('.ui-jqgrid-btable tr').removeClass('custom_selected');

                var rowData = jQuery(this).getRowData(rowId);
                $(window).trigger('gridDblClick', rowData);
                // console.log('dbclick::');
            },
            afterEditCell: function (rowid, cellname, value, iRow, iCol) {
                var retVal = Object.assign($(".jqGrid").jqGrid('getRowData', rowid), {
                    cell: {
                        id: rowid,
                        cellname: cellname,
                        value: value,
                        iRow: iRow,
                        iCol: iCol
                    }
                });
                $(window).trigger('afterEditCell', retVal);

                $("#" + iRow + "_" + cellname.valueOf()).bind('blur', function () {
                    $('.jqGrid').saveCell(iRow, iCol);
                });
            },
            afterSaveCell: function (rowid, cellname, value, iRow, iCol) {
                var retVal = Object.assign($(".jqGrid").jqGrid('getRowData', rowid), {
                    cell: {
                        id: rowid,
                        cellname: cellname,
                        value: value,
                        iRow: iRow,
                        iCol: iCol
                    }
                });
                $(window).trigger('afterSaveCell', retVal);
            },
            onSelectRow: function (rowId) { // add 2019.08.19
                $('.ui-jqgrid-btable tr').removeClass('custom_selected');
                $('.ui-jqgrid-btable tr[aria-selected=true]').addClass('custom_selected');

                var rowData = {rowId, ...jQuery(this).getRowData(rowId)} ;
                $(window).trigger('onSelectRow', rowData);
            },
            loadonce: false,
            viewrecords: true,
            emptyrecords: '조회된 데이터가 없습니다',
            height: 'auto',
            rowNum: _rowList[0],
            rowList: _rowList,
            // pager: ".jqGridPager",
        }, window.jqgridOption);

        if (flagCellEdit) {
            jqGridOption = Object.assign(jqGridOption, {
                cellEdit: true,
                cellsubmit: 'clientArray',
                cellurl: '${path}/cell',
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
        $('.jqGrid').jqGrid('filterToolbar');

        $('.ui-search-toolbar input').on('keyup', function (e) {
            if (e.keyCode == 13)
                $(window).trigger('reloadGrid');
        });

        $('.ui-jqgrid-htable .clearsearchclass').off().on('click', function () {
            $(this).closest('tr').find('select option:eq(0)').prop('selected', true);
            $grid[0].clearToolbar();
            reloadJqGrid();
        });

        $('.jqGrid').jqGrid('navGrid', ".jqGridPager", {
            search: false, // show search button on the toolbar
            add: false,
            edit: false,
            del: false,
            refresh: false
        });

        $grid.on("click", function () {
            $grid.find('tr').removeClass("ui-state-highlight");
        });

        $(window).trigger('afterLoadGrid', columnData);

        if (window.jqgridOption.columnAutoWidth) {
            $(window).resize(function() {
                console.log('resize');
                var gridWidth = $(window).width() - 445;  // 그리드 컨테이너 너비
                // console.log('resize ' + gridWidth);
                $grid.jqGrid('setGridWidth', gridWidth, true);  // shrinkToFit를 true로 설정하여 조정
            });

            $(window).trigger('resize');
        }
    });

    function downloadExcel(fileName, $grid = $('.jqGrid')) {
        //20231228 urlParameters 추가
        const gridData = $grid.getGridParam('postData');
        const urlParameters = Object.entries(gridData).map(e => e.join('=')).join('&');

        var url = "${path}/excel/" + fileName + '?' + urlParameters;

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

