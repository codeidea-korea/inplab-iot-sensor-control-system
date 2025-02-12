<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
    <head>
	    <jsp:include page="../common/include_head.jsp" flush="true" />
		<script type="text/javascript" src="/admin_add.js"></script>
        <script>
			const limit = 25;
			let offset = 0;

			const checkboxFormatter = (cellValue, options, rowObject) => {
				return '<input type="checkbox" class="row-checkbox" value="'+rowObject.cctv_no+'">';
			};

			const column = [
				{name: 'checkbox', index: 'checkbox', width: 35, align: 'center', sortable: false, hidden: false, formatter: checkboxFormatter},
				{name : 'cctv_no', index : 'cctv_no', width: 100, align : 'center', hidden:false},
				{name : 'cctv_nm', index : 'cctv_nm', align : 'center', hidden:false},
				{name : 'model_nm', index : 'model_nm', align : 'center', hidden:false},
				{name : 'cctv_make', index : 'cctv_make', align : 'center', hidden:false},
				{name : 'inst_ymd', index : 'inst_ymd', width: 120, align : 'center', hidden:false},
				{name : 'cctv_ip', index : 'cctv_ip', align : 'center', hidden:false},
				{name : 'web_port', index : 'web_port', width: 80, align : 'center', hidden:false},
				{name : 'rtsp_port', index : 'rtsp_port', width: 80, align : 'center', hidden:false},
				{name : 'cctv_conn_id', index : 'cctv_conn_id', align : 'center', hidden:false},
				{name : 'relay_nm', index : 'relay_nm', align : 'center', hidden:false},
				{name : 'relay_ip', index : 'relay_ip', align : 'center', hidden:false},
				{name : 'relay_port', index : 'relay_port', width: 90, align : 'center', hidden:false},
			];

			const header = ['','CCTV ID','CCTV 명','모델명','제조사명','설치일자','연결IP(DDNS)','Web Port','RTSP Port','접속 ID','릴레이명','릴레이 IP','릴레이 Port'];

			const getCctv = (obj) => {
				return new Promise((resolve, reject) => {
					$.ajax({
						type: 'GET',
						url: `/adminAdd/cctv/cctv`,
						dataType: 'json',
						contentType: 'application/json; charset=utf-8',
						async: true,
						data: obj
					}).done(function(res) {
						resolve(res);
					}).fail(function(fail) {
						reject(fail);
						console.log('getCctv fail > ', fail);
						alert2('CCTV 정보를 가져오는데 실패했습니다.', function() {});
					});
				});
			};

			const insCctv = (array) => {
				return new Promise((resolve, reject) => {
					$.ajax({
						type: 'POST',
						url: `/adminAdd/cctv/cctv`,
						dataType: 'json',
						contentType: 'application/json; charset=utf-8',
						async: true,
						data: JSON.stringify(array)
					}).done(function(res) {
						resolve(res);
					}).fail(function(fail) {
						reject(fail);
						console.log('insCctv fail > ', fail);
						alert2('CCTV 등록하는데 실패했습니다.', function() {});
					});
				});
			};

			const udtCctv = (array) => {
				return new Promise((resolve, reject) => {
					$.ajax({
						type: 'PUT',
						url: `/adminAdd/cctv/cctv`,
						dataType: 'json',
						contentType: 'application/json; charset=utf-8',
						async: true,
						data: JSON.stringify(array)
					}).done(function(res) {
						resolve(res);
					}).fail(function(fail) {
						reject(fail);
						alert2('CCTV 수정하는데 실패했습니다.', function() {});
					});
				});
			};

			const actionDelCctv = (cctv_no) => {
				udtCctv([{cctv_no: cctv_no, del_yn: 'Y'}]).then((res) => {
					if (res.count?.pass > 0) {
						alert2(res?.pass_list[0]?.message, function() {});
						return;
					}
					if (res.count?.del === 0) {
						alert2('CCTV 정보가 삭제되지 않았습니다.', function() {});
						return;
					}
					alert2('CCTV 정보가 삭제되었습니다.', function () {
						popFancyClose('#lay-form-write08');
						const search_cctv_nm = $('input[name=search_cctv_nm]').val();
						offset = 0;
						getCctv({cctv_nm: search_cctv_nm, limit: limit, offset: offset}).then((res) => {
							$("#jqGrid").jqGrid('clearGridData');
							$("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
						}).catch((fail) => {
							console.log('setJqGridTable fail > ', fail);
						});
					});
				}).catch((fail) => {
					console.log('delCctv fail > ', fail);
					alert2('CCTV 정보 삭제에 실패했습니다.', function() {});
				});
			};

			const initForm = () => {
				$('#lay-form-write08').find('input').not('#ins_cctv, #udt_cctv, #del_cctv').val('');
				$('#lay-form-write08').find('select').prop('selectedIndex', 0);
			};

			const validCheck = () => {
				let result = false;
				const cctv_no = $('input[name=cctv_no]').val();
				const cctv_nm = $('input[name=cctv_nm]').val();
				const district_no = $('select[name=district_no]').val();
				const cctv_conn_id = $('input[name=cctv_conn_id]').val();
				const cctv_conn_pwd = $('input[name=cctv_conn_pwd]').val();
				const cctv_ip = $('input[name=cctv_ip]').val();
				const web_port = $('input[name=web_port]').val();
				const rtsp_port = $('input[name=rtsp_port]').val();
				const relay_nm = $('input[name=relay_nm]').val();
				const relay_ip = $('input[name=relay_ip]').val();
				const relay_port = $('input[name=relay_port]').val();
				const inst_ymd = $('input[name=inst_ymd]').val().replaceAll('-', '');
				const maint_sts_cd = $('select[name=maint_sts_cd]').val();
				const cctv_lat = $('input[name=cctv_lat]').val();
				const cctv_lon = $('input[name=cctv_lon]').val();
				const model_nm = $('input[name=model_nm]').val();
				const cctv_maker = $('input[name=cctv_maker]').val();
				const admin_center = $('input[name=admin_center]').val();
				const partner_comp_id = $('select[name=partner_comp_id]').val();
				const partner_comp_user_nm = $('input[name=partner_comp_user_nm]').val();
				const partner_comp_user_phone = $('input[name=partner_comp_user_phone]').val();

				const obj = {
					cctv_no : cctv_no,
					cctv_nm : cctv_nm,
					district_no : district_no,
					cctv_conn_id : cctv_conn_id,
					cctv_conn_pwd : cctv_conn_pwd,
					cctv_ip : cctv_ip,
					web_port : web_port,
					rtsp_port : rtsp_port,
					relay_nm : relay_nm,
					relay_ip : relay_ip,
					relay_port : relay_port,
					inst_ymd : inst_ymd,
					maint_sts_cd : maint_sts_cd,
					cctv_lat : cctv_lat,
					cctv_lon : cctv_lon,
					model_nm : model_nm,
					cctv_maker : cctv_maker,
					admin_center : admin_center,
					partner_comp_id : partner_comp_id,
					partner_comp_user_nm : partner_comp_user_nm,
					partner_comp_user_phone : partner_comp_user_phone,
				};

				if (cctv_nm === '' || cctv_nm === undefined) {
					$('input[name=cctv_nm]').focus();
					result = true;
				} else if (district_no === '' || district_no === undefined) {
					$('select[name=district_no]').focus();
					result = true;
				} else if (cctv_conn_id === '' || cctv_conn_id === undefined) {
					$('input[name=cctv_conn_id]').focus();
					result = true;
				} else if (cctv_conn_pwd === '' || cctv_conn_pwd === undefined) {
					$('input[name=cctv_conn_pwd]').focus();
					result = true;
				} else if (cctv_ip === '' || cctv_ip === undefined) {
					$('input[name=cctv_ip]').focus();
					result = true;
				} else if (isNaN(web_port)) {
					alert2('Web Port는 숫자만 입력해주세요.', function() {
						$('input[name=web_port]').focus();
					});
					result = true;
				} else if (isNaN(rtsp_port)) {
					alert2('RTSP Port는 숫자만 입력해주세요.', function() {
						$('input[name=rtsp_port]').focus();
					});
					result = true;
				} else if (relay_nm === '' || relay_nm === undefined) {
					$('input[name=relay_nm]').focus();
					result = true;
				} else if (relay_ip === '' || relay_ip === undefined) {
					$('input[name=relay_ip]').focus();
					result = true;
				} else if (isNaN(relay_port)) {
					alert2('릴레이 Port는 숫자만 입력해주세요.', function() {
						$('input[name=relay_port]').focus();
					});
					result = true;
				} else if (inst_ymd === '' || inst_ymd === undefined) {
					$('input[name=inst_ymd]').focus();
					result = true;
				} else if (maint_sts_cd === '' || maint_sts_cd === undefined) {
					$('select[name=maint_sts_cd]').focus();
					result = true;
				} else if (isNaN(cctv_lat)) {
					alert2('위도는 숫자만 입력해주세요.', function () {
						$('input[name=cctv_lat]').focus();
					});
					result = true;
				} else if (isNaN(cctv_lon)) {
					alert2('경도는 숫자만 입력해주세요.', function () {
						$('input[name=cctv_lon]').focus();
					});
					result = true;
				} else if (model_nm === '' || model_nm === undefined) {
					$('input[name=model_nm]').focus();
					result = true;
				} else if (cctv_maker === '' || cctv_maker === undefined) {
					$('input[name=cctv_maker]').focus();
					result = true;
				}
				return {isValid : result, obj : obj};
			};

			const setCctv = (data) => {
				$('input[name=cctv_no]').val(data.cctv_no);
				$('input[name=cctv_nm]').val(data.cctv_nm);
				$('select[name=district_no]').val(data.district_no);
				$('input[name=cctv_conn_id]').val(data.cctv_conn_id);
				$('input[name=cctv_conn_pwd]').val(data.cctv_conn_pwd);
				$('input[name=cctv_ip]').val(data.cctv_ip);
				$('input[name=web_port]').val(data.web_port);
				$('input[name=rtsp_port]').val(data.rtsp_port);
				$('input[name=relay_nm]').val(data.relay_nm);
				$('input[name=relay_ip]').val(data.relay_ip);
				$('input[name=relay_port]').val(data.relay_port);
				$('input[name=inst_ymd]').val(data.inst_ymd);
				$('input[name=inst_sts_cd]').val(data.inst_sts_cd);
				$('input[name=cctv_lat]').val(data.cctv_lat);
				$('input[name=cctv_lon]').val(data.cctv_lon);
				$('input[name=model_nm]').val(data.model_nm);
				$('input[name=cctv_maker]').val(data.cctv_maker);
				$('select[name=maint_sts_cd]').val(data.maint_sts_cd);
				$('input[name=admin_center]').val(data.admin_center);
				$('select[name=partner_comp_id]').val(data.partner_comp_id);
				$('input[name=partner_comp_user_nm]').val(data.partner_comp_user_nm);
				$('input[name=partner_comp_user_phone]').val(data.partner_comp_user_phone);
			};

            $(function () {
				$("[datepicker]").flatpickr({
					locale: "ko",
					dateFormat: "Y-m-d",
					onClose: function (selectedDates, dateStr, instance) {},
				});

				getCctv({limit : limit, offset : offset}).then((res) => {
					console.log('res > ', res);
					setJqGridTable(res.rows, column, header, function () {}, onSelectRow, ['cctv_no'], 'jqGrid', limit, offset, getCctv);
				}).catch((fail) => {
					console.log('setJqGridTable fail > ', fail);
				});

				$('.searchtBtn').on('click', function() {
					const cctv_nm = $('input[name=search_cctv_nm]').val();
					offset = 0;
					getCctv({cctv_nm : cctv_nm, limit : limit, offset : offset}).then((res) => {
						$("#jqGrid").jqGrid('clearGridData');
						$("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
					}).catch((fail) => {
						console.log('setJqGridTable fail > ', fail);
					});
				});

				$('.insertBtn').on('click', function() {
					initForm();

					$.get('/adminAdd/cctv/max-no', null, (res) => {
						if (res !== null && res !== undefined) {
							const newId = 'T' + (parseInt(res.substring(1)) + 1).toString().padStart(2, '0');
							$('input[name=cctv_no]').val(newId)
						}
					});

					Promise.all([getMaintCompInfo({partner_type_flag : '1'}), getDistrictInfo()]).then(([res1, res2]) => {
						let partner_comp_id = $('select[name=partner_comp_id]');
						partner_comp_id.empty();
						partner_comp_id.append('<option value="">선택</option>');
						$.each(res1.rows, function(index, item) {
							partner_comp_id.append('<option value="' + item.partner_comp_id + '">' + item.partner_comp_nm + '</option>');
						});

						let district_nm = $('select[name=district_no]');
						district_nm.empty();
						district_nm.append('<option value="">선택</option>');
						$.each(res2.rows, function(index, item) {
							district_nm.append('<option value="' + item.district_no + '">' + item.district_nm + '</option>');
						});
						$("#form_sub_title").html('신규 등록');
						$('#ins_cctv').show();
						$('#udt_cctv').hide();
						$('#del_cctv').hide();

						popFancy('#lay-form-write08');
					}).catch((fail) => {
						console.log('fail > ', fail);
					});
				});

				$('#ins_cctv').on('click', function() {
					let array = [];
					const {isValid, obj} = validCheck();

					if (isValid) {
						return;
					}

					array.push(obj);
					insCctv(array).then((res) => {
						if (res.count?.pass > 0) {
							alert2(res?.pass_list[0]?.message, function() {});
							return;
						}
						if (res.count?.ins === 0) {
							alert2('CCTV 정보가 등록되지 않았습니다.', function() {});
							return;
						}
						alert2('CCTV 정보가 등록되었습니다.', function () {
							popFancyClose('#lay-form-write08');
							const search_cctv_nm = $('input[name=search_cctv_nm]').val();
							offset = 0;
							getCctv({cctv_nm : search_cctv_nm, limit : limit, offset : offset}).then((res) => {
								$("#jqGrid").jqGrid('clearGridData');
								$("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
							}).catch((fail) => {
								console.log('setJqGridTable fail > ', fail);
							});
						});
					}).catch((fail) => {
						console.log('insCctv fail > ', fail);
						alert2('CCTV 정보 등록에 실패했습니다.', function() {});
					});
				});

				$('#udt_cctv').on('click', function() {
					let array = [];
					const {isValid, obj} = validCheck();

					if (isValid) {
						return;
					}

					array.push(obj);

					udtCctv(array).then((res) => {
						if (res.count?.pass > 0) {
							alert2(res?.pass_list[0]?.message, function() {});
							return;
						}
						if (res.count?.udt === 0) {
							alert2('CCTV 정보가 수정되지 않았습니다.', function() {});
							return;
						}
						alert2('CCTV 정보가 수정되었습니다.', function () {
							popFancyClose('#lay-form-write08');
							const search_cctv_nm = $('input[name=search_cctv_nm]').val();
							offset = 0;
							getCctv({cctv_nm : search_cctv_nm, limit : limit, offset : offset}).then((res) => {
								$("#jqGrid").jqGrid('clearGridData');
								$("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
							}).catch((fail) => {
								console.log('setJqGridTable fail > ', fail);
							});
						});
					}).catch((fail) => {
						console.log('insCctv fail > ', fail);
						alert2('CCTV 정보 수정에 실패했습니다.', function() {});
					});
				});

                // 수정 팝업
                $('.modifyBtn').on('click', function() {
					const cctv_no = $("#jqGrid").jqGrid('getGridParam', 'selrow');

					if (cctv_no === null) {
						alert2('CCTV를 선택해주세요.', function() {});
						return;
					}

					initForm();

					Promise.all([getCctv({cctv_no : cctv_no}), getDistrictInfo(), getMaintCompInfo({partner_type_flag: '1'})]).then(([res1, res2, res3]) => {
						if (res1.rows.length === 0) {
							alert2('불러온 CCTV 정보가 없습니다.', function() {});
							return;
						} else if (res1.rows.length > 1) {
							alert2('불러온 CCTV 정보가 2개 이상입니다.', function() {});
							return;
						}

						let district_nm = $('select[name=district_no]');
						district_nm.empty();
						district_nm.append('<option value="">선택</option>');
						$.each(res2.rows, function(index, item) {
							district_nm.append('<option value="' + item.district_no + '">' + item.district_nm + '</option>');
						});

						let partner_comp_id = $('select[name=partner_comp_id]');
						partner_comp_id.empty();
						partner_comp_id.append('<option value="">선택</option>');
						$.each(res3.rows, function(index, item) {
							partner_comp_id.append('<option value="' + item.partner_comp_id + '">' + item.partner_comp_nm + '</option>');
						});

						setCctv(res1.rows[0]);
						$("#form_sub_title").html('상세 정보');
						$('#ins_cctv').hide();
						$('#udt_cctv').show();
						$('#del_cctv').show();
						popFancy('#lay-form-write08');
					}).catch((fail) => {
						console.log('fail > ', fail);
					});
                });

				$('#del_cctv').on('click', function() {
					const cctv_no = $('input[name=cctv_no]').val();
					if (cctv_no === '') {
						alert2('CCTV를 선택해주세요.', function() {});
						return;
					}
					confirm2('CCTV 정보를 삭제하시겠습니까?', function() {
						actionDelCctv(cctv_no);
					});
				});

                $('.excelBtn').on('click', function() {
					const obj = makeExcelData('CCTV 관리');
					listExcelDown(obj);
                });

				$('input[name=search_cctv_nm]').on('keypress', function(e) {
					if (e.key === 'Enter') {
						$('.searchtBtn').trigger('click');
					}
				});
			});
        </script>
	
	</head>

	<body data-pgcode="0000">
		<section id="wrap">
		    <jsp:include page="../common/include_top.jsp" flush="true" />
		    <div id="global-menu">
		        <jsp:include page="../common/include_sidebar.jsp" flush="true" />
		    </div>
				<div id="container">
					<h2 class="txt">
						관리자 전용 
						<span class="arr">장치 관리</span>
					</h2>
	                <div id="contents">
	                    <div class="contents-re">
	                        <h3 class="txt">CCTV 관리</h3>
	                        <div class="btn-group">
								<input type="text" name="search_cctv_nm" placeholder="CCTV명" style="background-color: white; font-size: medium;"/>
								<a class="searchtBtn">검색</a>
	                            <a class="insertBtn">신규등록</a>
	                            <a class="modifyBtn">상세정보</a>
	                            <a class="excelBtn">다운로드</a>
	                        </div>
	                        <div class="contents-in">
								<table id="jqGrid"></table>
	                        </div>
	                    </div>
	                </div>
				</div>
			<div id="lay-form-write08" class="layer-base">
				<div class="layer-base-btns">
					<a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
				</div>
				<div class="layer-base-title">CCTV <span id="form_sub_title"></span></div>
				<div class="layer-base-conts">
					<div class="bTable">
						<table>
							<colgroup>
								<col width="130" />
								<col width="*" />
								<col width="130" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr id="tr_cctv_no">
									<th>CCTV ID <span style="color: red">*</span></th>
									<td colspan="3">
										<input type="text" name="cctv_no" value="" readonly>
									</td>
								</tr>
								<tr>
									<th>CCTV 명 <span style="color: red">*</span></th>
									<td colspan="3">
										<input type="text" name="cctv_nm"/>
									</td>
								</tr>
								<tr>
									<th>현장명 <span style="color: red">*</span></th>
									<td colspan="3">
										<select id="district_no" name="district_no">
											<option value="">선택</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>접속ID <span style="color: red">*</span></th>
									<td><input type="text" name="cctv_conn_id"/></td>
									<th>접속PWD <span style="color: red">*</span></th>
									<td><input type="text" name="cctv_conn_pwd"/></td>
								</tr>
								<tr>
									<th>IP(DDNS) <span style="color: red">*</span></th>
									<td colspan="3"><input type="text" name="cctv_ip"/></td>
								</tr>
								<tr>
									<th>WEB Port <span style="color: red">*</span></th>
									<td><input type="text" name="web_port"/></td>
									<th>RTSP Port <span style="color: red">*</span></th>
									<td><input type="text" name="rtsp_port"/></td>
								</tr>
								<tr>
									<th>릴레이명 <span style="color: red">*</span></th>
									<td colspan="3"><input type="text" name="relay_nm"/></td>
								</tr>
								<tr>
									<th>릴레이 IP <span style="color: red">*</span></th>
									<td><input type="text" name="relay_ip"/></td>
									<th>릴레이 Port <span style="color: red">*</span></th>
									<td><input type="text" name="relay_port"/></td>
								</tr>
								<tr>
									<th>설치일자 <span style="color: red">*</span></th>
									<td>
										<input type="text" id="inst_ymd" name="inst_ymd" value="" placeholder="" datepicker="" class="flatpickr-input" readonly="readonly" />
									</td>
									<th>설치상태 <span style="color: red">*</span></th>
									<td>
										<select name="maint_sts_cd">
											<option value="">선택</option>
											<option value="MTN001">정상</option>
											<option value="MTN002">망실</option>
											<option value="MTN003">점검</option>
											<option value="MTN004">망실(철거)</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>위도 <span style="color: red">*</span></th>
									<td>
										<input type="text" name="cctv_lat" />
									</td>
									<th>경도 <span style="color: red">*</span></th>
									<td>
										<input type="text" name="cctv_lon" />
									</td>
								</tr>
								<tr>
									<th>모델명 <span style="color: red">*</span></th>
									<td>
										<input type="text" name="model_nm" />
									</td>
									<th>제조사 <span style="color: red">*</span></th>
									<td>
										<input type="text" name="cctv_maker" />
									</td>
								</tr>
								<tr>
									<th>관리사무소</th>
									<td>
										<input type="text" name="admin_center" />
									</td>
									<th>계측사</th>
									<td>
										<select name="partner_comp_id">
											<option value="">선택</option>
										</select>
									</td>
								</tr>
								<tr>
									<th>계측담당자</th>
									<td>
										<input type="text" name="partner_comp_user_nm" />
									</td>
									<th>담당 연락처</th>
									<td>
										<input type="text" name="partner_comp_user_phone" />
									</td>
								</tr>
							</tbody>
						</table>

					</div>
					<div class="btn-btm">
						<input type="button" blue value="저장" id="ins_cctv"/>
						<input type="button" blue value="수정" id="udt_cctv"/>
						<input type="button" red value="삭제" id="del_cctv"/>
						<button type="button" data-fancybox-close>닫기</button>
					</div>
				</div>
			</div>
			<!--[e] 사용자 등록 팝업 -->
		</section>
	</body>
</html>
