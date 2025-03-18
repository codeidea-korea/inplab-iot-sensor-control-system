<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"/>
    <script type="text/javascript" src="/admin_add.js"></script>
    <script>
        const limit = 25;
        let offset = 0;

        const checkboxFormatter = (cellValue, options, rowObject) => {
            return '<input type="checkbox" class="row-checkbox" value="' + rowObject.dispbd_no + '">';
        };

        const column = [
            {
                name: 'checkbox',
                index: 'checkbox',
                width: 35,
                align: 'center',
                sortable: false,
                hidden: false,
                formatter: checkboxFormatter
            },
            {name: 'dispbd_no', index: 'dispbd_no', width: 100, align: 'center', hidden: false},
            {name: 'dispbd_nm', index: 'dispbd_nm', align: 'center', hidden: false},
            {name: 'district_nm', index: 'district_nm', align: 'center', hidden: false},
            {name: 'dispbd_ip', index: 'dispbd_ip', align: 'center', hidden: false},
            {name: 'dispbd_port', index: 'dispbd_port', align: 'center', hidden: false},
            {name: 'dispbd_conn_id', index: 'dispbd_conn_id', align: 'center', hidden: false},
            {name: 'maint_sts_nm', index: 'maint_sts_nm', align: 'center', hidden: false},
            {name: 'inst_ymd', index: 'inst_ymd', width: 120, align: 'center', hidden: false},
        ];

        const header = ['', '전광판 ID', '전광판명', '현장명', '장비 IP', '장비 Port', '접속 ID', '설치 상태', '설치 일자'];

        const getDisplayBoard = (obj) => {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: 'GET',
                    url: `/adminAdd/displayBoard/displayBoard`,
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    async: true,
                    data: obj
                }).done(function (res) {
                    resolve(res);
                }).fail(function (fail) {
                    reject(fail);
                    console.log('getDisplayBoard fail > ', fail);
                    alert2('전광판 정보를 가져오는데 실패했습니다.', function () {
                    });
                });
            });
        };

        const insDisplayBoard = (array) => {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: 'POST',
                    url: `/adminAdd/displayBoard/displayBoard`,
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    async: true,
                    data: JSON.stringify(array)
                }).done(function (res) {
                    resolve(res);
                }).fail(function (fail) {
                    reject(fail);
                    console.log('insDisplayBoard fail > ', fail);
                    alert2('전광판 등록하는데 실패했습니다.', function () {
                    });
                });
            });
        };

        const udtDisplayBoard = (array) => {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: 'PUT',
                    url: `/adminAdd/displayBoard/displayBoard`,
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    async: true,
                    data: JSON.stringify(array)
                }).done(function (res) {
                    resolve(res);
                }).fail(function (fail) {
                    reject(fail);
                    console.log('udtDisplayBoard fail > ', fail);
                    alert2('전광판 수정하는데 실패했습니다.', function () {
                    });
                });
            });
        };

        const actionDelDisplayBoard = (dispbd_no) => {
            udtDisplayBoard([{dispbd_no: dispbd_no, del_yn: 'Y'}]).then((res) => {
                if (res.count?.pass > 0) {
                    alert2(res?.pass_list[0]?.message, function () {
                    });
                    return;
                }
                if (res.count?.del === 0) {
                    alert2('전광판 정보가 삭제되지 않았습니다.', function () {
                    });
                    return;
                }
                alert2('전광판 정보가 삭제되었습니다.', function () {
                    popFancyClose('#lay-form-write08');
                    const search_text = $('input[name=search_text]').val();
                    offset = 0;
                    getDisplayBoard({search_text: search_text, limit: limit, offset: offset}).then((res) => {
                        $("#jqGrid").jqGrid('clearGridData');
                        $("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
                    }).catch((fail) => {
                        console.log('setJqGridTable fail > ', fail);
                    });
                });
            }).catch((fail) => {
                console.log('delBroadcast fail > ', fail);
                alert2('전광판 정보 삭제에 실패했습니다.', function () {
                });
            });
        };

        const initForm = () => {
            $('#lay-form-write08').find('input').not('#ins_displayBoard, #udt_displayBoard, #del_displayBoard').val('');
            $('#lay-form-write08').find('select').prop('selectedIndex', 0);
        };

        const validCheck = () => {
            let result = false;
            const dispbd_no = $('input[name=dispbd_no]').val();
            const dispbd_nm = $('input[name=dispbd_nm]').val();
            const district_no = $('select[name=district_no]').val();
            const dispbd_ip = $('input[name=dispbd_ip]').val();
            const dispbd_port = $('input[name=dispbd_port]').val();
            const dispbd_conn_id = $('input[name=dispbd_conn_id]').val();
            const dispbd_conn_pwd = $('input[name=dispbd_conn_pwd]').val();
            const inst_ymd = $('input[name=inst_ymd]').val().replaceAll('-', '');
            const maint_sts_cd = $('select[name=maint_sts_cd]').val();
            const dispbd_lat = $('input[name=dispbd_lat]').val();
            const dispbd_lon = $('input[name=dispbd_lon]').val();
            const model_nm = $('input[name=model_nm]').val();
            const dispbd_maker = $('input[name=dispbd_maker]').val();

            const obj = {
                dispbd_no: dispbd_no,
                dispbd_nm: dispbd_nm,
                district_no: district_no,
                dispbd_ip: dispbd_ip,
                dispbd_port: dispbd_port,
                dispbd_conn_id: dispbd_conn_id,
                dispbd_conn_pwd: dispbd_conn_pwd,
                inst_ymd: inst_ymd,
                maint_sts_cd: maint_sts_cd,
                dispbd_lat: dispbd_lat,
                dispbd_lon: dispbd_lon,
                model_nm: model_nm,
                dispbd_maker: dispbd_maker,
            };

            if (dispbd_nm === '' || dispbd_nm === undefined) {
                $('input[name=dispbd_nm]').focus();
                result = true;
            } else if (district_no === '' || district_no === undefined) {
                $('select[name=district_no]').focus();
                result = true;
            } else if (dispbd_conn_id === '' || dispbd_conn_id === undefined) {
                $('input[name=dispbd_conn_id]').focus();
                result = true;
            } else if (dispbd_conn_pwd === '' || dispbd_conn_pwd === undefined) {
                $('input[name=dispbd_conn_pwd]').focus();
                result = true;
            } else if (dispbd_ip === '' || dispbd_ip === undefined) {
                $('input[name=dispbd_ip]').focus();
                result = true;
            } else if (isNaN(dispbd_port)) {
                alert2('접속Port는 숫자만 입력해주세요.', function () {
                    $('input[name=dispbd_port]').focus();
                });
                result = true;
            } else if (inst_ymd === '' || inst_ymd === undefined) {
                $('input[name=inst_ymd]').focus();
                result = true;
            } else if (maint_sts_cd === '' || maint_sts_cd === undefined) {
                $('select[name=maint_sts_cd]').focus();
                result = true;
            } else if (isNaN(dispbd_lat)) {
                alert2('위도는 숫자만 입력해주세요.', function () {
                    $('input[name=dispbd_lat]').focus();
                });
                result = true;
            } else if (isNaN(dispbd_lon)) {
                alert2('경도는 숫자만 입력해주세요.', function () {
                    $('input[name=dispbd_lon]').focus();
                });
                result = true;
            }
            return {isValid: result, obj: obj};
        };

        const setDisplayBoard = (data) => {
            $('input[name=dispbd_no]').val(data.dispbd_no);
            $('input[name=dispbd_nm]').val(data.dispbd_nm);
            $('select[name=district_no]').val(data.district_no);
            $('input[name=dispbd_ip]').val(data.dispbd_ip);
            $('input[name=dispbd_port]').val(data.dispbd_port);
            $('input[name=dispbd_conn_id]').val(data.dispbd_conn_id);
            $('input[name=dispbd_conn_pwd]').val(data.dispbd_conn_pwd);
            $('input[name=inst_ymd]').val(data.inst_ymd);
            $('select[name=maint_sts_cd]').val(data.maint_sts_cd);
            $('input[name=dispbd_lat]').val(data.dispbd_lat);
            $('input[name=dispbd_lon]').val(data.dispbd_lon);
            $('input[name=model_nm]').val(data.model_nm);
            $('input[name=dispbd_maker]').val(data.dispbd_maker);
        };

        $(function () {
            $("[datepicker]").flatpickr({
                locale: "ko",
                dateFormat: "Y-m-d",
                onClose: function (selectedDates, dateStr, instance) {
                },
            });

            getDisplayBoard({limit: limit, offset: offset}).then((res) => {
                setJqGridTable(res.rows, column, header, function () {
                }, onSelectRow, ['dispbd_no'], 'jqGrid', limit, offset, getDisplayBoard);
            }).catch((fail) => {
                console.log('setJqGridTable fail > ', fail);
            });

            $('.searchtBtn').on('click', function () {
                const search_text = $('input[name=search_text]').val();
                offset = 0;
                getDisplayBoard({search_text: search_text, limit: limit, offset: offset}).then((res) => {
                    $("#jqGrid").jqGrid('clearGridData');
                    $("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
                }).catch((fail) => {
                    console.log('setJqGridTable fail > ', fail);
                });
            });

            const getMaxNo = () => {
                return new Promise((resolve, reject) => {
                    $.ajax({
                        type: 'GET',
                        url: '/adminAdd/displayBoard/max-dispbd-no',
                        dataType: 'text',
                        contentType: 'application/json; charset=utf-8',
                        async: true,
                    }).done(function (res) {
                        resolve(res);
                    }).fail(function (fail) {
                        console.log('getMaxNo fail > ', fail);
                        reject(fail);
                    });
                });
            };

            $('.insertBtn').on('click', function () {
                getMaxNo().then((res) => {
                    const prefix = res.substring(0, 1); // 'P'
                    const number = parseInt(res.substring(1), 10) + 1;
                    const dispbd_no = prefix + number.toString().padStart(2, '0');
                    $('input[name=dispbd_no]').val(dispbd_no);
                })
                initForm();
                getDistrictInfo().then((res2) => {
                    let district_nm = $('select[name=district_no]');
                    district_nm.empty();
                    district_nm.append('<option value="">선택</option>');
                    $.each(res2.rows, function (index, item) {
                        district_nm.append('<option value="' + item.district_no + '">' + item.district_nm + '</option>');
                    });
                    $("#form_sub_title").html('신규 등록');
                    $('#ins_displayBoard').show();
                    $('#udt_displayBoard').hide();
                    $('#del_displayBoard').hide();
                    popFancy('#lay-form-write08');
                }).catch((fail) => {
                    console.log('fail > ', fail);
                });
            });

            $('#ins_displayBoard').on('click', function () {
                let array = [];
                const {isValid, obj} = validCheck();

                if (isValid) {
                    return;
                }

                array.push(obj);

                insDisplayBoard(array).then((res) => {
                    if (res.count?.pass > 0) {
                        alert2(res?.pass_list[0]?.message, function () {
                        });
                        return;
                    }
                    if (res.count?.ins === 0) {
                        alert2('전광판 정보가 등록되지 않았습니다.', function () {
                        });
                        return;
                    }
                    alert2('전광판 정보가 등록되었습니다.', function () {
                        const search_text = $('input[name=search_text]').val();
                        offset = 0;
                        getDisplayBoard({search_text: search_text, limit: limit, offset: offset}).then((res) => {
                            $("#jqGrid").jqGrid('clearGridData');
                            $("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
                        }).catch((fail) => {
                            console.log('setJqGridTable fail > ', fail);
                        });
                    });
                }).catch((fail) => {
                    console.log('insDisplayBoard fail > ', fail);
                    alert2('전광판 정보 등록에 실패했습니다.', function () {
                    });
                });
            });

            $('#udt_displayBoard').on('click', function () {
                let array = [];
                const {isValid, obj} = validCheck();

                if (isValid) {
                    return;
                }

                array.push(obj);

                udtDisplayBoard(array).then((res) => {
                    if (res.count?.pass > 0) {
                        alert2(res?.pass_list[0]?.message, function () {
                        });
                        return;
                    }
                    if (res.count?.udt === 0) {
                        alert2('전광판 정보가 수정되지 않았습니다.', function () {
                        });
                        return;
                    }
                    alert2('전광판 정보가 수정되었습니다.', function () {
                        const search_text = $('input[name=search_text]').val();
                        offset = 0;
                        getDisplayBoard({search_text: search_text, limit: limit, offset: offset}).then((res) => {
                            $("#jqGrid").jqGrid('clearGridData');
                            $("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
                        }).catch((fail) => {
                            console.log('setJqGridTable fail > ', fail);
                        });
                    });
                }).catch((fail) => {
                    console.log('insDisplayBoard fail > ', fail);
                    alert2('전광판 수정에 실패했습니다.', function () {
                    });
                });
            });

            // 수정 팝업
            $('.modifyBtn').on('click', function () {
                const selectedDispbdNos = [];
                $("#jqGrid tbody").find(".row-checkbox:checked").each(function () {
                    const dispbdNo = $(this).closest("tr").find("td[aria-describedby='jqGrid_dispbd_no']").text().trim();
                    selectedDispbdNos.push(dispbdNo);
                });
                const dispbd_no = selectedDispbdNos[0]

                if (dispbd_no === null) {
                    alert2('전광판을 선택해주세요.', function () {
                    });
                    return;
                }

                initForm();

                Promise.all([getDisplayBoard({dispbd_no: dispbd_no}), getDistrictInfo()]).then(([res1, res2]) => {
                    if (res1.rows.length === 0) {
                        alert2('불러온 전광판정보가 없습니다.', function () {
                        });
                        return;
                    } else if (res1.rows.length > 1) {
                        alert2('불러온 전광판정보가 2개 이상입니다.', function () {
                        });
                        return;
                    }

                    let district_nm = $('select[name=district_no]');
                    district_nm.empty();
                    district_nm.append('<option value="">선택</option>');
                    $.each(res2.rows, function (index, item) {
                        district_nm.append('<option value="' + item.district_no + '">' + item.district_nm + '</option>');
                    });

                    setDisplayBoard(res1.rows[0]);
                    $("#form_sub_title").html('상세 정보');
                    $('#ins_displayBoard').hide();
                    $('#udt_displayBoard').show();
                    $('#del_displayBoard').show();
                    $('#tr_dispbd_no').show();
                    popFancy('#lay-form-write08');
                }).catch((fail) => {
                    console.log('fail > ', fail);
                });
            });

            $('#del_displayBoard').on('click', function () {
                const dispbd_no = $('input[name=dispbd_no]').val();
                if (dispbd_no === '') {
                    alert2('전광판를 선택해주세요.', function () {
                    });
                    return;
                }
                confirm2('전광판를 정보를 삭제하시겠습니까?', function () {
                    actionDelDisplayBoard(dispbd_no);
                });
            });

            $('.excelBtn').on('click', function () {
                const obj = makeExcelData('전광판 관리');
                listExcelDown(obj);
            });

            $('input[name=search_text]').on('keypress', function (e) {
                if (e.key === 'Enter') {
                    $('.searchtBtn').trigger('click');
                }
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
        <h2 class="txt">
            관리자 전용
            <span class="arr">장치 관리</span>
        </h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">전광판 관리</h3>
                <div class="btn-group">
                    <input type="text" name="search_text" placeholder="전광판명 / 현장명 / 설치상태"
                           style="background-color: white; font-size: medium;"/>
                    <a class="searchtBtn">검색</a>
                    <a class="insertBtn">신규등록</a>
                    <a class="modifyBtn">상세정보</a>
                    <a class="excelBtn">다운로드</a>
                </div>
                <div class="contents-in">
                    <table id="jqGrid"></table>
                </div>
            </div>
        </div>
    </div>
    <div id="lay-form-write08" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">전광판 <span id="form_sub_title"></span></div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                        <col width="130"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr id="tr_dispbd_no">
                        <th>전광판 ID <span style="color: red">*</span></th>
                        <td colspan="3">
                            <input type="text" name="dispbd_no" value="" readonly>
                        </td>
                    </tr>
                    <tr>
                        <th>전광판명 <span style="color: red">*</span></th>
                        <td colspan="3">
                            <input type="text" name="dispbd_nm"/>
                        </td>
                    </tr>
                    <tr>
                        <th>현장명 <span style="color: red">*</span></th>
                        <td colspan="3">
                            <select id="district_no" name="district_no">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>장비 IP <span style="color: red">*</span></th>
                        <td><input type="text" name="dispbd_ip"/></td>
                        <th>접속Port <span style="color: red">*</span></th>
                        <td><input type="text" name="dispbd_port"/></td>
                    </tr>
                    <tr>
                        <th>접속ID <span style="color: red">*</span></th>
                        <td><input type="text" name="dispbd_conn_id"/></td>
                        <th>접속PWD <span style="color: red">*</span></th>
                        <td><input type="text" name="dispbd_conn_pwd"/></td>
                    </tr>
                    <tr>
                        <th>설치일자 <span style="color: red">*</span></th>
                        <td>
                            <input type="text" id="inst_ymd" name="inst_ymd" value="" placeholder="" datepicker=""
                                   class="flatpickr-input" readonly="readonly"/>
                        </td>
                        <th>설치상태 <span style="color: red">*</span></th>
                        <td>
                            <select name="maint_sts_cd">
                                <option value="">선택</option>
                                <option value="MTN001">정상</option>
                                <option value="MTN002">망실</option>
                                <option value="MTN003">점검</option>
                                <option value="MTN004">망실(철거)</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>위도 <span style="color: red">*</span></th>
                        <td>
                            <input type="text" name="dispbd_lat"/>
                        </td>
                        <th>경도 <span style="color: red">*</span></th>
                        <td>
                            <input type="text" name="dispbd_lon"/>
                        </td>
                    </tr>
                    <tr>
                        <th>모델명</th>
                        <td>
                            <input type="text" name="model_nm"/>
                        </td>
                        <th>제조사</th>
                        <td>
                            <input type="text" name="dispbd_maker"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <input type="button" blue value="저장" id="ins_displayBoard"/>
                <input type="button" blue value="수정" id="udt_displayBoard"/>
                <input type="button" red value="삭제" id="del_displayBoard"/>
                <button type="button" data-fancybox-close>닫기</button>
            </div>
        </div>
    </div>
</section>
</body>
</html>
