<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>

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

        window.jqgridOption = {
            columnAutoWidth: true,
            // filterToolbarCheck: true,
            multiselect: true,
            multiboxonly: false
        }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

        //             var _popupClearData;
        let firstCode = '';
        $(function () {
            window.vworld = new vwutil({
                mapId: "map",
                initPosition: {
                    center: [
                        // 126.88624657982738, 37.480957215573261
                        127.449482276989, 36.9317789946793
                    ],
                    zoom: 18,
                    rotation: 0.5
                }
            });

            window.vworld.vwmap2d();

            $(window).on('gridComplete', function(){
                var allRowData = $(".jqGrid").jqGrid("getRowData");
                var isInitialLoad = !$(".jqGrid").jqGrid("getGridParam", "postData")._search;  // 검색이 활성화되었는지 확인
                if (allRowData.length > 0) {
                    $('.modifyBtn').show();
                    $('.insertBtn').hide();
                } else {
                    if (isInitialLoad) {
                        $('.insertBtn').show();
                    } else {
                        $('.insertBtn').hide();
                    }
                    $('.modifyBtn').hide();
                }
            });

            $("#site_logo").on("change", function (event) {
                var file = event.target.files[0];
                $('#lay-form-write input[name=site_logo_nm]').val(file.name);
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#uploadFileImg').css("cursor", "");
                    $('#uploadFileImg').off('click');

                    $("#uploadFileImg").attr("src", e.target.result);
                }
                reader.readAsDataURL(file);
            });


            $("#site_title_logo").on("change", function (event) {
                var file = event.target.files[0];
                $('#lay-form-write input[name=site_title_logo_nm]').val(file.name);
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#uploadFileImg2').css("cursor", "");
                    $('#uploadFileImg2').off('click');

                    $("#uploadFileImg2").attr("src", e.target.result);
                }
                reader.readAsDataURL(file);
            });

            // 등록
            // $('.insertBtn').on('click', function () {
            //
            // 	$("#form_sub_title").html('등록');
            //
            // 	initForm();
            //
            // 	$('#uploadFileImg').css("cursor","");
            // 	$('#uploadFileImg').off('click');
            //
            //     popFancy('#lay-form-write');
            //      $('#site_no').val(firstCode).change();
            //     // 저장버튼 클릭시
            //     $('#lay-form-write input[type=submit]').off().on('click', function () {
            //         if(!validate()) return;
            //
            // 		const form = $('#lay-form-write')[0]; // 폼 요소 선택
            // 		const formData = new FormData(form); // FormData 객체 생성
            //
            // 		$.ajax({
            // 			url: '/adminAdd/siteInfo/add',
            // 			type: 'POST',
            // 			data: formData,
            // 			contentType: false, // 서버에 전송되는 데이터의 타입을 기본 설정으로 둠
            // 			processData: false, // 데이터의 처리 방법 설정 (false로 해야 파일을 처리할 수 있음)
            // 			success: function(res) {
            // 				alert('저장되었습니다.', function() {
            // 					popFancyClose('#lay-form-write');
            // 				});
            // 				reloadJqGrid();
            // 			},
            // 			error: function(err) {
            // 				alert('파일 업로드에 실패했습니다.');
            // 			}
            // 		});
            // 	});
            // });

            // 수정 팝업
            $('.modifyBtn').on('click', function () {

                $("#form_sub_title").html('상세정보');
                $('input[type="submit"]').val('수정');
                initForm();

                var targetArr = getSelectedCheckData();

                if (targetArr.length > 1) {
                    alert('수정 할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length == 0) {
                    alert('수정할 데이터를 선택해주세요.');
                    return;
                }

                $("#uploadFileImg").attr("src", "data:image/jpeg;base64," + targetArr[0].site_logo_src);
                $("#uploadFileImg2").attr("src", "data:image/jpeg;base64," + targetArr[0].site_title_logo_src);

                targetArr[0].site_logo = '';
                targetArr[0].site_title_logo = '';

                setSerialize('#lay-form-write', targetArr[0]); // 선택값 세팅

                popFancy('#lay-form-write');

                // 저장버튼 클릭시
                $('#lay-form-write input[type=submit]').off().on('click', function () {
                    if (!validate()) return;
                    $('#site_no').prop('disabled', false);
                    const form = $('#lay-form-write')[0]; // 폼 요소 선택
                    const formData = new FormData(form); // FormData 객체 생성

                    $.ajax({
                        url: '/adminAdd/siteInfo/mod',
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

            $.get('/adminAdd/common/code/getSiteInfo', null, function (res) {
                let option = '';
                $.each(res, function (idx) {

                    if (idx === 0) {
                        firstCode = res[idx].code;
                    }

                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#site_no').html(option);
            });

            // $('.excelBtn').on('click', function () {
            //     downloadExcel('기관관리');
            // });
        });

        function initForm() {
            $('#lay-form-write input[name=site_nm]').val('');
            $('#lay-form-write input[name=site_zip]').val('');
            $('#lay-form-write input[name=site_addr]').val('');
            $('#lay-form-write input[name=site_road_addr]').val('');
            $('#lay-form-write input[name=site_sys_nm]').val('');

            $("#site_logo").attr("src", '');
            $('#lay-form-write input[name=site_logo]').val('');
            $("#site_title_logo").attr("src", '');
            $('#lay-form-write input[name=site_title_logo]').val('');
        }

    </script>
</head>

<body data-pgcode="0000">
<section id="wrap">
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
                <h3 class="txt">기관 정보 관리</h3>
                <div class="btn-group">
                    <%--                            <a class="insertBtn" style="display:none;">신규 등록</a>--%>
                    <a class="modifyBtn" style="display:none;">상세정보</a>
                    <%--<a class="deleteBtn">삭제</a>--%>
                    <%--<a class="excelBtn">다운로드</a>--%>
                </div>
                <div class="contents-in">
                    <jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>
<%--                    <jsp:include page="../common/include_slickgrid.jsp" flush="true"></jsp:include>--%>
                </div>
            </div>
        </div>
    </div>
    <!--[e] 컨텐츠 영역 -->

    <!--[s] 유지보수 등록 팝업 -->
    <form id="lay-form-write" class="layer-base" style="width:900px">

        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">기관 정보 <span id="form_sub_title">등록/수정</span></div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                        <col width="*"/>
                        <%--                        <col width="300"/>--%>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th class="required_th">사이트 ID</th>
                        <td><input type="text" id="site_no" name="site_no" value="" placeholder="" readonly/></td>
<%--                        <td>--%>
<%--                            <select id="site_no" name="site_no" disabled>--%>
<%--                                <option value="">선택</option>--%>
<%--                            </select>--%>
<%--                        </td>--%>
                    </tr>
                    <tr>
                        <th class="required_th">관리 기관명</th>
                        <td><input type="text" id="site_nm" name="site_nm" value="" class="required" placeholder=""/>
                        </td>
                    </tr>


                    <tr>
                        <th class="required_th" style="vertical-align: middle;">우편번호</th>
                        <td colspan="2" style="display: flex; align-items: center;">
                            <input type="text" name="site_zip" class="required" readonly
                                   style="flex: 1; margin-right: 10px;"/>
                            <div class="btn-btm" style="width: auto; margin-top: 0px;">
                                <button type="button" id="addrSearchBtn" style="margin-left: 10px; padding: 5px 10px;"
                                        onclick="openDaumPostcode('site_zip', 'site_addr', 'site_road_addr')">주소 검색
                                </button>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">주소</th>
                        <td><input type="text" name="site_addr" class="required" readonly/></td>
                    </tr>
                    <tr>
                        <th class="required_th">도로명주소</th>
                        <td><input type="text" name="site_road_addr" class="required" readonly/></td>
                    </tr>


                    <tr>
                        <th class="required_th">시스템명칭</th>
                        <td><input type="text" id="site_sys_nm" name="site_sys_nm" value="" class="required"
                                   placeholder=""/>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">지자체로고</th>
                        <td colspan="2" style="display: flex; align-items: center;">
                            <input type="file" id="site_logo" name="site_logo" class="file1" accept="image/*" style="display:none;" />
                            <input type="text" id="site_logo_nm" name="site_logo_nm" class="required" readonly style="flex: 1; margin-right: 10px;"/>
                            <div class="btn-btm" style="width: auto; margin-top: 0px;">
                                <button type="button" class="btn-search" onclick="$('#site_logo').click()">파일 선택</button>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">지자체 타이틀 로고</th>
                        <td colspan="2" style="display: flex; align-items: center;">
                            <input type="file" id="site_title_logo" name="site_title_logo" class="file2" accept="image/*" style="display:none;" />
                            <input type="text" id="site_title_logo_nm" name="site_title_logo_nm" class="required" readonly style="flex: 1; margin-right: 10px;"/>
                            <div class="btn-btm" style="width: auto; margin-top: 0px;">
                                <button type="button" class="btn-search" onclick="$('#site_title_logo').click()">파일 선택</button>
                            </div>
                            <div style="margin-left: 10px">권장 사이즈 460 x 310</div>
                        </td>
                    </tr>

<%--                    <tr>--%>
<%--                        <th>지자체로고 사진</th>--%>
<%--                        <td style="height:250px">--%>
<%--                            <img id="uploadFileImg" src="" alt="" style="width:300px">--%>
<%--                        </td>--%>
<%--                    </tr>--%>

<%--                    <tr>--%>
<%--                        <th>지자체 타이틀 로고 사진</th>--%>
<%--                        <td style="height:250px">--%>
<%--                            <img id="uploadFileImg2" src="" alt="" style="width:300px">--%>
<%--                        </td>--%>
<%--                    </tr>--%>

                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <input type="submit" blue value="저장"/>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </form>
    <!--[e] 유지보수 등록 팝업 -->

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
