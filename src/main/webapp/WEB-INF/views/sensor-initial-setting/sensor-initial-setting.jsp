<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>
    <script>
        window.jqgridOption = {
            columnAutoWidth: true,
            multiselect: true,
            multiboxonly: false
        };
        $(function () {
            $.ajax({
                url: '/adminAdd/districtInfo/all',
                type: 'GET',
                success: function (res) {
                    res.forEach((item) => {
                        $('#district-no').append(
                            "<option value='" + item.district_no + "'>" + item.district_nm + "</option>"
                        )
                    })
                },
                error: function () {
                    alert('알 수 없는 오류가 발생했습니다.');
                }
            });

            $("#district-no").on('change', function () {
                setGridData();
                $(".jqGrid").trigger('reloadGrid');
            });

            function setGridData() {
                $(".jqGrid").setGridParam({
                    postData: {
                        ...$(".jqGrid").jqGrid('getGridParam', 'postData'),
                        district_no: $('#district-no').val()
                    }
                }, true);
            }

            $('.save-btn').on('click', function () {
                const allRowData = $(".jqGrid").jqGrid("getRowData");
                $.ajax({
                    method: 'POST',
                    url: '/sensor-initial-setting/mod',
                    traditional: true,
                    data: { jsonData: JSON.stringify(allRowData) },
                    dataType: 'json',
                    success: function (_res) {
                        alert('저장되었습니다.')
                        $(".jqGrid").trigger('reloadGrid');
                    },
                    error: function () {
                        alert('입력 값이 올바르지 않습니다.');
                    }
                });
            });
        });
    </script>
</head>

<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"></jsp:include>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"></jsp:include>
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
                            <select id="district-no">
                                <option value="">선택</option>
                            </select>
                        </dd>
                    </dl>
                </div>
                <div class="btn-group">
                    <a class="save-btn">저장</a>
                </div>
                <div class="contents-in">
                    <jsp:include page="./sensor-initial-setting-grid.jsp" flush="true"></jsp:include>
                </div>
            </div>
        </div>
    </div>

    </div>
</section>
</body>
</html>