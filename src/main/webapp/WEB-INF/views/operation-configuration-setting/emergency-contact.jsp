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
            const path = "/operation-configuration-setting/emergency-contact";
            initGrid($grid, path, $('#grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                useFilterToolbar: true,
            })

            $.ajax({
                url: '/adminAdd/districtInfo/all',
                type: 'GET',
                success: function (res) {
                    res.forEach((item) => {
                        $('#district_no').append(
                            "<option value='" + item.district_no + "'>" + item.district_nm + "</option>"
                        )
                    })
                },
                error: function (err) {
                    console.log(err)
                }
            });


            $('.insertBtn').on('click', () => {
                resetForm();
                initInsertForm();
                popFancy('#lay-form-write');
            });

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

                $("#deleteBtn").show()
                $("#form-update-btn").show();

                $("#form-submit-btn").hide();

                $('#mgnt_no').val(data.mgnt_no);
                $('#district_no').val(data.district_no);
                $('#partner_comp_nm').val(data.partner_comp_nm);
                $('#emerg_chgr_nm').val(data.emerg_chgr_nm);
                $('#emerg_chgr_role').val(data.emerg_chgr_role);
                $('#emerg_recv_ph').val(data.emerg_recv_ph);
                $('#emerg_tel').val(data.emerg_tel);
                $('#e_mail').val(data.e_mail);
            }

            $('.excelBtn').on('click', function () {
                downloadExcel('emergency contact', $grid, path);
            });

            function initInsertForm() {
                $("#form_sub_title").html('신규 등록');
                $("#deleteBtn").hide()
                $("#form-update-btn").hide();
            }

            function resetForm() {
                $('#district_no').val('');
                $('#partner_comp_nm').val('');
                $('#emerg_chgr_nm').val('');
                $('#emerg_chgr_role').val('');
                $('#emerg_recv_ph').val('');
                $('#emerg_tel').val('');
                $('#e_mail').val('');
            }

            $("#form-submit-btn").on('click', () => {
                if (validated() === false) {
                    return;
                }
                $.ajax({
                    url: '/operation-configuration-setting/emergency-contact/add',
                    type: 'POST',
                    data: {
                        district_no: $('#district_no').val(),
                        partner_comp_nm: $('#partner_comp_nm').val(),
                        emerg_chgr_nm: $('#emerg_chgr_nm').val(),
                        emerg_chgr_role: $('#emerg_chgr_role').val(),
                        emerg_recv_ph: $('#emerg_recv_ph').val(),
                        emerg_tel: $('#emerg_tel').val(),
                        e_mail: $('#e_mail').val()
                    },
                    success: function (_res) {
                        popFancyClose('#lay-form-write');
                        reloadJqGrid();
                    },
                    error: function (err) {
                        console.log(err)
                    }
                });
            });

            $("#form-update-btn").on('click', () => {
                if (validated() === false) {
                    return;
                }
                $.ajax({
                    url: '/operation-configuration-setting/emergency-contact/mod',
                    type: 'POST',
                    data: {
                        mgnt_no: $('#mgnt_no').val(),
                        district_no: $('#district_no').val(),
                        partner_comp_nm: $('#partner_comp_nm').val(),
                        emerg_chgr_nm: $('#emerg_chgr_nm').val(),
                        emerg_chgr_role: $('#emerg_chgr_role').val(),
                        emerg_recv_ph: $('#emerg_recv_ph').val(),
                        emerg_tel: $('#emerg_tel').val(),
                        e_mail: $('#e_mail').val()
                    },
                    success: function (_res) {
                        popFancyClose('#lay-form-write');
                        reloadJqGrid();
                    },
                    error: function (_err) {
                        alert('수정에 실패했습니다. 다시 시도해 주세요.');
                    }
                });
            });

            function validated() {
                if ($('#district_no').val() === '') {
                    alert('관리 현장을 선택해 주세요.');
                    return false;
                }

                if ($('#partner_comp_nm').val() === '') {
                    alert('소속 기관을 입력해 주세요.');
                    return false;
                }

                if ($('#emerg_chgr_nm').val() === '') {
                    alert('이름을 입력해 주세요.');
                    return false;
                }

                if ($('#emerg_chgr_role').val() === '') {
                    alert('역할을 입력해 주세요.');
                    return false;
                }

                if ($('#emerg_recv_ph').val() === '') {
                    alert('연락처 1을 입력해 주세요.');
                    return false;
                }

                return true;
            }

            $('#deleteBtn').on('click', () => {
                confirm('삭제하시겠습니까?', () => {
                    $.ajax({
                        url: '/operation-configuration-setting/emergency-contact/del',
                        type: 'POST',
                        data: {
                            mgnt_no: $('#mgnt_no').val(),
                        },
                        success: function (_res) {
                            popFancyClose('#lay-form-write');
                            reloadJqGrid();
                        },
                        error: function (_err) {
                            alert('삭제에 실패했습니다. 다시 시도해 주세요.');
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
        <h2 class="txt">운영환경설정</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">비상연락망 관리</h3>
                <div class="btn-group">
                    <input type="text" class="search_input" id="search" name="search" placeholder="이름/소속기관/휴대폰"/>
                    <a class="searchBtn">검색</a>
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

    <!-- 팝업 -->
    <div id="lay-form-write" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">비상연락망 관리<span id="form_sub_title"></span></div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <input type="hidden" id="mgnt_no"/>
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th class="required_th">관리 현장</th>
                        <td>
                            <select id="district_no" class="required">
                                <option value="">Ex) 이월지구</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="required_th">소속 기관</th>
                        <td><input type="text" id="partner_comp_nm" placeholder="Ex) 인플랩" class="required"/></td>
                    </tr>
                    <tr>
                        <th class="required_th">이름</th>
                        <td><input type="text" id="emerg_chgr_nm" placeholder="Ex) 홍길동"
                                   class="required"/></td>
                    </tr>
                    <tr>
                        <th class="required_th">역할</th>
                        <td><input type="text" id="emerg_chgr_role" placeholder="Ex) 비상 관리자" class="required"/></td>
                    </tr>
                    <tr>
                        <th class="required_th">연락처 1</th>
                        <td><input type="text" id="emerg_recv_ph" placeholder="Ex) 010-1234-5678" class="required"/>
                        </td>
                    </tr>
                    <tr>
                        <th>연라처 2</th>
                        <td><input type="text" id="emerg_tel" placeholder="Ex) 010-1234-5678"/></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td><input type="text" id="e_mail" placeholder="Ex) 이메일"/></td>
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
    <!-- 팝업 -->

    </div>
</section>
</body>
</html>