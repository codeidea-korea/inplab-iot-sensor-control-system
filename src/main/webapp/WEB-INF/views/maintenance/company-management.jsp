<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"/>
    <script type="text/javascript" src="/jqgrid.js"></script>
    <script>
        $(function () {
            var compTypeStr = ":전체;0:시공사;1:계측사;2:ALL";
            const $grid = $("#jq-grid");
            const path = "/maintenance/company-management";
            initGrid($grid, path, $('#grid-wrapper'), {
                multiselect: true,
                multiboxonly: false,
                custom: {
                    useFilterToolbar: false,
                },
                loadComplete: function () {
                    var $grid = $("#jq-grid");
                    if ($grid.data('toolbar_created')) return;

                    $grid.jqGrid('setColProp', 'partner_type_flag', {
                        stype: 'select',
                        searchoptions: { value: compTypeStr, sopt: ['eq'] }
                    });

                    $grid.jqGrid('filterToolbar', {
                        stringResult: false,
                        searchOnEnter: true,
                        defaultSearch: "eq",
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

                partner_comp_addr: {
                    formatter: function (cellValue, options, rowObject) {
                        const addr = rowObject.partner_comp_addr || '';
                        const addrAdd = rowObject.partner_comp_addr_add || '';

                        return (addr + ' ' + addrAdd).trim();
                    }
                },
                partner_comp_addr_add: {
                    hidden: true
                },

                partner_type_flag: {
                    formatter: function (cellValue) {
                        if (cellValue === '0') {
                            return '시공사';
                        } else if (cellValue === '1') {
                            return '계측사';
                        } else if (cellValue === '2') {
                            return 'ALL';
                        }
                    }
                },
                maint_rep_ph: {
                    formatter: function (cellValue) {
                        return getFormattedPhoneNumber(cellValue);
                    }
                },
                comp_biz_no: {
                    formatter: function (cellValue) {
                        return getFormattedCompanyNumber(cellValue);
                    }
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

                $("#partner_comp_id").attr('readonly', true);
                $("#deleteBtn").show();
                $("#form-submit-btn").hide();
                $("#form-update-btn").show();

                $('#partner_comp_id').val(data.partner_comp_id);
                $('#partner_comp_nm').val(data.partner_comp_nm);

                $('#partner_type_flag option').each(function () {
                    if ($(this).text() === data.partner_type_flag) {
                        $(this).prop('selected', true);
                    }
                });
                
                let fullAddr = data.partner_comp_addr || '';
                let addrDetail = data.partner_comp_addr_add || '';
                let baseAddr = fullAddr;


                if (addrDetail && fullAddr.endsWith(addrDetail)) {

                    baseAddr = fullAddr.substring(0, fullAddr.lastIndexOf(addrDetail)).trim();
                }

                $('#partner_comp_addr').val(baseAddr);
                $('#partner_comp_addr_add').val(addrDetail);

                //$('#partner_comp_addr').val(data.partner_comp_addr);
                //$('#partner_comp_addr_add').val(data.partner_comp_addr_add);


                $('#comp_biz_no').val(data.comp_biz_no);
                $('#maint_rep_nm').val(data.maint_rep_nm);
                $('#maint_rep_ph').val(data.maint_rep_ph);
                $("[datepicker]").flatpickr({
                    onReady: function (selectedDates, dateStr, instance) {
                        $('#lay-form-write #reg_dt').val(
                            instance.formatDate(new Date(data.reg_dt), 'Y-m-d')
                        )
                    }
                });
                $("[datepicker]").flatpickr({
                    onReady: function (selectedDates, dateStr, instance) {
                        $('#lay-form-write #mod_dt').val(
                            instance.formatDate(new Date(data.mod_dt), 'Y-m-d')
                        )
                    }
                });
            }

            function initInsertForm() {
                $("#form_sub_title").html('신규등록');
                $("#form-submit-btn").show();
                $("#deleteBtn").hide()
                $("#form-update-btn").hide();
            }

            function resetForm() {
                $('#partner_comp_id').val('');
                $('#partner_comp_nm').val('');
                $('#partner_type_flag').val('');
                $('#partner_comp_addr').val('');
                $('#partner_comp_addr_add').val('');
                $('#comp_biz_no').val('');
                $('#maint_rep_nm').val('');
                $('#maint_rep_ph').val('');
                $('#reg_dt').val('');
                $('#mod_dt').val('');
            }

            $("#form-submit-btn").on('click', () => {
                if (validated() === false) {
                    return;
                }
                $.ajax({
                    url: '/maintenance/company-management/add',
                    type: 'POST',
                    data: {
                        partner_comp_nm: $('#partner_comp_nm').val(),
                        partner_type_flag: $('#partner_type_flag').val(),
                        partner_comp_addr: $('#partner_comp_addr').val(),
                        partner_comp_addr_add: $('#partner_comp_addr_add').val(),
                        comp_biz_no: $('#comp_biz_no').val(),
                        maint_rep_nm: $('#maint_rep_nm').val(),
                        maint_rep_ph: $('#maint_rep_ph').val(),
                        reg_dt: $('#reg_dt').val(),
                        mod_dt: $('#mod_dt').val()
                    },
                    success: function (_res) {
                        popFancyClose('#lay-form-write');
                        reloadJqGrid($grid);
                    },
                    error: function (_err) {
                        alert('등록에 실패했습니다. 다시 시도해 주세요.');
                    }
                });
            });

            $("#form-update-btn").on('click', () => {
                if (validated() === false) {
                    return;
                }
                $.ajax({
                    url: '/maintenance/company-management/mod',
                    type: 'POST',
                    data: {
                        partner_comp_id: $('#partner_comp_id').val(),
                        partner_comp_nm: $('#partner_comp_nm').val(),
                        partner_type_flag: $('#partner_type_flag').val(),
                        partner_comp_addr: $('#partner_comp_addr').val(),
                        partner_comp_addr_add: $('#partner_comp_addr_add').val(),
                        comp_biz_no: $('#comp_biz_no').val(),
                        maint_rep_nm: $('#maint_rep_nm').val(),
                        maint_rep_ph: $('#maint_rep_ph').val(),
                        reg_dt: $('#reg_dt').val(),
                        mod_dt: $('#mod_dt').val()
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
                if ($('#partner_comp_nm').val() === '') {
                    alert('협력사명을 입력해주세요.');
                    return false;
                }

                if ($('#partner_type_flag').val() === '') {
                    alert('협력사구분을 선택해주세요.');
                    return false;
                }

                if ($('#partner_comp_addr').val() === '') {
                    alert('주소를 입력해주세요.');
                    return false;
                }

                if ($('#comp_biz_no').val() === '') {
                    alert('사업자번호를 입력해주세요.');
                    return false;
                }

                if ($('#maint_rep_nm').val() === '') {
                    alert('대표명을 입력해주세요.');
                    return false;
                }

                if ($('#maint_rep_ph').val() === '') {
                    alert('대표연락처를 입력해주세요.');
                    return false;
                }

                if ($('#reg_dt').val() === '') {
                    alert('등록일시를 입력해주세요.');
                    return false;
                }

                if ($('#mod_dt').val() === '') {
                    alert('수정일시를 입력해주세요.');
                    return false;
                }
                return true;
            }

            $('.excelBtn').on('click', function () {
                downloadExcel('company management', $grid, path);
            });

            $('#deleteBtn').on('click', () => {
                confirm('삭제하시겠습니까?', () => {
                    $.ajax({
                        url: '/maintenance/company-management/del',
                        type: 'POST',
                        data: {
                            partner_comp_id: $('#partner_comp_id').val()
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

        function getFormattedCompanyNumber(companyNumber){
            if (!companyNumber) return "";

            const cleanNum = companyNumber.toString().replace(/[^0-9]/g, "");

            if(cleanNum.length === 10){
                return cleanNum.replace(/(\d{3})(\d{2})(\d{5})/, "$1-$2-$3");
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
        <h2 class="txt">유지보수관리</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">유지보수업체관리</h3>
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

    <!-- 팝업 -->
    <div id="lay-form-write" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">유지보수업체 <span id="form_sub_title"></span></div>
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
                        <th>협력사 ID</th>
                        <td><input type="text" id="partner_comp_id" readonly/></td>
                    </tr>
                    <tr>
                        <th>협력사명</th>
                        <td><input type="text" id="partner_comp_nm" placeholder="Ex) 협력사"/></td>
                    </tr>
                    <tr>
                        <th>협력사구분</th>
                        <td>
                            <select id="partner_type_flag">
                                <option value="">선택</option>
                                <option value="0">시공사</option>
                                <option value="1">계측사</option>
                                <option value="2">ALL</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th style="vertical-align: middle;">주소</th>
                        <td colspan="2" style="display: flex; align-items: center;">
                            <input type="text" id="partner_comp_addr" name="site_addr" readonly
                                   style="flex: 1; margin-right: 10px;"/>
                            <div class="btn-btm" style="width: auto; margin-top: 0px;">
                                <button type="button" id="addrSearchBtn" style="margin-left: 10px; padding: 5px 10px;"
                                        onclick="openDaumPostcode('', '', 'site_addr')">주소 검색
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th style="vertical-align: middle;">상세 주소</th>
                        <td><input type="text" id="partner_comp_addr_add"/></td>
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
                        <th>사업자번호</th>
                        <td><input type="text" id="comp_biz_no" placeholder="Ex) 1231212345 (“-” 없이 숫자만 입력)"/></td>
                    </tr>
                    <tr>
                        <th>대표명</th>
                        <td><input type="text" id="maint_rep_nm" placeholder="Ex) 홍길동"/></td>
                    </tr>
                    <tr>
                        <th>대표연락처</th>
                        <td><input type="text" id="maint_rep_ph" placeholder="Ex) 01012341234 (“-” 없이 숫자만 입력)"/></td>
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
                        <th>등록일자</th>
                        <td><input type="text" id="reg_dt" placeholder="Ex) 2024-01-01" datepicker=""
                                   readonly="readonly"/></td>
                    </tr>
                    <tr>
                        <th>수정일자</th>
                        <td><input type="text" id="mod_dt" placeholder="Ex) 2024-01-01" datepicker=""
                                   readonly="readonly"/></td>
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
    <!-- 팝업 -->

    </div>
</section>
</body>
</html>