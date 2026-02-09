<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"/>
    <style>
        #contents {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 1.2rem;
        }

        .contents-re .gridDataContent > table {
            width: calc(100% + 0px);
        }

        .contents-re .gridDataContent {
            height: 200px;
            overflow: auto;
        }

        #left-grid-wrapper .ui-jqgrid-htable,
        #left-grid-wrapper .ui-jqgrid-btable {
            width: 100% !important;
            table-layout: fixed;
        }

        #left-grid-wrapper .ui-jqgrid-htable th,
        #left-grid-wrapper .ui-jqgrid-htable td,
        #left-grid-wrapper .ui-jqgrid-btable td {
            box-sizing: border-box;
        }

        #left-grid-wrapper .ui-jqgrid-btable tr.jqgrow td {
            overflow: hidden !important;
            text-overflow: ellipsis;
            white-space: nowrap !important;
            font-size: 0.9em;
            line-height: 1.2;
        }

        #left-grid-wrapper .ui-jqgrid-htable th div {
            font-size: 0.92em;
        }

        #lay-broadcast-text-write.layer-base {
            width: 920px;
            max-width: 92vw;
        }

        #lay-broadcast-text-write .layer-base-conts {
            max-height: none;
            overflow: visible;
        }

        #lay-broadcast-text-write .bTable table th {
            width: 180px;
        }

        #lay-broadcast-text-write textarea {
            width: 100%;
            min-height: 420px;
            resize: none;
        }

        #lay-broadcast-text-write .title-row {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        #lay-broadcast-text-write .title-row input {
            flex: 1;
        }

        #lay-broadcast-text-write .checkDuplicateBtn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 104px;
            height: 38px;
            padding: 0 16px;
            border-radius: 19px;
            border: 1px solid #0f4f74;
            background: #1f6f97;
            color: #fff !important;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            box-sizing: border-box;
        }

        #lay-broadcast-text-write .checkDuplicateBtn:hover {
            background: #175d80;
        }

        .broadcastTextDeleteBtn {
            display: none;
        }

        #lay-broadcast-send-write.layer-base {
            width: 980px;
            max-width: 94vw;
        }

        #lay-broadcast-send-write .layer-base-conts {
            max-height: none;
            overflow: visible;
        }

        #lay-broadcast-send-write .bTable table th {
            width: 180px;
        }

        #lay-broadcast-send-write .send-form-message {
            width: 100%;
            min-height: 250px;
            resize: none;
        }

    </style>
    <script type="text/javascript" src="/jqgrid.js?v=20260209-2"></script>
    <script>
        $(function () {
            let sendFormOptions = {noticeOptions: [], districtOptions: [], equipOptions: []};
            const $leftGrid = $("#left-jq-grid");
            const leftPath = "/broadcast-text"
            initGrid($leftGrid, leftPath, $('#left-grid-wrapper'), {
                cellEdit: false,
                multiselect: true,
                multiboxonly: false,
                multiselectWidth: 24,
                shrinkToFit: true,
                custom: {
                    useFilterToolbar: true,
                    useColumnWidth: true,
                }
            })

            const $rightGrid = $("#right-jq-grid");
            const rightPath = "/broadcast-history"
            $.getJSON(rightPath + "/filter-options", function (rightSelectableRows) {
                initGrid($rightGrid, rightPath, $('#right-grid-wrapper'), {
                    cellEdit: false,
                    multiselect: true,
                    multiboxonly: false,
                    shrinkToFit: true,
                    custom: {
                        useFilterToolbar: true,
                    }
                }, null, null, rightSelectableRows);
            });

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
                openSendModal();
            });

            $('.rightDeleteBtn').click(() => {
                const selectedRowIds = $rightGrid.jqGrid('getGridParam', 'selarrrow');
                if (selectedRowIds.length === 0) {
                    alert('삭제할 이력을 선택해주세요.');
                    return;
                } else if (selectedRowIds.length > 1) {
                    alert('삭제할 이력을 1건만 선택해주세요.');
                    return;
                }

                confirm('선택한 전송이력을 삭제하시겠습니까?', () => {
                    const selectedRow = $rightGrid.jqGrid('getRowData', selectedRowIds[0]);
                    $.ajax({
                        url: '/broadcast-history/del',
                        type: 'POST',
                        data: {mgnt_no: selectedRow.mgnt_no},
                        success: function (_res) {
                            $rightGrid.trigger('reloadGrid');
                        },
                        error: function (_err) {
                            alert('삭제에 실패했습니다. 다시 시도해 주세요.');
                        }
                    });
                });
            });

            $('.newBtn').click(() => {
                resetBroadcastTextForm('new');
                popFancy('#lay-broadcast-text-write', {closeButton: false});
            });

            $('.detailBtn').click(() => {
                const selectedRowIds = $leftGrid.jqGrid('getGridParam', 'selarrrow');
                if (selectedRowIds.length === 0) {
                    alert('상세정보를 확인할 데이터를 선택해주세요.');
                    return;
                } else if (selectedRowIds.length > 1) {
                    alert('상세정보는 1건만 선택해주세요.');
                    return;
                }

                const selectedRow = $leftGrid.jqGrid('getRowData', selectedRowIds[0]);
                resetBroadcastTextForm('detail', selectedRow);
                popFancy('#lay-broadcast-text-write', {closeButton: false});
            });

            $('.checkDuplicateBtn').click(() => {
                const title = $.trim($('#new_brdcast_title').val());
                const currentMgntNo = $.trim($('#edit_mgnt_no').val());
                if (!title) {
                    alert('안내 제목을 입력해주세요.');
                    return;
                }

                $.ajax({
                    url: '/broadcast-text/list',
                    type: 'GET',
                    data: {page: 1, rows: 1000, brdcast_title: title},
                    success: function (res) {
                        const rows = (res && res.rows) ? res.rows : [];
                        const duplicated = rows.some(row =>
                            $.trim(row.brdcast_title) === title &&
                            String(row.mgnt_no || '') !== String(currentMgntNo || '')
                        );
                        if (duplicated) {
                            $('#title_duplicate_checked').val('N');
                            alert('동일한 안내 제목이 이미 존재합니다.');
                            return;
                        }
                        $('#title_duplicate_checked').val('Y');
                        alert('사용 가능한 안내 제목입니다.');
                    },
                    error: function () {
                        alert('중복 확인 중 오류가 발생했습니다.');
                    }
                });
            });

            $('#new_brdcast_title').on('input', function () {
                $('#title_duplicate_checked').val('N');
            });

            $('.newBroadcastSaveBtn').click(() => {
                const title = $.trim($('#new_brdcast_title').val());
                const msg = $.trim($('#new_brdcast_msg_dtls').val());
                const duplicatedChecked = $('#title_duplicate_checked').val();
                const mode = $('#broadcast_text_form_mode').val();
                const mgntNo = $.trim($('#edit_mgnt_no').val());

                if (!title) {
                    alert('안내 제목을 입력해주세요.');
                    return;
                }
                if (!msg) {
                    alert('안내 문구를 입력해주세요.');
                    return;
                }
                if (duplicatedChecked !== 'Y') {
                    alert('안내 제목 중복확인을 먼저 진행해주세요.');
                    return;
                }

                const payload = [{
                    mgnt_no: mode === 'detail' ? mgntNo : '',
                    brdcast_title: title,
                    brdcast_msg_dtls: msg
                }];
                $.ajax({
                    method: 'post',
                    url: '/broadcast-text/save',
                    traditional: true,
                    data: {jsonData: JSON.stringify(payload)},
                    dataType: 'json',
                    success: function () {
                        popFancyClose('#lay-broadcast-text-write');
                        $leftGrid.trigger('reloadGrid');
                        alert(mode === 'detail' ? '수정되었습니다.' : '저장되었습니다.');
                    },
                    error: function () {
                        alert(mode === 'detail' ? '수정에 실패했습니다.' : '저장에 실패했습니다.');
                    }
                });
            });

            $('.broadcastTextDeleteBtn').click(() => {
                const mgntNo = $.trim($('#edit_mgnt_no').val());
                if (!mgntNo) {
                    alert('삭제할 대상이 없습니다.');
                    return;
                }

                confirm('삭제하시겠습니까?', () => {
                    $.ajax({
                        url: '/broadcast-text/del',
                        type: 'POST',
                        data: {mgnt_no: mgntNo},
                        success: function () {
                            popFancyClose('#lay-broadcast-text-write');
                            $leftGrid.trigger('reloadGrid');
                        },
                        error: function () {
                            alert('삭제에 실패했습니다. 다시 시도해 주세요.');
                        }
                    });
                });
            });

            function resetBroadcastTextForm(mode, data) {
                const isDetail = mode === 'detail';
                $('#broadcast_text_form_mode').val(isDetail ? 'detail' : 'new');

                if (isDetail && data) {
                    $('#edit_mgnt_no').val(data.mgnt_no || '');
                    $('#new_brdcast_title').val(data.brdcast_title || '');
                    $('#new_brdcast_msg_dtls').val(data.brdcast_msg_dtls || '');
                    $('#lay-broadcast-text-write .layer-base-title').text('방송안내문구 상세정보');
                    $('.broadcastTextDeleteBtn').show();
                    $('.newBroadcastSaveBtn').text('수정');
                    $('#title_duplicate_checked').val('Y');
                } else {
                    $('#edit_mgnt_no').val('');
                    $('#new_brdcast_title').val('');
                    $('#new_brdcast_msg_dtls').val('');
                    $('#lay-broadcast-text-write .layer-base-title').text('방송안내문구 신규등록');
                    $('.broadcastTextDeleteBtn').hide();
                    $('.newBroadcastSaveBtn').text('저장');
                    $('#title_duplicate_checked').val('N');
                }
            }

            function openSendModal() {
                $.getJSON('/broadcast-text/send-form-options', function (res) {
                    sendFormOptions = res || {noticeOptions: [], districtOptions: [], equipOptions: []};
                    renderSendFormOptions();
                    popFancy('#lay-broadcast-send-write', {closeButton: false});
                }).fail(function () {
                    alert('전송 팝업 데이터를 불러오지 못했습니다.');
                });
            }

            function renderSendFormOptions() {
                const noticeList = sendFormOptions.noticeOptions || [];
                const districtList = sendFormOptions.districtOptions || [];
                const equipList = sendFormOptions.equipOptions || [];

                const $noticeSelect = $('#send_notice_mgnt_no');
                const $districtSelect = $('#send_district_no');
                const $equipSelect = $('#send_brdcast_no');

                $noticeSelect.empty().append('<option value="">선택</option>');
                noticeList.forEach(item => {
                    $noticeSelect.append(
                        $('<option>')
                            .val(String(item.mgnt_no))
                            .text(item.brdcast_title)
                            .attr('data-msg', item.brdcast_msg_dtls || '')
                    );
                });

                $districtSelect.empty().append('<option value="">선택</option>');
                districtList.forEach(item => {
                    $districtSelect.append(
                        $('<option>')
                            .val(item.district_no)
                            .text(item.district_nm)
                    );
                });

                $equipSelect.empty().append('<option value="">선택</option>');
                equipList.forEach(item => {
                    $equipSelect.append(
                        $('<option>')
                            .val(item.brdcast_no)
                            .text(item.brdcast_nm)
                            .attr('data-district-no', item.district_no || '')
                    );
                });

                $('#send_brdcast_msg_preview').val('');

                const selectedRowIds = $leftGrid.jqGrid('getGridParam', 'selarrrow');
                if (selectedRowIds.length === 1) {
                    const selectedRow = $leftGrid.jqGrid('getRowData', selectedRowIds[0]);
                    const matched = noticeList.find(item => (item.brdcast_title || '') === (selectedRow.brdcast_title || ''));
                    if (matched) {
                        $noticeSelect.val(String(matched.mgnt_no)).trigger('change');
                    }
                }
            }

            $('#send_notice_mgnt_no').on('change', function () {
                const selectedMsg = $(this).find('option:selected').attr('data-msg') || '';
                $('#send_brdcast_msg_preview').val(selectedMsg);
            });

            $('#send_district_no').on('change', function () {
                const districtNo = $(this).val();
                const equipList = sendFormOptions.equipOptions || [];
                const $equipSelect = $('#send_brdcast_no');

                $equipSelect.empty().append('<option value="">선택</option>');
                equipList
                    .filter(item => !districtNo || String(item.district_no) === String(districtNo))
                    .forEach(item => {
                        $equipSelect.append(
                            $('<option>')
                                .val(item.brdcast_no)
                                .text(item.brdcast_nm)
                                .attr('data-district-no', item.district_no || '')
                        );
                    });
            });

            $('.sendModalSubmitBtn').click(() => {
                const noticeMgntNo = $('#send_notice_mgnt_no').val();
                const districtNo = $('#send_district_no').val();
                const brdcastNo = $('#send_brdcast_no').val();
                const msg = $.trim($('#send_brdcast_msg_preview').val());

                if (!noticeMgntNo) {
                    alert('안내 제목을 선택해주세요.');
                    return;
                }
                if (!districtNo) {
                    alert('현장을 선택해주세요.');
                    return;
                }
                if (!brdcastNo) {
                    alert('방송장비를 선택해주세요.');
                    return;
                }
                if (!msg) {
                    alert('전송할 안내 문구가 없습니다.');
                    return;
                }

                $.ajax({
                    url: '/broadcast-history/add',
                    type: 'POST',
                    data: {
                        brdcast_msg_dtls: msg,
                        brdcast_no: brdcastNo
                    },
                    success: function () {
                        popFancyClose('#lay-broadcast-send-write');
                        $rightGrid.trigger('reloadGrid');
                        alert('전송되었습니다.');
                    },
                    error: function () {
                        alert('전송에 실패했습니다. 다시 시도해 주세요.');
                    }
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
                    <a class="newBtn">신규등록</a>
                    <a class="detailBtn">상세정보</a>
                    <a class="submitBtn">전송</a>
                </div>
                <div id="left-grid-wrapper" class="contents-in">
                    <table id="left-jq-grid"></table>
                </div>
            </div>
            <div class="contents-re">
                <h3 class="txt">방송 전송이력 조회</h3>
                <div class="btn-group">
                    <a class="rightDeleteBtn">삭제</a>
                </div>
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

    <div id="lay-broadcast-text-write" class="layer-base">
        <input type="hidden" id="broadcast_text_form_mode" value="new"/>
        <input type="hidden" id="edit_mgnt_no" value=""/>
        <input type="hidden" id="title_duplicate_checked" value="N"/>
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">방송안내문구 신규등록</div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="180"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>안내 제목</th>
                        <td>
                            <div class="title-row">
                                <input type="text" id="new_brdcast_title" maxlength="100"/>
                                <a class="checkDuplicateBtn">중복확인</a>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>안내 문구</th>
                        <td>
                            <textarea id="new_brdcast_msg_dtls" maxlength="4000"></textarea>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <a class="broadcastTextDeleteBtn">삭제</a>
                <a class="newBroadcastSaveBtn" blue>저장</a>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>

    <div id="lay-broadcast-send-write" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">방송안내문구 전송</div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="180"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>안내 제목</th>
                        <td>
                            <select id="send_notice_mgnt_no">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>현장선택</th>
                        <td>
                            <select id="send_district_no">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>방송장비</th>
                        <td>
                            <select id="send_brdcast_no">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>안내 문구</th>
                        <td>
                            <textarea id="send_brdcast_msg_preview" class="send-form-message" readonly></textarea>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <a class="sendModalSubmitBtn" blue>전송</a>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>
</section>
</body>
</html>
