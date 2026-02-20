<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"/>
    <style>
        #map {
            width: 100%;
            height: 500px;
        }

        .centerMarker {
            position: absolute;
            left: calc(50% - 15px);
            top: calc(50% - 27px);
        }
    </style>
    <script type="text/javascript" src="/admin_add.js"></script>
    <script>
        const limit = 25;
        let offset = 0;

        const checkboxFormatter = (cellValue, options, rowObject) => {
            return '<input type="checkbox" class="row-checkbox" value="' + rowObject.brdcast_no + '">';
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
            {name: 'brdcast_no', index: 'brdcast_no', width: 100, align: 'center', hidden: false},
            {name: 'brdcast_nm', index: 'brdcast_nm', align: 'center', hidden: false},
            {name: 'district_nm', index: 'district_nm', align: 'center', hidden: false},
            {name: 'brdcast_svr_ip', index: 'brdcast_svr_ip', align: 'center', hidden: false},
            {name: 'brdcast_svr_port', index: 'brdcast_svr_port', align: 'center', hidden: false},
            {name: 'brdcast_conn_id', index: 'brdcast_conn_id', align: 'center', hidden: false},
            {name: 'maint_sts_nm', index: 'maint_sts_nm', align: 'center', hidden: false},
            {name: 'inst_ymd', index: 'inst_ymd', width: 120, align: 'center', hidden: false},
        ];

        const header = ['', '장비 ID', '방송 장비명', '현장명', '장비 IP', '장비 Port', '접속 ID', '설치 상태', '설치 일자'];

        const getBroadcast = (obj) => {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: 'GET',
                    url: `/adminAdd/broadcast/broardcast`,
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    async: true,
                    data: obj
                }).done(function (res) {
                    resolve(res);
                }).fail(function (fail) {
                    reject(fail);
                    console.log('getBroadcast fail > ', fail);
                    alert2('방송장비 정보를 가져오는데 실패했습니다.', function () {
                    });
                });
            });
        };

        const insBroadcast = (array) => {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: 'POST',
                    url: `/adminAdd/broadcast/broardcast`,
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    async: true,
                    data: JSON.stringify(array)
                }).done(function (res) {
                    resolve(res);
                }).fail(function (fail) {
                    reject(fail);
                    console.log('insBroadcast fail > ', fail);
                    alert2('방송장비 등록하는데 실패했습니다.', function () {
                    });
                });
            });
        };

        const udtBroadcast = (array) => {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: 'PUT',
                    url: `/adminAdd/broadcast/broardcast`,
                    dataType: 'json',
                    contentType: 'application/json; charset=utf-8',
                    async: true,
                    data: JSON.stringify(array)
                }).done(function (res) {
                    resolve(res);
                }).fail(function (fail) {
                    reject(fail);
                    console.log('udtBroadcast fail > ', fail);
                    alert2('방송장비 수정하는데 실패했습니다.', function () {
                    });
                });
            });
        };

        const actionDelBroadcast = (brdcast_no) => {
            udtBroadcast([{brdcast_no: brdcast_no, del_yn: 'Y'}]).then((res) => {
                if (res.count?.pass > 0) {
                    alert2(res?.pass_list[0]?.message, function () {
                    });
                    return;
                }
                if (res.count?.del === 0) {
                    alert2('방송장비 정보가 삭제되지 않았습니다.', function () {
                    });
                    return;
                }
                alert2('방송장비 정보가 삭제되었습니다.', function () {
                    popFancyClose('#lay-form-write08');
                    const search_text = $('input[name=search_text]').val();
                    offset = 0;
                    getBroadcast({search_text: search_text, limit: limit, offset: offset}).then((res) => {
                        $("#jqGrid").jqGrid('clearGridData');
                        $("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
                    }).catch((fail) => {
                        console.log('setJqGridTable fail > ', fail);
                    });
                });
            }).catch((fail) => {
                console.log('delBroadcast fail > ', fail);
                alert2('방송정보 정보 삭제에 실패했습니다.', function () {
                });
            });
        };

        const initForm = () => {
            $('#lay-form-write08').find('input').not('#ins_broadcast, #udt_broadcast, #del_broadcast').val('');
            $('#lay-form-write08').find('select').prop('selectedIndex', 0);
        };

        const validCheck = () => {
            let result = false;
            const brdcast_no = $('input[name=brdcast_no]').val();
            const brdcast_nm = $('input[name=brdcast_nm]').val();
            const district_no = $('select[name=district_no]').val();
            const brdcast_svr_ip = $('input[name=brdcast_svr_ip]').val();
            const brdcast_svr_port = $('input[name=brdcast_svr_port]').val();
            const brdcast_conn_id = $('input[name=brdcast_conn_id]').val();
            const brdcast_conn_pwd = $('input[name=brdcast_conn_pwd]').val();
            const iot_no = $('input[name=iot_no]').val();
            const inst_ymd = $('input[name=inst_ymd]').val().replaceAll('-', '');
            const maint_sts_cd = $('select[name=maint_sts_cd]').val();
            const brdcast_lat = $('input[name=brdcast_lat]').val();
            const brdcast_lon = $('input[name=brdcast_lon]').val();
            const model_nm = $('input[name=model_nm]').val();
            const brdcast_maker = $('input[name=brdcast_maker]').val();

            const obj = {
                brdcast_no: brdcast_no,
                brdcast_nm: brdcast_nm,
                district_no: district_no,
                brdcast_svr_ip: brdcast_svr_ip,
                brdcast_svr_port: brdcast_svr_port,
                brdcast_conn_id: brdcast_conn_id,
                brdcast_conn_pwd: brdcast_conn_pwd,
                iot_no: iot_no,
                inst_ymd: inst_ymd,
                maint_sts_cd: maint_sts_cd,
                brdcast_lat: brdcast_lat,
                brdcast_lon: brdcast_lon,
                model_nm: model_nm,
                brdcast_maker: brdcast_maker,
            };

            if (brdcast_nm === '' || brdcast_nm === undefined) {
                $('input[name=brdcast_nm]').focus();
                result = true;
            } else if (district_no === '' || district_no === undefined) {
                $('select[name=district_no]').focus();
                result = true;
            } else if (brdcast_conn_id === '' || brdcast_conn_id === undefined) {
                $('input[name=brdcast_conn_id]').focus();
                result = true;
            } else if (brdcast_conn_pwd === '' || brdcast_conn_pwd === undefined) {
                $('input[name=brdcast_conn_pwd]').focus();
                result = true;
            } else if (brdcast_svr_ip === '' || brdcast_svr_ip === undefined) {
                $('input[name=brdcast_svr_ip]').focus();
                result = true;
            } else if (isNaN(brdcast_svr_port)) {
                alert2('접속Port는 숫자만 입력해주세요.', function () {
                    $('input[name=brdcast_svr_port]').focus();
                });
                result = true;
            } else if (iot_no === '' || iot_no === undefined) {
                $('input[name=iot_no]').focus();
                result = true;
            } else if (inst_ymd === '' || inst_ymd === undefined) {
                $('input[name=inst_ymd]').focus();
                result = true;
            } else if (maint_sts_cd === '' || maint_sts_cd === undefined) {
                $('select[name=maint_sts_cd]').focus();
                result = true;
            } else if (isNaN(brdcast_lat)) {
                alert2('위도는 숫자만 입력해주세요.', function () {
                    $('input[name=brdcast_lat]').focus();
                });
                result = true;
            } else if (isNaN(brdcast_lon)) {
                alert2('경도는 숫자만 입력해주세요.', function () {
                    $('input[name=brdcast_lon]').focus();
                });
                result = true;
            }
            return {isValid: result, obj: obj};
        };

        const setBroadcast = (data) => {
            $('input[name=brdcast_no]').val(data.brdcast_no);
            $('input[name=brdcast_nm]').val(data.brdcast_nm);
            $('select[name=district_no]').val(data.district_no);
            $('input[name=brdcast_svr_ip]').val(data.brdcast_svr_ip);
            $('input[name=brdcast_svr_port]').val(data.brdcast_svr_port);
            $('input[name=brdcast_conn_id]').val(data.brdcast_conn_id);
            $('input[name=brdcast_conn_pwd]').val(data.brdcast_conn_pwd);
            $('input[name=iot_no]').val(data.iot_no);
            $('input[name=inst_ymd]').val(data.inst_ymd);
            $('select[name=maint_sts_cd]').val(data.maint_sts_cd);
            $('input[name=brdcast_lat]').val(data.brdcast_lat);
            $('input[name=brdcast_lon]').val(data.brdcast_lon);
            $('input[name=model_nm]').val(data.model_nm);
            $('input[name=brdcast_maker]').val(data.brdcast_maker);
        };

        $(function () {
            window.vworld = new vwutil({
                mapId: "map",
                initPosition: {
                    center: [
                        127.449482276989, 36.9317789946793
                    ],
                    zoom: 18,
                    rotation: 0.5
                }
            });

            window.vworld.vwmap2d();

            $('.mapBtn').on('click', function () {
                if ($('#lay-form-write08 input[name=brdcast_lat]').val() !== '' && $('#lay-form-write08 input[name=brdcast_lon]').val() !== '') {
                    window.vworld.setPanBy([
                        parseFloat($('#lay-form-write08 input[name=brdcast_lon]').val()),
                        parseFloat($('#lay-form-write08 input[name=brdcast_lat]').val())], parseFloat($('#lay-form-write08 input[name=brdcast_zoom]').val())
                    );
                }else{
                    /* 빈 칸 default 처리 */
                    window.vworld.setPanBy([127.449482276989, 36.9317789946793], 18);
                }
                popFancy('#lay-form-address', {dragToClose: false, touch: false});
            });


            $('.locationApply').on('click', function () {
                const coords = window.vworld.getCenter();
                $('#lay-form-write08 input[name=brdcast_lat]').val(coords[1]);
                $('#lay-form-write08 input[name=brdcast_lon]').val(coords[0]);
                popFancyClose('#lay-form-address');
            });

            $("[datepicker]").flatpickr({
                locale: "ko",
                dateFormat: "Y-m-d",
                onClose: function (selectedDates, dateStr, instance) {
                },
            });

            getBroadcast({limit: limit, offset: offset}).then((res) => {
                console.log('res > ', res);
                setJqGridTable(res.rows, column, header, function () {
                }, onSelectRow, ['brdcast_no'], 'jqGrid', limit, offset, getBroadcast);
            }).catch((fail) => {
                console.log('setJqGridTable fail > ', fail);
            });

            $('.searchtBtn').on('click', function () {
                const search_text = $('input[name=search_text]').val();
                offset = 0;
                getBroadcast({search_text: search_text, limit: limit, offset: offset}).then((res) => {
                    $("#jqGrid").jqGrid('clearGridData');
                    $("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
                }).catch((fail) => {
                    console.log('setJqGridTable fail > ', fail);
                });
            });

            $('.insertBtn').on('click', function () {
                initForm();
                getDistrictInfo().then((res2) => {
                    let district_nm = $('select[name=district_no]');
                    district_nm.empty();
                    district_nm.append('<option value="">선택</option>');
                    $.each(res2.rows, function (index, item) {
                        district_nm.append('<option value="' + item.district_no + '">' + item.district_nm + '</option>');
                    });
                    $("#form_sub_title").html('신규 등록');
                    $('#ins_broadcast').show();
                    $('#udt_broadcast').hide();
                    $('#del_broadcast').hide();
                    $('#tr_brdcast_no').hide();
                    popFancy('#lay-form-write08');
                }).catch((fail) => {
                    console.log('fail > ', fail);
                });
            });

            $('#ins_broadcast').on('click', function () {
                let array = [];
                const {isValid, obj} = validCheck();

                if (isValid) {
                    return;
                }

                array.push(obj);

                insBroadcast(array).then((res) => {
                    if (res.count?.pass > 0) {
                        alert2(res?.pass_list[0]?.message, function () {
                        });
                        return;
                    }
                    if (res.count?.ins === 0) {
                        alert2('방송장비 정보가 등록되지 않았습니다.', function () {
                        });
                        return;
                    }
                    alert2('방송장비 정보가 등록되었습니다.', function () {
                        popFancyClose('#lay-form-write08');
                        const search_text = $('input[name=search_text]').val();
                        offset = 0;
                        getBroadcast({search_text: search_text, limit: limit, offset: offset}).then((res) => {
                            $("#jqGrid").jqGrid('clearGridData');
                            $("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
                        }).catch((fail) => {
                            console.log('setJqGridTable fail > ', fail);
                        });
                    });
                }).catch((fail) => {
                    console.log('insBroadcast fail > ', fail);
                    alert2('방송장비 정보 등록에 실패했습니다.', function () {
                    });
                });
            });

            $('#udt_broadcast').on('click', function () {
                let array = [];
                const {isValid, obj} = validCheck();

                if (isValid) {
                    return;
                }

                array.push(obj);

                udtBroadcast(array).then((res) => {
                    if (res.count?.pass > 0) {
                        alert2(res?.pass_list[0]?.message, function () {
                        });
                        return;
                    }
                    if (res.count?.udt === 0) {
                        alert2('방송정보 정보가 수정되지 않았습니다.', function () {
                        });
                        return;
                    }
                    alert2('방송정보 정보가 수정되었습니다.', function () {
                        popFancyClose('#lay-form-write08');
                        const search_text = $('input[name=search_text]').val();
                        offset = 0;
                        getBroadcast({search_text: search_text, limit: limit, offset: offset}).then((res) => {
                            $("#jqGrid").jqGrid('clearGridData');
                            $("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
                        }).catch((fail) => {
                            console.log('setJqGridTable fail > ', fail);
                        });
                    });
                }).catch((fail) => {
                    console.log('insBroadcast fail > ', fail);
                    alert2('방송정보 정보 수정에 실패했습니다.', function () {
                    });
                });
            });

            // 수정 팝업
            $('.modifyBtn').on('click', function () {
                const brdcast_no = $("#jqGrid").jqGrid('getGridParam', 'selrow');

                if (brdcast_no === null) {
                    alert2('방송장비를 선택해주세요.', function () {
                    });
                    return;
                }

                initForm();

                Promise.all([getBroadcast({brdcast_no: brdcast_no}), getDistrictInfo()]).then(([res1, res2]) => {
                    if (res1.rows.length === 0) {
                        alert2('불러온 방송정보가 없습니다.', function () {
                        });
                        return;
                    } else if (res1.rows.length > 1) {
                        alert2('불러온 방송정보가 2개 이상입니다.', function () {
                        });
                        return;
                    }

                    let district_nm = $('select[name=district_no]');
                    district_nm.empty();
                    district_nm.append('<option value="">선택</option>');
                    $.each(res2.rows, function (index, item) {
                        district_nm.append('<option value="' + item.district_no + '">' + item.district_nm + '</option>');
                    });

                    setBroadcast(res1.rows[0]);
                    $("#form_sub_title").html('상세 정보');
                    $('#ins_broadcast').hide();
                    $('#udt_broadcast').show();
                    $('#del_broadcast').show();
                    $('#tr_brdcast_no').show();
                    popFancy('#lay-form-write08');
                }).catch((fail) => {
                    console.log('fail > ', fail);
                });
            });

            $('#del_broadcast').on('click', function () {
                const brdcast_no = $('input[name=brdcast_no]').val();
                if (brdcast_no === '') {
                    alert2('방송장비를 선택해주세요.', function () {
                    });
                    return;
                }
                confirm2('방송장비를 정보를 삭제하시겠습니까?', function () {
                    actionDelBroadcast(brdcast_no);
                });
            });

            $('.excelBtn').on('click', function () {
                const obj = makeExcelData('방송장비 관리');
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
                <h3 class="txt">방송장비 관리</h3>
                <div class="btn-group">
                    <input type="text" name="search_text" placeholder="방송장비명 / 현장명 / 설치상태"
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
                    <tr id="tr_brdcast_no">
                        <th>방송장비 ID <span style="color: red">*</span></th>
                        <td colspan="3">
                            <input type="text" name="brdcast_no" value="" readonly>
                        </td>
                    </tr>
                    <tr>
                        <th>방송장비명 <span style="color: red">*</span></th>
                        <td colspan="3">
                            <input type="text" name="brdcast_nm"/>
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
                        <td><input type="text" name="brdcast_svr_ip"/></td>
                        <th>접속Port <span style="color: red">*</span></th>
                        <td><input type="text" name="brdcast_svr_port"/></td>
                    </tr>
                    <tr>
                        <th>접속ID <span style="color: red">*</span></th>
                        <td><input type="text" name="brdcast_conn_id"/></td>
                        <th>접속PWD <span style="color: red">*</span></th>
                        <td><input type="text" name="brdcast_conn_pwd"/></td>
                    </tr>
                    <tr>
                        <th>ioT 단말번호<span style="color: red">*</span></th>
                        <td colspan="3"><input type="text" name="iot_no"/></td>
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
                        <td style="position: relative; text-align: left;">
                            <input type="text" name="brdcast_lat" class="required" style="width: 80%;">
                            <a class="mapBtn">지도찾기</a>
                        </td>
                        <th>경도 <span style="color: red">*</span></th>
                        <td>
                            <input type="text" name="brdcast_lon"/>
                        </td>
                    </tr>
                    <tr>
                        <th>모델명</th>
                        <td>
                            <input type="text" name="model_nm"/>
                        </td>
                        <th>제조사</th>
                        <td>
                            <input type="text" name="brdcast_maker"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <input type="button" red value="삭제" id="del_broadcast"/>
                <input type="button" blue value="수정" id="udt_broadcast"/>
                <input type="button" blue value="저장" id="ins_broadcast"/>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>

    <div id="lay-form-address" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">위치 찾기</div>
        <div class="layer-base-conts">
            <div class="map" id="map" style="min-height: 400px;"></div>
            <img src="/images/rv_marker.png" width="30px" class="centerMarker"/>
            <div class="btn-btm">
                <input type="button" class="locationApply" blue value="확인"/>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>
</section>
</body>
</html>
