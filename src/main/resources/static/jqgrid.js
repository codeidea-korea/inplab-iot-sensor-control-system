function initGrid($grid, path, $gridWrapper, options = {
    autowidth: true,
    shrinkToFit: true
}, loadCompleteCallback, formatters, selectableRows) {
    // multi select 제거
    /* 20251020 - 커밋내역상 250224에 전체 선택 제거 요청이 있었던 걸로 보여지나 [ 경보기준관리/센서초기치설정 ] 에서 노출시켜달라고 재요청들어온 걸로 보여지므로 아래와 같이 전체 주석 처리 */
    if(path.includes("/measure-details")){
        $grid.on('jqGridInitGrid', function () {
            $(this).closest(".ui-jqgrid").find(".ui-jqgrid-htable th input[type='checkbox']").remove();
        });
    }

    getColumns(path, (columns) => {
        const columnData = {
            model: []
        };

        $.each(columns, (index) => {
            columnData.model.push(setColumn($grid, columns[index], formatters, selectableRows));
        });

        $(window).trigger('beforeLoadGrid', columnData)

        const setting = Object.assign({}, {
            url: path + '/list',
            datatype: "json",
            cellEdit: true,
            cellsubmit: 'clientArray',
            mtype: "GET",
            colModel: columnData.model,
            rowNum: 50,
            scroll: true,
            scrollrows: true,
            height: "auto",
            viewrecords: true,
            loadonce: false,
            autowidth: true,
            shrinkToFit: true,
            emptyrecords: "조회된 데이터가 없습니다",
            loadComplete: function () {
                $(window).trigger('loadComplete');

                if (loadCompleteCallback) {
                    loadCompleteCallback();
                }
            },
            gridComplete: function () {
                const allData = $grid.jqGrid('getRowData');
                if (!allData.length === 0) {
                    $(window).trigger('resize');
                }
            },
            beforeRequest: () => {
                const currentPage = $grid.getGridParam('page');
                const postData = $grid.jqGrid('getGridParam', 'postData');
                postData.page = currentPage;
            },
            ondblClickRow: function (rowId) {
                $(window).trigger('gridDblClick', {rowId, ...$grid.jqGrid('getRowData', rowId)});
            },
            onSelectRow: function (rowId, status, _e) {
                if (rowId === lastSel) {
                    $(this).jqGrid("resetSelection");
                    lastSel = undefined;
                    status = false;
                } else {
                    lastSel = rowId;
                }
            },
            beforeSelectRow: function (_rowId, _e) {
                $(this).jqGrid("resetSelection");
                return true;
            },
            afterEditCell: function (rowid, cellname, value, iRow, iCol) {
                $(window).trigger('afterEditCell', Object.assign($grid.jqGrid('getRowData', rowid), {
                    cell: {
                        id: rowid,
                        cellname: cellname,
                        value: value,
                        iRow: iRow,
                        iCol: iCol
                    }
                }));
                $("#" + iRow + "_" + cellname.valueOf()).bind('blur', function () {
                    $grid.saveCell(iRow, iCol);
                });
            },
            beforeSubmitCell: function (rowid, cellname, value) { // submit 전
                return {"id": rowid, "cellName": cellname, "cellValue": value}
            },
            afterSaveCell: function (rowid, cellname, value, iRow, iCol) {
                $(window).trigger('afterSaveCell', Object.assign($grid.jqGrid('getRowData', rowid), {
                    cell: {
                        id: rowid,
                        cellname: cellname,
                        value: value,
                        iRow: iRow,
                        iCol: iCol
                    }
                }));
            },
        }, options);

        $grid.jqGrid(setting);

        if (options?.custom?.useFilterToolbar) {
            $grid.jqGrid('filterToolbar');
        }

        if (options?.custom?.multiSelect) {
            $grid.jqGrid('setGridParam', {
                beforeSelectRow: null,
                onSelectRow: null
            });
        }

        setAdditionalFunc($grid, $gridWrapper);
    });
}

function getColumns(path, callback) {
    $.ajax({
        method: 'GET',
        url: path + "/columns",
        success: (columns) => {
            callback(columns);
        }
    })
}

