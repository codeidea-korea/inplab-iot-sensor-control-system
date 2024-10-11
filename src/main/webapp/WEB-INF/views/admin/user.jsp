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

        //             var _popupClearData;

        $(function () {
//                 _popupClearData = getSerialize('#lay-form-write');       // 초기화할 데이터값

            $.get('/common/code/list', {category: "사용자구분"}, function (res) {
                let option = '<option value="">선택</option>';
                $.each(res, function (idx) {
                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#grade').html(option);
            });

            // 삭제
            $('.deleteBtn').on('click', function () {
                var targetArr = getSelectedCheckData();

                if (targetArr.length > 0) {
                    confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function () {
                        $.each(targetArr, function (idx) {
                            $.get('/admin/user/del', this, function (res) {
                                // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?

                                if ((idx + 1) == targetArr.length) reloadJqGrid();
                            });
                        });

//                             reloadJqGrid();
                    });
                } else {
                    alert('삭제하실 사용자를 선택해주세요.');
                    return;
                }
            });

            // 등록
            $('.insertBtn').on('click', function () {

                $("#form_sub_title").html('등록');

                initForm();

//                     setSerialize('#lay-form-write', _popupClearData);           

                popFancy('#lay-form-write');

                // 저장버튼 클릭시
                $('#lay-form-write input[type=submit]').off().on('click', function () {
                    if (!validate()) return;

                    $.get('/admin/user/isExists', getSerialize('#lay-form-write'), function (res) {
//                             // todo : true가 아닌 경우 실패된것을 알릴것인지?
                        console.log(res);
                        if (res < 1) {
                            $.get('/admin/user/add', getSerialize('#lay-form-write'), function (res) {
                                // todo : true가 아닌 경우 실패된것을 알릴것인지?
                                alert('저장되었습니다.', function () {
                                    popFancyClose('#lay-form-write');
                                });
                                reloadJqGrid();
                            });
                        } else {
                            alert('등록 할 수 없는 id입니다.');
                        }
                    });

//                         reloadJqGrid();
                });
            });

            // 수정 팝업
            $('.modifyBtn').on('click', function () {

                $("#form_sub_title").html('수정');

                initForm();

                $("#user_id").attr("readonly", true);
                $('#lay-form-write input[name=password]').attr("placeholder", "비밀번호 변경 시 입력하세요");

                // $("#user_id").css("border","none");
                // $("#user_id").focus(function(){
                // 	$("#user_id").css("outline","none");
                // });

                var targetArr = getSelectedCheckData();

                if (targetArr.length > 1) {
                    alert('수정 할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length == 0) {
                    alert('수정할 데이터를 선택해주세요.');
                    return;
                }

                setSerialize('#lay-form-write', targetArr[0]);     // 선택값 세팅

                popFancy('#lay-form-write');

                // 저장버튼 클릭시
                $('#lay-form-write input[type=submit]').off().on('click', function () {
                    if (!validate()) return;

                    $.get('/admin/user/mod', getSerialize('#lay-form-write'), function (res) {
                        // todo : true가 아닌 경우 실패된것을 알릴것인지?
                        alert('저장되었습니다.', function () {
                            popFancyClose('#lay-form-write');
                        });
                        reloadJqGrid();
                    });

//                         reloadJqGrid();

                });
            });

            $('.excelBtn').on('click', function () {
                downloadExcel('사용자');
            });
        });

        function initForm() {
            $('#lay-form-write input[name=user_id]').val('');
            $('#lay-form-write input[name=name]').val('');
            $('#lay-form-write input[name=company_name]').val('');
            $('#lay-form-write input[name=email]').val('');
            $('#lay-form-write input[name=password]').val('');
            $('#lay-form-write input[name=phone]').val('');
            $('#lay-form-write select[name=grade_hid]').val('');
            $('#lay-form-write input[name=part]').val('');
            $('#lay-form-write input[name=etc1]').val('');
            $('#lay-form-write select[name=use_flag]').val('Y');

            $('#lay-form-write input[name=password]').removeAttr('placeholder');
            $("#user_id").attr("readonly", false);
            $("#user_id").removeAttr("style");
        }

        function validate() {

            if ($('#lay-form-write input[name=user_id]').val().trim() == '') {
                $('#lay-form-write input[name=user_id]').focus();
                alert('사용자 ID를 입력해주세요.');
                return false;
            }

            if ($('#lay-form-write input[name=name]').val().trim() == '') {
                $('#lay-form-write input[name=name]').focus();
                alert('사용자명을 입력해주세요.');
                return false;
            }

            if ($("#form_sub_title").html() === '등록') {
                if ($('#lay-form-write input[name=password]').val().trim() == '') {
                    $('#lay-form-write input[name=password]').focus();
                    alert('사용자 비밀번호를 입력해주세요.');
                    return false;
                }
            }

            if ($('#lay-form-write select[name=grade_hid]').val().trim() == '') {
                $('#lay-form-write select[name=grade_hid]').focus();
                alert('사용자구분을 선택해주세요.');
                return false;
            }

            return true;
        }
    </script>

</head>

<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"></jsp:include>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"></jsp:include>
    </div>
    <div id="container">
        <h2 class="txt">
            관리자 전용
            <span class="arr">관리자</span>
        </h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">사용자 관리</h3>
                <div class="btn-group">
                    <a class="insertBtn">등록</a>
                    <a class="modifyBtn">수정</a>
                    <a class="deleteBtn">삭제</a>
                    <a class="excelBtn">다운로드</a>
                </div>
                <div class="contents-in">
                    <jsp:include page="../common/include_jqgrid_old.jsp" flush="true"></jsp:include>
                </div>
            </div>
        </div>
    </div>

    <!--[s] 사용자 등록 팝업 -->
    <div id="lay-form-write" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">사용자 <span id="form_sub_title">등록/수정</span></div>
        <div class="layer-base-conts">
            <!-- 					<div class="layer-base-tit">사용자 정보 입력</div> -->
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>사용자 ID</th>
                        <td><input type="text" id="user_id" name="user_id"/></td>
                    </tr>
                    <tr>
                        <th>사용자 명</th>
                        <td><input type="text" name="name"/></td>
                    </tr>
                    <tr>
                        <th>소속</th>
                        <td><input type="text" name="company_name"/></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td><input type="text" name="email"/></td>
                    </tr>
                    <tr>
                        <th>사용자 비밀번호</th>
                        <td><input type="text" name="password"/></td>
                    </tr>
                    <tr>
                        <th>사용자 연락처</th>
                        <td><input type="text" name="phone"/></td>
                    </tr>
                    <tr>
                        <th>사용자구분</th>
                        <td>
                            <select id="grade" name="grade_hid">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>역할</th>
                        <td><input type="text" name="part"/></td>
                    </tr>
                    <tr>
                        <th>기타1</th>
                        <td><input type="text" name="etc1"/></td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <input type="submit" blue value="확인"/>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>
    <!--[e] 사용자 등록 팝업 -->
</section>
</body>
</html>
