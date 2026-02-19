<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<table id="sms-details-grid"></table>
<div class="gridSpacer"></div>

<script>
    $(document).ready(function () {
        window.jqgridOption = {
            multiselect: true,
            multiboxonly: false,
            columnAutoWidth: true
        };

        const gridId = "sms-details-grid";
        const path = "/sensor/sms-details";

        let _columns = [];

        function phoneFormatter(cellValue) {
            if (!cellValue) return "";

            // 숫자만 추출
            const digits = cellValue.replace(/\D/g, "");

            if (digits.length === 11) {
                // 01012345678 → 010-1234-5678
                return digits.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
            } else if (digits.length === 10) {
                // 02 같은 지역번호 포함 10자리 처리 → 02-1234-5678
                return digits.replace(/(\d{2,3})(\d{3,4})(\d{4})/, "$1-$2-$3");
            }
            return cellValue; // fallback
        }

        $.get(path + "/columns", function (res) {
            _columns = res;

            const _labels = [];
            const _names = [];
            var _widths = [];
            var _types = [];
            var _rowList = [15, 30, 60];
            var pageCount = 5;
            var columnData = {
                model: []
            };
            var $grid = $("#" + gridId);

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
                if (typeof cellvalue === 'undefined')
                    return '0';

                cellvalue = String(cellvalue);
                return cellvalue.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
            }

            function numUnformat(cellvalue, options, rowObject) {
                if (typeof cellvalue === 'undefined')
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

            let flagCellEdit = false;
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
                delete column.width;
                delete column.fixed;

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
                            setRangePicker($(element), function () {
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
                            $(element).daterangepicker({
                                ranges: {
                                    '금일': [moment(), moment()],
                                    '지난 1주': [moment().subtract(6, 'days'), moment()],
                                    '지난 1개월': [moment().subtract(29, 'days'), moment()],
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
                            $(element).on('show.daterangepicker', function (ev, picker) {
                                $(element).val('');
                            });
                            $(element).on('apply.daterangepicker', function (ev, picker) {
                                // todo : 시간 검색 양식?
                                $(element).val(picker.startDate.format('YYYY-MM-DD') + ' ~ ' + picker.endDate.format('YYYY-MM-DD'));
                                reloadJqGrid($grid);
                            });
                        }
                    }
                }

                if (_types[idx].indexOf('date') > -1) {
                    column.sorttype = 'date';
                    column.formatter = 'date';
                    column.formatoptions = {
                        srcformat: 'Y-m-d',
                        newformat: 'Y/m/d'
                    };
                    column.searchoptions = {
                        dataInit: function (element) {
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
                }
                if (_types[idx].indexOf('hidden') > -1 || _types[idx].indexOf('password') > -1) { // if (_types[idx].indexOf('hidden') > -1) {
                    column.hidden = true;
                }
                if (_types[idx].indexOf('editable') > -1) {
                    column.editable = true;
                    flagCellEdit = true;
                }
                if (this.toString() === "sms_recv_ph") {
                    column.formatter = phoneFormatter;
                }
                columnData.model.push(column);
            });

            $.jgrid.defaults.width = $grid.parent().width();

            $(window).trigger('beforeLoadGrid', columnData);

            var jqGridOption = Object.assign({}, {
                url: path + '/list',
                mtype: "GET",
                datatype: "json",
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
                    var params = Object.assign($grid.jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                        return !!this.value;
                    }).serializeObject());

                    $grid.setGridParam({
                        postData: Object.assign(params, window.gridParam)
                    });
                },
                loadComplete: function (rowId) {
                    var rowData = jQuery(this).getRowData(rowId);
                    $(window).trigger('loadComplete', rowData);
                    $grid.on('reloadGrid', function (e) { // console.log(e);
                    });

                    $('.ui-jqgrid .ui-search-table input').attr('autocomplete', 'new-password');
                    window.jqgridModify = false;

                    initPage($grid, $(".paginate"), true, "TOT", pageCount);
                },
                gridComplete: function () {
                    $(window).trigger('gridComplete');
                    if (window.jqgridOption.columnAutoWidth) {
                        $(window).trigger('resize');
                    }
                },
                ondblClickRow: function (rowId) { // 더블클릭시 색상해제
                    $('.ui-jqgrid-btable tr').removeClass('custom_selected');

                    var rowData = jQuery(this).getRowData(rowId);
                    $(window).trigger('gridDblClick', rowData);
                },
                afterEditCell: function (rowid, cellname, value, iRow, iCol) {
                    var retVal = Object.assign($grid.jqGrid('getRowData', rowid), {
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
                        $grid.saveCell(iRow, iCol);
                    });
                },
                afterSaveCell: function (rowid, cellname, value, iRow, iCol) {
                    var retVal = Object.assign($grid.jqGrid('getRowData', rowid), {
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
                onSelectRow: function (rowId) {
                    const $grid = $("#" + gridId);
                    $("#sms-content").text($grid.jqGrid("getRowData", rowId).sms_msg_dtls);

                    const selectedRows = $grid.jqGrid("getGridParam", "selarrrow");

                    if (selectedRows.length > 1) {
                        // 다중 선택이 된 경우, 마지막 선택된 로우만 남기고 나머지를 해제
                        selectedRows.forEach(function (id) {
                            if (id !== rowId) {
                                $grid.jqGrid("setSelection", id, false);
                            }
                        });
                    }

                    $('.ui-jqgrid-btable tr').removeClass('custom_selected');
                    $('.ui-jqgrid-btable tr[aria-selected=true]').addClass('custom_selected');

                    const rowData = { rowId, ...jQuery(this).getRowData(rowId) };
                    $(window).trigger('onSelectRow', rowData);
                },
                loadonce: false,
                viewrecords: true,
                emptyrecords: '조회된 데이터가 없습니다',
                height: 'auto',
                rowNum: _rowList[0],
                rowList: _rowList,
            }, window.jqgridOption);

            if (flagCellEdit) {
                jqGridOption = Object.assign(jqGridOption, {
                    cellEdit: true,
                    cellsubmit: 'clientArray',
                    cellurl: path + '/cell',
                    beforeSubmitCell: function (rowid, cellname, value) { // submit 전
                        return {"id": rowid, "cellName": cellname, "cellValue": value}
                    },
                    afterSubmitCell: function (res) { // 변경 후
                        var aResult = $.parseJSON(res.responseText);
                        var userMsg = "";
                        if ((aResult.msg === "success")) {
                            userMsg = "데이터가 변경되었습니다.";
                        }
                        return [
                            (aResult.msg === "success"),
                            userMsg
                        ];
                    }
                });
            }

            $grid.jqGrid(jqGridOption);
            $grid.jqGrid('filterToolbar');

            $('.ui-search-toolbar input').on('keyup', function (e) {
                if (e.keyCode === 13)
                    $(window).trigger('reloadGrid');
            });

            $('.ui-jqgrid-htable .clearsearchclass').off().on('click', function () {
                $(this).closest('tr').find('select option:eq(0)').prop('selected', true);
                var postData = $grid.jqGrid('getGridParam', 'postData');
                $.each(_names, function (idx, name) {
                    delete postData[name]; // 사용되었던 컬럼명 검색 조건 모두 삭제
                });
                $grid.jqGrid('setGridParam', { postData: postData, page: 1, search: false });
                $grid[0].clearToolbar();
                reloadJqGrid($grid);
            });

            $grid.jqGrid('navGrid', ".jqGridPager", {
                search: false,
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
                $(window).resize(function () {
                    var gridWidth = ($("#lay-sensor-message").width() / 2) - 50;
                    $grid.jqGrid('setGridWidth', gridWidth, true);
                });

                $(window).trigger('resize');
            }
        });

    })
</script>

