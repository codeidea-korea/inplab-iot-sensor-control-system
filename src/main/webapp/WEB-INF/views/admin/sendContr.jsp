<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>

	<style>
		#container {
			overflow: hidden;
		}
		#contents {
			min-height: unset;
		}
		#contents .contents-re {
			height: 70vh;
		}
		#footer {
			height: 13vh;
			background-color: #2b2946;
			margin-top: 1vh;
			border-radius: 1rem;
			display: flex;
			justify-content: space-between;
		}

		#footer .footerItem {
			width: 100%;
			padding: 1rem;
			color: #ddd;
			font-size: larger;
		}
		#footer .sendButtonArea {
			text-align: right;
		}

		h2.txt {
			width : 80%;
		}
		div.sendGroupArea {
			margin-top: -45px;
			margin-bottom: 1vh;
			float: right;
			background-color: white;
			width: 5.5vw;
		}
		select.sendGroup {
			width: 5vw;
			height: 3.6rem;
			font-weight: 300;
			font-size: 1.5rem;
			color: #47474c;
			display: inline-block;
			vertical-align: top;
			background: url("/images/bg_select_arr_m.png") no-repeat right center/1rem;
			line-height: 3.6rem;
			appearance: none;
			padding: 0 5px;
		}
		.sendButtonArea {
			display: flex;
			justify-content: flex-end;
			align-items: center;
		}

		.sendButtonArea div{
			background-color: white;
			margin: 0 1rem;
			padding: 0 0.3rem;
		}

		select.dp_location {
			width: 7vw;
			height: 3.6rem;
			font-weight: 300;
			font-size: 1.5rem;
			color: #47474c;
			display: inline-block;
			vertical-align: top;
			background: url("/images/bg_select_arr_m.png") no-repeat right center/1rem;
			line-height: 3.6rem;
			appearance: none;
			padding: 0 5px;
		}
		select.send_type {
			width: 3vw;
			height: 3.6rem;
			font-weight: 300;
			font-size: 1.5rem;
			color: #47474c;
			display: inline-block;
			vertical-align: top;
			background: url("/images/bg_select_arr_m.png") no-repeat right center/1rem;
			line-height: 3.6rem;
			appearance: none;
			padding: 0 5px;
		}
		.contents-re .bTable {
			height: calc(70vh - 12vh);
			overflow-y: auto;
		}
		.bTable>table>tbody>tr:first-child>*, .bTable>table th, .bTable>table td {
			border-color: white;
			color: #dbdbdb;
		}
		.bTable>table td {
			background-color: #1d1d28;
		}
		.rwd-table th:nth-child(1) {
			width: 35%; /* 첫 번째 셀 */
		}
		.rwd-table th {
			width: 13%; /* 나머지 셀 */
		}
		#lay-form-write .bTable>table>tbody>tr:first-child>*, .bTable>table th, .bTable>table td {
			border-color: unset;
			color: #dbdbdb;
		}
		#lay-form-write .bTable>table td {
			background-color: unset;
		}
		.modifyBtn {
			cursor: pointer;
		}
		.deleteBtn {
			cursor: pointer;
		}
		.sendBtn {
			height: 2.8rem;
			margin-left: 1rem;
			padding: 0 2rem;
			background-color: #6975ac;
			font-weight: 500;
			font-size: 1.4rem;
			line-height: 1;
			color: #fff;
			text-align: center;
			border-radius: 99px;
			display: flex;
			align-items: center;
			cursor: pointer;
		}
	</style>

	<script>
		var _popupClearData;

		var _columns = ${columns};

		const emptyTable = `<table style="height: 100%"><tr><td>등록된 데이터가 없습니다.</td></tr></table>`;

		$(function () {
			// 초기화할 데이터값
			_popupClearData = getSerialize('#lay-form-write');

			$('#sendGroup').on('change', function (e) {
				if(e.target.value === '' ){
					console.log('empty');
					emptyGrid();
					return false;
				}

				reloadGrid(e.target.value);
			});

			function reloadGrid(id) {
				console.log('reloadGrid', id);

				$.get("/admin/sendContr/list", {
					send_group_id : id
				}, function (res) {
					$('.insertBtn').show();
					$('.sendButtonArea').show();

					console.log(res);
					let normal = "";
					let emergency = "";

					$.each(res, function (idx, ele) {

						const json = encodeURIComponent(JSON.stringify(ele));

						let template = `<tr data-row='`+json+`'><td><img style="height: 80px;background-color: white;" src="` + ele.url_path + ele.filename + `" /></td>`
										+ `<td>`+ ele.dp_effect_name +`</td>`
										+ `<td>`+ ele.dp_time +`</td>`
										+ `<td>`+ ele.use_yn +`</td>`
										+ `<td><i class="fas fa-wrench modifyBtn"></i></td>`
										+ `<td><i class="fas fa-trash deleteBtn"></i></td></tr>`

						if(ele.send_type === "normal" ) {
							normal += template;
						} else {
							emergency += template;
						}
					});

					if(emergency.length > 0) {
						emergency = `<table class="rwd-table">
										<thead>
										<tr>
											<th>이미지</th>
											<th>효과</th>
											<th>표시시간(Sec)</th>
											<th>사용여부</th>
											<th>수정</th>
											<th>삭제</th>
										</tr>
										</thead>
										<tbody>`
								+ emergency + `</tbody></table>`
						;
					} else {
						emergency = emptyTable;
					}

					if(normal.length > 0) {
						normal = `<table class="rwd-table">
										<thead>
										<tr>
											<th>이미지</th>
											<th>효과</th>
											<th>표시시간(Sec)</th>
											<th>사용여부</th>
											<th>수정</th>
											<th>삭제</th>
										</tr>
										</thead>
										<tbody>`
								+ normal + `</tbody></table>`
						;
					} else {
						normal = emptyTable;
					}

					$('.bTable.normalTable').html(normal);
					$('.bTable.emergencyTable').html(emergency);
				});
			}

			// 등록
			$('.insertBtn').on('click', function () {

				$("#form_sub_title").html('등록');

				initForm();
				setSerialize('#lay-form-write', _popupClearData);

				$('#type').val($(this).data('type'));
				$('#send_group_id').val($('#sendGroup').val());

				popFancy('#lay-form-write');

				// 저장버튼 클릭시
				$('#lay-form-write input[type=submit]').off().on('click', function () {
					if (!validate('reg'))
						return;

					//파일업로드 1
					if ($("#uploadFile1")[0].files[0] != undefined) {
						var call_url = "/common/file/uploaddp"
						var serverFileName1 = genServerFileName() + getExtName($("#uploadFile1")[0].files[0].name);
						$("#filename").val(serverFileName1);//for db insert

						var form = new FormData();
						form.append("uploadFile", $("#uploadFile1")[0].files[0]);
						form.append("serverFileName", serverFileName1);

						fileUpload(call_url, form);
					}


					$.get('/admin/sendContr/add', getSerialize('#lay-form-write'), function (res) {
						alert('저장되었습니다.', function () {
							popFancyClose('#lay-form-write');
						});
						reloadGrid($('#sendGroup').val());
					});
				});
			});

			// 수정 팝업
			$(document).on('click', '.modifyBtn', function () {

				$("#form_sub_title").html('수정');

				const data = JSON.parse(decodeURIComponent($(this).closest("tr").data("row")));
				console.log(data);

				$("#uploadFileImg1").attr("src", '/common/dp/'+data.filename);
				$("#send_contr_id").val(data.send_contr_id);

				setSerialize('#lay-form-write', data);

				popFancy('#lay-form-write');

				// 저장버튼 클릭시
				$('#lay-form-write input[type=submit]').off().on('click', function () {
					if (!validate('mod'))
						return;

					//파일업로드 1
					if($("#uploadFile1")[0].files[0] != undefined){
						var call_url = "/common/file/uploaddp"
						var serverFileName1 = genServerFileName() + getExtName( $("#uploadFile1")[0].files[0].name );
						$("#new_filename").val(serverFileName1);//for db insert

						var form = new FormData();
						form.append( "uploadFile", $("#uploadFile1")[0].files[0] );
						form.append( "serverFileName", serverFileName1 );

						fileUpload(call_url, form);
					}

					$.get('/admin/sendContr/mod', getSerialize('#lay-form-write'), function (res) {
						alert('저장되었습니다.', function () {
							popFancyClose('#lay-form-write');
						});
						reloadGrid($('#sendGroup').val());
					});
				});
			});

			// 삭제
			$(document).on('click', '.deleteBtn', function () {
				const data = JSON.parse(decodeURIComponent($(this).closest("tr").data("row")));

				confirm('데이터를 삭제하시겠습니까?', function() {
					$.get('/admin/sendContr/del', data, function(res) {
						reloadGrid($('#sendGroup').val());
					});
				});
			});

			// 파일 선택(이미지 첨부)
			$("#uploadFile1").on("change", function (event) {
				var file1 = event.target.files[0];
				var reader1 = new FileReader();
				reader1.onload = function (e) {
					$('#uploadFileImg1').css("cursor", "");
					$('#uploadFileImg1').off('click');

					$("#uploadFileImg1").attr("src", e.target.result);
				}
				reader1.readAsDataURL(file1);
			});

			$('.sendBtn').on('click', function (e) {
				const data = {};
				data.send_group_id = $('#sendGroup').val();
				data.asset_id = $('#asset_id').val();
				data.send_type = $('#send_type').val();

				$.get('/admin/sendContr/send', data, function(res) {
					console.log(res);
					if (!res) {
						$('.footerItem ul').hide();
						return false;
					}
					let html = '<li>전송 ' + res.send_result + ' ( ' + res.send_time + ' )</li>'
							+ '<li>' + res.asset_name + '</li>'
							+ '<li>전송분류 ( ' + res.send_type + ' ) - 전송그룹 ( ' + res.send_group_name + ' )</li>';
					$('.footerItem ul').html(html);
				});
			});



		}); //jquery end

		function getExtName(name) {
			return name.substring(name.lastIndexOf('.'));
		}

		function fileUpload(call_url, form) {
			$.ajax({
				url: call_url
				, type: "POST"
				, processData: false
				, contentType: false
				, data: form
			});
		}

		function genServerFileName() {
			var date = new Date;
			var year = date.getFullYear();
			var month = date.getMonth() + 1;
			var day = date.getDate();
			var seconds = date.getSeconds();
			var minutes = date.getMinutes();
			var hour = date.getHours();
			var milliSeconds = date.getMilliseconds();
			return year + '' + month + '' + day + '' + hour + '' + month + '' + minutes + '' + seconds + '' + milliSeconds;
		}

		function initForm() {
			$('#lay-form-write input[name=uploadFile1]').val('');
			$("#uploadFileImg1").attr("src", '');
		}

		function validate(type) {
			var maxSizeMb = 10;
			var maxSize = maxSizeMb * 1024 * 1024; // 10MB

			if ($("#uploadFile1")[0].files[0] != undefined) {
				var fileSize = $("#uploadFile1")[0].files[0].size;
				if (fileSize > maxSize) {
					alert("파일1은 " + maxSizeMb + "MB 이내로 등록 가능합니다.");
					$("#uploadFile1").val("");
					return false;
				}

				if ($("#uploadFile1").val() != "") {
					var ext = $("#uploadFile1").val().split(".").pop().toLowerCase();
					if ($.inArray(ext, ['jpg', 'jpeg', 'png', 'bmp']) == -1) {
						alert("이미지 파일(jpg,jpeg,png,bmp)만 등록 가능합니다.");
						$("#uploadFile1").val("");
						return false;
					}
				}
			} else if(type === 'reg') { // 등록시에만 체크
				alert('이미지를 등록해주세요.');
				return false;
			}

			return true;
		}

		function emptyGrid() {
			$('.bTable.normalTable').html(emptyTable);
			$('.bTable.emergencyTable').html(emptyTable);
			$('.insertBtn').hide();
			$('.sendButtonArea').hide();
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
			<span class="arr">전광판관리</span>
			<span class="arr">전송 제어</span>
		</h2>
		<div class="sendGroupArea">
			<select class="sendGroup" id="sendGroup" name="sendGroup">
				<option value="">선택</option>
				<c:forEach items="${sendGroups}" var="item">
					<option value="${item.send_group_id}">${item.send_group_name}</option>
				</c:forEach>
			</select>
		</div>
		<div id="contents">
			<div class="contents-re">
				<h3 class="txt">평시 이미지 (평시 전광판 메시지 송출하는 기능)</h3>
				<div class="btn-group">
					<a class="insertBtn" data-type="normal" style="display: none">등록</a>
				</div>
				<div class="bTable normalTable">
					<table style="height: 100%"><tr><td>등록된 데이터가 없습니다.</td></tr></table>
				</div>
			</div>
			<div class="contents-re">
				<h3 class="txt">긴급 이미지 (긴급으로 전광판 메시지 송출하는 기능)</h3>
				<div class="btn-group">
					<a class="insertBtn" data-type="emergency" style="display: none">등록</a>
				</div>
				<div class="bTable emergencyTable">
					<table style="height: 100%"><tr><td>등록된 데이터가 없습니다.</td></tr></table>
				</div>
			</div>
		</div>
		<div id="footer">
			<div class="footerItem">
				<h3 class="txt">최근 전송 현황</h3>
				<ul>
				<c:if test="${not empty log}">
					<li>전송 ${log.send_result} ( ${log.send_time} )</li>
					<li>${log.asset_name}</li>
					<li>전송분류 ( ${log.send_type} ) - 전송그룹 ( ${log.send_group_name} )</li>
				</c:if>
				</ul>
			</div>
			<div class="footerItem sendButtonArea" style="display: none;">
				<div>
					<select name="asset_id" id="asset_id" class="dp_location">
						<c:forEach items="${assetList}" var="item">
							<option value="${item.asset_id}">${item.name}</option>
						</c:forEach>
					</select>
				</div>
				<div>
					<select name="send_type" id="send_type" class="send_type">
						<option value="normal">평시</option>
						<option value="emergency">긴급</option>
					</select>
				</div>
				<button class="sendBtn">전송</button>
			</div>
		</div>
	</div>
	<!--[e] 컨텐츠 영역 -->

	<!--[s] 등록 팝업 -->
	<div id="lay-form-write" class="layer-base">
		<div class="layer-base-btns">
			<a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
		</div>
		<div class="layer-base-title">전송제어 <span id="form_sub_title">등록/수정</span></div>
		<div class="layer-base-conts">
			<div class="bTable">
				<table>
					<colgroup>
						<col width="130">
						<col width="*">
					</colgroup>
					<tbody>
					<tr>
						<th>전광판 표시효과</th>
						<td>
							<select name="dp_effect">
								<c:forEach items="${types}" var="item">
									<option value="${item.code}">${item.name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>전송그룹</th>
						<td>
							<select name="send_group_id">
								<c:forEach items="${sendGroups}" var="item">
									<option value="${item.send_group_id}">${item.send_group_name}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>사용 여부</th>
						<td>
							<select name="use_yn">
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>표시시간</th>
						<td>
							<select name="dp_time">
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4" selected>4</option>
								<option value="5">5</option>
								<option value="6">6</option>
								<option value="7">7</option>
								<option value="8">8</option>
							</select>
						</td>
					</tr>
					<tr>
						<th rowspan="2">이미지 선택</th>
						<td style="height:250px"><img id="uploadFileImg1" src="" alt="" style="width:300px"></td>
					</tr>
					<tr>
						<td>
							<input type="file" id="uploadFile1" name="uploadFile1" value="" placeholder="" />
							<input type="hidden" name="new_filename" id="new_filename"/>
							<input type="hidden" name="filename" id="filename"/>
							<input type="hidden" name="send_type" id="type"/>
							<input type="hidden" name="send_contr_id" id="send_contr_id"/>
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
	<!--[e] 등록 팝업 -->
</section>
</body>
</html>
