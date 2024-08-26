<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>

    <style>
        #map {
            width: 100%;
            /* height: calc(100% - 48px); */
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
        }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

        //             var _popupClearData;

        $(function () {
            window.vworld = new vwutil({
                mapId: "map",
                initPosition: {
                    center: [
                        // 126.88624657982738, 37.480957215573261
                        127.449482276989, 36.9317789946793
                    ], // [14124968.051077379, 4506389.894300204],
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

            $.get('/adminAdd/common/code/maintcompInfoList', {partner_type_flag: "0"}, function (res) {
                let option = '<option value="">선택</option>';
                $.each(res, function (idx) {
                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#inst_comp_id1').html(option);
                $('#inst_comp_id2').html(option);
            });

            $.get('/adminAdd/common/code/maintcompInfoList', {partner_type_flag: "1"}, function (res) {
                let option = '<option value="">선택</option>';
                $.each(res, function (idx) {
                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#meas_comp_id1').html(option);
                $('#meas_comp_id2').html(option);
            });

                _popupClearData = getSerialize('#lay-form-write');       // 초기화할 데이터값

            // 삭제
//             $('.deleteBtn').on('click', function () {
//                 var targetArr = getSelectedCheckData();
//
//                 if (targetArr.length > 0) {
//                     confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function () {
//                         $.each(targetArr, function (idx) {
//                             $.get('/adminAdd/districtInfo/del', this, function (res) {
//                                 // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?
//
//                                 if ((idx + 1) == targetArr.length) reloadJqGrid();
//                             });
//                         });
//
// //                             reloadJqGrid();
//                     });
//                 } else {
//                     alert('삭제하실 현장을 선택해주세요.');
//                     return;
//                 }
//             });

            // 팝업에서 삭제 버튼 클릭 시
            $('#lay-form-write .deleteBtn').on('click', function() {
                var districtNo = $('#district_no').val();

                if (!districtNo) {
                    alert('삭제할 현장이 선택되지 않았습니다.');
                    return;
                }

                    $.get('/adminAdd/districtInfo/del', {district_no: districtNo}, function(res) {
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

            // 등록
            $('.insertBtn').on('click', function () {

                $('.deleteBtn').hide();
                $("#form_sub_title").html('등록');

                initForm();

                //district_no 셋팅
                $.get('/adminAdd/common/code/getNewGenerationKey', { table_nm: "tb_district_info", column_nm: "district_no", pre_type: "" }, function (res) {
                    if (res.length > 0) {
                        $('#lay-form-write input[name=district_no]').val(res[0].new_id);
                    }
                });

                setSerialize('#lay-form-write', _popupClearData);

                popFancy('#lay-form-write');

                // 저장버튼 클릭시
                $('#lay-form-write input[type=submit]').off().on('click', function (e) {

                    e.preventDefault();

                    if (!validate()){
                        return;
                    }
                    console.log("등록")
                    const form = $('#lay-form-write')[0]; // 폼 요소 선택
                    const formData = new FormData(form); // FormData 객체 생성

                    $.ajax({
                        url: '/adminAdd/districtInfo/add',
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

            // 수정 팝업
            $('.modifyBtn').on('click', function () {

                $("#form_sub_title").html('수정');

                initForm();

                var targetArr = getSelectedCheckData();

                if (targetArr.length > 1) {
                    alert('수정 할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length == 0) {
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

                // 저장버튼 클릭시
                $('#lay-form-write input[type=submit]').off().on('click', function (e) {

                    e.preventDefault();
                    if (!validate()){
                        return;
                    }
                    const form = $('#lay-form-write')[0]; // 폼 요소 선택
                    const formData = new FormData(form); // FormData 객체 생성

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

            /*24.02.27
현장 수정시 위도를 선택해도 지도창이 오픈, 경도를 선택해도 지도창이 오픈됨
        => 1.지도검색 버튼을 추가하고 지도에서 위치 선택하면 자동 위도/경도 정보 표출.*/
            $('#mapSearchBtn').on('click', function () {
                if ($('#lay-form-write input[name=dist_lat]').val() != '' && $('#lay-form-write input[name=dist_lon]').val() != '') {
                    try {
                        window.vworld.setPanBy([
                            parseFloat($('#lay-form-write input[name=dist_lon]').val()),
                            parseFloat($('#lay-form-write input[name=dist_lat]').val())], parseFloat($('#lay-form-write input[name=zoom]').val())
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
                $('#lay-form-write input[name=dist_lat]').val(coords[1]);
                $('#lay-form-write input[name=dist_lon]').val(coords[0]);
                popFancyClose('#lay-form-address');
            });

            $('.excelBtn').on('click', function () {
                downloadExcel('현장관리');
            });
        });

        function initForm() {

            $('#lay-form-write input[name=district_no]').val('');

            $('#lay-form-write input[name=dist_zip]').val('');
            $('#lay-form-write input[name=dist_addr]').val('');

            $('#lay-form-write input[name=zoom]').val('');
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

        // function validate() {
        //
        // 	var maxSizeMb = 10;
        // 	var maxSize = maxSizeMb * 1024 * 1024; // 10MB
        //
        // 	if($("#uploadFile1")[0].files[0] != undefined){
        //
        // 		var fileSize = $("#uploadFile1")[0].files[0].size;
        // 		if(fileSize > maxSize){
        // 			alert("파일1은 "+maxSizeMb+"MB 이내로 등록 가능합니다.");
        // 			$("#uploadFile1").val("");
        // 			return false;
        // 		}
        //
        // 		if($("#uploadFile1").val() != "") {
        // 			var ext = $("#uploadFile1").val().split(".").pop().toLowerCase();
        // 			if($.inArray(ext, ['jpg','jpeg','gif','png', 'bmp', 'pdf']) == -1) {
        // 				alert("이미지 파일만 파일1로 등록 가능합니다.");
        // 				$("#uploadFile1").val("");
        // 				return false;
        // 			}
        // 		}
        //
        // 	}
        //
        // 	if($("#uploadFile2")[0].files[0] != undefined){
        //
        // 		var fileSize = $("#uploadFile2")[0].files[0].size;
        // 		if(fileSize > maxSize){
        // 			alert("파일2는 "+maxSizeMb+"MB 이내로 등록 가능합니다.");
        // 			$("#uploadFile2").val("");
        // 			return false;
        // 		}
        //
        // 		if($("#uploadFile2").val() != "") {
        // 			var ext = $("#uploadFile2").val().split(".").pop().toLowerCase();
        // 			if($.inArray(ext, ['jpg','jpeg','gif','png', 'bmp', 'pdf']) == -1) {
        // 				alert("이미지 파일만 파일2로 등록 가능합니다.");
        // 				$("#uploadFile2").val("");
        // 				return false;
        // 			}
        // 		}
        //
        // 	}
        //
        // 	if ($('#lay-form-write select[name=area_id_hid]').val().trim() == '') {
        // 		$('#lay-form-write select[name=area_id_hid]').focus();
        // 		alert('현장명을 선택해주세요.');
        // 		return false;
        // 	}
        //
        //     if ($('#lay-form-write input[name=name]').val().trim() == '') {
        //         $('#lay-form-write input[name=name]').focus();
        //         alert('현장명을 입력해주세요.');
        //         return false;
        //     }
        //
        //     if ($('#lay-form-write select[name=use_flag]').val().trim() == '') {
        //         $('#lay-form-write select[name=use_flag]').focus();
        //         alert('사용 여부를 선택해주세요.');
        //         return false;
        //     }
        //
        // 	// if ($('#lay-form-write input[name=dist_lat]').val().trim() == '') {
        // 	// 	$('#lay-form-write input[name=dist_lat]').focus();
        // 	// 	alert('위도를 입력해주세요.');
        // 	// 	return false;
        // 	// }
        //
        //     if ($('#lay-form-write select[name=etc1_hid]').val().trim() == '') {
        //         $('#lay-form-write select[name=etc1_hid]').focus();
        //         alert('로거 ID를 입력해주세요.');
        //         return false;
        //     }
        //
        //     return true;
        // }
        //
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
    <!--[s] 상단 -->
    <jsp:include page="../common/include_top.jsp" flush="true"></jsp:include>
    <!--[e] 상단 -->

    <!--[s] 왼쪽 메뉴 -->
    <div id="global-menu">
        <!--[s] 주 메뉴 -->
        <jsp:include page="../common/include_sidebar.jsp" flush="true"></jsp:include>
        <!--[e] 주 메뉴 -->
    </div>
    <!--[e] 왼쪽 메뉴 -->

    <!--[s] 컨텐츠 영역 -->
    <div id="container">
        <h2 class="txt">
            관리자 전용
            <span class="arr">관리자</span>
        </h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">현장 관리</h3>
                <div class="btn-group">
                    <input type="text" class="search_input"  id="search" name="search" placeholder="현장명/주소/시공사/계측사"/>
                    <a class="searchBtn">검색</a>

                    <a class="insertBtn">등록</a>
                    <a class="modifyBtn">수정</a>
                    <%--<a class="deleteBtn">삭제</a>--%>
                    <a class="excelBtn">다운로드</a>
                </div>
                <div class="contents-in" style="width: 100%">
                    <jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>
                </div>
            </div>
        </div>
    </div>
    <!--[e] 컨텐츠 영역 -->

    <!--[s] 현장 등록 팝업 -->
    <form id="lay-form-write" class="layer-base wide">
        <input type="hidden" id="district_no" name="district_no"/>
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">현장 관리 <span id="form_sub_title">등록/수정</span></div>
        <div class="layer-base-conts">
            <%--            <div class="table-container" style="display: flex; justify-content: space-between; gap:10px;>--%>
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
                            <td colspan=""><input type="text" name="district_no"  readonly/></td>
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
                                                onclick="openDaumPostcode('dist_zip', 'dist_addr', 'dist_road_addr')">
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
                                    <input type="text" name="zoom" class="" readonly
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
                <input type="submit" blue value="저장"/>
                <button type="button" class="deleteBtn" style="display:none;">삭제</button>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>

    </form>
    <!--[e] 현장 등록 팝업 -->

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
