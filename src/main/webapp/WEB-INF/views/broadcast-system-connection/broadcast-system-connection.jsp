<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"/>
    <style>
        .contents-re .gridDataContent > table {
            width: calc(100% + 0px);
        }

        .contents-re .gridDataContent {
            height: 200px;
            overflow: auto;
        }
    </style>
    <script type="text/javascript" src="/jqgrid.js"></script>
    <script>
        $(function () {
            const brdcastInfo = []
            let brdcastNoSelections = ''

            $.ajax({
                url: '/broadcast-text/broadcast-info',
                type: 'GET',
                async: false,
                success: function (res) {
                    brdcastInfo.push(...res)
                    brdcastNoSelections = res.map((item) => item.brdcast_no + ':' + item.brdcast_nm + "(" + item.brdcast_no + ")").join(';');
                }
            });

            const $leftGrid = $("#left-jq-grid");
            const leftPath = "/broadcast-text"
            initGrid($leftGrid, leftPath, $('#left-grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                custom: {
                    useFilterToolbar: true,
                }
            }, null, {
                brdcast_no: {
                    formatter: (cellValue, _options, _rowObject) => {
                        const item = brdcastInfo.find((item) => item.brdcast_no === cellValue)
                        return item.brdcast_nm + "(" + item.brdcast_no + ")";
                    }
                },
            }, {brdcast_no: brdcastNoSelections})

            const $rightGrid = $("#right-jq-grid");
            const rightPath = "/broadcast-history"
            initGrid($rightGrid, rightPath, $('#right-grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                custom: {
                    useFilterToolbar: true,
                }
            })


            // 행추가 버튼 클릭 이벤트
            $('.addRow').click(() => {
                addEmptyRow()
            });

            function addEmptyRow() {
                const newRowId = "new_row_" + new Date().getTime();
                const defaultRowData = {mgnt_no: "", brdcast_title: "", brdcast_msg_dtls: ""};
                $leftGrid.jqGrid('addRowData', newRowId, defaultRowData, "last");
            }

            // 저장 버튼 클릭 이벤트
            $('.saveBtn').click(() => {
                const allRowData = $leftGrid.jqGrid("getRowData");
                const filteredData = allRowData.filter((item) =>
                    item.brdcast_msg_dtls && item.brdcast_title
                );
                // TODO 수정해야 됨
                filteredData.map((item) => {
                    item.brdcast_no = item.brdcast_no.split("(")[1].split(")")[0];
                    item.brdcast_dt = new Date().toISOString().slice(0, 10).replace(/-/g, '');
                    item.brdcast_rslt_yn = 'N';
                    item.brdcast_contnts = 'test';
                    item.district_no = 'D01';
                });
                $.ajax({
                    method: 'post',
                    url: '/broadcast-text/save',
                    traditional: true,
                    data: {jsonData: JSON.stringify(filteredData)},
                    dataType: 'json',
                    success: function (_res) {
                        alert('저장되었습니다.')
                    },
                    error: function (_err) {
                        alert('저장에 실패했습니다.')
                    }
                });
            });

            // 삭제 버튼 클릭 이벤트
            $('.deleteBtn').click(() => {
                const selectedRowIds = $leftGrid.jqGrid('getGridParam', 'selarrrow');
                if (selectedRowIds.length === 0) {
                    alert('삭제할 데이터를 선택해주세요.');
                    return;
                } else if (selectedRowIds.length > 1) {
                    alert('삭제할 데이터를 1건만 선택해주세요.');
                    return;
                }

                confirm('삭제하시겠습니까?', () => {
                    const selectedRowData = selectedRowIds.map((rowId) => $leftGrid.jqGrid('getRowData', rowId));
                    $.ajax({
                        url: '/broadcast-text/del',
                        type: 'POST',
                        data: {
                            mgnt_no: selectedRowData[0].mgnt_no
                        },
                        success: function (_res) {
                            $leftGrid.trigger('reloadGrid');
                        },
                        error: function (_err) {
                            alert('삭제에 실패했습니다. 다시 시도해 주세요.');
                        }
                    });
                });
            });

            // 전송 버튼 클릭 이벤트
            $('.submitBtn').click(() => {
                const selectedRowIds = $leftGrid.jqGrid('getGridParam', 'selarrrow');
                if (selectedRowIds.length === 0) {
                    alert('전송할 데이터를 선택해주세요.');
                    return;
                } else if (selectedRowIds.length > 1) {
                    alert('전송할 데이터를 1건만 선택해주세요.');
                    return;
                }

                confirm('전송하시겠습니까?', () => {
                    const selectedRowData = selectedRowIds.map((rowId) => $leftGrid.jqGrid('getRowData', rowId));
                    $.ajax({
                        url: '/broadcast-history/add',
                        type: 'POST',
                        data: {
                            brdcast_msg_dtls: selectedRowData[0].brdcast_msg_dtls
                        },
                        success: function (_res) {
                            $rightGrid.trigger('reloadGrid');
                        },
                        error: function (_err) {
                            alert('전송에 실패했습니다. 다시 시도해 주세요.');
                        }
                    });
                });
            });
        });
    </script>
</head>

<body data-pgCode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"/>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"/>
    </div>
    <div id="container">
        <h2 class="txt">동보방송시스템 연계</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">방송안내 문구 관리</h3>
                <div class="btn-group">
                    <a class="addRow">행추가</a>
                    <a class="saveBtn">저장</a>
                    <a class="deleteBtn">삭제</a>
                    <a class="submitBtn">전송</a>
                </div>
                <div id="left-grid-wrapper" class="contents-in">
                    <table id="left-jq-grid"></table>
                </div>
            </div>
            <div class="contents-re">
                <h3 class="txt">방송 전송이력 조회</h3>
                <div id="right-grid-wrapper" class="contents-in">
                    <table id="right-jq-grid"></table>
                </div>
            </div>
        </div>
    </div>

    <!--[s] 알람 설정 수정 팝업 -->
    <div id="lay-form-write" class="layer-base">
        <input type="hidden" name="alarm_kind_id"/>
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">업로드</div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>엑셀파일</th>
                        <td><input type="file" id="uploadFile" name="uploadFile" value="" placeholder=""/></td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <input type="submit" blue value="저장"/>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>
</section>
</body>
</html>
