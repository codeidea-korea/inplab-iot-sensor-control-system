<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>

        <style></style>

        <script>
            window.jqgridOption = {
                multiselect: true,
                multiboxonly: false
            }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

            var _popupClearData;

            $(function () {
                _popupClearData = getSerialize('#lay-form-write');
                // 초기화할 데이터값

                // 삭제
                $('.deleteBtn').on('click', function () {
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 0) {
                        confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function () {
                            $.each(targetArr, function (idx) {
                                $.get('/admin/assetKind/del', this, function (res) { // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?
                                
                                    if( (idx+1)== targetArr.length ) reloadJqGrid();
                                });
                            });

//                             reloadJqGrid();
                        });
                    } else {
                        alert('삭제하실 자산종류를 선택해주세요.');
                        return;
                    }
                });

                // 등록
                $('.insertBtn').on('click', function () {
                	
                	$("#form_sub_title").html('등록');
                	
                    setSerialize('#lay-form-write', _popupClearData);

                    popFancy('#lay-form-write');

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function () {
                        if (!validate()) 
                            return;

                        $.get('/admin/assetKind/add', getSerialize('#lay-form-write'), function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
                            alert('저장되었습니다.', function () {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });
                    });
                });

                // 수정 팝업
                $('.modifyBtn').on('click', function () {
                	
                	$("#form_sub_title").html('수정');
                	
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 1) {
                        alert('수정 할 데이터를 1건만 선택해주세요.');
                        return;
                    } else if (targetArr.length == 0) {
                        alert('수정할 데이터를 선택해주세요.');
                        return;
                    }

                    setSerialize('#lay-form-write', targetArr[0]); // 선택값 세팅

                    popFancy('#lay-form-write');

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function () {
                        if (!validate()) 
                            return;                        

                        $.get('/admin/assetKind/mod', getSerialize('#lay-form-write'), function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
                            alert('저장되었습니다.', function () {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });
                    });
                });

                $('.excelBtn').on('click', function () {
                    downloadExcel('자산종류');
                });
            });

            function validate() {
                if ($('#lay-form-write input[name=name]').val().trim() == '') {
                    $('#lay-form-write input[name=name]').focus();
                    alert('자산종류명을 입력해주세요.');
                    return false;
                }

                return true;
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
                    <span class="arr">자산 관리</span>
                </h2>
                <!-- <div class="search-top">
                                    <select name="">
                                        <option value="">금일</option>
                                        <option value="">일주일</option>
                                        <option value="">1개월</option>
                                    </select>
                                    <input type="text" id="" name="" value="" placeholder="2023-11-18  to  2023-11-18" datetimepicker="" class="flatpickr-input" readonly="readonly" />
                                    <a href="javascript:void(0);" class="btns">조회</a>
                                </div> -->

                <div id="contents">
                    <div class="contents-re">
                        <h3 class="txt">자산 종류</h3>
                        <div class="btn-group">
                            <%--<a class="insertBtn">등록</a> --%>
                            <a class="modifyBtn">수정</a>
                            <%--<a class="deleteBtn">삭제</a>--%>
                            <a class="excelBtn">다운로드</a>
                        </div>
                        <div class="contents-in">
                            <jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>
                        </div>
                    </div>
                </div>
            </div>
            <!--[e] 컨텐츠 영역 -->

            <!--[s] 자산 등록 팝업 -->
            <div id="lay-form-write" class="layer-base">
            
            	<input type="hidden" id="asset_kind_id" name="asset_kind_id"/>
            
                <div class="layer-base-btns">
                    <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
                </div>
                <div class="layer-base-title">자산 <span id="form_sub_title">등록/수정</span></div>
                <div class="layer-base-conts">
                    <div class="bTable">
                        <table>
                            <colgroup>
                                <col width="130"/>
                                <col width="*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>자산종류명</th>
                                    <td>
                                        <input type="text" name="name"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>자산종류설명</th>
                                    <td>
                                        <textarea name="description"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <th>기타1</th>
                                    <td>
                                        <input type="text" name="etc1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>기타2</th>
                                    <td>
                                        <input type="text" name="etc2"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>기타3</th>
                                    <td>
                                        <input type="text" name="etc3"/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="btn-btm">
                        <input type="submit" blue value="저장"/>
                        <button type="button" data-fancybox-close>취소</button>
                    </div>
                </div>
            </div>
            <!--[e] 자산 등록 팝업 -->

            <!--[s] 안내 팝업 -->

            <!--[e] 안내 팝업 -->

            <!--[s] EDIT MODE 팝업 -->
<!--                 <div id="lay-edit-mode" class="layer-alarm"> <div class="layer-alarm-btns"> -->
<!--                     <a href="javascript:popFancyClose();"><img src="/images/btn_lay_close.png" alt="닫기"/></a> -->
<!--                 </div> -->
<!--                 <div class="layer-alarm-conts"> -->
<!--                     <p class="tit">자산 위치관리</p> -->
<!--                     <p class="txt"> -->
<!--                         <strong point>EDIT MODE</strong>로 변환 하시겠습니까?</p> -->
<!--                     <p class="btn"> -->
<!--                         <a href="javascript:popFancyClose();">아니오</a> -->
<!--                         <a href="javascript:editMode('open');" blue>예</a> -->
<!--                     </p> -->
<!--                 </div> -->
<!--             </div> -->
            <!--[e] EDIT MODE 팝업 -->

            <!--[s] EDIT MODE 사용중 -->
<!--             <div class="edit-mode-use"> -->
<!--                 <p class="tit">Edit Mode를 사용중입니다.</p> -->
<!--                 <p class="btn"> -->
<!--                     <a href="javascript:editMode('close');" blue>저장</a> -->
<!--                     <a href="javascript:editMode('close');">취소</a> -->
<!--                 </p> -->
<!--             </div> -->
            <!--[e] EDIT MODE 사용중 -->
        </section>
    </body>
</html>
