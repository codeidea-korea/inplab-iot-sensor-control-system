<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"/>
    <style>
        .search-top-label {
            color: #ffffff76;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            padding: 1rem;
        }

        .filter-area .select_filter .search-top-label {
            padding: 0;
        }

        #district-select {
            width: 150px;
            height: 3.6rem;
            padding: 0 1rem;
            background-color: #fff;
            border: 1px solid rgba(0, 0, 0, 0.2);
            font-weight: 300;
            font-size: 1.5rem;
            line-height: 3.4rem;
            color: #47474c;
            display: inline-block;
            vertical-align: top;
            margin-right:auto;
        }

        #contents .contents-in {
            position: static;
            padding: 2rem;
            margin-top: 2rem;
            height: calc(100% - 10rem);
            background-color: #fff;
            border-radius: 1rem;
        }

        .btn-group{
            position: static;
            display:flex;
            align-items:center;
            gap: .8rem;
        }
    </style>
    <script type="text/javascript" src="/jqgrid.js"></script>
    <script>
        $(function () {
            $.when(
                $.get('/adminAdd/common/code/districtInfoList'),
                $.get('/adminAdd/common/code/sensorType'),
                $.get('/adminAdd/common/code/list', {code_grp_nm: "알람상태"}),
                $.get('/adminAdd/common/code/list', {code_grp_nm: "유지보수상태"})
            ).done(function (distRes, typeRes, alarmRes, statusRes) {
                function makeJqGridSelectByName(list) {
                    var str = ':전체';
                    $.each(list, function (i, v) {
                        var name = v.name || v.sens_tp_nm || v.district_nm || v.code_nm;
                        if (name) {
                            str += ";" + name + ":" + name;
                        }
                    });
                    return str;
                }

                const districtStr = makeJqGridSelectByName(distRes[0]);
                const sensorTypeStr = makeJqGridSelectByName(typeRes[0]);
                const alarmStr = makeJqGridSelectByName(alarmRes[0]);
                const sensorStatusStr = makeJqGridSelectByName(statusRes[0]);

                $(window).on('beforeLoadGrid', (e, data) => {
                    const column = data.model.find(col => col.name === 'real_data');
                    if (column) {
                        column.align = 'right';
                    }
                });

                const $grid = $("#jq-grid");

                initGrid($grid, "/sensor-initial-setting", $('#grid-wrapper'), {
                    multiselect: true,
                    multiboxonly: false,
                    custom: {
                        useFilterToolbar: false,
                        multiSelect: true,
                    },
                    loadComplete: function () {
                        if ($grid.data('toolbar_created')) return;

                        $grid.jqGrid('setColProp', 'district_nm', {
                            stype: 'select',
                            searchoptions: {value: districtStr, sopt: ['eq']}
                        });

                        $grid.jqGrid('setColProp', 'sens_tp_nm', {
                            stype: 'select',
                            searchoptions: {value: sensorTypeStr, sopt: ['eq']}
                        });

                        $grid.jqGrid('setColProp', 'emer_status', {
                            stype: 'select',
                            searchoptions: {value: alarmStr, sopt: ['eq']}
                        });

                        $grid.jqGrid('setColProp', 'sens_status', {
                            stype: 'select',
                            searchoptions: {value: sensorStatusStr, sopt: ['eq']}
                        });

                        $grid.jqGrid('filterToolbar', {
                            stringResult: false,
                            searchOnEnter: true,
                            defaultSearch: "cn",
                            ignoreCase: true
                        });

                        $('.clearsearchclass').off('click').on('click', function () {
                            var $this = $(this);
                            var $inputTd = $this.closest('td').prev('td');
                            var $select = $inputTd.find('select');
                            var $input = $inputTd.find('input');

                            if ($select.length > 0) $select.val('');
                            if ($input.length > 0) $input.val('');

                            $grid[0].triggerToolbar();
                        });

                        $grid.data('toolbar_created', true);
                    }
                }, null, {
                    sens_chnl_id: {
                        formatter: function (cellValue, options, rowObject) {
                            return cellValue ? rowObject.sens_nm + '-' + cellValue : rowObject.sens_nm;
                        }
                    }
                });

                $('.save-btn').on('click', function () {
                    const selectedIds = $grid.jqGrid("getGridParam", "selarrrow");

                    if (selectedIds.length === 0) {
                        alert("선택된 데이터가 없습니다.");
                        return;
                    }

                    const selectedData = selectedIds.map(id => $grid.jqGrid("getRowData", id));

                    $.ajax({
                        method: 'POST',
                        url: '/sensor-initial-setting/mod',
                        traditional: true,
                        data: {jsonData: JSON.stringify(selectedData)},
                        dataType: 'json',
                        success: (_res) => {
                            alert('저장되었습니다.')
                            $grid.trigger('reloadGrid');
                        },
                        error: () => {
                            alert('입력 값이 올바르지 않습니다.');
                        }
                    });
                });
            });
        });
    </script>
</head>

<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"/>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"/>
    </div>
    <div id="container">
        <h2 class="txt">센서모니터링</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">초기치설정관리</h3>
                <div class="btn-group">
                    <a class="save-btn">저장</a>
                </div>
                <div id="grid-wrapper" class="contents-in">
                    <table id="jq-grid"></table>
                </div>
            </div>
        </div>
    </div>
    </div>
</section>
</body>
</html>
