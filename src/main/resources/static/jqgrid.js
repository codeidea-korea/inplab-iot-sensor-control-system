function initGrid($grid, path, $gridWrapper, options = {
    autowidth: true,
    shrinkToFit: true
}, loadCompleteCallback, formatters) {
    getColumns(path, (columns) => {
        const columnData = {
            model: []
        };

        $.each(columns, (index) => {
            columnData.model.push(setColumn(columns[index], formatters));
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
                $(window).trigger('resize');
            },
            beforeRequest: () => {
                const currentPage = $grid.getGridParam('page');
                const postData = $grid.jqGrid('getGridParam', 'postData');
                postData.page = currentPage;
            },
            ondblClickRow: function (rowId) {
                $(window).trigger('gridDblClick', {rowId, ...$grid.jqGrid('getRowData', rowId)});
            },
            onSelectRow: (rowId) => {
                // $(window).trigger('onSelectRow', {rowId, ...$grid.jqGrid('getRowData', rowId)});
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

        if (options.useFilterToolbar) {
            $grid.jqGrid('filterToolbar');
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

function setColumn(column, formatters) {
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
            dataInit: (element) => {
                setRangePicker($(element), () => {
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