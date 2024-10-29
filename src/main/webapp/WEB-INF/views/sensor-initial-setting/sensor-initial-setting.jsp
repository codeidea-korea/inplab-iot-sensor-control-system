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
            const $districtSelect = $('#district-select');
            initGrid($grid, "/sensor-initial-setting", $('#grid-wrapper'), {}, () => {
                const allRowIds = $grid.jqGrid('getDataIDs');
                allRowIds.forEach(rowId => {
                    $grid.jqGrid('setCell', rowId, 'district_nm', $('#district-select option:selected').text());
                });
            })

            $.ajax({
                url: '/adminAdd/districtInfo/all',
                type: 'GET',
                success: (res) => {
                    res.forEach((item) => {
                        $districtSelect.append(
                            "<option value='" + item.district_no + "'>" + item.district_nm + "</option>"
                        )
                    })
                }
            });

            $districtSelect.on('change', (e) => {
                const value = e.target.value;
                if (value === '') {
                    return
                }
                $grid.setGridParam({
                    page: 1,
                    postData: {
                        ...$grid.jqGrid('getGridParam', 'postData'),
                        district_no: value
                    }
                }).trigger('reloadGrid', [{page: 1}]);
            });

            $('.save-btn').on('click', function () {
                const allRowData = $grid.jqGrid("getRowData");
                $.ajax({
                    method: 'POST',
                    url: '/sensor-initial-setting/mod',
                    traditional: true,
                    data: {jsonData: JSON.stringify(allRowData)},
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
                <div class="search-bg">
                    <dl>
                        <dt>현장명</dt>
                        <dd>
                            <select id="district-select">
                                <option value="">선택</option>
                            </select>
                        </dd>
                    </dl>
                </div>
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