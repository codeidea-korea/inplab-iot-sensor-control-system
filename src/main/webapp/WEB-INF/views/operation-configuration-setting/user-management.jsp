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
            const path = "/operation-configuration-setting/user-management";

            $grid.on('jqGridGridComplete', function() { // on에서는 명령어 앞에 jqgrid 붙여야 함
                var ids = $grid.jqGrid('getDataIDs');
                    for (var i = 0; i < ids.length; i++) {
                        var rowId = ids[i];
                        var val = $grid.jqGrid('getCell', rowId, 'usr_flag');

                        // 태그가 포함되어 있을 수 있으므로 순수 텍스트만 비교하거나 처리 필요
                        if (val.indexOf('1') > -1) $grid.jqGrid('setCell', rowId, 'usr_flag', '운영 관리자');
                        else if (val.indexOf('0') > -1) $grid.jqGrid('setCell', rowId, 'usr_flag', '시스템 관리자');
                }
            });



            initGrid($grid, path, $('#grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                custom: {
                    useFilterToolbar: true,
                }
            })

            $('.insertBtn').on('click', () => {
                resetForm();
                initInsertForm();
                popFancy('#lay-form-write');

                $("[datepicker]").flatpickr({
                    onReady: function (selectedDates, dateStr, instance) {
                        $('#lay-form-write .flatpickr-input').val(
                            instance.formatDate(new Date(), 'Y-m-d')
                        )
                    }
                });
            });

            function initInsertForm() {
                $("#form_sub_title").html('신규 등록');
                $("#deleteBtn").hide()
                $("#form-update-btn").hide();
                $("#form-submit-btn").show();
                $("#usr_id").attr('readonly', false);
                $("#usr_nm").attr('readonly', false);
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
                resetForm();
                initModifyForm(targetArr[0]);
                popFancy('#lay-form-write');
            });

            function initModifyForm(data) {
                $("#form_sub_title").html('상세 정보');

                $("#usr_id").attr('readonly', true);
                $("#usr_nm").attr('readonly', true);
                $("#deleteBtn").show();
                $("#form-submit-btn").hide();
                $("#form-update-btn").show();

                $("#usr_id").val(data.usr_id);
                $("#usr_nm").val(data.usr_nm);
                $("#usr_ph").val(data.usr_ph);
                $("#e_mail").val(data.e_mail);
                $("#usr_org").val(data.usr_org);
                $("#usr_flag").val(data.usr_flag === '운영 관리자' ? 1 : 0);
                $("[datepicker]").flatpickr({
                    onReady: function (selectedDates, dateStr, instance) {
                        $('#lay-form-write .flatpickr-input').val(
                            instance.formatDate(new Date(data.usr_exp_ymd), 'Y-m-d')
                        )
                    }
                });
            }

            function resetForm() {
                $('#usr_id').val('');
                $('#usr_pwd').val('');
                $('#usr_pwd_confm').val('');
                $('#usr_nm').val('');
                $('#usr_ph').val('');
                $('#e_mail').val('');
                $('#usr_flag').val('');
            }

            $("#form-submit-btn").on('click', () => {
                if (validated(true) === false) {
                    return;
                }
                $.ajax({
                    url: '/operation-configuration-setting/user-management/add',
                    type: 'POST',
                    data: {
                        usr_id: $('#usr_id').val(),
                        usr_pwd: $('#usr_pwd').val(),
                        usr_nm: $('#usr_nm').val(),
                        usr_ph: $('#usr_ph').val(),
                        e_mail: $('#e_mail').val(),
                        usr_org: $('#usr_org').val(),
                        usr_flag: $('#usr_flag').val(),
                        usr_exp_ymd: $('#usr_exp_ymd').val()
                    },
                    success: function (_res) {
                        popFancyClose('#lay-form-write');
                        reloadJqGrid($grid);
                    },
                    error: function (err) {
                        if (err?.responseJSON?.message === "이미 등록된 사용자 ID 입니다.") {
                            alert('이미 등록된 사용자 ID 입니다.');
                        }
                    }
                });
            });

            $("#form-update-btn").on('click', () => {
                if (validated(false) === false) {
                    return;
                }
                $.ajax({
                    url: '/operation-configuration-setting/user-management/mod',
                    type: 'POST',
                    data: {
                        usr_id: $('#usr_id').val(),
                        usr_pwd: $('#usr_pwd').val(),
                        usr_nm: $('#usr_nm').val(),
                        usr_ph: $('#usr_ph').val(),
                        e_mail: $('#e_mail').val(),
                        usr_org: $('#usr_org').val(),
                        usr_flag: $('#usr_flag').val(),
                        usr_exp_ymd: $('#usr_exp_ymd').val()
                    },
                    success: function (_res) {
                        popFancyClose('#lay-form-write');
                        reloadJqGrid($grid);
                    },
                    error: function (_err) {
                        alert('수정에 실패했습니다. 다시 시도해 주세요.');
                    }
                });
            });

            function validated(insert) {
                if ($('#usr_id').val().length < 8) {
                    alert('사용자ID는 최소 8자 이상 입력해 주세요.');
                    return false;
                }

                if (insert) {
                    if (/^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]+$/.test($('#usr_pwd').val()) === false) {
                        alert('비밀번호는 영문자, 숫자, 특수문자 최소 1자 이상 입력해 주세요.');
                        return false;
                    }

                    if ($('#usr_pwd').val() !== $('#usr_pwd_confm').val()) {
                        alert('비밀번호가 일치하지 않습니다.');
                        return false;
                    }
                } else {
                    if ($('#usr_pwd').val() || $('#usr_pwd_confm').val()) {
                        if (/^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]+$/.test($('#usr_pwd').val()) === false) {
                            alert('비밀번호는 영문자, 숫자, 특수문자 최소 1자 이상 입력해 주세요.');
                            return false;
                        }

                        if ($('#usr_pwd').val() !== $('#usr_pwd_confm').val()) {
                            alert('비밀번호가 일치하지 않습니다.');
                            return false;
                        }
                    }
                }

                if ($('#usr_nm').val().length > 10) {
                    alert('사용자명은 10자 이하로 입력해 주세요.');
                    return false;
                }

                if ($('#usr_flag').val() === '') {
                    alert('사용자 권한을 선택해 주세요.');
                    return false;
                }

                return true;
            }

            $('.excelBtn').on('click', () => {
                downloadExcel('users', $grid, path);
            });

            $('#deleteBtn').on('click', () => {
                confirm('삭제하시겠습니까?', () => {
                    $.ajax({
                        url: '/operation-configuration-setting/user-management/del',
                        type: 'POST',
                        data: {
                            usr_id: $('#usr_id').val(),
                        },
                        success: function (_res) {
                            popFancyClose('#lay-form-write');
                            reloadJqGrid($grid);
                        },
                        error: function (_err) {
                            alert('삭제에 실패했습니다. 다시 시도해 주세요.');
                        }
                    });
                })
            });
        });
    </script>
        <style>
        .ui-jqgrid tr.jqgrow td {
            text-align: center !important;
        }
    </style>
