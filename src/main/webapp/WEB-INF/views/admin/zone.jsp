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
                        ], // [14124968.051077379, 4506389.894300204],
                        zoom: 18,
                        rotation: 0.5
                    }
                });

				window.vworld.vwmap2d();
            	
            	$("#uploadFile1").on("change", function(event) {
            	    var file1 = event.target.files[0];
            	    var reader1 = new FileReader(); 
            	    reader1.onload = function(e) {
            	    	$('#uploadFileImg1').css("cursor","");
                    	$('#uploadFileImg1').off('click');
                    	
            	        $("#uploadFileImg1").attr("src", e.target.result);
            	    }
            	    reader1.readAsDataURL(file1);
            	});
            	
            	$("#uploadFile2").on("change", function(event) {
            	    var file2 = event.target.files[0];
            	    var reader2 = new FileReader(); 
            	    reader2.onload = function(e) {
            	    	$('#uploadFileImg2').css("cursor","");
                    	$('#uploadFileImg2').off('click');
                    	
            	        $("#uploadFileImg2").attr("src", e.target.result);
            	    }
            	    reader2.readAsDataURL(file2);
            	});
            	
				$.get('/common/code/areaList', null, function(res) {
					let option = '<option value="">선택</option>';
					$.each(res, function(idx) {
						option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
					});
					$('#area_id').html(option);
				});

				$.get('/common/code/mappingList', null, function(res) {
					let option = '<option value="">선택</option>';
					$.each(res, function(idx) {
						option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
					});
					$('#etc1').html(option);
				});

