<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<table class="jqGrid"></table>
<div class="gridSpacer"></div>
<div class="paginate"></div>
<c:set var="path" value="${requestScope['javax.servlet.forward.servlet_path']}"/>

<script>
    var _columns = ${columns};
    $(function() {
        var _labels = [];
        var _names = [];
        var _widths = [];
        var _types = [];
        var _rowList = [15, 30, 60];
        var columnData = {
            model: []
        };

        var $grid = $(".jqGrid");

        $grid.on('jqGridInitGrid', function() {
            $(this).closest(".ui-jqgrid").find(".ui-jqgrid-htable th input[type='checkbox']").remove();
        });

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
                column.stype = 'select';
                column.searchoptions = {
                    value: _types[idx]
                };
                var data = _types[idx].split(";");
                column.formatter = function (cellValue, options, rowObject) { // 그리드 출력시 역으로 값 변환
                    var res = '';
                    $.each(data, function () {
                        var cell = this.split(':');
                        if (cell[0] === cellValue)
                            res = cell[1];

                    });

                    return res;
                }
            }

            if (_types[idx].indexOf('range') > -1) { // 달력
                column.sorttype = 'date';
                column.formatter = 'date';
                column.formatoptions = {
                    srcformat: 'Y/m/d',
                    newformat: 'Y-m-d'
                };
                column.searchoptions = {
                    dataInit: function (element) {
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
                        $(element).daterangepicker({
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

        $.jgrid.defaults.width = $grid.parent().width();

        $(window).trigger('beforeLoadGrid', columnData);
        var jqGridOption = Object.assign({}, {
            url: '${path}/list',
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
                var params = Object.assign($(".jqGrid").jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                    return !!this.value;
                }).serializeObject());

                $(".jqGrid").setGridParam({
                    postData: Object.assign(params, window.gridParam)
                });
            },
            loadComplete: function (response) {

                var rows = response.rows.map(function (row) {
                    Object.keys(row).forEach(function(key) {
                        if (row[key] === null) {
                            row[key] = '';  // null 값을 빈 문자열로 변환
                        }
                    });
                    if (row.site_logo) {
                        row.site_logo_src = row.site_logo;
                        row.site_logo = `<img src="data:image/jpeg;base64, ` + row.site_logo + `" style="width:100px; height:auto;" />`;
                    } else {
                        row.site_logo_src = '';
                        row.site_logo = `<img src="data:image/jpeg;base64, " style="width:100px; height:auto;" />`;
                    }
                    if (row.site_title_logo) {
                        row.site_title_logo_src = row.site_title_logo;
                        row.site_title_logo = `<img src="data:image/jpeg;base64, ` + row.site_title_logo + `" style="width:100px; height:auto;" />`;
                    } else {
                        row.site_title_logo_src = '';
                        row.site_title_logo = `<img src="data:image/jpeg;base64, " style="width:100px; height:auto;" />`;
                    }

                    if (row.dist_pic) {
                        row.dist_pic_src = row.dist_pic;
                    } else {
                        row.dist_pic_src = '';
                    }

                    if (row.dist_view_pic) {
                        row.dist_view_pic_src = row.dist_view_pic;
                    } else {
                        row.dist_view_pic_src = '';
                    }

                    return row;
                });

                this.addJSONData(rows);

                $(window).trigger('loadComplete', rows);

                $('.jqGrid').on('reloadGrid', function (e) { // console.log(e);
                });

                $('.ui-jqgrid .ui-search-table input').attr('autocomplete', 'new-password');
                window.jqgridModify = false;

                $grid.closest(".ui-jqgrid").find(".ui-jqgrid-htable th input[type='checkbox']").remove();
            },
            gridComplete: function() {
                $(window).trigger('gridComplete');
                if (window.jqgridOption.columnAutoWidth) {
                    $(window).trigger('resize');
                }
                enableColumnReordering();
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
            autowidth: true,
            shrinkToFit: true
        }, window.jqgridOption);

        function enableColumnReordering() {

            $(".ui-jqgrid-labels").sortable({
                items: ".ui-th-column",

                update: function (event, ui) {
                    var newOrder = $(this).sortable("toArray", { attribute: "id" });
                    var newColModel = [];
                    var newRowData = [];

                    newOrder.forEach(function (colId) {
                        var colName = colId.replace("jqgh_", "").replace(/^_/, "");  // "jqgh_" 및 앞의 언더스코어 제거
                        var col = Object.values(_columns).find(c => c.columnName === colName);

                        if (col) {
                            newColModel.push({
                                name: col.columnName,
                                label: col.title,
                                width: col.width,
                                hidden: col.type === "hidden"
                            });
                        } else {
                            newColModel.push({
                                name: colName,
                                label: colName.toUpperCase(),
                                width: 50,  // 기본 너비
                                hidden: false  // 기본으로 표시
                            });
                            console.warn('Column not found for:', colName);
                        }
                    });

                    $grid.jqGrid('getRowData').forEach(function (row) {
                        var newRow = {};
                        newColModel.forEach(function (col) {
                            newRow[col.name] = row[col.name] || '';
                        });
                        newRowData.push(newRow);
                    });

                    $grid.jqGrid('setGridParam', {
                        colModel: newColModel,
                        data: newRowData
                    }).trigger("reloadGrid");
                }
            });
        }


        if (flagCellEdit) {
            jqGridOption = Object.assign(jqGridOption, {
                cellEdit: true,
                cellsubmit: 'clientArray',
                cellurl: '${path}/cell',
                beforeSubmitCell: function (rowid, cellname, value) { // submit 전
                    // console.log({"id": rowid, "cellName": cellname, "cellValue": value});
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


        $(document).on('keydown', '#search', function(e) {
            if (e.keyCode === 13) {  // Enter 키 감지
                var searchValue = $('#search').val();  // 검색어 가져오기
                $(".jqGrid").jqGrid('setGridParam', {
                    postData: {
                        searchKeyword: searchValue
                    },
                    page: 1  // 검색 시 첫 페이지로 이동
                }).trigger('reloadGrid');  // 그리드 새로고침
            }
        });

        $(document).on('click', '.searchBtn', function() {
            var searchValue = $('#search').val();  // 검색어 가져오기
            $(".jqGrid").jqGrid('setGridParam', {
                postData: {
                    searchKeyword: searchValue
                },
                page: 1  // 검색 시 첫 페이지로 이동
            }).trigger('reloadGrid');  // 그리드 새로고침
        });


        if (window.jqgridOption.filterToolbarCheck) {
            $('.jqGrid').jqGrid('filterToolbar');
        }

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
                // 그리드의 너비 조정
                var gridWidth = $(".contents-in").width();
                $grid.jqGrid('setGridWidth', gridWidth, true);  // shrinkToFit를 true로 설정하여 조정

                // 그리드의 높이 조정
                var gridHeight = $(".contents-in").height() - 35;
                $grid.jqGrid('setGridHeight', gridHeight);  // 그리드 높이를 동적으로 설정
            });
            $(window).trigger('resize');
        }
    });

    function downloadExcel(fileName, $grid = $('.jqGrid')) {
        //20231228 urlParameters 추가
        const gridData = $grid.getGridParam('postData');
        const urlParameters = Object.entries(gridData).map(e => e.join('=')).join('&');

        var url = "${path}/excel/" + fileName + '?' + urlParameters;

        // console.log(url);

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