function setColumn($grid, column, formatters, selectableRows) {
    const _column = {
        name: column['columnName'],
        label: column['title'],
        width: column['width'],
        title: false,
        fixed: true
    };

    delete _column.width;
    delete _column.fixed;

    if (column['type'] === 'range') {
        _column.sorttype = 'date';
        _column.formatter = 'date';
        _column.formatoptions = {
            srcformat: 'Y/m/d',
            newformat: 'Y-m-d'
        };
        _column.searchoptions = {
            dataInit: function (element) {
                setRangePicker($(element), function (rangeValue) {
                    const postData = $grid.jqGrid('getGridParam', 'postData');
                    postData[_column.name] = rangeValue
                    reloadJqGrid($grid);
                });
            }
        }
    }

    if (column['type'] === 'datetime') {
        _column.width = '220';
        _column.sorttype = 'date';
        _column.formatter = 'date';
        _column.formatoptions = {
            srcformat: 'Y/m/d H:i:s',
            newformat: 'Y-m-d H:i:s'
        };
        _column.searchoptions = {
            dataInit: function (element) {
                setRangePicker($(element), function (rangeValue) {
                    const postData = $grid.jqGrid('getGridParam', 'postData');
                    postData[_column.name] = rangeValue
                    reloadJqGrid($grid);
                });
            }
        }
    }

    if (column['type'] === 'hidden') {
        _column.hidden = true;
    }

    if (column['type'] === 'editable') {
        _column.editable = true;
    }

    if (formatters && formatters[column['columnName']]) {
        _column.formatter = formatters[column['columnName']].formatter;
    }

    if (column['type'] === 'selectable') {
        _column.editable = true;
        _column.edittype = 'select';
        _column.editoptions = {value: selectableRows[column['columnName']]};
        _column.searchoptions = {
            dataInit: function (element) {
                const $select = $("<select></select>")
                    .attr("id", _column.name)
                    .on("change", (event) => {
                        const postData = $grid.jqGrid('getGridParam', 'postData');
                        postData[_column.name] = $(event.target).val()
                        reloadJqGrid($grid);
                    });
                $select.append($("<option></option>").attr("value", "").text("전체"));

                selectableRows[_column.name].split(";").forEach(item => {
                    const [value, label] = item.split(":");
                    $select.append($("<option></option>").attr("value", value).text(label));
                });

                $(element).replaceWith($select);
                $select.parent().next().remove() // remove 'x' button
            }
        }
    }
    return _column;
}

function setAdditionalFunc($grid, $gridWrapper) {
    $grid.on("scroll", () => {
        const scrollTop = this.scrollTop;
        const scrollHeight = this.scrollHeight;
        const clientHeight = this.clientHeight;
        if (scrollTop + clientHeight >= scrollHeight - 50) {
            const currentPage = $grid.getGridParam('page');
            const lastPage = $grid.getGridParam('lastpage');
            if (currentPage < lastPage) {
                $grid.jqGrid('setGridParam', {
                    page: currentPage + 1
                }).trigger('reloadGrid');
            }
        }
    });
    $(window).resize(function () {
        const gridWidth = $gridWrapper.width();
        $grid.jqGrid('setGridWidth', gridWidth, true);
        const gridHeight = $gridWrapper.height() - 35;
        $grid.jqGrid('setGridHeight', gridHeight);
    });
    $(window).trigger('resize');
}

function downloadExcel(fileName, $grid, path) {
    const gridData = $grid.getGridParam('postData');
    const urlParameters = Object.entries(gridData).map(e => e.join('=')).join('&');

    const url = path + "/excel/" + fileName + '?' + urlParameters;
    const hiddenIFrameId = 'hiddenDownloader';
    let iframe = document.getElementById(hiddenIFrameId);
    if (iframe === null) {
        iframe = document.createElement('iframe');
        iframe.id = hiddenIFrameId;
        iframe.style.display = 'none';
        document.body.appendChild(iframe);
    }
    iframe.src = url;
}