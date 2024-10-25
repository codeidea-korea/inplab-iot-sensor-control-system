function initGrid($grid, path, $gridWrapper, options = {
    autowidth: true,
    shrinkToFit: true
}) {
    getColumns(path, (columns) => {
        const columnData = {
            model: []
        };

        $.each(columns, (index) => {
            columnData.model.push(setColumn(columns[index]));
        });
        $(window).trigger('beforeLoadGrid', columnData)

        const setting = {
            url: path + '/list',
            datatype: "json",
            cellEdit: true,
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
            jsonReader: {
                root: "rows",
                page: "page",
                total: "total",
                records: "records",
                repeatitems: false
            },
            loadComplete: function () {
                $(window).trigger('loadComplete');
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
            }
        };
        $grid.jqGrid(setting);
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
        console.log('editable', column);
        _column.editable = true;
    }
    console.log(_column)
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