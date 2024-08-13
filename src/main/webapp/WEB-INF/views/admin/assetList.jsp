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
                multiboxonly: false,
                // columnAutoWidth: true
            }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

            $(function () {
				$('#asset_kind_id').on('change', function () {
					$('#tr_sensor_id_1').hide();
					$('#tr_sensor_id_2').hide();
					// $('#tr_device_id').hide();
                    $('#tr_etc1').hide();
                    $('#tr_etc3').hide();
					
					$('#lay-form-write input[name=name]').val('');
					// $('#lay-form-write input[name=device_id]').val('');
	            	$('#lay-form-write input[name=sensor_id_1]').val('');
	            	$('#lay-form-write input[name=sensor_id_2]').val('');
                    $('#lay-form-write input[name=etc1]').val('');
                    $('#lay-form-write input[name=etc3]').val('');
					
					//센서
					if( '2' == $(this).val() ){ //구조물경사계; -> x,y
						$('#tr_sensor_id_1').show();
						$('#tr_sensor_id_2').show();
					//센서
					}else if( '3' == $(this).val() //지표변위계;
							|| '4' == $(this).val() //강우량계;
							|| '6' == $(this).val() //지하수위계(6);
							|| '7' == $(this).val() ){ //지하수위계(7);
						$('#tr_sensor_id_1').show();
					//그 외
					} else if( '8' == $(this).val() //CCTV;
							// || '9' == $(this).val() //재난문자 전광판;
							|| '10' == $(this).val() //전광판;
                    ) {
						$('#tr_etc1').show();
						$('#tr_etc3').show();
					}
				});
            	
                $("[datepicker]").flatpickr({
                    locale: "ko",
                    dateFormat: "Y-m-d",
                    onClose: function (selectedDates, dateStr, instance) {},
                });
            	
				$.get('/common/code/list', {category: "센서상태"}, function(res) {
					let option = '<option value="">선택</option>';
					$.each(res, function(idx) {
						option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
					});
					$('#status').html(option);
				});

				$.get('/common/code/assetKindList', null, function(res) {
					let option = '<option value="">선택</option>';
					$.each(res, function(idx) {
						option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
					});
					$('#asset_kind_id').html(option);
				});
				
				// $.get('/common/code/areaList', null, function(res) {
				// 	let option = '<option value="">선택</option>';
				// 	$.each(res, function(idx) {
				// 		option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
				// 	});
				// 	$('#area_id').html(option);
				// });
				
				$.get('/common/code/zoneList', null, function(res) {
					let option = '<option value="">선택</option>';
					$.each(res, function(idx) {
						option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
					});
					$('#zone_id').html(option);
				});
				
                // 삭제
                $('.deleteBtn').on('click', function () {
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 0) {
                        confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function () {
                            $.each(targetArr, function (idx) {
                                $.get('/admin/assetList/del', this, function (res) { // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?
                                
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

                    $("[datepicker]").flatpickr({
                        onReady: function (selectedDates, dateStr, instance) {
                            $('#lay-form-write .flatpickr-input').val(
                                instance.formatDate(new Date(), 'Y-m-d')
                            )
                        }
                    });

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function () {
	                    if(!validate()) return;
	                    
                        $.get('/admin/assetList/add', getSerialize('#lay-form-write'), function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
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
                    
                    console.log(targetArr[0]);
                    
                    setSerialize('#lay-form-write', targetArr[0]); // 선택값 세팅

                    popFancy('#lay-form-write');
                    
//                     console.log( 'sensor_id ===========     ' + $('#sensor_id').val() );
                    
                	if ($('#lay-form-write select[name=asset_kind_id_hid]').val() == '2') {
                		
                		$('#sensor_id_1').val( $('#sensor_id').val().split(',')[0] );
                		$('#sensor_id_2').val( $('#sensor_id').val().split(',')[1] );
                		
        				$('#tr_sensor_id_1').show();
        				$('#tr_sensor_id_2').show();
        				
                    }else if($('#lay-form-write select[name=asset_kind_id_hid]').val() == '3'
                    		|| $('#lay-form-write select[name=asset_kind_id_hid]').val() == '4'
                    		|| $('#lay-form-write select[name=asset_kind_id_hid]').val() == '6'
                    		|| $('#lay-form-write select[name=asset_kind_id_hid]').val() == '7' ){
                    	
                    	$('#sensor_id_1').val( $('#sensor_id').val() );
                    	
        				$('#tr_sensor_id_1').show();

					}
                    else if($('#lay-form-write select[name=asset_kind_id_hid]').val() == '8'
                    		// || $('#lay-form-write select[name=asset_kind_id_hid]').val() == '9'
                    		|| $('#lay-form-write select[name=asset_kind_id_hid]').val() == '10' // 전광판
                    ) {
						// $('#tr_device_id').show();
						$('#tr_etc1').show();
						$('#tr_etc3').show();
                    }

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function () {
                        if (!validate()) return;                        
                        
                        //수정
                        $.get('/admin/assetList/mod', getSerialize('#lay-form-write'), function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
                            alert('저장되었습니다.', function () {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });

                    });

                    $("[datepicker]").flatpickr({
                        onReady: function (selectedDates, dateStr, instance) {
                            $('#lay-form-write .flatpickr-input').val(
                                instance.formatDate(new Date(targetArr[0].install_date), 'Y-m-d')
                            )
                        }
                    });
                });

                $('.excelBtn').on('click', function () {
                    downloadExcel('자산목록'); //20231228 현장관리 -> 자산목록
                });
            });
            
            function initForm(){
            	$('#lay-form-write select[name=asset_kind_id_hid]').val('');
            	$('#lay-form-write input[name=name]').val('');
            	// $('#lay-form-write select[name=area_id_hid]').val('');
            	$('#lay-form-write select[name=zone_id_hid]').val('');
            	$('#lay-form-write input[name=install_date]').val('');
//             	$('#lay-form-write select[name=status_hid]').val('');
//             	$('#lay-form-write input[name=device_id]').val('');
            	$('#lay-form-write input[name=sensor_id_1]').val('');
            	$('#lay-form-write input[name=sensor_id_2]').val('');
            	$('#lay-form-write input[name=etc1]').val('');
            	$('#lay-form-write input[name=etc3]').val('');

				$('#tr_sensor_id_1').hide();
				$('#tr_sensor_id_2').hide();
				$('#tr_etc1').hide();
				$('#tr_etc3').hide();
				// $('#tr_device_id').hide();
            }

            function validate() {
                if ($('#lay-form-write select[name=asset_kind_id_hid]').val() == '') {
                    $('#lay-form-write select[name=asset_kind_id_hid]').focus();
                    alert('자산종류를 선택해주세요.');
                    return false;
                }

                if ($('#lay-form-write input[name=name]').val().trim() == '') {
                    $('#lay-form-write input[name=name]').focus();
                    alert('센서명을 입력해주세요.');
                    return false;
                }
                
                if ($('#lay-form-write select[name=asset_kind_id_hid]').val() == '2') {
                    if ($('#lay-form-write input[name=sensor_id_1]').val().trim() == '') {
                        $('#lay-form-write input[name=sensor_id_1]').focus();
                        alert('센서 ID 1을 입력해주세요.');
                        return false;
                    }
                    
                    if ($('#lay-form-write input[name=sensor_id_2]').val().trim() == '') {
                        $('#lay-form-write input[name=sensor_id_2]').focus();
                        alert('센서 ID 2를 입력해주세요.');
                        return false;
                    }
                	
                }else if($('#lay-form-write select[name=asset_kind_id_hid]').val() == '3'
                		|| $('#lay-form-write select[name=asset_kind_id_hid]').val() == '4'
                		|| $('#lay-form-write select[name=asset_kind_id_hid]').val() == '6'
                		|| $('#lay-form-write select[name=asset_kind_id_hid]').val() == '7' ){
                	
                    if ($('#lay-form-write input[name=sensor_id_1]').val().trim() == '') {
                        $('#lay-form-write input[name=sensor_id_1]').focus();
                        alert('센서 ID 1을 입력해주세요.');
                        return false;
                    }
                	
                } else if ($('#lay-form-write select[name=asset_kind_id_hid]').val() == '8'){
                    if ($('#lay-form-write input[name=etc1]').val().trim() == '') {
                        $('#lay-form-write input[name=etc1]').focus();
                        alert('RTSP 주소를 입력해주세요.');
                        return false;
                    }

                    if ($('#lay-form-write input[name=etc3]').val().trim() == '') {
                        $('#lay-form-write input[name=etc3]').focus();
                        alert('웹 콘솔를 입력해주세요.');
                        return false;
                    }
                }


                // else if($('#lay-form-write select[name=asset_kind_id_hid]').val() == '8'
                // 		|| $('#lay-form-write select[name=asset_kind_id_hid]').val() == '9'
                // 		|| $('#lay-form-write select[name=asset_kind_id_hid]').val() == '10'){
                //
				// 	if ($('#lay-form-write select[name=device_id]').val() == '') {
				// 		$('#lay-form-write select[name=device_id]').focus();
				// 		alert('장비 ID를 입력해주세요.');
				// 		return false;
				// 	}
   	         //
                // }
                
                // if ($('#lay-form-write select[name=area_id_hid]').val() == '') {
                //     $('#lay-form-write select[name=area_id_hid]').focus();
                //     alert('현장을 선택해주세요.');
                //     return false;
                // }
                
                if ($('#lay-form-write select[name=zone_id_hid]').val() == '') {
                    $('#lay-form-write select[name=zone_id_hid]').focus();
                    alert('지구을 선택해주세요.');
                    return false;
                }
                
                if ($('#lay-form-write input[name=install_date]').val().trim() == '') {
                    $('#lay-form-write input[name=install_date]').focus();
                    alert('설치일자를 입력해주세요.');
                    return false;
                }
                
//                 if ($('#lay-form-write select[name=status_hid]').val().trim() == '') {
//                     $('#lay-form-write select[name=status_hid]').focus();
//                     alert('상태를 선택해주세요.');
//                     return false;
//                 }
                
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

            <div id="container">
                <h2 class="txt">관리자 전용
                    <span class="arr">자산 관리</span>
                </h2>
                <div id="contents">
                    <div class="contents-re">
                        <h3 class="txt">자산 목록</h3>
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

            <!--[s] 자산 등록 팝업 -->
            <div id="lay-form-write" class="layer-base">
            
            	<input type="hidden" name="asset_id"/>
            	<input type="hidden" id="sensor_id" name="sensor_id"/>
            
                <div class="layer-base-btns">
                    <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
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
                                    <th>자산종류</th>
                                    <td>
                                        <select id="asset_kind_id" name="asset_kind_id_hid">
                                            <option value="">선택</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr id="tr_name">
                                    <th>센서명</th>
                                    <td><input type="text" id="name" name="name" value="" placeholder="" /></td>
                                </tr>
                                <tr id="tr_sensor_id_1" style="display: none;">
                                    <th>센서 ID 1</th>
                                    <td><input type="text" id="sensor_id_1" name="sensor_id_1" value="" placeholder="" /></td>
                                </tr>
                                <tr id="tr_sensor_id_2" style="display: none;">
                                    <th>센서 ID 2</th>
                                    <td><input type="text" id="sensor_id_2" name="sensor_id_2" value="" placeholder="" /></td>
                                </tr>
<%--                                <tr id="tr_device_id" style="display: none;">--%>
<%--                                    <th>장비 ID</th>--%>
<%--                                    <td><input type="text" id="device_id" name="device_id" value="" placeholder="" /></td>--%>
<%--                                </tr>--%>
<%--                                <tr>--%>
<%--                                    <th>현장</th>--%>
<%--                                    <td>--%>
<%--                                        <select id="area_id" name="area_id_hid">--%>
<%--                                            <option value="">선택</option>--%>
<%--                                        </select>--%>
<%--                                    </td>--%>
<%--                                </tr>--%>
                                <tr id="tr_etc1" style="display: none;">
                                    <th>RTSP 주소<br/>(전광판 IP)</th>
                                    <td>
                                        <input type="text" id="etc1" name="etc1"/>
                                    </td>
                                </tr>
                                <tr id="tr_etc3" style="display: none;">
                                    <th>웹 콘솔<br/>(전광판 PORT)</th>
                                    <td>
                                        <input type="text" id="etc3" name="etc3"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>지구명</th>
                                    <td>
                                        <select id="zone_id" name="zone_id_hid">
                                            <option value="">선택</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>설치일자</th>
                                    <td><input type="text" id="install_date" name="install_date" value="" placeholder="" datepicker="" readonly="readonly"/></td>
                                </tr>
<!--                                 <tr> -->
<!--                                     <th>상태</th> -->
<!--                                     <td> -->
<!--                                     	<select id="status" name="status_hid"> -->
<!--                                             <option value="">선택</option> -->
<!--                                         </select> -->
<!--                                     </td> -->
<!--                                 </tr> -->
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
        </section>
    </body>
</html>
