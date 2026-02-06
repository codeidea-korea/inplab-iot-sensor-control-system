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
            initGrid($grid,path,$('#grid-wrapper'), {                   
                    multiselect: true,
                    multiboxonly: false,
                    custom: {
                        useFilterToolbar: true,
                    }
                },
                null,               
                {                  
                    emerg_recv_ph: {  
                        formatter: function (cellValue) {
                            return getFormattedPhoneNumber(cellValue);
                        }
                    },
                    emerg_tel: {
                        formatter: function (cellValue) {
                            return getFormattedPhoneNumber(cellValue);
                        }
                    }
                })

            $.ajax({
                url: '/maintenance/company-management/all',
                type: 'GET',
                success: function (res) {
                    res.forEach((item) => {
                        $('#partner_comp').append(
                            "<option value='" + item.partner_comp_id + "'>" + item.partner_comp_nm + "</option>"
                        )
                    })
                }
            });

            $.ajax({
                url: '/adminAdd/districtInfo/all',
                type: 'GET',
                success: function (res) {
                    res.forEach((item) => {
                        $('#district_no').append(
                            "<option value='" + item.district_no + "'>" + item.district_nm + "</option>"
                        )
                    })
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
                $('#partner_comp').val(data.partner_comp_id);
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
                $("#form-submit-btn").show();
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
                        partner_comp_id: $('#partner_comp').val(),
                        emerg_chgr_nm: $('#emerg_chgr_nm').val(),
                        emerg_chgr_role: $('#emerg_chgr_role').val(),
                        emerg_recv_ph: $('#emerg_recv_ph').val(),
                        emerg_tel: $('#emerg_tel').val(),
                        e_mail: $('#e_mail').val()
                    },
                    success: function (_res) {
                        popFancyClose('#lay-form-write');
                        reloadJqGrid($grid);
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
                        partner_comp_id: $('#partner_comp').val(),
                        emerg_chgr_nm: $('#emerg_chgr_nm').val(),
                        emerg_chgr_role: $('#emerg_chgr_role').val(),
                        emerg_recv_ph: $('#emerg_recv_ph').val(),
                        emerg_tel: $('#emerg_tel').val(),
                        e_mail: $('#e_mail').val()
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

            function validated() {
                if ($('#district_no').val() === '') {
                    alert('관리 현장을 선택해 주세요.');
                    return false;
                }

                if ($('#partner_comp').val() === '') {
                    alert('소속 기관을 선택해 주세요.');
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

            $("#excelBtn").click(() => {
                downloadExcel('emergency contact', $grid, path);
            });

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
                            reloadJqGrid($grid);
                        },
                        error: function (_err) {
                            alert('삭제에 실패했습니다. 다시 시도해 주세요.');
                        }
                    });
                })
            });

        });
        function getFormattedPhoneNumber(phoneNumber) {
            if (!phoneNumber) return ""; 

            const cleanNum = phoneNumber.toString().replace(/[^0-9]/g, "");

            if (cleanNum.length === 11) {
                return cleanNum.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
            }
           
            if (cleanNum.length === 10) {
                if (cleanNum.startsWith("02")) {
                    return cleanNum.replace(/(\d{2})(\d{4})(\d{4})/, "$1-$2-$3");
                }
                return cleanNum.replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3");
            }

            if (cleanNum.length === 9 && cleanNum.startsWith("02")) {
                return cleanNum.replace(/(\d{2})(\d{3})(\d{4})/, "$1-$2-$3");
            }

            if (cleanNum.length === 8) {
                return cleanNum.replace(/(\d{4})(\d{4})/, "$1-$2");
            }

            return cleanNum;
        }
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
                        <td><select id="partner_comp" class="required">
                            <option value="">선택</option>
                        </select></td>
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
                        <td><input type="text" id="emerg_recv_ph" placeholder="Ex) 01012341234 (“-” 없이 숫자만 입력) class="required"/>
                        </td>
                    </tr>
                    <tr>
                        <th>연라처 2</th>
                        <td><input type="text" id="emerg_tel" placeholder="Ex) 01012341234 (“-” 없이 숫자만 입력)"/></td>
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