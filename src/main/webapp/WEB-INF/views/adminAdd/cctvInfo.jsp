<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
	    <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>
	
	    <style></style>
	
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

			// 각 행에 체크박스를 추가하는 코드
			const addCheckboxToGrid = () => {
				const ids = $("#jqGrid").jqGrid('getDataIDs');
				for (let i = 0; i < ids.length; i++) {
					const id = ids[i];
					$("#jqGrid").jqGrid('setRowData', id, {
						checkbox: "<input type='checkbox' class='row-checkbox' data-id='" + id + "'>"
					});
				}
			};

			const onSelectRow = (rowId) => {
				// 모든 체크박스를 먼저 해제합니다.
				$('input[type="checkbox"]').prop('checked', false);

				// 클릭된 row의 첫 번째 체크박스를 체크합니다.
				let $checkbox = $('#' + rowId).find('input[type="checkbox"]').first();
				$checkbox.prop('checked', true);
			};

			const gridComplete = () => {
				// 헤더에 체크박스 추가
				const $grid = $("#jqGrid");
				const $headerCheckbox = $('<input type="checkbox" id="header-checkbox"/>');
				$grid.closest(".ui-jqgrid-view")
						.find("th:first")
						.html($headerCheckbox);

				// 헤더 체크박스 클릭 시 모든 행의 체크박스를 선택 또는 해제
				$headerCheckbox.on('click', function() {
					const isChecked = $(this).is(':checked');
					const rowIds = $grid.jqGrid('getDataIDs');
					for (let i = 0; i < rowIds.length; i++) {
						let rowId = rowIds[i];
						// 행의 체크박스에 체크 또는 해제
						$("#jqGrid").find("tr[id='" + rowId + "']").find("input[type='checkbox']").prop('checked', isChecked);
					}
				});
			};

			const setJqGridTable = (data, column, gridComplete, onSelectRow) => {

				const formattedData = data.map(item => ({
					id: item.cctv_no, // cctv_no 값을 id로 설정
					...item
				}));

				$("#jqGrid").jqGrid({
					datatype: "local",
					data: formattedData,
					height: $('.contents-in').height() - 50,
					width: '100%',
					autowidth: true,
					shrinkToFit: true,
					scroll: true,
					loadtext: "로딩중...",
					colNames : header,
					colModel:column,
					gridComplete: gridComplete,
					onSelectRow: onSelectRow,
				});

				$('#jqGrid').closest(".ui-jqgrid-bdiv").on("scroll", function() {
					const $grid = $(this);
					// 스크롤이 맨 아래에 도달했는지 확인
					if ($grid.scrollTop() + $grid.innerHeight() >= $grid[0].scrollHeight) {
						// 스크롤을 빠르게 이동시 랜더링 꼬임 이슈로 setTimeout 사용
						setTimeout(() => {
							offset += limit;
							getCctv({limit : limit, offset : offset}).then((res) => {
								console.log('res > ', res);
								if (res.rows.length === 0) {
									offset -= limit;
								}
								$("#jqGrid").jqGrid('addRowData', 'cctv_no', res.rows);
								//addCheckboxToGrid();
							}).catch((fail) => {
								console.log('setJqGridTable fail > ', fail);
							});
						}, 500);
					}
				});

				$('#jqGrid').on('click', 'input[type="checkbox"]', function() {
					const $this = $(this);
					if (!$this.prop('checked')) {
						$this.prop('checked', false);
					} else {
						$('#jqGrid input[type="checkbox"]').prop('checked', false);
						$this.prop('checked', true);
					}
				});
			};

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
						console.log('/adminAdd/cctv fail > ', fail);
						alert('CCTV 정보를 가져오는데 실패했습니다.');
					});
				});
			};

			const makeExcelData = (file_name) => {
				let obj = {};
				let headerArray = [];
				let totalRowArray = [];

				$('.ui-common-table').eq(0).find('div[id^=jqgh_jqGrid_]').each(function() {
					headerArray.push($(this).text());
				});

				$('#jqGrid').eq(0).find('tr').each(function(index) {
					if (index === 0) return;
					let rowArray = [];
					$(this).find('td').each(function() {
						if ($(this).attr('aria-describedby') === 'jqGrid_checkbox') return;
						rowArray.push($(this).text());
					});
					totalRowArray.push(rowArray);
				});

				obj = {
					header : headerArray,
					rows : totalRowArray,
					file_name : file_name,
				};

				return obj;
			};

			const listExcelDown = (obj) => {
				let request = new XMLHttpRequest();
				request.open("POST", "/adminAdd/excel/down", true);
				request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
				request.responseType = "blob";

				request.onload = function(e) {

					let filename = "";
					let disposition = request.getResponseHeader("Content-Disposition");
					if (disposition && disposition.indexOf("attachment") !== -1) {
						let filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
						let matches = filenameRegex.exec(disposition);
						if (matches != null && matches[1])
							filename = decodeURI( matches[1].replace(/['"]/g, "") );
					}
					console.log("FILENAME: " + filename);

					if (this.status === 200) {
						let blob = this.response;
						if(window.navigator.msSaveOrOpenBlob) {
							window.navigator.msSaveBlob(blob, filename);
						}
						else{
							let downloadLink = window.document.createElement("a");
							let contentTypeHeader = request.getResponseHeader("Content-Type");
							downloadLink.href = window.URL.createObjectURL(new Blob([blob], { type: contentTypeHeader }));
							downloadLink.download = filename;
							document.body.appendChild(downloadLink);
							downloadLink.click();
							document.body.removeChild(downloadLink);
						}
					}
				};
				request.send(JSON.stringify(obj));
			};

			const initForm = () => {
				$('#lay-form-write08').find('input').not('#ins_cctv, #udt_cctv, #del_cctv').val('');
				$('#lay-form-write08').find('select').prop('selectedIndex', 0);
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
						console.log('/adminAdd/cctv fail > ', fail);
						alert('CCTV 등록하는데 실패했습니다.');
					});
				});
			};

			const getDistrictInfo = () => {
				return new Promise((resolve, reject) => {
					$.ajax({
						type: 'GET',
						url: `/adminAdd/cctv/district`,
						dataType: 'json',
						contentType: 'application/json; charset=utf-8',
						async: true,
					}).done(function(res) {
						resolve(res);
					}).fail(function(fail) {
						reject(fail);
						console.log('/adminAdd/cctv/district fail > ', fail);
						alert('현장 정보를 가져오는데 실패했습니다.');
					});
				});
			};

			const getMaintCompInfo = (obj) => {
				return new Promise((resolve, reject) => {
					$.ajax({
						type: 'GET',
						url: `/adminAdd/cctv/maintComp`,
						dataType: 'json',
						contentType: 'application/json; charset=utf-8',
						async: true,
						data: obj
					}).done(function(res) {
						resolve(res);
					}).fail(function(fail) {
						reject(fail);
						console.log('/adminAdd/cctv/maintComp fail > ', fail);
						alert('유지보수 업체 정보를 가져오는데 실패했습니다.');
					});
				});
			};

			const validCheck = () => {
				let result = false;

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
				const inst_sts_cd = $('input[name=inst_sts_cd]').val();
				const cctv_lat = $('input[name=cctv_lat]').val();
				const cctv_lon = $('input[name=cctv_lon]').val();
				const model_nm = $('input[name=model_nm]').val();
				const cctv_maker = $('input[name=cctv_maker]').val();
				const maint_sts_cd = $('select[name=maint_sts_cd]').val();
				const admin_center = $('input[name=admin_center]').val();
				const partner_comp_id = $('input[name=partner_comp_id]').val();
				const partner_comp_user_nm = $('input[name=partner_comp_user_nm]').val();
				const partner_comp_user_phone = $('input[name=partner_comp_user_phone]').val();

				const obj = {
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
					inst_sts_cd : inst_sts_cd,
					cctv_lat : cctv_lat,
					cctv_lon : cctv_lon,
					model_nm : model_nm,
					cctv_maker : cctv_maker,
					maint_sts_cd : maint_sts_cd,
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
					alert('Web Port는 숫자만 입력해주세요.');
					$('input[name=web_port]').focus();
					result = true;
				} else if (isNaN(rtsp_port)) {
					alert('RTSP Port는 숫자만 입력해주세요.');
					$('input[name=rtsp_port]').focus();
					result = true;
				} else if (relay_nm === '' || relay_nm === undefined) {
					$('input[name=relay_nm]').focus();
					result = true;
				} else if (relay_ip === '' || relay_ip === undefined) {
					$('input[name=relay_ip]').focus();
					result = true;
				} else if (isNaN(relay_port)) {
					alert('릴레이 Port는 숫자만 입력해주세요.');
					$('input[name=relay_port]').focus();
					result = true;
				} else if (inst_ymd === '' || inst_ymd === undefined) {
					$('input[name=inst_ymd]').focus();
					result = true;
				} else if (inst_sts_cd === '' || inst_sts_cd === undefined) {
					$('select[name=inst_sts_cd]').focus();
					result = true;
				} else if (isNaN(cctv_lat)) {
					alert('위도는 숫자만 입력해주세요.');
					$('select[name=cctv_lat]').focus();
					result = true;
				} else if (isNaN(cctv_lon)) {
					alert('경도는 숫자만 입력해주세요.');
					$('input[name=ccvt_lon]').focus();
					result = true;
				} else if (model_nm === '' || model_nm === undefined) {
					$('input[name=model_nm]').focus();
					result = true;
				} else if (cctv_maker === '' || cctv_maker === undefined) {
					$('input[name=cctv_maker]').focus();
					result = true;
				} else if (maint_sts_cd === '' || maint_sts_cd === undefined) {
					$('select[name=maint_sts_cd]').focus();
					result = true;
				}
				return {isValid : result, obj : obj};
			};

			/*const formatDateString = (yyyymmdd) => {
				const yyyy = yyyymmdd.substring(0, 4);
				const mm = yyyymmdd.substring(4, 6);
				const dd = yyyymmdd.substring(6, 8);
				return yyyy + '-' + mm + '-' + dd;
			};*/

			const setCctv = (data) => {
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
					setJqGridTable(res.rows, column, function () {}, onSelectRow);
				}).catch((fail) => {
					console.log('setJqGridTable fail > ', fail);
				});

				$('.searchtBtn').on('click', function() {
					const cctv_nm = $('input[name=search_cctv_nm]').val();
					offset = 0;
					getCctv({cctv_nm : cctv_nm, limit : limit, offset : offset}).then((res) => {
						console.log('res > ', res);
						$("#jqGrid").jqGrid('clearGridData');
						$("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
					}).catch((fail) => {
						console.log('setJqGridTable fail > ', fail);
					});
				});

				$('.insertBtn').on('click', function() {
					initForm();
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
						if (res.count.pass > 0) {
							alert(res.pass_list[0].message);
							return;
						}
						alert('CCTV 정보가 등록되었습니다.');
						popFancyClose('#lay-form-write08');
						const search_cctv_nm = $('input[name=search_cctv_nm]').val();
						getCctv({cctv_nm : search_cctv_nm, limit : limit, offset : offset}).then((res) => {
							console.log('res > ', res);
							$("#jqGrid").jqGrid('clearGridData');
							$("#jqGrid").jqGrid('setGridParam', {data: res.rows}).trigger('reloadGrid');
						}).catch((fail) => {
							console.log('setJqGridTable fail > ', fail);
						});
					}).catch((fail) => {
						console.log('insCctv fail > ', fail);
						alert('CCTV 정보 등록에 실패했습니다.');
					});
				});

                // 삭제
                $('.deleteBtn').on('click', function() {
                    var targetArr = getSelectedCheckData();

                    if (targetArr.length > 0) {
                        confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function() {
                            $.each(targetArr, function(idx) {
                                $.get('/admin/user/del', this, function(res) {
                                    // todo : 1이 아닌 경우 삭제가 실패된것을 알릴것인지?

                                    if( (idx+1)== targetArr.length ) reloadJqGrid();
                                });
                            });

//                             reloadJqGrid();
                        });
                    } else {
                        alert('삭제하실 사용자를 선택해주세요.');
                        return;
                    }
                });

                // 수정 팝업
                $('.modifyBtn').on('click', function() {
					const cctv_no = $("#jqGrid").jqGrid('getGridParam', 'selrow');

					if (cctv_no === null) {
						alert('CCTV를 선택해주세요.');
						return;
					}

					initForm();

					Promise.all([getCctv({cctv_no : cctv_no}), getDistrictInfo()]).then(([res1, res2]) => {
						let district_nm = $('select[name=district_no]');
						district_nm.empty();
						district_nm.append('<option value="">선택</option>');
						$.each(res2.rows, function(index, item) {
							district_nm.append('<option value="' + item.district_no + '">' + item.district_nm + '</option>');
						});

						if (res1.rows.length === 0) {
							alert('불러온 CCTV 정보가 없습니다.');
							return;
						} else if (res1.rows.length > 1) {
							alert('불러온 CCTV 정보가 2개 이상입니다.');
							return;
						}
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
						<span class="arr">장치 관리</span>
					</h2>
	                <div id="contents">
	                    <div class="contents-re">
	                        <h3 class="txt">CCTV 관리</h3>
	                        <div class="btn-group">
								<input type="text" name="search_cctv_nm" placeholder="CCTV 명" style="background-color: white; font-size: medium;"/>
								<a class="searchtBtn">검색</a>
	                            <a class="insertBtn">신규등록</a>
	                            <a class="modifyBtn">상세정보</a>
	                            <a class="excelBtn">다운로드</a>
	                        </div>
	                        <div class="contents-in">
								<table id="jqGrid"></table>
	                            <%--<jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>--%>
	                        </div>
	                    </div>
	                </div>
				</div>
			<!--[e] 컨텐츠 영역 -->
			
			<!--[s] 사용자 등록 팝업 -->
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
								<tr>
									<th>CCTV 명 <span style="color: red">*</span></th>
									<td colspan="3">
										<input type="hidden" name="cctv_no" value="">
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
											<option value="0">정상</option>
											<option value="1">망실</option>
											<option value="2">점검</option>
											<option value="3">망실(철거)</option>
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