</head>

<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"/>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"/>
    </div>
    <div id="container">
        <h2 class="txt">운영환경설정</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">사용자 관리</h3>
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
        <div class="layer-base-title">사용자 <span id="form_sub_title">등록/수정</span></div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th class="required_th">사용자ID</th>
                        <td><input type="text" id="usr_id" placeholder="Ex) 최소 8자 이상" class="required"/></td>
                    </tr>
                    <tr>
                        <th class="required_th">비밀번호</th>
                        <td><input type="password" id="usr_pwd" placeholder="Ex) 영문자, 숫자, 특수문자 최소 1Char"
                                   class="required"/>
                        </td>
                    </tr>
                    <tr>
                        <th class="required_th">비밀번호 확인</th>
                        <td><input type="password" id="usr_pwd_confm" placeholder="Ex) 영문자, 숫자, 특수문자 최소 1Char"
                                   class="required"/></td>
                    </tr>
                    <tr>
                        <th class="required_th">사용자명</th>
                        <td><input type="text" id="usr_nm" placeholder="Ex) 10자 입력 제한" class="required"/></td>
                    </tr>
                    </tbody>
                </table>
                <table style="margin-top: 20px;">
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>휴대폰</th>
                        <td><input type="text" id="usr_ph" placeholder="Ex) 010-1234-5678"/></td>
                    </tr>
                    <tr>
                        <th>E-Mail</th>
                        <td><input type="text" id="e_mail" placeholder="Ex) abc@nate.com"/></td>
                    </tr>
                    <tr>
                        <th>소속 기관</th>
                        <td><input type="text" id="usr_org" placeholder="Ex) 인플랩 A팀"/></td>
                    </tr>
                    </tbody>
                </table>
                <table style="margin-top: 20px;">
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th class="required_th">사용자 권한</th>
                        <td>
                            <select id="usr_flag" name="grade_hid" class="required">
                                <option value="">Ex) 운영 관리자 / 시스템 관리자</option>
                                <%-- 0: 관리자, 1: 운영자 --%>
                                <option value="1">운영 관리자</option>
                                <option value="0">시스템 관리자</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>사용 만료일</th>
                        <td><input type="text" id="usr_exp_ymd" value="" placeholder="" datepicker=""
                                   readonly="readonly"/></td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <input type="button" id="form-submit-btn" blue value="저장"/>
                <button type="button" style="margin-right: auto" id="deleteBtn">삭제</button>
                <input type="button" id="form-update-btn" blue value="수정"/>
                <button type="button" data-fancybox-close>닫기</button>
            </div>
        </div>
    </div>
    </div>
</section>
</body>
</html>