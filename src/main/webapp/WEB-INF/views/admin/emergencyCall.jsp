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

				$.get('/common/code/areaList', null, function(res) {
					let option = '<option value="">선택</option>';
					$.each(res, function(idx) {
						option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
					});
					$('#area_id').html(option);
				});

                // 삭제
                $('.deleteBtn').on('click', function() {
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 0) {
                        confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function() {
                            $.each(targetArr, function(idx) {
                                $.get('/admin/emergencyCall/del', this, function(res) {
                                    // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?
                                
                                    if( (idx+1)== targetArr.length ) reloadJqGrid();
                                });
                            });

//                             reloadJqGrid();
                        });
                    } else {
                        alert('삭제하실 데이터를 선택해주세요.');
                        return;
                    }
                });

                // 등록
                $('.insertBtn').on('click', function() {
                	
					$("#form_sub_title").html('등록');
					
                	initForm();
                	
//                     setSerialize('#lay-form-write', _popupClearData);           
                    
                    popFancy('#lay-form-write');

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function() {
                        if (!validate()) return;
    
							$.get('/admin/emergencyCall/add', getSerialize('#lay-form-write'), function(res) {
								// todo : true가 아닌 경우 실패된것을 알릴것인지?
								alert('저장되었습니다.', function() {
									popFancyClose('#lay-form-write');
								});
								reloadJqGrid();
							});    
                        
//                         reloadJqGrid();
                    });
                });

                // 수정 팝업
                $('.modifyBtn').on('click', function() {
                	
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

                    setSerialize('#lay-form-write', targetArr[0]);     // 선택값 세팅                  

                    popFancy('#lay-form-write');

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function() {                        
                        if (!validate()) return;
    
                        $.get('/admin/emergencyCall/mod', getSerialize('#lay-form-write'), function(res) {
                            // todo : true가 아닌 경우 실패된것을 알릴것인지?
                            alert('저장되었습니다.', function() {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });
                        
//                         reloadJqGrid();
                        
                    });
                });

                $('.excelBtn').on('click', function() {
                    downloadExcel('비상연락망');
                });
            });

            function initForm(){
            	$('#lay-form-write select[name=area_id_hid]').val('');
            	$('#lay-form-write input[name=role]').val('');
            	$('#lay-form-write input[name=company_name]').val('');
            	$('#lay-form-write input[name=name]').val('');
            	$('#lay-form-write input[name=tel1]').val('');
            	$('#lay-form-write input[name=email]').val('');
            	$('#lay-form-write input[name=etc1]').val('');
            }
            
            function validate() {
                if ($('#lay-form-write select[name=area_id_hid]').val() == '') {
                    $('#lay-form-write select[name=area_id_hid]').focus();
                    alert('현장명을 선택해주세요.');
                    return false;
                }
                if ($('#lay-form-write input[name=name]').val().trim() == '') {
                    $('#lay-form-write input[name=name]').focus();                        
                    alert('이름을 입력해주세요.');
                    return false;
                }
                
                return true;
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
	                        <h3 class="txt">비상연락망</h3>
	                        <div class="btn-group">
	                            <a class="insertBtn">등록</a>
	                            <a class="modifyBtn">수정</a>
	                            <a class="deleteBtn">삭제</a>
	                            <a class="excelBtn">다운로드</a>
	                        </div>
	                        <div class="contents-in">
	                            <jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>
	                        </div>
	                    </div>
	                </div>
				</div>
			<!--[e] 컨텐츠 영역 -->
			
			<!--[s] 사용자 등록 팝업 -->
			<div id="lay-form-write" class="layer-base">
			
				<input type="hidden" id="emergency_call_id" name="emergency_call_id"/>
			
				<div class="layer-base-btns">
					<a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
				</div>
				<div class="layer-base-title">비상연락망 <span id="form_sub_title">등록/수정</span></div>
				<div class="layer-base-conts">
					<div class="bTable">
						<table>
							<colgroup>
								<col width="130" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th>현장명</th>
									<td>
										<select id="area_id" name="area_id_hid">
											<option value="">선택</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>역할</th>
									<td><input type="text" name="role"/></td>
								</tr>
								<tr>
									<th>소속</th>
									<td><input type="text" name="company_name"/></td>
								</tr>
								<tr>
									<th>이름</th>
									<td><input type="text" name="name"/></td>
								</tr>
								<tr>
									<th>사용자 연락처</th>
									<td><input type="text" name="tel1"/></td>
								</tr>
								<tr>
									<th>이메일</th>
									<td><input type="text" name="email"/></td>
								</tr>
								<tr>
									<th>기타1</th>
									<td><input type="text" name="etc1"/></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn-btm">
						<input type="submit" blue value="확인" />
						<button type="button" data-fancybox-close>취소</button>
					</div>
				</div>
			</div>
			<!--[e] 사용자 등록 팝업 -->
		</section>
	</body>
</html>
