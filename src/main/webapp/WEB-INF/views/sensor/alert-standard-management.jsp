<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"/>
    <script type="text/javascript" src="/jqgrid.js"></script>
     <script>
        $(function () {
            const $grid = $("#jq-grid");
            $.when(
                $.get('/adminAdd/common/code/districtInfoList'),
                $.get('/adminAdd/common/code/sensorType'),
            ).done(function(distRes, typeRes){

                function makeJqGridSelectByName(list){
                    var str = ':전체';
                    $.each(list, function(i,v){
                        // Value와 Label 모두 Name을 사용
                        str += ";" + v.name + ":" + v.name;
                    });
                    return str;
                }

                var distStr = makeJqGridSelectByName(distRes[0]);
                var typeStr = makeJqGridSelectByName(typeRes[0]);

                const path = "/sensor/alert-standard-management"

                initGrid($grid, path, $('#grid-wrapper'), {
                    multiselect: true,
                    multiboxonly: false,
                    custom: {
                        useFilterToolbar: false,
                        multiSelect: true,
                    },
                    loadComplete : function(){
                        var $grid = $("#jq-grid");
                        if ($grid.data('toolbar_created')) return;

                        $grid.jqGrid('setColProp','district_nm', {
                            stype: 'select',
                            searchoptions: {value:distStr, sopt:['eq']  }
                        })

                        $grid.jqGrid('setColProp', 'sens_tp_nm', {
                            stype: 'select',
                            searchoptions: { value: typeStr, sopt: ['eq'] }
                        });

                        $grid.jqGrid('filterToolbar', {
                            stringResult: false, // 중요! XML이 개별 파라미터를 받으므로 false여야 함
                            searchOnEnter: true,
                            defaultSearch: "eq",
                            ignoreCase: true

                        });

                        $('.clearsearchclass').off('click').on('click', function () {
                            var $this = $(this);

                            // 1. X버튼이 있는 셀(td)의 바로 앞 셀에서 입력창(Select/Input)을 찾습니다.
                            var $inputTd = $this.closest('td').prev('td');
                            var $select = $inputTd.find('select'); // SelectBox 찾기
                            var $input = $inputTd.find('input');   // InputBox 찾기

                            // 2. 값을 강제로 비웁니다 (SelectBox는 '전체'로 돌아감)
                            if ($select.length > 0) $select.val('');
                            if ($input.length > 0) $input.val('');

                            // 3. 그리드에게 "검색 다시 해!"라고 명령합니다.
                            // (값이 비워졌으니 전체 목록이 조회됩니다)
                            $grid[0].triggerToolbar();
                        });

                        $grid.data('toolbar_created', true);
                    }
                })
            })




            $('.save-btn').on('click', function () {
                const selectedIds = $grid.jqGrid("getGridParam", "selarrrow");

                if (selectedIds.length === 0) {
                    alert("선택된 데이터가 없습니다.");
                    return;
                }

                // 선택한 row 만 업데이트
                const selectedData = selectedIds.map(id => $grid.jqGrid("getRowData", id));
                $.ajax({
                    method: 'post',
                    url: '/sensor/alert-standard-management/mod',
                    traditional: true,
                    data: {jsonData: JSON.stringify(selectedData)},
                    dataType: 'json',
                    success: function (_res) {
                        alert('저장되었습니다.');
                        $grid.trigger('reloadGrid');
                    },
                    error: function (_res) {
                        alert('저장에 실패하였습니다. 입력 값을 확인해 주세요.')
                    }
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
                <h3 class="txt">경보기준관리</h3>
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
