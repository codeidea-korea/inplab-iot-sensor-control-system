function initGrid($grid, path, $gridWrapper, options = {
    autowidth: true,
    shrinkToFit: true
}) {
    getColumns(path, (columns) => {
        console.log('jq initGrid');
        const columnData = {
            model: []
        };

        $.each(columns, (index) => {
            columnData.model.push(setColumn(columns[index]));
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
                console.log('jq loadComplete');
                $(window).trigger('loadComplete');
            },
            gridComplete: function () {
                console.log('jq gridComplete');
                $(window).trigger('resize');
            },
            beforeRequest: () => {
                console.log('jq beforeRequest');
                const currentPage = $grid.getGridParam('page');
                const postData = $grid.jqGrid('getGridParam', 'postData');
                postData.page = currentPage;
            },
            ondblClickRow: function (rowId) {
                console.log('jq ondblClickRow');
                $(window).trigger('gridDblClick', {rowId, ...$grid.jqGrid('getRowData', rowId)});
            },
            onSelectRow: (rowId) => {
                console.log('jq onSelectRow');
                // $(window).trigger('onSelectRow', {rowId, ...$grid.jqGrid('getRowData', rowId)});
            },
            afterEditCell: function (rowid, cellname, value, iRow, iCol) {
                console.log('jq afterEditCell');
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
                console.log('jq, beforeSubmitCell');
                return {"id": rowid, "cellName": cellname, "cellValue": value}
            },
            afterSaveCell: function (rowid, cellname, value, iRow, iCol) {
                console.log('jq afterSaveCell');
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
            console.log('jq getColumns', columns);
            callback(columns);
        }
    })
}

function setColumn(column) {
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