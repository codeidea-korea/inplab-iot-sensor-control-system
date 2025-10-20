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
    <script>
        $('.deleteBtn').hide();
        window.jqgridOption = {
            columnAutoWidth: true,
            multiselect: true,
            multiboxonly: false
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

            $("#dist_pic").on("change", function (event) {
                var file1 = event.target.files[0];
                var reader1 = new FileReader();
                reader1.onload = function (e) {
                    $('#uploadFileImg1').css("cursor", "");
                    $('#uploadFileImg1').off('click');

                    $("#uploadFileImg1").attr("src", e.target.result);
                }
                reader1.readAsDataURL(file1);
            });

            $("#dist_view_pic").on("change", function (event) {
                var file2 = event.target.files[0];
                var reader2 = new FileReader();
                reader2.onload = function (e) {
                    $('#uploadFileImg2').css("cursor", "");
                    $('#uploadFileImg2').off('click');

                    $("#uploadFileImg2").attr("src", e.target.result);
                }
                reader2.readAsDataURL(file2);
            });

            $.get('/adminAdd/common/code/list', {code_grp_nm: "현장구분"}, function (res) {
                let option = '<option value="">선택</option>';
                $.each(res, function (idx) {
                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#dist_type_cd').html(option);
            });

            $.ajax({
                method: 'post',
                url: '/adminAdd/common/code/maintcompInfoList',
                data: JSON.stringify({partner_type_flag: [0, 2]}),
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (res) {
                    let option = '<option value="">선택</option>';
                    $.each(res, function (idx) {
                        option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                    });
                    $('#inst_comp_id1').html(option);
                    $('#inst_comp_id2').html(option);
                }
            });

            $.ajax({
                method: 'post',
                url: '/adminAdd/common/code/maintcompInfoList',
                data: JSON.stringify({partner_type_flag: [1, 2]}),
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                success: function (res) {
                    let option = '<option value="">선택</option>';
                    $.each(res, function (idx) {
                        option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                    });
                    $('#meas_comp_id1').html(option);
                    $('#meas_comp_id2').html(option);
                }
            });

            _popupClearData = getSerialize('#lay-form-write');       // 초기화할 데이터값

            // 팝업에서 삭제 버튼 클릭 시
            $('#lay-form-write .deleteBtn').on('click', function () {
                var districtNo = $('#district_no').val();

                if (!districtNo) {
                    alert('삭제할 현장이 선택되지 않았습니다.');
                    return;
                }
                confirm('삭제하시겠습니까?', function () {
                    $.get('/adminAdd/districtInfo/del', {district_no: districtNo}, function (res) {
                        if (res === 1) {  // 성공 시
                            alert('삭제되었습니다.');
                            popFancyClose('#lay-form-write');
                            reloadJqGrid();  // 그리드를 리로드하여 변경 사항을 반영
                        } else if (res === -1) {  // 검증 실패 시
                            alert('이 현장은 삭제할 수 없습니다. 이미 사용 중이거나 다른 제약이 있습니다.');
                        } else {
                            alert('삭제 실패: ' + res);
                        }
                    });
                });

            });

            $('.insertBtn').on('click', function () {
                $('.deleteBtn').hide();
                $("#form_sub_title").html('신규 등록');
                $('input[type="submit"]').val('저장');

                initForm();

                $.get('/adminAdd/districtInfo/max-no', null, (res) => {
                    if (res !== null && res !== undefined) {
                        const newId = 'D' + (parseInt(res.substring(1)) + 1).toString().padStart(2, '0');
                        $('#lay-form-write input[name=district_no]').val(newId);
                    }
                });

                setSerialize('#lay-form-write', _popupClearData);
                popFancy('#lay-form-write');

                $('#lay-form-write input[type=submit]').off().on('click', function (e) {

                    e.preventDefault();

                    if (!validate()) {
                        return;
                    }
                    const form = $('#lay-form-write')[0]; // 폼 요소 선택
                    const formData = new FormData(form); // FormData 객체 생성

                    $.ajax({
                        url: '/adminAdd/districtInfo/add',
                        type: 'POST',
                        data: formData,
                        contentType: false, // 서버에 전송되는 데이터의 타입을 기본 설정으로 둠
                        processData: false, // 데이터의 처리 방법 설정 (false로 해야 파일을 처리할 수 있음)
                        success: function (res) {
                            if (res.success) {
                                alert(res.message, function () {
                                    popFancyClose('#lay-form-write');
                                    reloadJqGrid(); // 그리드 리로드
                                });
                            } else {
                                alert(res.message); // 중복된 값이 있거나 오류가 발생한 경우의 메시지
                                if (res.message === "중복된 값이 존재합니다.") {
                                    $('.abbr').focus(); // 중복된 값이 있는 필드로 포커스 이동
                                }
                            }
                        },
                        error: function (err) {
                            alert('파일 업로드에 실패했습니다.');
                        }
                    });
                });
            });

            $('.modifyBtn').on('click', function () {

                $("#form_sub_title").html('상세정보');
                $('input[type="submit"]').val('수정');

                initForm();

                var targetArr = getSelectedCheckData();

                if (targetArr.length > 1) {
                    alert('수정 할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length === 0) {
                    alert('수정할 데이터를 선택해주세요.');
                    return;
                }

                $("#uploadFileImg1").attr("src", "data:image/jpeg;base64," + targetArr[0].dist_pic_src);
                $("#uploadFileImg2").attr("src", "data:image/jpeg;base64," + targetArr[0].dist_view_pic_src);

                targetArr[0].dist_pic = '';
                targetArr[0].dist_view_pic = '';

                setSerialize('#lay-form-write', targetArr[0]);     // 선택값 세팅
                $('.deleteBtn').show();
                popFancy('#lay-form-write');

                $('#lay-form-write input[type=submit]').off().on('click', function (e) {
                    e.preventDefault();
                    if (!validate()) {
                        return;
                    }
                    const form = $('#lay-form-write')[0];
                    const formData = new FormData(form);

                    $.ajax({
                        url: '/adminAdd/districtInfo/mod',
                        type: 'POST',
                        data: formData,
                        contentType: false, // 서버에 전송되는 데이터의 타입을 기본 설정으로 둠
                        processData: false, // 데이터의 처리 방법 설정 (false로 해야 파일을 처리할 수 있음)
                        success: function (res) {
                            alert('저장되었습니다.', function () {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        },
                        error: function (err) {
                            alert('파일 업로드에 실패했습니다.');
                        }
                    });

                });
            });

            $('#mapSearchBtn').on('click', function () {
                if ($('#lay-form-write input[name=dist_lat]').val() !== '' && $('#lay-form-write input[name=dist_lon]').val() !== '') {
                    try {
                        window.vworld.setPanBy([
                            parseFloat($('#lay-form-write input[name=dist_lon]').val()),
                            parseFloat($('#lay-form-write input[name=dist_lat]').val())], parseFloat($('#lay-form-write input[name=dist_zoom]').val())
                        );
                    } catch (e) {
                    }
                }
                popFancy('#lay-form-address', {dragToClose: false, touch: false});
            });

            $('input[name=dist_lat], input[name=dist_lon]').on('click', function () {
                if ($('#lay-form-write input[name=dist_lat]').val() != '' && $('#lay-form-write input[name=dist_lon]').val() != '') {
                    try {
                        window.vworld.setPanBy([parseFloat($('#lay-form-write input[name=dist_lon]').val()), parseFloat($('#lay-form-write input[name=dist_lat]').val())]);
                    } catch (e) {
                    }
                }

                popFancy('#lay-form-address', {dragToClose: false, touch: false});
            });

            $('.locationApply').on('click', function () {
                let coords = window.vworld.getCenter();
                let zoom = window.vworld.getZoom();
                $('#lay-form-write input[name=dist_lat]').val(coords[1]);
                $('#lay-form-write input[name=dist_lon]').val(coords[0]);
                $('#lay-form-write input[name=dist_zoom]').val(zoom);
                popFancyClose('#lay-form-address');
            });

            $('.excelBtn').on('click', function () {
                downloadExcel('현장관리');
            });
        });

        function afterSetAddress(data) {
            const geocoder = new kakao.maps.services.Geocoder();
            geocoder.addressSearch(data.address, function (result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                    $('#lay-form-write input[name=dist_lat]').val(coords.getLat());
                    $('#lay-form-write input[name=dist_lon]').val(coords.getLng());
                    $('#lay-form-write input[name=dist_zoom]').val(18);
                    window.vworld.setPanBy([coords.getLng(), coords.getLat()], 18);
                }
            });
        }

        function initForm() {

            $('#lay-form-write input[name=district_no]').val('');

            $('#lay-form-write input[name=dist_zip]').val('');
            $('#lay-form-write input[name=dist_addr]').val('');

            $('#lay-form-write input[name=dist_zoom]').val('');
            $('#lay-form-write select[name=inst_comp_id1]').val('');
            $('#lay-form-write select[name=inst_comp_id2]').val('');

            $('#lay-form-write input[name=meas_str_ymd]').val('');
            $('#lay-form-write input[name=dist_abbr]').val('');

            $("#uploadFileImg1").attr("src", '');
            $('#lay-form-write input[name=dist_pic]').val('');

            $("#dist_pic").attr("src", '');

            $('#lay-form-write input[name=district_nm]').val('');

            $('#lay-form-write select[name=dist_type_cd]').val('');
            $('#lay-form-write input[name=dist_road_addr]').val('');

            $('#lay-form-write input[name=dist_lat]').val('');
            $('#lay-form-write input[name=dist_lon]').val('');

            $('#lay-form-write select[name=meas_comp_id1]').val('');
            $('#lay-form-write select[name=meas_comp_id2]').val('');

            $('#lay-form-write input[name=meas_end_ymd]').val('');
            $('#lay-form-write input[name=dist_offi_nm]').val('');

            $("#uploadFileImg2").attr("src", '');
            $('#lay-form-write input[name=dist_view_pic]').val('');
            $("#dist_view_pic").attr("src", '');
        }

        function genServerFileName() {
            var date = new Date;
            var year = date.getFullYear();
            var month = date.getMonth() + 1;
            var day = date.getDate();
            var seconds = date.getSeconds();
            var minutes = date.getMinutes();
            var hour = date.getHours();
            var milliSeconds = date.getMilliseconds();
            return year + '' + month + '' + day + '' + hour + '' + month + '' + minutes + '' + seconds + '' + milliSeconds;
        }

        function getExtName(name) {
            return name.substr(name.lastIndexOf('.'));
        }

        function fileUpload(call_url, form) {
            $.ajax({
                url: call_url
                , type: "POST"
                , processData: false
                , contentType: false
                , data: form
            });
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
        <h2 class="txt">
            관리자 전용
            <span class="arr">현장관리</span>
        </h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">현장 정보 관리</h3>
                <div class="btn-group">
                    <input type="text" class="search_input" id="search" name="search" placeholder="현장명/주소/시공사/계측사"/>
                    <a class="searchBtn">검색</a>
                    <a class="insertBtn">신규 등록</a>
                    <a class="modifyBtn">상세정보</a>
                    <a class="excelBtn">다운로드</a>
                </div>
                <div class="contents-in" style="width: 100%">
                    <jsp:include page="../common/include_jqgrid.jsp" flush="true"/>
                </div>
            </div>
        </div>
    </div>
    <form id="lay-form-write" class="layer-base wide">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">현장 정보 <span id="form_sub_title">등록/수정</span></div>
        <div class="layer-base-conts">
            <div class="table-container" style="display: flex; justify-content: space-between; gap:10px;">
                <div class="bTable tal">
                    <table>
                        <colgroup>
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>관리 기관</th>
                            <td colspan=""><input type="text" name="site_no" value="S01" readonly/></td>

                            <th>현장ID</th>
                            <td colspan=""><input type="text" id="district_no" name="district_no" readonly/></td>
                        </tr>
                        <tr>
                            <th class="required_th" style="vertical-align: middle;">우편번호</th>
                            <td colspan="3">
                                <div style="display: flex; align-items: center;">
                                    <input type="text" name="dist_zip" class="required" readonly
                                           style="flex: 1; margin-right: 10px;"/>
                                    <div class="btn-btm" style="width: auto; margin-top: 0px;">
                                        <button type="button" id="addrSearchBtn"
                                                style="margin-left: 10px; padding: 5px 10px;"
                                                onclick="openDaumPostcode('dist_zip', 'dist_addr', 'dist_road_addr', afterSetAddress)">
                                            주소 검색
                                        </button>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>현장 주소</th>
                            <td colspan="3"><input type="text" name="dist_addr"/></td>
                        </tr>
                        <tr>
                            <th>지도 Zoom</th>
                            <td colspan="3">
                                <div style="display: flex; align-items: center;">
                                    <input type="text" name="dist_zoom" class="" readonly
                                           style="flex: 1; margin-right: 10px;"/>
                                    <div class="btn-btm" style="width: auto; margin-top: 0px;">
                                        <button type="button" id="mapSearchBtn"
                                                style="margin-left: 10px; padding: 5px 10px;"
                                        >지도 검색
                                        </button>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="required_th">시공사 1</th>
                            <td colspan="3">
                                <select id="inst_comp_id1" name="inst_comp_id1" class="required">
                                    <option value="">선택</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>시공사 2</th>
                            <td colspan="3">
                                <select id="inst_comp_id2" name="inst_comp_id2">
                                    <option value="">선택</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th class="required_th">계측시작일</th>
                            <td colspan="3"><input type="text" id="meas_str_ymd" name="meas_str_ymd" value=""
                                                   placeholder="2000-01-01" class="datetimepickerOne required"/></td>
                        </tr>
                        <tr>
                            <th class="required_th">현장 약어</th>
                            <td colspan="3"><input type="text" name="dist_abbr" class="required abbr"/></td>
                        </tr>
                        <tr>
                            <th class="required_th">현장사진</th>
                            <td colspan="3">
                                <div style="display: flex; align-items: center;">
                                    <input type="file" id="dist_pic" name="dist_pic" class="file1"
                                           accept="image/*" style="display:none;"/>

                                    <div class="btn-btm" style="width: auto; margin-top: 0px;">
                                        <button type="button" class="btn-search" onclick="$('#dist_pic').click()"
                                                style="margin-left: 10px;">파일 선택
                                        </button>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>현장사진</th>
                            <td colspan="3" style="height:250px">
                                <img id="uploadFileImg1" src="" alt="" style="width:300px">
                            </td>
                        </tr>
                        </tbody>
                    </table>

                </div>

                <div class="bTable tal" style="margin-top: 0px !important;">
                    <table>
                        <colgroup>
                            <col width="*">
                            <col width="*">
                            <col width="*">
                            <col width="*">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th class="required_th">현장명</th>
                            <td colspan="3"><input type="text" name="district_nm" class="required"/></td>
                        </tr>

                        <tr>
                            <th class="required_th">현장구분</th>
                            <td colspan="3">
                                <select id="dist_type_cd" name="dist_type_cd" class="required">
                                    <option value="">선택</option>
                                </select>
                            </td>
                        </tr>

                        <tr>
                            <th>도로명주소</th>
                            <td colspan="3"><input type="text" name="dist_road_addr"/></td>
                        </tr>
                        <tr>
                            <th class="required_th">위도</th>
                            <td><input type="text" name="dist_lat" class="required"/></td>
                            <th class="required_th">경도</th>
                            <td><input type="text" name="dist_lon" class="required"/></td>
                        </tr>

                        <tr>
                            <th class="required_th">계측사 1</th>
                            <td colspan="3">
                                <select id="meas_comp_id1" name="meas_comp_id1" class="required">
                                    <option value="">선택</option>
                                </select>
                            </td>
                        </tr>

                        <tr>
                            <th>계측사 2</th>
                            <td colspan="3">
                                <select id="meas_comp_id2" name="meas_comp_id2">
                                    <option value="">선택</option>
                                </select>
                            </td>
                        </tr>

                        <tr>
                            <th>계측 종료일</th>
                            <td colspan="3"><input type="text" id="meas_end_ymd" name="meas_end_ymd" value=""
                                                   placeholder="2000-01-01" class="datetimepickerOne"/></td>
                        </tr>

                        <tr>
                            <th>관리사업소</th>
                            <td colspan="3"><input type="text" name="dist_offi_nm"/></td>
                        </tr>

                        <tr>
                            <th>현장사진</th>
                            <td colspan="3">
                                <div style="display: flex; align-items: center;">
                                    <input type="file" id="dist_view_pic" name="dist_view_pic" class="file2"
                                           accept="image/*" style="display:none;"/>
                                    <div class="btn-btm" style="width: auto; margin-top: 0px;">
                                        <button type="button" class="btn-search" onclick="$('#dist_view_pic').click()"
                                                style="margin-left: 10px;">파일 선택
                                        </button>
                                    </div>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <th>현장사진</th>
                            <td colspan="3" style="height:250px">
                                <img id="uploadFileImg2" src="" alt="" style="width:300px">
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="btn-btm">
                <button type="button" class="deleteBtn" style="display:none;">삭제</button>
                <input type="submit" blue value="저장"/>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </form>

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
