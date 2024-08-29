<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>

        <style></style>

        <script>
            window.jqgridOption = {
                columnAutoWidth: true,
                multiselect: true,
                multiboxonly: false
            }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

            var _popupClearData;
            let firstCode = '';

            $(function () {
                $('.deleteBtn').hide();

                _popupClearData = getSerialize('#lay-form-write');
                // 초기화할 데이터값

                $.get('/adminAdd/common/code/list', {code_grp_nm: "로거구분"}, function (res) {
                    let option = '<option value="">선택</option>';
                    $.each(res, function (idx) {
                        option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                    });
                    $('#logr_flag').html(option);
                });

                $.get('/adminAdd/common/code/list', {code_grp_nm: "유지보수상태"}, function (res) {
                    let option = '<option value="">선택</option>';
                    $.each(res, function (idx) {
                        option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                    });
                    $('#maint_sts_cd').html(option);
                });

                $.get('/adminAdd/common/code/districtInfoList', null, function (res) {
                    let option = '<option value="">선택</option>';
                    $.each(res, function (idx) {
                        option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                    });
                    $('#district_no').html(option);
                });


                // 삭제
                // $('.deleteBtn').on('click', function () {
                //     var targetArr = getSelectedCheckData();
                //
                //     if (targetArr.length > 0) {
                //         confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function () {
                //             $.each(targetArr, function (idx) {
                //                 $.get('/adminAdd/sensorType/del', this, function (res) { // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?
                //
                //                     if( (idx+1)== targetArr.length ) reloadJqGrid();
                //                 });
                //             });
                //
                //             // reloadJqGrid();
                //         });
                //     } else {
                //         alert('삭제하실 센서 타입종류를 선택해주세요.');
                //         return;
                //     }
                // });

                // 팝업에서 삭제 버튼 클릭 시
                $('#lay-form-write .deleteBtn').on('click', function() {
                    var senstypeNo = $('#senstype_no').val();

                    if (!senstypeNo) {
                        alert('삭제할 센서 타입이 선택되지 않았습니다.');
                        return;
                    }
                    confirm('삭제하시겠습니까?', function() {
                        $.get('/adminAdd/sensorType/del', {senstype_no: senstypeNo}, function(res) {
                            if (res === 1) {  // 성공 시
                                alert('삭제되었습니다.');
                                popFancyClose('#lay-form-write');
                                reloadJqGrid();  // 그리드를 리로드하여 변경 사항을 반영
                            } else if (res === -1) {  // 검증 실패 시
                                alert('이 센서 타입은 삭제할 수 없습니다. 이미 사용 중이거나 다른 제약이 있습니다.');
                            } else {
                                alert('삭제 실패: ' + res);
                            }
                        });
                    });
                });

                // 등록
                $('.insertBtn').on('click', function () {
                    $('.deleteBtn').hide();
                	$("#form_sub_title").html('신규 등록');
                    $('input[type="submit"]').val('저장');
                    setSerialize('#lay-form-write', _popupClearData);

                    popFancy('#lay-form-write');

                    $.get('/adminAdd/common/code/getNewGenerationKey', { table_nm: "tb_sensor_type", column_nm: "senstype_no", pre_type: "" }, function (res) {
                        if (res.length > 0) {
                            $('#lay-form-write input[name=senstype_no]').val(res[0].new_id);
                        }
                    });

                    $('#site_no').val(firstCode).change();

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function () {
                        if (!validate())
                            return;

                        $.get('/adminAdd/sensorType/add', getSerialize('#lay-form-write'), function (res) {
                            alert('저장되었습니다.', function () {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });
                    });
                });

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

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function () {
                        if (!validate())
                            return;

                        $.get('/adminAdd/sensorType/mod', getSerialize('#lay-form-write'), function (res) {
                            alert('저장되었습니다.', function () {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });
                    });
                });



                $.get('/adminAdd/common/code/getSiteInfo', null, function (res) {
                    let option = '';  // 기본 선택 옵션 추가
                    $.each(res, function (idx) {

                        if (idx === 0) {
                            firstCode = res[idx].code;
                        }

                        option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                    });
                    $('#site_no').html(option);


                });

                $('.excelBtn').on('click', function () {
                    downloadExcel('센서 타입관리');
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
                        url: "/adminAdd/sensorType/upload",
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function(response) {
                            alert(response);
                        },
                        error: function(response) {
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
                        <h3 class="txt">센서 타입 관리</h3>
                        <div class="btn-group">
                            <input class="search_input" type="text" id="search" name="search" placeholder="센서타입명 / 약어 "/>
                            <a class="searchBtn">검색</a>

<%--                            <a class="insertBtn">등록</a>--%>
<%--                            <a class="modifyBtn">수정</a>--%>
                            <a class="insertBtn">신규 등록</a>
                            <a class="modifyBtn">상세정보</a>
<%--                            <a class="deleteBtn">삭제</a>--%>

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

            <!--[s] 센서 타입 등록 팝업 -->
            <div id="lay-form-write" class="layer-base">

<%--            	<input type="hidden" id="senstype_no" name="senstype_no"/>--%>

                <div class="layer-base-btns">
                    <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
                </div>
                <div class="layer-base-title">센서 타입 <span id="form_sub_title">등록/수정</span></div>
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
                                    <th>센서 타입 ID</th>
                                    <td colspan="3">
                                        <input type="text" id="senstype_no" name="senstype_no" readonly/>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="required_th">센서 타입명</th>
                                    <td colspan="3">
                                        <input type="text" name="sens_tp_nm" class="required"/>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="required_th">로거 구분</th>
                                    <td colspan="3">
                                        <select id="logr_flag" name="logr_flag" class="required">
                                            <option value="">선택</option>
                                        </select>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="required_th">센서약어</th>
                                    <td colspan="3">
                                        <input type="text" name="sens_abbr" class="required"/>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="required_th">관리기관</th>
                                    <td colspan="3">
                                        <select id="site_no" name="site_no">
                                            <option value="">선택</option>
                                        </select>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="required_th">보정식</th>
                                    <td colspan="3">
                                        <input type="text" name="basic_formul"  class="required"/>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="required_th">채널수</th>
                                    <td colspan="3">
                                        <input type="text" name="sens_chnl_cnt"  class="required"/>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="required_th">로거_idx_S</th>
                                    <td>
                                        <input type="text" name="logr_idx_str"  class="logr_idx"/>
                                    </td>
                                    <th class="required_th">로거_idx_E</th>
                                    <td>
                                        <input type="text" name="logr_idx_end"  class="logr_idx"/>
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
            <!--[e] 센서 타입 등록 팝업 -->
        </section>
    </body>
</html>
