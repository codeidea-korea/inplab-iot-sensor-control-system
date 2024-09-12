<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>

	<style>
		#container {
			display: block; /* h2는 위에 배치 */
		}

		.content-wrapper {
			display: flex;
			justify-content: space-between; /* 두 요소 사이의 간격을 조정 */
		}

		#contents {
			flex: 4; /* 전체 비율 중 4에 해당하는 너비 */
			margin-right: 20px; /* 두 요소 간의 간격 조정 */
		}

		#contents-2 {
			flex: 6; /* 전체 비율 중 6에 해당하는 너비 */
		}

		.contents-re {
			width: 100%; /* 각 내용물이 부모 요소 내에서 전체 너비를 차지하도록 */
		}

		.ui-jqgrid-htable th.group-header {
			background-color: #2b2a6d;  /* 원하는 배경색 */
			color: white;  /* 글자색 */
			font-weight: bold;  /* 글자 굵기 */
		}

		.btn-group-1 > a {
			height: 2.8rem;
			margin-left: 1rem; /* padding:0 2rem; */
			background-color: #6975ac;
			font-weight: 500;
			font-size: 1.4rem;
			line-height: 1;
			color: #fff; /* text-align:center; */
			border-radius: 99px;
			display: flex;
			align-items: center;
			cursor: pointer;
			width: 56px;
			justify-content: center;
			white-space: nowrap;
		}

		.btn-group-2 > a {
			height: 2.8rem;
			margin-left: 1rem;
			padding:0 1rem;
			background-color: #237149;
			font-weight: 500;
			font-size: 1.4rem;
			line-height: 1;
			color: #fff; /* text-align:center; */
			border-radius: 99px;
			display: flex;
			align-items: center;
			cursor: pointer;
			justify-content: center;
			white-space: nowrap;
		}
	</style>

	<script type="text/javascript" src="/admin_add.js"></script>
	<!-- SheetJS (XLSX.js) 라이브러리 추가 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
	<script>
		const limit_1 = 25;
		let offset_1 = 0;
		const limit_2 = 25;
		let offset_2 = 0;
		let delArr = [];

		const checkboxFormatter = (cellValue, options, rowObject) => {
			return '<input type="checkbox" class="row-checkbox" value="'+rowObject.mgnt_no+'">';
		};

		const dateFormatter = (cellValue, options, rowObject) => {
			return cellValue === undefined ? '' : '<span style="white-space: normal">'+cellValue+'</span>';
		};

		const column_1 = [
			{name : 'district_nm', index : 'district_nm', align : 'center', hidden:false},
			{name : 'sens_tp_nm', index : 'sens_tp_nm', align : 'center', hidden:false},
			{name : 'sens_nm', index : 'sens_nm', align : 'center', hidden:false},
			{name : 'meas_dt', index : 'meas_dt', align : 'center', width: 200, hidden:false, formatter: dateFormatter},
			{name : 'sect_no', index : 'sect_no', align : 'center', width: 80, hidden:false},
			{name : 'maint_sts_nm', index : 'maint_sts_nm', width: 120, align : 'center', hidden:false},
		];

		const header_1 = ['현장명','센서타입','센서명','최종계측일시','단면','센서상태'];

		let column_2 = [];
		let header_2 = [];
		let header_2_group = [];

		const onSelectRow2 = (rowid, status, e) => {
			const sens_no = $("#jqGrid").jqGrid('getGridParam', 'selrow');

			$('#contents-2').html('<table id="jqGrid-2"></table>');
			$('#district_nm').html($("#jqGrid").jqGrid('getRowData', rowid).district_nm);
			$('#sens_tp_nm').html($("#jqGrid").jqGrid('getRowData', rowid).sens_tp_nm);
			$('#sens_nm').html($("#jqGrid").jqGrid('getRowData', rowid).sens_nm);

			column_2 = [
				{name : 'checkbox', index: 'checkbox', width: 35, align: 'center', sortable: false, hidden: false, formatter: checkboxFormatter},
				{name : 'meas_dt', index : 'meas_dt', width: 230, align : 'center', hidden:false},
			];
			header_2 = ['', '계측일시'];
			header_2_group = [];
			delArr = [];
			offset_2 = 0;

			getMeasureDetails({sens_no : sens_no, limit : limit_2, offset : offset_2}).then((res) => {
				if (res?.rows.length === 0) {
					column_2 = [];
					header_2 = [];
					header_2_group = [];
					$('#btn-group-1').hide();
					return;
				}
				res?.rows[0]?.logr_idx_map.forEach((logr) => {
					//column_2.push({name : logr?.sens_chnl_nm, index : logr?.sens_chnl_nm, align : 'center', hidden : false});
					column_2.push({name : 'raw_data_'+logr?.sens_chnl_id?.toLowerCase(), index : 'raw_data_'+logr?.sens_chnl_id?.toLowerCase(), align : 'center', hidden : false});
					column_2.push({name : 'formul_data_'+logr?.sens_chnl_id?.toLowerCase(), index : 'formul_data_'+logr?.sens_chnl_id?.toLowerCase(), align : 'center', hidden : false});
					//header_2.push(logr?.sens_chnl_nm);
					header_2.push('Raw Data');
					header_2.push('보정(Deg)');
					header_2_group.push({ startColumnName: 'raw_data_'+logr?.sens_chnl_id?.toLowerCase(), numberOfColumns: 2, titleText: logr?.sens_chnl_nm, className: 'group-header'});
				});
				res?.rows?.forEach((item) => {
					if (item?.sens_chnl_id === 'X') {
						item.raw_data_x = item.raw_data;
						item.formul_data_x = item.formul_data;
					} else if (item?.sens_chnl_id === 'Y') {
						item.raw_data_y = item.raw_data;
						item.formul_data_y = item.formul_data;
					} else if (item?.sens_chnl_id === 'Z') {
						item.raw_data_z = item.raw_data;
						item.formul_data_z = item.formul_data;
					}
				});
				setJqGridTable(res.rows, column_2, header_2, function () {}, onSelectRow, ['mgnt_no'], 'jqGrid-2', limit_2, offset_2, getMeasureDetails, header_2_group);
				$('#btn-group-1').show();
			}).catch((fail) => {
				console.log('setJqGridTable fail > ', fail);
			});
		};

		const getMeasureDetails = (obj) => {
			return new Promise((resolve, reject) => {
				$.ajax({
					type: 'GET',
					url: `/adminAdd/sensor/measureDetails`,
					dataType: 'json',
					contentType: 'application/json; charset=utf-8',
					async: true,
					data: obj
				}).done(function(res) {
					resolve(res);
				}).fail(function(fail) {
					reject(fail);
					console.log('getDisplayBoard fail > ', fail);
					alert2('계측 상세 정보를 가져오는데 실패했습니다.', function() {});
				});
			});
		};

		const getSensor = (obj) => {
			return new Promise((resolve, reject) => {
				$.ajax({
					type: 'GET',
					url: `/adminAdd/sensor/sensor`,
					dataType: 'json',
					contentType: 'application/json; charset=utf-8',
					async: true,
					data: obj
				}).done(function(res) {
					res.rows.forEach((item) => {
						item?.logr_idx_map.forEach((logr) => {
							item.district_nm = logr.district_nm;
						});
						item?.measure_details.forEach((meas) => {
							item.meas_dt = meas.meas_dt;
						});
					});
					resolve(res);
				}).fail(function(fail) {
					reject(fail);
					console.log('getDisplayBoard fail > ', fail);
					alert2('센서 정보를 가져오는데 실패했습니다.', function() {});
				});
			});
		};

		const actInsDel = (obj) => {
			return new Promise((resolve, reject) => {
				$.ajax({
					type: 'POST',
					url: `/adminAdd/sensor/actUdtIns`,
					dataType: 'json',
					contentType: 'application/json; charset=utf-8',
					async: true,
					data: JSON.stringify(obj)
				}).done(function(res) {
					resolve(res);
				}).fail(function(fail) {
					reject(fail);
					console.log('actUdtIns fail > ', fail);
					alert2('저장에 실패했습니다.', function() {});
				});
			});
		};

		const gridComplete2 = () => {
			$("#jqGrid").parent().height($("#jqGrid").height()+100);
		};

		$(function () {
			$("[datepicker]").flatpickr({
				locale: "ko",
				dateFormat: "Y-m-d",
				onClose: function (selectedDates, dateStr, instance) {},
			});

			/*getDisplayBoard({limit : limit, offset : offset}).then((res) => {
				console.log('res > ', res);
				setJqGridTable(res.rows, column, function () {}, onSelectRow, 'dispbd_no');
			}).catch((fail) => {
				console.log('setJqGridTable fail > ', fail);
			});*/

			/*setTimeout(function() {
				// iframe 생성 및 추가
				const iframe = document.createElement('iframe');
				iframe.style.display = 'none';
				document.body.appendChild(iframe);

				// iframe의 window 객체를 통해 기본 alert 접근
				const iframeWindow = iframe.contentWindow;

				// iframe의 기본 alert을 호출
				const originalAlert = iframeWindow.alert;

				// 기본 alert 호출
				iframeWindow.alert('준비중입니다.');
			}, 1000);*/

			$('#btn-group-1').hide();

			getSensor({limit : limit_1, offset : offset_1}).then((res) => {
				console.log('res > ', res);
				setJqGridTable(res.rows, column_1, header_1, gridComplete2, onSelectRow2, ['sens_no'], 'jqGrid', limit_1, offset_1, getSensor);
			}).catch((fail) => {
				console.log('setJqGridTable fail > ', fail);
			});

			$("#addRow").click(function() {
				let newRowId = $.jgrid.randId();  // 랜덤 ID 생성
				let array = [
					{
						mgnt_no : newRowId,
						raw_data_x : '<input type="text" class="raw_data_x"/>',
						formul_data_x : '<input type="text" class="formul_data_x"/>',
						raw_data_y : '<input type="text" class="raw_data_y"/>',
						formul_data_y : '<input type="text" class="formul_data_y"/>',
						raw_data_z : '<input type="text" class="raw_data_z"/>',
						formul_data_z : '<input type="text" class="formul_data_z"/>',
						meas_dt: '<input type="text" class="meas_dt"/>'
					}
				];
				$("#jqGrid-2").jqGrid('addRowData', newRowId, array[0], "first");

				// 새 행을 편집 모드로 전환
				$("#jqGrid-2").jqGrid('editRow', newRowId, {
					keys: true,  // Enter 키로 편집 완료 가능
					focusField: 1  // 첫 번째 편집 가능한 필드에 포커스
				});
			});

			$('#delRow').click(function() {
				const mgnt_no =  $("#jqGrid-2").jqGrid('getGridParam', 'selrow');
				if (mgnt_no === '' || mgnt_no === null || mgnt_no === undefined || mgnt_no === 'undefined') {
					alert2('삭제할 행을 선택해주세요.', function() {});
					return;
				}
				confirm2('선택한 행을 삭제하시겠습니까?', function() {
					$("#jqGrid-2").jqGrid('delRowData', mgnt_no);
					if (mgnt_no.indexOf('jqg') === -1) {
						delArr.push(mgnt_no);
					}
				});
			});

			$('#insDel').on('click', function() {
				let insArr = [];
				let isValid = false;
				const sens_no = $("#jqGrid").jqGrid('getGridParam', 'selrow');

				$("#jqGrid-2").find('tr[id^=jqg]').each(function() {
					let obj = {};
					if ($(this).find('.meas_dt').val() !== '' && $(this).find('.meas_dt').val() !== undefined) {
						obj.sens_no = sens_no;
						obj.meas_dt = $(this).find('.meas_dt').val();
					}
					if ($(this).find('.raw_data_x').val() !== '' && $(this).find('.raw_data_x').val() !== undefined) {
						obj.raw_data = $(this).find('.raw_data_x').val();
						obj.sens_chnl_id = 'X';
					}
					if ($(this).find('.formul_data_x').val() !== '' && $(this).find('.formul_data_x').val() !== undefined) {
						obj.formul_data = $(this).find('.formul_data_x').val();
						obj.sens_chnl_id = 'X';
					}
					if ($(this).find('.raw_data_y').val() !== '' && $(this).find('.raw_data_y').val() !== undefined) {
						obj.raw_data = $(this).find('.raw_data_y').val();
						obj.sens_chnl_id = 'Y';
					}
					if ($(this).find('.formul_data_y').val() !== '' && $(this).find('.formul_data_y').val() !== undefined) {
						obj.formul_data = $(this).find('.formul_data_y').val();
						obj.sens_chnl_id = 'Y';
					}
					if ($(this).find('.raw_data_z').val() !== '' && $(this).find('.raw_data_z').val() !== undefined) {
						obj.raw_data = $(this).find('.raw_data_z').val();
						obj.sens_chnl_id = 'Z';
					}
					if ($(this).find('.formul_data_z').val() !== '' && $(this).find('.formul_data_z').val() !== undefined) {
						obj.formul_data = $(this).find('.formul_data_z').val();
						obj.sens_chnl_id = 'Z';
					}
					if ($(this).find('.raw_data_').val() !== '' && $(this).find('.raw_data_').val() !== undefined) {
						obj.raw_data = $(this).find('.raw_data_').val();
						obj.sens_chnl_id = '';
					}
					if ($(this).find('.formul_data_').val() !== '' && $(this).find('.formul_data_').val() !== undefined) {
						obj.formul_data = $(this).find('.formul_data_').val();
						obj.sens_chnl_id = '';
					}
					insArr.push(obj);
				});

				insArr.some((item) => {
					if (item.meas_dt === undefined || item.meas_dt === '') {
						isValid = true;
						return;
					}
					if (isValidTimestamp(item.meas_dt) === false) {
						isValid = true;
						return;
					}
					if ((item.raw_data === undefined || item.raw_data === '')
						&& (item.formul_data === undefined || item.formul_data === '')) {
						isValid = true;
						return;
					}
				});

				if (isValid) {
					alert2('계측일시와 계측값을 확인해주세요.', function() {});
					return;
				}

				actInsDel({ins_arr : insArr, del_arr : delArr}).then((res) => {
					console.log('res > ', res);
					alert2('저장되었습니다.', function() {
						$("#" + sens_no).trigger("click");
					});
				}).catch((fail) => {
					console.log('actUdtIns fail > ', fail);
					alert2('저장에 실패했습니다.', function() {});
				});
			});

			$("#importExcel").click(function() {
				$("#fileInput").click();
			});

			// 파일 선택 후 엑셀 읽기
			$("#fileInput").change(function(e) {
				const file = e.target.files[0];
				const reader = new FileReader();

				reader.onload = function(e) {
					const data = new Uint8Array(e.target.result);
					const workbook = XLSX.read(data, { type: 'array' });

					// 첫 번째 시트의 데이터를 가져옴
					const sheetName = workbook.SheetNames[0];
					const worksheet = workbook.Sheets[sheetName];

					// 엑셀 데이터를 JSON 형태로 변환
					const jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1 });

					// JSON 데이터를 사용하여 jqGrid에 행 추가
					jsonData.forEach(function(row, index) {
						if (index === 0) return; // 헤더 행을 건너뜀

						let newRowId = $.jgrid.randId();  // 랜덤 ID 생성
						let rowData = {
							mgnt_no: newRowId,
							meas_dt: '<input type="text" class="meas_dt" value="' + (row[0] || '') + '"/>',
							raw_data_x: '<input type="text" class="raw_data_x" value="' + (row[1] || '') + '"/>',
							formul_data_x: '<input type="text" class="formul_data_x" value="' + (row[2] || '') + '"/>',
							raw_data_y: '<input type="text" class="raw_data_y" value="' + (row[3] || '') + '"/>',
							formul_data_y: '<input type="text" class="formul_data_y" value="' + (row[4] || '') + '"/>',
							raw_data_z: '<input type="text" class="raw_data_z" value="' + (row[5] || '') + '"/>',
							formul_data_z: '<input type="text" class="formul_data_z" value="' + (row[6] || '') + '"/>',
						};
						$("#jqGrid-2").jqGrid('addRowData', newRowId, rowData, "first");
					});
					$('#fileInput').val('');
				};
				reader.readAsArrayBuffer(file);
			});

			// 엑셀 다운로드 버튼 클릭 시 동작
			$("#exportExcel").click(function() {
				// jqGrid 데이터 가져오기
				const gridData = $("#jqGrid-2").jqGrid('getRowData');

				// 워크시트 데이터 준비
				const worksheetData = gridData.map(function(row) {
					return {
						'계측일시': row.meas_dt === undefined ? $(row.meas_dt).val() : row.meas_dt,
						'Raw Data X': row.raw_data_x === undefined ? $(row.raw_data_x).val() : row.raw_data_x,
						'Formul Data X': row.formul_data_x === undefined ? $(row.formul_data_x).val() : row.formul_data_x,
						'Raw Data Y': row.raw_data_y === undefined ? $(row.raw_data_y).val() : row.raw_data_y,
						'Formul Data Y': row.formul_data_y === undefined ? $(row.formul_data_y).val() : row.formul_data_y,
						'Raw Data Z': row.raw_data_z === undefined ? $(row.raw_data_z).val() : row.raw_data_z,
						'Formul Data Z': row.formul_data_z === undefined ? $(row.formul_data_z).val() : row.formul_data_z,
					};
				});

				// 워크시트 생성
				const worksheet = XLSX.utils.json_to_sheet(worksheetData);

				// 워크북 생성
				const workbook = XLSX.utils.book_new();
				XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet1");

				// 엑셀 파일 다운로드
				XLSX.writeFile(workbook, "measureDetails.xlsx");
			});

			$('#viewChart').on('click', function() {
				alert2('준비중입니다.', function() {});
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
			<span class="arr">데이터 관리</span>
			<span class="arr">계측기 데이터 관리</span>
		</h2>
		<!-- 컨텐츠들을 래핑하는 div 추가 -->
		<div class="content-wrapper" style="height: 95%">
			<div id="contents">
				<div class="contents-re">
					<h3 class="txt">센서 계측 현황</h3>
					<div class="contents-in">
						<table id="jqGrid"></table>
						<%--<jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>--%>
					</div>
				</div>
			</div>
			<div id="contents" style="flex: 6">
				<div class="contents-re">
					<div style="display: flex; align-items: center; justify-content: space-between">
						<div style="display: flex; gap: 2px;">
							<h3 class="txt">데이터값 수정</h3>
							<div class="btn-group-2" style="display: flex; gap: 2px;">
								<a id="district_nm">현장명</a>
								<a id="sens_tp_nm">센서타입</a>
								<a id="sens_nm">센서명</a>
							</div>
						</div>
						<div class="btn-group-1" style="display: flex; gap: 2px; margin-bottom: 2.2rem;" id="btn-group-1">
							<a id="addRow">행추가</a>
							<a id="delRow">행삭제</a>
							<a id="insDel">저장</a>
							<a id="importExcel">업로드</a>
							<a id="exportExcel">다운로드</a>
							<a id="viewChart">차트조회</a>
							<input type="file" id="fileInput" style="display:none;" accept=".xls,.xlsx"/>
						</div>
					</div>
					<div class="contents-in" id="contents-2">
						<table id="jqGrid-2"></table>
						<%--<jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>--%>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!--[e] 컨텐츠 영역 -->
</section>
</body>
</html>
