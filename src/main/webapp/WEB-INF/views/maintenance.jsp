<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>

        <style></style>

        <script>
            window.jqgridOption = {
                multiselect: true,
                multiboxonly: false
            }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

//             var _popupClearData;

            $(function () {
				$("#zone_id").off().on('change', function() {
					let $selected = $("option:selected", this);
					$.get('/common/code/sensorListByZone', {zone_id: $selected.val()}, function(res) {
						$('#asset_id option').empty();
						let option = '<option value="">선택</option>';
						$.each(res, function(idx) {
							option += '<option value="'+this.code+'">'+this.name+'</option>';
						});
						$('#asset_id').html(option);
					});
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
            	
				$.get('/common/code/zoneList', null, function(res) {
					let option = '<option value="">선택</option>';
					$.each(res, function(idx) {
						option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
					});
					$('#zone_id').html(option);
				});

				$.get('/common/code/list', {category: "유지보수종류"}, function(res) {
					let option = '<option value="">선택</option>';
					$.each(res, function(idx) {
						option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
					});
					$('#type').html(option);
				});

//                 _popupClearData = getSerialize('#lay-form-write');
                // 초기화할 데이터값

                // 삭제
                $('.deleteBtn').on('click', function () {
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 0) {
                        confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function () {
                            $.each(targetArr, function (idx) {
                                $.get('/maintenance/del', this, function (res) { // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?
                                
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

					$("[datepicker]").flatpickr({
						locale: "ko",
						dateFormat: "Y-m-d",
						onClose: function (selectedDates, dateStr, instance) {},
					});

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
	                    
                        $.get('/maintenance/add', getSerialize('#lay-form-write'), function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
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
					getSensorList({zone_id : targetArr[0].zone_id_hid});
                    
                    if(targetArr[0].file1 == ''){
                    	$('#uploadFileImg').css("cursor","");
                    	$('#uploadFileImg').off('click');
                    }else{
                    	$("#uploadFileImg").attr("src", '/common/img/view?name='+targetArr[0].file1);
                        $('#uploadFileImg').css("cursor","pointer");
                    	$('#uploadFileImg').on('click', function () {
                    		var popup = window.open('/common/img/view?name='+targetArr[0].file1, '', 'width=750px,height=450px');
                    	});
                    }

					setTimeout(function (){
						setSerialize('#lay-form-write', targetArr[0]); // 선택값 세팅
						popFancy('#lay-form-write');

						const myDate = document.querySelector("#mt_date");
						myDate._flatpickr.destroy();
						myDate.readOnly = true;
					},500);

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
                        
                        $.get('/maintenance/mod', getSerialize('#lay-form-write'), function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
                            alert('저장되었습니다.', function () {
                                popFancyClose('#lay-form-write');
                            });
                            reloadJqGrid();
                        });

                    });
                });

                $('.excelBtn').on('click', function () {
                    downloadExcel('유지보수');
                });
            });
            
            function initForm(){
            	console.log('초기화!');
            	$('#lay-form-write select[name=zone_id_hid]').val('');
            	$('#lay-form-write select[name=type_hid]').val('');
            	$('#lay-form-write input[name=mt_date]').val('');
            	$('#lay-form-write select[name=asset_id_hid]').val('');
            	$('#lay-form-write input[name=manager_name]').val('');
            	$('#lay-form-write input[name=manager_tel]').val('');
            	$("#description").val('');
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
            	
                if ($('#lay-form-write select[name=zone_id_hid]').val() == '') {
                    $('#lay-form-write select[name=zone_id_hid]').focus();
                    alert('지구명을 선택해주세요.');
                    return false;
                }
                
                if ($('#lay-form-write select[name=type_hid]').val() == '') {
                    $('#lay-form-write select[name=type_hid]').focus();
                    alert('유지보수 종류를 선택해주세요.');
                    return false;
                }

                if ($('#lay-form-write select[name=asset_id_hid]').val() == '') {
                    $('#lay-form-write select[name=asset_id_hid]').focus();
                    alert('센서명을 선택해주세요.');
                    return false;
                }
                
                if ($('#lay-form-write input[name=mt_date]').val().trim() == '') {
                    $('#lay-form-write input[name=mt_date]').focus();
                    alert('유지보수 일자를 입력해주세요.');
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
            
//             function handleImgFileSelect(e) {
//                 var files = e.target.files;
//                 var filesArr = Array.prototype.slice.call(files);
         
//                 var reg = /(.*?)\/(jpg|jpeg|png|bmp)$/;
         
//                 filesArr.forEach(function(f) {
//                     if (!f.type.match(reg)) {
//                         alert("확장자는 이미지 확장자만 가능합니다.");
//                         return;
//                     }
         
//                     sel_file = f;
         
//                     var reader = new FileReader();
//                     reader.onload = function(e) {
//                         $("#img").attr("src", e.target.result);
//                     }
//                     reader.readAsDataURL(f);
//                 });
//             }

			function getSensorList(param){
				$.get('/common/code/sensorListByZone', param, function(res) {
					let option = '<option value="">선택</option>';
					$.each(res, function(idx) {
						option += '<option value="'+res[idx].code+'">'+res[idx].name+'</option>';
					});
					$('#asset_id').html(option);
				});
			}
            
        </script>
    </head>

    <body data-pgcode="0000">
        <section id="wrap">
            <!--[s] 상단 -->
            <jsp:include page="common/include_top.jsp" flush="true"></jsp:include>
            <!--[e] 상단 -->

            <!--[s] 왼쪽 메뉴 -->
            <div
                id="global-menu">
                <!--[s] 주 메뉴 -->
                <jsp:include page="common/include_sidebar.jsp" flush="true"></jsp:include>
                <!--[e] 주 메뉴 -->
            </div>
            <!--[e] 왼쪽 메뉴 -->

            <div id="container">
                <h2 class="txt">유지보수 관리</h2>
                <div id="contents">
                    <div class="contents-re">
                        <h3 class="txt">유지보수 관리</h3>
                        <div class="btn-group">
                            <a class="insertBtn">등록</a>
                            <a class="modifyBtn">수정</a>
                            <a class="deleteBtn">삭제</a>
                            <a class="excelBtn">다운로드</a>
                        </div>
                        <div class="contents-in">
                            <jsp:include page="common/include_jqgrid.jsp" flush="true"></jsp:include>
                        </div>
                    </div>
                </div>
            </div>
            <!--[e] 컨텐츠 영역 -->

			<!--[s] 유지보수 등록 팝업 -->
			<div id="lay-form-write" class="layer-base" style="width:900px">
			
				<input type="hidden" id="serverFileName" name="serverFileName"/>
				<input type="hidden" id="maintenance_id" name="maintenance_id"/>
			
				<div class="layer-base-btns">
					<a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
				</div>
				<div class="layer-base-title">유지보수 <span id="form_sub_title">등록/수정</span></div>
				<div class="layer-base-conts">
					<div class="bTable">
						<table>
							<colgroup>
								<col width="130" />
								<col width="*" />
								<col width="300" />
							</colgroup>
							<tbody>
								<tr>
									<th>지구명</th>
									<td>
										<select id="zone_id" name="zone_id_hid">
											<option value="">선택</option>
										</select>
									</td>
									<td>현장사진</td>
								</tr>
								<tr>
									<th>유지보수 종류</th>
									<td>
										<select id="type" name="type_hid">
											<option value="">선택</option>
										</select>
									</td>
									<td rowspan="7"><img id="uploadFileImg" src="" alt="" style="width:300px"></td>
								</tr>
								<tr>
									<th>유지보수 일자</th>
									<td>
										<input type="text" id="mt_date" name="mt_date" value="" placeholder="" datepicker="" class="flatpickr-input" readonly="readonly" />
									</td>
								</tr>
								<tr>
									<th>센서명</th>
									<td>
										<select id="asset_id" name="asset_id_hid">
											<option value="">선택</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>담당자</th>
									<td><input type="text" id="manager_name" name="manager_name" value="" placeholder="" /></td>
								</tr>
								<tr>
									<th>연락처</th>
									<td><input type="text" id="manager_tel" name="manager_tel" value="" placeholder="" /></td>
								</tr>
								<tr>
									<th>설명</th>
									<td><textarea name="description" id="description"></textarea></td>
								</tr>
								<tr>
									<th>현장사진첨부</th>
									<td><input type="file" id="uploadFile" name="uploadFile" value="" placeholder="" /></td>
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

        </section>
    </body>
</html>
