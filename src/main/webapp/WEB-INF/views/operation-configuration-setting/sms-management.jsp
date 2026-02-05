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
            const path = "/operation-configuration-setting/sms-management";
            initGrid($grid, path, $('#grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                custom: {
                    useFilterToolbar: true,
                }
            }, null, null, {alarm_lvl_nm: "1:1차 초과 이상;2:2차 초과 이상;3:3차 초과 이상;4:4차 초과 이상", sms_autosnd_yn: "Y:Y;N:N"});

            const $partnerSelect = $('#partner_comp_select');
            const $districtSelect = $('#district_select');

            $.ajax({
                url: '/api/maintenance-companies/all',
                type: 'GET',
                success: (res) => {
                    res.forEach((item) => {
                        $partnerSelect.append(
                            "<option value='" + item.partnerCompId + "'>" + item.partnerCompNm + "</option>"
                        );
                    });
                }
            });

            $.ajax({
                url: '/api/districts/all',
                type: 'GET',
                success: (res) => {
                    res.forEach((item) => {
                        $districtSelect.append(
                            "<option value='" + item.districtNo + "'>" + item.districtNm + "</option>"
                        );
                    });
                }
            });

            $('.save-btn').on('click', function () {
                const allRowData = $grid.jqGrid("getRowData");
                const filteredData = allRowData.filter((item) =>
                    item.mgnt_no && item.alarm_lvl_nm
                );
                $.ajax({
                    method: 'post',
                    url: '/operation-configuration-setting/sms-management/mod',
                    traditional: true,
                    data: {jsonData: JSON.stringify(filteredData)},
                    dataType: 'json',
                    success: function (_res) {
                        alert('저장되었습니다.')
                    }
                });
            });

            $('.insertBtn').on('click', () => {
                clearForm();
                initInsertForm();
                popFancy('#lay-form-write');
            });

            $("#form-submit-btn").on('click', () => {
                if (!validated()) {
                    return;
                }
                $.ajax({
                    url: '/api/sms-receivers',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        partnerCompId: $('#partner_comp_select').val(),
                        smsRecvDept: '',
                        districtNo: $('#district_select').val(),
                        smsChgrNm: $('#sms_chgr_nm').val(),
                        smsRecvPh: $('#sms_recv_ph').val(),
                        alarmLvlNm: $('#alarm_lvl_nm_select').val(),
                        smsAutosndYn: $('#sms_autosnd_yn_select').val()
                    }),
                    success: function (_res) {
                        popFancyClose('#lay-form-write');
                        reloadJqGrid($grid);
                    }
                });
            });

            function validated() {
                if (!$('#partner_comp_select').val()) {
                    alert('소속 기관을 선택해주세요.');
                    return false;
                }

                if (!$('#district_select').val()) {
                    alert('현장명을 선택해주세요.');
                    return false;
                }

                if (!$('#sms_chgr_nm').val()) {
                    alert('이름을 입력해주세요.');
                    return false;
                }

                if (!$('#sms_recv_ph').val()) {
                    alert('휴대폰 번호를 입력해주세요.');
                    return false;
                }

                if (!$('#alarm_lvl_nm_select').val()) {
                    alert('경보단계를 선택해주세요.');
                    return false;
                }

                if (!$('#sms_autosnd_yn_select').val()) {
                    alert('자동 전송 여부를 선택해주세요.');
                    return false;
                }

                return true;
            }

            function initInsertForm() {
                $("#form_sub_title").html('신규 등록');
                $("#deleteBtn").hide()
                $("#form-update-btn").hide();
            }

            function clearForm() {
                $('#partner_comp_select').val('');
                $('#district_select').val('');
                $('#sms_chgr_nm').val('');
                $('#sms_recv_ph').val('');
                $('#alarm_lvl_nm_select').val('');
                $('#sms_autosnd_yn_select').val('');
            }

            $('.modifyBtn').on('click', () => {
                const targetArr = getSelectedCheckData($grid);
                if (targetArr.length > 1) {
                    alert('수정할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length === 0) {
                    alert('수정할 데이터를 선택해주세요.');
                    return;
                }
                clearForm();
                initModifyForm(targetArr[0]);
                popFancy('#lay-form-write');
            });

            function initModifyForm(data) {
                $("#form_sub_title").html('상세 정보');

                $("#deleteBtn").show();
                $("#form-submit-btn").hide();
                $("#form-update-btn").show();

                $('#partner_comp_select').val(data.partner_comp_id);
                $('#district_select').val(data.district_no);
                $('#sms_chgr_nm').val(data.sms_chgr_nm);
                $('#sms_recv_ph').val(data.sms_recv_ph);
                $('#alarm_lvl_nm_select').val(data.alarm_lvl_nm);
                $('#sms_autosnd_yn_select').val(data.sms_autosnd_yn);
            }

            $("#form-update-btn").on('click', () => {
                if (!validated()) {
                    return;
                }
                $.ajax({
                    url: '/api/sms-receivers/' + getSelectedCheckData($grid)[0].mgnt_no,
                    type: 'PUT',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        partnerCompId: $('#partner_comp_select').val(),
                        smsRecvDept: '',
                        districtNo: $('#district_select').val(),
                        smsChgrNm: $('#sms_chgr_nm').val(),
                        smsRecvPh: $('#sms_recv_ph').val(),
                        alarmLvlNm: $('#alarm_lvl_nm_select').val(),
                        smsAutosndYn: $('#sms_autosnd_yn_select').val()
                    }),
                    success: function (_res) {
                        popFancyClose('#lay-form-write');
                        reloadJqGrid($grid);
                    }
                });
            });

            $('.excelBtn').on('click', () => {
                downloadExcel('sms receiver', $grid, path);
            });

            $('#deleteBtn').on('click', () => {
                confirm('삭제하시겠습니까?', () => {
                    $.ajax({
                        url: '/api/sms-receivers/' + getSelectedCheckData($grid)[0].mgnt_no,
                        type: 'DELETE',
                        success: function (_res) {
                            popFancyClose('#lay-form-write');
                            reloadJqGrid($grid);
                        }
                    });
                })
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
        <h2 class="txt">SMS 경보대상 관리</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">SMS 경보 대상 관리</h3>
                <div class="btn-group">
                    <a class="insertBtn">신규등록</a>
                    <a class="modifyBtn">상세정보</a>
                    <a class="excelBtn">다운로드</a>
                </div>
                <div id="grid-wrapper" class="contents-in">
                    <table id="jq-grid"></table>
                </div>
            </div>
        </div>
    </div>

    <div id="lay-form-write" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">SMS 경보대상 <span id="form_sub_title">등록/수정</span></div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th class="required_th">소속 기관</th>
                        <td>
                            <select id="partner_comp_select">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="required_th">현장명</th>
                        <td>
                            <select id="district_select">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="required_th">이름</th>
                        <td><input type="text" id="sms_chgr_nm" class="required"/>
                        </td>
                    </tr>
                    <tr>
                        <th class="required_th">휴대폰 번호</th>
                        <td><input type="text" id="sms_recv_ph" class="required" placeholder="Ex) 01012341234 (“-” 없이 숫자만 입력)"/></td>
                    </tr>
                    <tr>
                        <th class="required_th">경보단계</th>
                        <td>
                            <select id="alarm_lvl_nm_select" class="required">
                                <option value="">선택</option>
                                <option value="1차 초과 이상">1차 초과 이상</option>
                                <option value="2차 초과 이상">2차 초과 이상</option>
                                <option value="3차 초과 이상">3차 초과 이상</option>
                                <option value="4차 초과 이상">4차 초과 이상</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="required_th">자동 전송 여부</th>
                        <td>
                            <select id="sms_autosnd_yn_select" class="required">
                                <option value="">선택</option>
                                <option value="Y">Y</option>
                                <option value="N">N</option>
                            </select>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <input type="button" id="form-submit-btn" blue value="저장"/>
                <button type="button" id="deleteBtn">삭제</button>
                <input type="button" id="form-update-btn" blue value="수정"/>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>
    </div>
</section>
</body>
</html>