//                 _popupClearData = getSerialize('#lay-form-write');       // 초기화할 데이터값

                // 삭제
                $('.deleteBtn').on('click', function() {
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 0) {
                        confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function() {
                            $.each(targetArr, function(idx) {
                                $.get('/admin/zone/del', this, function(res) {
                                    // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?
                                
                                    if((idx+1)==targetArr.length) reloadJqGrid();
                                });
                            });

//                             reloadJqGrid();
                        });
                    } else {
                        alert('삭제하실 지구을 선택해주세요.');
                        return;
                    }
                });

                // 등록
                $('.insertBtn').on('click', function() {
                	
                	$("#form_sub_title").html('등록');
                	
                	initForm();
                	
                	$('#uploadFileImg1').css("cursor","");
                	$('#uploadFileImg1').off('click');
                	
                	$('#uploadFileImg2').css("cursor","");
                	$('#uploadFileImg2').off('click');
                	
//                     setSerialize('#lay-form-write', _popupClearData);           
                    
                    popFancy('#lay-form-write');

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function() {
                        if (!validate()) return;
                        //파일업로드 1
                        if($("#uploadFile1")[0].files[0] != undefined){
                        	var call_url = "/common/file/upload"
                        	var serverFileName1 = genServerFileName() + getExtName( $("#uploadFile1")[0].files[0].name );
                        	$("#serverFileName1").val(serverFileName1);//for db insert
                        	
                            var form = new FormData();
                            form.append( "uploadFile", $("#uploadFile1")[0].files[0] );
                            form.append( "serverFileName", serverFileName1 );
                        
                            fileUpload(call_url, form);
                        }
                        
                        //파일업로드 2
                        if($("#uploadFile2")[0].files[0] != undefined){
                        	var call_url = "/common/file/upload"
                        	var serverFileName2 = genServerFileName() + getExtName( $("#uploadFile2")[0].files[0].name );
                        	$("#serverFileName2").val(serverFileName2);//for db insert
                        	
                            var form = new FormData();
                            form.append( "uploadFile", $("#uploadFile2")[0].files[0] );
                            form.append( "serverFileName", serverFileName2 );
                        
                            fileUpload(call_url, form);
                        }
                        
                        $.get('/admin/zone/add', getSerialize('#lay-form-write'), function(res) {
                            // todo : true가 아닌 경우 실패된것을 알릴것인지?
                            alert('저장되었습니다.', function() {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });    
                        
                        
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
                    
                    if(targetArr[0].file1 == ''){
                    	$('#uploadFileImg1').css("cursor","");
                    	$('#uploadFileImg1').off('click');
                    }else{
                    	$("#uploadFileImg1").attr("src", '/common/img/view?name='+targetArr[0].file1);
                    	$('#serverFileName1').val(targetArr[0].file1);
                        $('#uploadFileImg1').css("cursor","pointer");
                    	$('#uploadFileImg1').on('click', function () {
                    		var popup = window.open('/common/img/view?name='+targetArr[0].file1, '', 'width=750px,height=450px');
                    	});
                    }
                    
                    if(targetArr[0].file2 == ''){
                    	$('#uploadFileImg2').css("cursor","");
                    	$('#uploadFileImg2').off('click');
                    }else{
                    	$("#uploadFileImg2").attr("src", '/common/img/view?name='+targetArr[0].file2);
                        $('#serverFileName2').val(targetArr[0].file2);
                        $('#uploadFileImg2').css("cursor","pointer");
                    	$('#uploadFileImg2').on('click', function () {
                    		var popup = window.open('/common/img/view?name='+targetArr[0].file2, '', 'width=750px,height=450px');
                    	});
                    }
                    
                    setSerialize('#lay-form-write', targetArr[0]);     // 선택값 세팅                  

                    popFancy('#lay-form-write');

                    // 저장버튼 클릭시
                    $('#lay-form-write input[type=submit]').off().on('click', function() {                        
                        if (!validate()) return;

                        //파일업로드 1
                        if($("#uploadFile1")[0].files[0] != undefined){
                        	var call_url = "/common/file/upload"
                        	var serverFileName1 = genServerFileName() + getExtName( $("#uploadFile1")[0].files[0].name );
                        	$("#serverFileName1").val(serverFileName1);//for db insert
                        	
                            var form = new FormData();
                            form.append( "uploadFile", $("#uploadFile1")[0].files[0] );
                            form.append( "serverFileName", serverFileName1 );
                        
                            fileUpload(call_url, form);
                        }
                        
                        //파일업로드 2
                        if($("#uploadFile2")[0].files[0] != undefined){
                        	var call_url = "/common/file/upload"
                        	var serverFileName2 = genServerFileName() + getExtName( $("#uploadFile2")[0].files[0].name );
                        	$("#serverFileName2").val(serverFileName2);//for db insert
                        	
                            var form = new FormData();
                            form.append( "uploadFile", $("#uploadFile2")[0].files[0] );
                            form.append( "serverFileName", serverFileName2 );
                        
                            fileUpload(call_url, form);
                        }
                        
                        $.get('/admin/zone/mod', getSerialize('#lay-form-write'), function(res) {
                            // todo : true가 아닌 경우 실패된것을 알릴것인지?
                            alert('저장되었습니다.', function() {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });
                    });
                });

				$('input[name=lat], input[name=lng]').on('click', function() {
					if ($('#lay-form-write input[name=lat]').val() != '' && $('#lay-form-write input[name=lng]').val() != '') {
						try {
							window.vworld.setPanBy([parseFloat($('#lay-form-write input[name=lng]').val()), parseFloat($('#lay-form-write input[name=lat]').val())]);
						} catch(e) { }
					}

					popFancy('#lay-form-address', { dragToClose : false, touch : false });
				});

				$('.locationApply').on('click', function() {
					let coords = window.vworld.getCenter();
					$('#lay-form-write input[name=lat]').val(coords[1]);
					$('#lay-form-write input[name=lng]').val(coords[0]);
					popFancyClose('#lay-form-address');
				});

                $('.excelBtn').on('click', function() {
                    downloadExcel('지구관리');
                });
            });

            function initForm(){
            	$('#lay-form-write select[name=area_id_hid]').val('');
            	$('#lay-form-write input[name=name]').val('');
            	
            	$('#lay-form-write input[name=lat]').val('');
            	$('#lay-form-write input[name=lng]').val('');
            	// $('#lay-form-write input[name=height]').val('');
            	
            	$('#lay-form-write select[name=etc1_hid]').val('');
            	$('#lay-form-write input[name=etc2]').val('');
            	$('#lay-form-write input[name=etc3]').val('');
            	
            	$('#lay-form-write input[name=uploadFile1]').val('');
            	$("#uploadFileImg1").attr("src", '');
            	$('#lay-form-write input[name=uploadFile2]').val('');
            	$("#uploadFileImg2").attr("src", '');
            }
            
            function validate() {
            	
            	var maxSizeMb = 10;
            	var maxSize = maxSizeMb * 1024 * 1024; // 10MB
            	
            	if($("#uploadFile1")[0].files[0] != undefined){

					var fileSize = $("#uploadFile1")[0].files[0].size;
					if(fileSize > maxSize){
						alert("파일1은 "+maxSizeMb+"MB 이내로 등록 가능합니다.");
						$("#uploadFile1").val("");
						return false;
					}

					if($("#uploadFile1").val() != "") {
						var ext = $("#uploadFile1").val().split(".").pop().toLowerCase();
						if($.inArray(ext, ['jpg','jpeg','gif','png', 'bmp', 'pdf']) == -1) {
							alert("이미지 파일만 파일1로 등록 가능합니다.");
							$("#uploadFile1").val("");
							return false;
						}
					}

            	}

            	if($("#uploadFile2")[0].files[0] != undefined){

					var fileSize = $("#uploadFile2")[0].files[0].size;
					if(fileSize > maxSize){
						alert("파일2는 "+maxSizeMb+"MB 이내로 등록 가능합니다.");
						$("#uploadFile2").val("");
						return false;
					}

					if($("#uploadFile2").val() != "") {
						var ext = $("#uploadFile2").val().split(".").pop().toLowerCase();
						if($.inArray(ext, ['jpg','jpeg','gif','png', 'bmp', 'pdf']) == -1) {
							alert("이미지 파일만 파일2로 등록 가능합니다.");
							$("#uploadFile2").val("");
							return false;
						}
					}

            	}

				if ($('#lay-form-write select[name=area_id_hid]').val().trim() == '') {
					$('#lay-form-write select[name=area_id_hid]').focus();
					alert('현장명을 선택해주세요.');
					return false;
				}
            	
                if ($('#lay-form-write input[name=name]').val().trim() == '') {
                    $('#lay-form-write input[name=name]').focus();                        
                    alert('지구명을 입력해주세요.');
                    return false;
                }

                if ($('#lay-form-write select[name=use_flag]').val().trim() == '') {
                    $('#lay-form-write select[name=use_flag]').focus();
                    alert('사용 여부를 선택해주세요.');
                    return false;
                }

				// if ($('#lay-form-write input[name=lat]').val().trim() == '') {
				// 	$('#lay-form-write input[name=lat]').focus();
				// 	alert('위도를 입력해주세요.');
				// 	return false;
				// }

                if ($('#lay-form-write select[name=etc1_hid]').val().trim() == '') {
                    $('#lay-form-write select[name=etc1_hid]').focus();
                    alert('로거 ID를 입력해주세요.');
                    return false;
                }

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
	                        <h3 class="txt">지구 관리</h3>
	                        <div class="btn-group">
	                            <a class="insertBtn">등록</a>
	                            <a class="modifyBtn">수정</a>
	                            <%--<a class="deleteBtn">삭제</a>--%>
	                            <a class="excelBtn">다운로드</a>
	                        </div>
	                        <div class="contents-in">
<%--	                            <jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>--%>
	                            <jsp:include page="../common/include_jqgrid_old.jsp" flush="true"></jsp:include>
	                        </div>
	                    </div>
	                </div>
				</div>
			<!--[e] 컨텐츠 영역 -->
			
			<!--[s] 지구 등록 팝업 -->
			<div id="lay-form-write" class="layer-base wide">
			
				<input type="hidden" id="serverFileName1" name="serverFileName1"/>
				<input type="hidden" id="serverFileName2" name="serverFileName2"/>
				<input type="hidden" id="zone_id" name="zone_id"/>
			
				<div class="layer-base-btns">
					<a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
				</div>
				<div class="layer-base-title">지구 관리 <span id="form_sub_title">등록/수정</span></div>
				<div class="layer-base-conts">
					<div class="bTable tal">
						<table>
							<colgroup>
								<col width="13%">
								<col width="*">
								<col width="13%">
								<col width="*">
								<col width="13%">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<th>현장명</th>
									<td>
										<select id="area_id" name="area_id_hid">
											<option value="">선택</option>
										</select>
									</td>
									<th>지구명</th>
									<td colspan=""><input type="text" name="name" /></td>


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
									<th>위도</th>
									<td><input type="text" name="lat" readonly/></td>
									<th>경도</th>
									<td><input type="text" name="lng" readonly/></td>
<%--									<th>높이</th>--%>
<%--									<td><input type="text" name="height" /></td>--%>
								</tr>
								<tr>
									<th>현장현황 사진</th>
									<td>
										<input type="file" id="uploadFile1" name="uploadFile1" value="" placeholder="" />
										<input type="hidden" name="preUploadFile1" id="preUploadFile1"/>
									</td>
									<th>배선도 사진</th>
									<td colspan="3">
										<input type="file" id="uploadFile2" name="uploadFile2" value="" placeholder="" />
										<input type="hidden" name="preUploadFile2" id="preUploadFile2"/>
									</td>
								</tr>
								<tr>
									<th>로거 ID</th>
									<td>
										<select id="etc1" name="etc1_hid">
											<option value="">선택</option>
										</select>
									</td>
									<th>기타1</th>
									<td><input type="text" name="etc2" /></td>
									<th>기타2</th>
									<td><input type="text" name="etc3" /></td>
								</tr>
							</tbody>
						</table>
					</div>
		
					<div class="bTable">
						<table>
							<colgroup>
								<col width="50%">
								<col width="*">
							</colgroup>
							<tbody>
								<tr>
									<td>현장현황 사진</td>
									
									<td>배선도 사진</td>
									
								</tr>
								<tr>
									<td style="height:250px"><img id="uploadFileImg1" src="" alt="" style="width:300px"></td>
									<td style="height:250px"><img id="uploadFileImg2" src="" alt="" style="width:300px"></td>
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
			<!--[e] 지구 등록 팝업 -->

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
