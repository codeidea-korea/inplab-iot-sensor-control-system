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

            	$("#uploadFile").on("change", function(event) {
            	    var file = event.target.files[0];
            	    var reader = new FileReader(); 
            	    reader.onload = function(e) {
            	    	$('#uploadFileImg').css("cursor","");
                    	$('#uploadFileImg').off('click');
                    	
            	        $("#uploadFileImg").attr("src", e.target.result);
            	    }
            	    reader.readAsDataURL(file);
            	});
            	
//                 _popupClearData = getSerialize('#lay-form-write');
                // 초기화할 데이터값

                // 삭제
                $('.deleteBtn').on('click', function () {
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 0) {
                        confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function () {
                            $.each(targetArr, function (idx) {
                                $.get('/admin/area/del', this, function (res) { // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?
                                
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
				$('.insertBtn').on('click', function () {
                	
					$("#form_sub_title").html('등록');
					
                	initForm();
                	
                	$('#uploadFileImg').css("cursor","");
                	$('#uploadFileImg').off('click');

                    popFancy('#lay-form-write');

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function () {
	                    if(!validate()) return;
	                    
                        //파일업로드
                        if($("#uploadFile")[0].files[0] != undefined){
                        	var call_url = "/common/file/upload"
                        	var serverFileName = genServerFileName() + getExtName( $("#uploadFile")[0].files[0].name );
                        	$("#serverFileName").val(serverFileName);//for db insert
                        	
                            var form = new FormData();
                            form.append( "uploadFile", $("#uploadFile")[0].files[0] );
                            form.append( "serverFileName", serverFileName );
                        
                            fileUpload(call_url, form);
                        }
	                  
	                	//등록
                        $.get('/admin/area/add', getSerialize('#lay-form-write'), function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
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
                    
                    if(targetArr[0].file1 == ''){
                    	$('#uploadFileImg').css("cursor","");
                    	$('#uploadFileImg').off('click');
                    }else{
                    	$("#uploadFileImg").attr("src", '/common/img/view?name='+targetArr[0].file1);
                    	$('#serverFileName').val(targetArr[0].file1);
                        $('#uploadFileImg').css("cursor","pointer");
                    	$('#uploadFileImg').on('click', function () {
                    		var popup = window.open('/common/img/view?name='+targetArr[0].file1, '', 'width=750px,height=450px');
                    	});
                    }
                    
                    setSerialize('#lay-form-write', targetArr[0]); // 선택값 세팅

                    popFancy('#lay-form-write');

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function () {
                        if (!validate()) return;                        
                        
                        //파일업로드
                        if($("#uploadFile")[0].files[0] != undefined){
                        	var call_url = "/common/file/upload"
                        	var serverFileName = genServerFileName() + getExtName( $("#uploadFile")[0].files[0].name );
                        	$("#serverFileName").val(serverFileName);//for db insert
                        	
                            var form = new FormData();
                            form.append( "uploadFile", $("#uploadFile")[0].files[0] );
                            form.append( "serverFileName", serverFileName );
                        
                            fileUpload(call_url, form);
                        }
                        
                        //수정
                        $.get('/admin/area/mod', getSerialize('#lay-form-write'), function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
                            alert('저장되었습니다.', function () {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });

                    });
                });

				/*
				$('input[name=lat], input[name=lng]').on('click', function() {
					if ($('#lay-form-write input[name=lat]').val() != '' && $('#lay-form-write input[name=lng]').val() != '') {
						try {
							window.vworld.setPanBy([
								parseFloat($('#lay-form-write input[name=lng]').val()),
								parseFloat($('#lay-form-write input[name=lat]').val())], parseFloat($('#lay-form-write input[name=zoom]').val())
							);
						} catch(e) { }
					}

					popFancy('#lay-form-address', { dragToClose : false, touch : false });
				});*/

				/*24.02.27
				현장 수정시 위도를 선택해도 지도창이 오픈, 경도를 선택해도 지도창이 오픈됨
						=> 1.지도검색 버튼을 추가하고 지도에서 위치 선택하면 자동 위도/경도 정보 표출.*/
				$('#mapSearchBtn').on('click', function() {
					if ($('#lay-form-write input[name=lat]').val() != '' && $('#lay-form-write input[name=lng]').val() != '') {
						try {
							window.vworld.setPanBy([
								parseFloat($('#lay-form-write input[name=lng]').val()),
								parseFloat($('#lay-form-write input[name=lat]').val())], parseFloat($('#lay-form-write input[name=zoom]').val())
							);
						} catch(e) { }
					}

					popFancy('#lay-form-address', { dragToClose : false, touch : false });
				});

				$('.locationApply').on('click', function() {
					let coords = window.vworld.getCenter();
					let zoom = window.vworld.getZoom();
					$('#lay-form-write input[name=lat]').val(coords[1]);
					$('#lay-form-write input[name=lng]').val(coords[0]);
					$('#lay-form-write input[name=zoom]').val(zoom);
					popFancyClose('#lay-form-address');
				});

                $('.excelBtn').on('click', function () {
                    downloadExcel('현장관리');
                });
            });
            
            function initForm(){
            	$('#lay-form-write input[name=name]').val('');
            	$('#lay-form-write input[name=type]').val('');
				$('#lay-form-write input[name=lat]').val('');
				$('#lay-form-write input[name=lng]').val('');
				$('#lay-form-write input[name=zoom]').val('');
            	$('#lay-form-write input[name=constructor]').val('');
            	$('#lay-form-write input[name=measure1]').val('');
            	$('#lay-form-write input[name=measure2]').val('');
            	$("#etc2").val('')
            	$('#lay-form-write input[name=uploadFile]').val('');
            	$("#uploadFileImg").attr("src", '');
            }

            function validate() {
            	if($("#uploadFile")[0].files[0] != undefined){
            		
	            	var maxSizeMb = 10;
	            	var maxSize = maxSizeMb * 1024 * 1024; // 10MB
	            	
					var fileSize = $("#uploadFile")[0].files[0].size;
					if(fileSize > maxSize){
						alert("파일은 "+maxSizeMb+"MB 이내로 등록 가능합니다.");
						$("#uploadFile").val("");
						return false;
					}
					
					if($("#uploadFile").val() != "") {		
						var ext = $("#uploadFile").val().split(".").pop().toLowerCase();		    
						if($.inArray(ext, ['jpg','jpeg','gif','png']) == -1) {
							alert("이미지 파일만 등록 가능합니다.");
							$("#uploadFile").val("");
							return false;
						}
					}
					
            	}
            	
                if ($('#lay-form-write input[name=name]').val().trim() == '') {
                    $('#lay-form-write input[name=name]').focus();
                    alert('현장명을 입력해주세요.');
                    return false;
                }

				if ($('#lay-form-write input[name=lat]').val().trim() == '') {
					$('#lay-form-write input[name=lat]').focus();
					alert('위도를 입력해주세요.');
					return false;
				}

//                 if ($('#lay-form-write select[name=type]').val().trim() == '') {
//                     $('#lay-form-write select[name=type]').focus();
//                     alert('현장 종류를 선택해주세요.');
//                     return false;
//                 }
                
                return true;
            }
            
            function genServerFileName(){
            	var date = new Date;
            	var year = date.getFullYear();
            	var month = date.getMonth() + 1;
            	var day = date.getDate();
            	var seconds = date.getSeconds();
            	var minutes = date.getMinutes();
            	var hour = date.getHours();
            	var milliSeconds = date.getMilliseconds();
            	return year +''+month+''+day+''+hour+''+month+''+minutes+''+seconds+''+milliSeconds;
            }
            
            function getExtName(name){
            	return name.substr( name.lastIndexOf('.') );
            }
            
            function fileUpload( call_url, form ){
	             $.ajax({
	                     url : call_url
	                     , type : "POST"
	                     , processData : false
	                     , contentType : false
	                     , data : form
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
                        <h3 class="txt">현장 관리</h3>
                        <div class="btn-group">
                            <a class="insertBtn" style="display:none;">등록</a>
                            <a class="modifyBtn" style="display:none;">수정</a>
                            <%--<a class="deleteBtn">삭제</a>--%>
                            <%--<a class="excelBtn">다운로드</a>--%>
                        </div>
                        <div class="contents-in">
                            <jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>
                        </div>
                    </div>
                </div>
            </div>
            <!--[e] 컨텐츠 영역 -->

			<!--[s] 유지보수 등록 팝업 -->
			<div id="lay-form-write" class="layer-base" style="width:900px">
			
				<input type="hidden" id="serverFileName" name="serverFileName"/>
				<input type="hidden" id="area_id" name="area_id"/>
			
				<div class="layer-base-btns">
					<a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
				</div>
				<div class="layer-base-title">현장 <span id="form_sub_title">등록/수정</span></div>
				<div class="layer-base-conts">
					<div class="bTable">
						<table>
							<colgroup>
								<col width="130" />
								<col width="*" />
								<col width="*" />
								<col width="300" />
							</colgroup>
							<tbody>
								<tr>
									<th>현장명</th>
									<td colspan="2"><input type="text" id="name" name="name" value="" placeholder="" /></td>
									<td>현장현황</td>
								</tr>
								<tr>
									<th>현장 종류</th>
									<td colspan="2"><input type="text" id="type" name="type" value="" placeholder="" /></td>
									<td rowspan="7"><img id="uploadFileImg" src="" alt="" style="width:300px"></td>
								</tr>
								<tr>
									<th>위도</th>
									<td>
										<input type="text" name="lat" readonly/>
									</td>
									<td rowspan="3">
										<div class="btn-btm" style="justify-content: center;">
											<button type="button" id="mapSearchBtn">지도검색</button>
										</div>
									</td>

								</tr>
								<tr>
									<th>경도</th>
									<td><input type="text" name="lng" readonly/></td>
								</tr>
								<tr>
									<th>줌</th>
									<td><input type="text" name="zoom" readonly/></td>
								</tr>
								<tr>
									<th>시공사</th>
									<td colspan="2"><input type="text" id="constructor" name="constructor" value="" placeholder="" /></td>
								</tr>
								<tr>
									<th>계측사1</th>
									<td colspan="2"><input type="text" id="measure1" name="measure1" value="" placeholder="" /></td>
								</tr>
								<tr>
									<th>계측사2</th>
									<td colspan="2"><input type="text" id="measure2" name="measure2" value="" placeholder="" /></td>
								</tr>
								<tr>
									<th>현장주소</th>
									<td colspan="3"><textarea name="etc2" id="etc2"></textarea></td>
								</tr>
								<tr>
									<th>현장현황</th>
									<td colspan="3"><input type="file" id="uploadFile" name="uploadFile" value="" placeholder="" /></td>
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
						<input type="button" class="locationApply" blue value="확인" />
						<button type="button" data-fancybox-close>취소</button>
					</div>
				</div>
			</div>

        </section>
    </body>
</html>
