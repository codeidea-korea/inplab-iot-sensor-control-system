<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>

        <style>
			.layer-base input[type=radio], .layer-base input[type=checkbox] {
				margin: 5px 5px 5px 15px;
				position: relative;
				top: 2px;
				font-size: 12px;
				-webkit-appearance: auto;
				width: 16px;
				height: 16px;
				color: #222;
			}
		</style>

        <script>
            window.jqgridOption = {
                multiselect: true,
                multiboxonly: false
            }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

            $(function () {
                // $.get('/common/code/list', {category: "임계치알람"}, function(res) {
                //     let option = '<option value="">선택</option>';
                //     $.each(res, function(idx) {
                //         option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
                //     });
                //     $('#threshold').html(option);
                // });


                // 삭제
                $('.deleteBtn').on('click', function () {
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 0) {
                        confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function () {
                            $.each(targetArr, function (idx) {
                                $.get('/smsAlarm/del', this, function (res) { // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?                                
                                	if( (idx+1)== targetArr.length ) reloadJqGrid();                                
                                });
                            });
                        });
                    } else {
                        alert('삭제하실 데이터를 선택해주세요.');
                        return;
                    }
                });

				// 등록
				$('.insertBtn').on('click', function () {                	
					$("#form_sub_title").html('등록');
					
                	initForm();

                    popFancy('#lay-form-write');

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function () {
	                    if(!validate()) return;
	                    
						let param = getSerialize('#lay-form-write');
						param.auto_send_flag = $('input[name=auto_send]').is(':checked') ? 'ON' : 'OFF';
						// param.filter_flag = $('input[name=filter]').val();

                        $.get('/smsAlarm/add', param, function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
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
                	
                	initForm();
                	
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 1) {
                        alert('수정 할 데이터를 1건만 선택해주세요.');
                        return;
                    } else if (targetArr.length == 0) {
                        alert('수정할 데이터를 선택해주세요.');
                        return;
                    }
                    
                    setSerialize('#lay-form-write', targetArr[0]); // 선택값 세팅

                    console.log(targetArr[0])

                    //20231229 checkbox 관련 추가
                    // $('#lay-form-write input[name=filter][value="' + targetArr[0].filter_flag + '"]').prop('checked', 'true');
                    $('#lay-form-write input[name=auto_send]').prop('checked', targetArr[0].auto_send_flag == 'ON');


                    popFancy('#lay-form-write');

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function () {
                        if (!validate()) return;                        

						let param = getSerialize('#lay-form-write');
						param.auto_send_flag = $('input[name=auto_send]').is(':checked') ? 'ON' : 'OFF';
						// param.filter_flag = $('input[name=filter]:checked').val(); //20231229 :checked 추가

                        param.id = getSelectedData().id;

                        //수정
                        $.get('/smsAlarm/mod', param, function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
                            alert('저장되었습니다.', function () {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });
                    });
                });

                // 보내기
                $('.sendBtn').on('click', function (e) {
                    popFancy('#lay-form-send', { dragToClose : false, touch : false });

                    $.get('/smsAlarm/columns' , function (res) {

                        const $gridSmsAlarm = jqgridUtil($('.gridSmsAlarm'), {
                            listPathUrl: "/admin/smsAlarmList"
                        }, res, true, null, null);

                        $gridSmsAlarm.jqGrid('setGridParam', {
                            beforeRequest: function() {
                                let currentParams = {
                                    listPathUrl: "/smsAlarm/list"
                                };

                                let p = Object.assign($gridSmsAlarm.jqGrid('getGridParam', 'postData'), $('.ui-search-input input').filter(function () {
                                    return !!this.value;
                                }).serializeObject());

                                $gridSmsAlarm.setGridParam({
                                    postData: Object.assign(p, currentParams)
                                });
                            }
                        });
                        $gridSmsAlarm.trigger('reloadGrid');
                    });

                });

                // 보내기 추가
                $('#lay-form-send > div.layer-base-conts > div.mem-form div.btn-btm button.add-user').on('click', function () {
                    console.log("추가");
                    const $grid = $('.gridSmsAlarm');
                    const $username = $('#lay-form-send div.mem-form input[name=username]');
                    const $phone = $('#lay-form-send div.mem-form input[name=phone]');
                    if ($username.val().trim() == '') {
                        $username.focus();
                        alert('이름을 입력해주세요.');
                        return false;
                    }

                    if ($phone.val().trim() == '') {
                        $phone.focus();
                        alert('휴대폰번호를 입력해주세요.');
                        return false;
                    }

                    // 새로운 데이터 객체
                    var newData = {
                        id: generateUUID(), // 고유한 행 ID
                        username: $username.val(),
                        phone: $phone.val(),
                        // 여기에 더 많은 필드를 추가할 수 있습니다.
                    };

                    $grid.jqGrid('addRowData', newData.id, newData);
                    $username.val('');
                    $phone.val('');
                });

                // 보내기 submit
                $('#lay-form-send > div.btn-btm > input[type=submit]').on('click', function () {
                    console.log('보내기');

                    const $grid = $('.gridSmsAlarm');
                    const targetArr = getSelectedCheckData($grid);
                    const sendMessage = $("#sendMessage").val();

                    console.log('targetArr', targetArr);
                    console.log('targetArr', JSON.stringify(targetArr));

                    if (targetArr.length == 0) {
                        alert('전송할 인원을 선택해주세요.');
                        return;
                    }

                    if(sendMessage.trim().length == 0){
                        alert('전송할 내용을 입력해주세요.');
                        return;
                    }

                    const data = {
                        sendList: targetArr,
                        sendMessage: sendMessage
                    }

                    $.ajax({
                        url: '/admin/smsAlarmList/send', // 요청을 보낼 서버의 URL
                        type: 'POST', // HTTP 요청 메소드
                        contentType: 'application/json', // 요청의 Content-Type 설정
                        data: JSON.stringify(data), // 전송할 데이터. 객체를 JSON 문자열로 변환
                        success: function(response) {
                            // 요청이 성공적으로 처리되었을 때 실행될 콜백 함수
                            console.log(response);
                            $("#sendMessage").val('')

                            if(response === "SUCCESS"){
                                alert('전송 요청 하였습니다.');
                            }

                        },
                        error: function(xhr, status, error) {
                            // 오류가 발생했을 때 실행될 콜백 함수
                            console.error(error);
                        },
                        complete: function(xhr, status) {
                            // 요청이 완료된 후 항상 실행될 코드
                            popFancyClose('#lay-form-send');
                        }
                    });

                });
                // $('.excelBtn').on('click', function () {
                //     downloadExcel('현장관리');
                // });
            });
            
            function initForm(){
                $('#lay-form-write select[name=threshold_id]').val('');
            	$.each($('#lay-form-write input[type=text]'), function() {
					$(this).val('');
				});

				// $('#lay-form-write input[name=filter]:eq(1)').prop('checked', 'true');
				$('#lay-form-write input[name=auto_send]').prop('checked', 'true');				
            }

            function validate() {
				if ($('#lay-form-write input[name=username]').val().trim() == '') {
					$('#lay-form-write input[name=username]').focus();
					alert('이름을 입력해주세요.');
					return false;
				}
				
				if ($('#lay-form-write input[name=phone]').val().trim() == '') {
					$('#lay-form-write input[name=phone]').focus();
					alert('휴대폰번호를 입력해주세요.');
					return false;
				}
				
				if ($('#lay-form-write select[name=threshold_id]').val().trim() == '') {
					$('#lay-form-write select[name=threshold_id]').focus();
					alert('알람 위험 레벨를 선택해주세요.');
					return false;
				}
                
                return true;
            }
        </script>
    </head>

    <body data-pgcode="0000">
        <section id="wrap">
            <!--[s] 상단 -->
            <jsp:include page="common/include_top.jsp" flush="true"></jsp:include>
            <!--[e] 상단 -->

            <!--[s] 왼쪽 메뉴 -->
            <div id="global-menu">
                <!--[s] 주 메뉴 -->
                <jsp:include page="common/include_sidebar.jsp" flush="true"></jsp:include>
                <!--[e] 주 메뉴 -->
            </div>
            <!--[e] 왼쪽 메뉴 -->

            <div id="container">
                <h2 class="txt">경보대상관리</h2>
                <div id="contents">
                    <div class="contents-re">
                        <h3 class="txt">경보대상관리</h3>
                        <div class="btn-group">
                            <a class="sendBtn">보내기</a>
                            <a class="insertBtn">등록</a>
                            <a class="modifyBtn">수정</a>
                            <a class="deleteBtn">삭제</a>
                            <!-- <a class="excelBtn">다운로드</a> -->
                        </div>
                        <div class="contents-in">
							<jsp:include page="common/include_jqgrid.jsp" flush="true"></jsp:include>
                        </div>
                    </div>
                </div>
            </div>
            <!--[e] 컨텐츠 영역 -->

            <!--[s] 자산 등록 팝업 -->
            <div id="lay-form-write" class="layer-base">
            	<div class="layer-base-btns">
                    <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
                </div>
                <div class="layer-base-title">경보 대상 <span id="form_sub_title">등록/수정</span></div>
                <div class="layer-base-conts">
                    <div class="bTable">
                        <table>
                            <colgroup>
                                <col width="130"/>
                                <col width="*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>이름</th>
                                    <td><input type="text" name="username" value="" placeholder="" /></td>
                                </tr>
                                <tr>
                                    <th>휴대폰번호</th>
                                    <td><input type="text" name="phone" value="" placeholder="- 없이 숫자만 입력해주세요." /></td>
                                </tr>
								<tr>
                                    <th>알람 위험 레벨</th>
                                    <td>
                                        <select name="threshold_id">
                                            <option value="">선택</option>
                                            <option value="1">관심</option>
                                            <option value="2">주의</option>
                                            <option value="3">경계</option>
                                            <option value="4">심각</option>
                                        </select>
                                    </td>
                                </tr>
                                <%--<tr>
                                    <th>필터링 전송 여부</th>
                                    <td><input type="radio" name="filter" value="ON" placeholder="" />ON <input type="radio" name="filter" value="OFF" placeholder="" selected/>OFF</td>
                                </tr>--%>
								<tr>
                                    <th>자동 전송 여부</th>
                                    <td class="tal"><input type="checkbox" name="auto_send" value="" placeholder="" checked/></td>
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


            <!--[s] 메세지 전송 팝업 -->
            <div id="lay-form-send" class="layer-base">
                <div class="layer-base-btns">
                    <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
                </div>
                <div class="layer-base-title">수동 문자 전송</div>
                <div class="layer-base-conts" style="display: flex;flex-direction: row;min-height: 400px;justify-content: space-between;">
                    <div class="bTable" style="width: 50%;">
                        <table class="gridSmsAlarm"></table>
                    </div>
                    <div class="mem-form" style="width: 48%; display: flex;flex-direction: column;">
                        <div class="bTable">
                            <table>
                                <colgroup>
                                    <col width="130"/>
                                    <col width="*"/>
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>이름</th>
                                    <td><input type="text" name="username" value="" placeholder="" /></td>
                                </tr>
                                <tr>
                                    <th>휴대폰번호</th>
                                    <td><input type="text" name="phone" value="" placeholder="- 없이 숫자만 입력해주세요." /></td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div class="btn-btm" style="margin: 0">
                                            <button class="add-user">추가</button>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <textarea id="sendMessage" name="sendMessage" placeholder="전송 문구를 입력하세요"></textarea>
                    </div>
                </div>
                <div class="btn-btm">
                    <input type="submit" blue value="전송"/>
                    <button type="button" data-fancybox-close>취소</button>
                </div>
            </div>
            <!--[e] 메세지 전송 팝업  -->
        </section>
    </body>
</html>
