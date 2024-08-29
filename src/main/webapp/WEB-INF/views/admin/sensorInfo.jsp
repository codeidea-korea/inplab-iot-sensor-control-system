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
        window.jqgridOption = {
            columnAutoWidth: true,
            multiselect: true,
            multiboxonly: false
        }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

        var _popupClearData;

        $(function () {
            $('.deleteBtn').hide();
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


            _popupClearData = getSerialize('#lay-form-write');
            // 초기화할 데이터값

            $.get('/adminAdd/common/code/list', {code_grp_nm: "유지보수상태"}, function (res) {
                let option = '<option value="">선택</option>';
                $.each(res, function (idx) {
                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#maint_sts_cd').html(option);
            });

            $.get('/adminAdd/common/code/list', {code_grp_nm: "사용유무"}, function (res) {
                let option = '<option value="">선택</option>';
                $.each(res, function (idx) {
                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#alarm_use_yn').html(option);
                $('#sms_snd_yn').html(option);
                $('#sens_disp_yn').html(option);
            });

            $.get('/adminAdd/common/code/loggerInfo', null, function (res) {
                let option = '<option value="">선택</option>';
                $.each(res, function (idx) {
                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#logr_no').html(option);
            });

            $.get('/adminAdd/common/code/sensorType', null, function (res) {
                let option = '<option value="">선택</option>';
                $.each(res, function (idx) {
                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#senstype_no').html(option);
            });


//             // 삭제
//             $('.deleteBtn').on('click', function () {
//                 var targetArr = getSelectedCheckData();
//
//                 if (targetArr.length > 0) {
//                     confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function () {
//                         $.each(targetArr, function (idx) {
//                             $.get('/adminAdd/sensorInfo/del', this, function (res) { // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?
//
//                                 if ((idx + 1) == targetArr.length) reloadJqGrid();
//                             });
//                         });
//
// //                             reloadJqGrid();
//                     });
//                 } else {
//                     alert('삭제하실 센서종류를 선택해주세요.');
//                     return;
//                 }
//             });

            // 팝업에서 삭제 버튼 클릭 시
            $('#lay-form-write .deleteBtn').on('click', function() {
                var sensNo = $('#sens_no').val();

                if (!sensNo) {
                    alert('삭제할 센서가 선택되지 않았습니다.');
                    return;
                }
                confirm('삭제하시겠습니까?', function() {
                    $.get('/adminAdd/sensorInfo/del', {sens_no: sensNo}, function(res) {
                        if (res === 1) {  // 성공 시
                            alert('삭제되었습니다.');
                            popFancyClose('#lay-form-write');
                            reloadJqGrid();  // 그리드를 리로드하여 변경 사항을 반영
                        } else if (res === -1) {  // 검증 실패 시
                            alert('이 센서는 삭제할 수 없습니다. 이미 사용 중이거나 다른 제약이 있습니다.');
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

                setSerialize('#lay-form-write', _popupClearData);

                popFancy('#lay-form-write');

                $('#logr_no').prop('disabled', false);
                $('#senstype_no').prop('disabled', false);
                // 수정 시작
                $('#logr_no').off('change').on('change', function () {
                    $('#senstype_no').val('');
                });
               
                $('#senstype_no').off('change').on('change', function () {
                    var senstypeNo = $(this).val();
                    var logrFlag = $('#logr_no').val(); 

                    if (logrFlag === "") {
                        alert("먼저 로거명을 선택하세요.");
                        $('#senstype_no').val('');
                        return;
                    }

                    if (senstypeNo !== "" && logrFlag !== "") {
                        getSenstypeAbbr(senstypeNo, function (senstypeAbbr) {
                            console.log(senstypeAbbr);
                            getNewSensorSeq(senstypeAbbr, logrFlag, function (newSensorSeq) {
                                //약어 logrFlag  senstypeAbbr newSensorSeq
                                $('#lay-form-write input[name="sens_nm"]').val(newSensorSeq);
                            });
                        });
                    } else {
                        $('#lay-form-write input[name="sens_nm"]').val('');
                    }
                });


                // 저장버튼 클릭시
                $('#lay-form-write input[type=submit]').off().on('click', function () {
                    if (!validate())
                        return;

                    $.get('/adminAdd/sensorInfo/add', getSerialize('#lay-form-write'), function (res) {
                        alert('저장되었습니다.', function () {
                            popFancyClose('#lay-form-write');
                        });
                        reloadJqGrid();
                    });
                });
            });

            function getSenstypeAbbr(senstypeNo, callback) {
                $.get('/adminAdd/common/code/sensorAbbr', {senstype_no: senstypeNo}, function (res) {
                    console.log(res[0])
                    var sens_abbr = res[0].sens_abbr;
                    callback(sens_abbr);  // 결과를 콜백 함수로 전달
                });
            }

            function getNewSensorSeq(senstypeAbbr, logrFlag, callback) {
                $.get('/adminAdd/common/code/newSensorSeq', {sensor_seq: senstypeAbbr, logr_no : logrFlag}, function (res) {
                    var new_sensor_seq = res[0].new_sensor_seq;
                    callback(new_sensor_seq);  // 결과를 콜백 함수로 전달
                });
            }

            // 수정 팝업
            $('.modifyBtn').on('click', function () {

                $("#form_sub_title").html('상세정보');
                $('input[type="submit"]').val('수정');
                var targetArr = getSelectedCheckData();

                if (targetArr.length > 1) {
                    alert('수정 할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length == 0) {
                    alert('수정할 데이터를 선택해주세요.');
                    return;
                }

                setSerialize('#lay-form-write', targetArr[0]); // 선택값 세팅
                $('.deleteBtn').show();
                popFancy('#lay-form-write');

                $('#logr_no').prop('disabled', true);
                $('#senstype_no').prop('disabled', true);

                // 저장버튼 클릭시
                $('#lay-form-write input[type=submit]').off().on('click', function () {
                    if (!validate())
                        return;

                    $.get('/adminAdd/sensorInfo/mod', getSerialize('#lay-form-write'), function (res) {
                        alert('저장되었습니다.', function () {
                            popFancyClose('#lay-form-write');
                        });
                        reloadJqGrid();
                    });
                });
            });

            $('.excelBtn').on('click', function () {
                downloadExcel('로거관리');
            });


            $('input[name=sens_lon], input[name=sens_lat]').on('click', function () {
                if ($('#lay-form-write input[name=sens_lon]').val() != '' && $('#lay-form-write input[name=sens_lat]').val() != '') {
                    try {
                        window.vworld.setPanBy([parseFloat($('#lay-form-write input[name=sens_lat]').val()), parseFloat($('#lay-form-write input[name=sens_lon]').val())]);
                    } catch (e) {
                    }
                }

                popFancy('#lay-form-address', {dragToClose: false, touch: false});
            });


            $('.locationApply').on('click', function () {
                let coords = window.vworld.getCenter();
                $('#lay-form-write input[name=sens_lon]').val(coords[1]);
                $('#lay-form-write input[name=sens_lat]').val(coords[0]);
                popFancyClose('#lay-form-address');
            });

        });

        function triggerFileUpload() {
            // 파일 선택 창을 열기 위해 숨겨진 input[type="file"] 요소를 클릭합니다.
            document.getElementById('file').click();
        }

        function uploadFile() {
            var fileInput = document.getElementById('file');

            // 사용자가 파일을 선택한 경우
            if (fileInput.files.length > 0) {
                var formData = new FormData();
                formData.append("file", fileInput.files[0]);

                $.ajax({
                    url: "/adminAdd/sensorInfo/upload",
                    type: "POST",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (response) {
                        alert(response);
                    },
                    error: function (response) {
                        alert("Error: " + response.responseText);
                    }
                });
            } else {
                alert("No file selected.");
            }
            reloadJqGrid();
        }

    </script>
</head>

<body data-pgcode="0000">
<section
        id="wrap">
    <!--[s] 상단 -->
    <jsp:include page="../common/include_top.jsp" flush="true"></jsp:include>
    <!--[e] 상단 -->

    <!--[s] 왼쪽 메뉴 -->
    <div
            id="global-menu">
        <!--[s] 주 메뉴 -->
        <jsp:include page="../common/include_sidebar.jsp" flush="true"></jsp:include>
        <!--[e] 주 메뉴 -->
    </div>
    <!--[e] 왼쪽 메뉴 -->

    <div id="container">
        <h2 class="txt">
            관리자 전용
            <span class="arr">관리자</span>
        </h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">센서 관리</h3>
                <div class="btn-group">
                    <input class="search_input" type="text" id="search" name="search"
                           placeholder="센서타입명 / 센서ID / 로거명 / 센서상태"/>
                    <a class="searchBtn">검색</a>

<%--                    <a class="insertBtn">등록</a>--%>
<%--                    <a class="modifyBtn">수정</a>--%>
                    <a class="insertBtn">신규 등록</a>
                    <a class="modifyBtn">상세정보</a>
<%--                    <a class="deleteBtn">삭제</a>--%>

                    <a class="uploadBtn" href="javascript:void(0);" onclick="triggerFileUpload()">업로드</a>
                    <form id="uploadForm" style="display:none;">
                        <input type="file" id="file" name="file" accept=".xlsx" onchange="uploadFile()">
                    </form>

                    <a class="excelBtn">다운로드</a>
                </div>
                <div class="contents-in">
                    <jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>
                </div>
            </div>
        </div>
    </div>
    <!--[e] 컨텐츠 영역 -->

    <!--[s] 센서 등록 팝업 -->
    <div id="lay-form-write" class="layer-base">

        <input type="hidden" id="sens_no" name="sens_no"/>

        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
        </div>
        <div class="layer-base-title">센서 <span id="form_sub_title">등록/수정</span></div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="*"/>
                        <col width="*"/>
                        <col width="*"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    
                    <tr>
                        <th class="required_th">로거명</th>
                        <td colspan="3">
                            <select id="logr_no" name="logr_no" class="required">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">센서타입명</th>
                        <td colspan="3">
                            <select id="senstype_no" name="senstype_no" class="required">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th>센서 ID</th>
                        <td colspan="3">
                            <input type="text" name="sens_nm" readonly/>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">단면번호</th>
                        <td colspan="3">
                            <input type="text" name="sect_no" class="required"/>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">미수신허용(분)</th>
                        <td colspan="3">
<%--                            <input type="text" name="nonrecv_limit_min" class="required number-only"/>--%>
                            <input type="number" name="nonrecv_limit_min" class="required number-only" min="0" step="1" />
                        </td>
                    </tr>


                    <tr>
                        <th class="required_th">경보사용</th>
                        <td colspan="3">
                            <select id="alarm_use_yn" name="alarm_use_yn" class="required">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">문자발송</th>
                        <td colspan="3">
                            <select id="sms_snd_yn" name="sms_snd_yn" class="required">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">화면표시</th>
                        <td colspan="3">
                            <select id="sens_disp_yn" name="sens_disp_yn" class="required">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">설치일자</th>
                        <td colspan="3">
                            <input type="text" name="inst_ymd" class="datetimepickerOne required"/>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">센서상태</th>
                        <td colspan="3">
                            <select id="maint_sts_cd" name="maint_sts_cd" class="required">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">위도</th>
                        <td>
                            <input type="text" name="sens_lat" class="required"/>
                        </td>

                        <th class="required_th">경도</th>
                        <td>
                            <input type="text" name="sens_lon" class="required"/>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">모델명</th>
                        <td>
                            <input type="text" name="model_nm" class="required"/>
                        </td>
                        <th class="required_th">제조사</th>
                        <td>
                            <input type="text" name="sens_maker" class="required"/>
                        </td>
                    </tr>


                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <button type="button" class="deleteBtn" style="display:none;">삭제</button>
                <input type="submit" blue value="저장"/>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>
    <!--[e] 센서 등록 팝업 -->

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
