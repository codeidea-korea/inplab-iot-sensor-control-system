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
            	
				// $.get('/common/code/list', {category: "위험레벨"}, function(res) {
				// 	let option = '<option value="">선택</option>';
				// 	$.each(res, function(idx) {
				// 		option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
				// 	});
				// 	$('#risk_level').html(option);
				// });
				
				$.get('/common/code/list', {category: "알람카테고리"}, function(res) {
					let option = '<option value="">선택</option>';
					$.each(res, function(idx) {
						option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
					});
					$('#category').html(option);
				});   
				
				// $.get('/common/code/list', {category: "알람종류"}, function(res) {
				// 	let option = '<option value="">선택</option>';
				// 	$.each(res, function(idx) {
				// 		option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
				// 	});
				// 	$('#type').html(option);
				// });
				
				
				$.get('/common/code/assetKindList', null, function(res) {
					let option = '<option value="">선택</option>';
					$.each(res, function(idx) {
						option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
					});
					$('#asset_kind_id').html(option);
				});  
            	
                _popupClearData = getSerialize('#lay-form-write');
                // 초기화할 데이터값

                // 수정 팝업
                $('.modifyBtn').on('click', function () {
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 1) {
                        alert('수정 할 데이터를 1건만 선택해주세요.');
                        return;
                    } else if (targetArr.length == 0) {
                        alert('수정할 데이터를 선택해주세요.');
                        return;
                    }

                    console.log( targetArr[0] );
                    
                    setSerialize('#lay-form-write', targetArr[0]); // 선택값 세팅

                    popFancy('#lay-form-write');

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function () {
                        if (!validate()) 
                            return;                        

                        $.get('/admin/alarmSetting/mod', getSerialize('#lay-form-write'), function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
                            alert('저장되었습니다.', function () {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });
                    });
                });

                $('.excelBtn').on('click', function () {
                    downloadExcel('알람설정');
                });
            });

            function validate() {
                if ($('#lay-form-write input[name=name]').val().trim() == '') {
                    $('#lay-form-write input[name=name]').focus();
                    alert('알람 종류 이름을 입력해주세요.');
                    return false;
                }
                
                // if ($('#lay-form-write select[name=risk_level_hid]').val().trim() == '') {
                //     $('#lay-form-write select[name=risk_level_hid]').focus();
                //     alert('알람 위험 레벨을 선택해주세요.');
                //     return false;
                // }
                
                // if ($('#lay-form-write select[name=category_hid]').val().trim() == '') {
                //     $('#lay-form-write select[name=category_hid]').focus();
                //     alert('카테고리를 선택해주세요.');
                //     return false;
                // }
                
                // if ($('#lay-form-write select[name=type_hid]').val().trim() == '') {
                //     $('#lay-form-write select[name=type_hid]').focus();
                //     alert('알람종류타입을 선택해주세요.');
                //     return false;
                // }
                
                if ($('#lay-form-write select[name=asset_kind_id_hid]').val().trim() == '') {
                    $('#lay-form-write select[name=asset_kind_id_hid]').focus();
                    alert('자산 종류를 선택해주세요.');
                    return false;
                }

                if ($('#lay-form-write select[name=use_flag]').val().trim() == '') {
                    $('#lay-form-write select[name=use_flag]').focus();
                    alert('사용 여부를 선택해주세요.');
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
                    <span class="arr">알람 관리</span>
                </h2>

                <div id="contents">
                    <div class="contents-re">
                        <h3 class="txt">알람 설정</h3>
                        <div class="btn-group">
                            <a class="modifyBtn">수정</a>
                            <a class="excelBtn">다운로드</a>
                        </div>
                        <div class="contents-in">
<%--                            <jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>--%>
                            <jsp:include page="../common/include_jqgrid_old.jsp" flush="true"></jsp:include>
                        </div>
                    </div>
                </div>
            </div>
            <!--[e] 컨텐츠 영역 -->

			<!--[s] 알람 설정 수정 팝업 -->
			<div id="lay-form-write" class="layer-base">
			
				<input type="hidden" name="alarm_kind_id"/>
			
				<div class="layer-base-btns">
					<a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
				</div>
				<div class="layer-base-title">알람 설정 수정</div>
				<div class="layer-base-conts">
					<div class="bTable">
						<table>
							<colgroup>
								<col width="130" />
								<col width="*" />
							</colgroup>
							<tbody>
<%--								<tr>--%>
<%--									<th>알람 위험 레벨</th>--%>
<%--									<td>--%>
<%--										<select id="risk_level" name="risk_level_hid">--%>
<%--											<option value="">선택</option>--%>
<%--										</select>--%>
<%--									</td>--%>
<%--								</tr>--%>
								<!-- <tr>
									<th>카테고리</th>
									<td>
										<select id="category" name="category_hid">
											<option value="">선택</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>알람 종류 타입</th>
									<td>
										<select id="type" name="type_hid">
											<option value="">선택</option>
										</select>
									</td>
								</tr> -->
								<tr>
									<th>알람 종류 설명</th>
									<td><input type="text" name="description"/></td>
								</tr>
								<tr>
									<th>자산 종류</th>
<!-- 									<td><input type="text" name="asset_kind_id"/></td> -->
									<td>
										<select id="asset_kind_id" name="asset_kind_id_hid">
											<option value="">선택</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>사용 여부</th>
									<td>
										<select name="use_flag">
											<option value="">선택</option>
											<option value="Y">Y</option>
											<option value="N">N</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>알람 종류 이름</th>
									<td><input type="text" name="name"/></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn-btm">
						<input type="submit" blue value="저장" />
						<button type="button" data-fancybox-close>취소</button>
					</div>
				</div>
			</div>
			<!--[e] 알람 설정 수정 팝업 -->

        </section>
    </body>
</html>
