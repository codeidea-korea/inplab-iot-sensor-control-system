<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> <%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
	    <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>
	
	    <style></style>

		<script type="text/javascript" src="/admin_add.js"></script>
        <script>
            window.jqgridOption = {
                multiselect: false,
                multiboxonly: false
            }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

			let $grid;
			const limit = 25;
			let offset = 0;

			const checkboxFormatter = (cellValue, options, rowObject) => {
				return '<input type="checkbox" class="row-checkbox" value="'+rowObject.sens_no+'">';
			};

			/*
			A.sens_no
			,A.logr_no
			,D.logr_nm
			,A.senstype_no
			,B.sens_tp_nm
			,A.sens_nm
			,C.sens_chnl_nm
			,TO_CHAR(TO_DATE(A.inst_ymd, 'YYYYMMDD'), 'YYYY-MM-DD') AS inst_ymd
			,A.sect_no
			,A.multi_sens_yn
			,A.disp_prior_yn
			,A.multi_senstype_no
			,A.multi_sens_no
			,A.nonrecv_limit_min
			,A.alarm_use_yn
			,A.sms_snd_yn
			,A.sens_disp_yn
			,A.maint_sts_cd
			,E.code_nm AS maint_sts_nm
			,A.sens_lon
			,A.sens_lat
			,A.sens_maker
			,A.model_nm
			,D.maint_sts_cd AS logger_maint_sts_cd
			,F.net_err_yn
			,F.formul_data
			,TO_CHAR(A.reg_dt, 'YYYY-MM-DD HH24:MI:SS') AS reg_dt
			,TO_CHAR(A.mod_dt, 'YYYY-MM-DD HH24:MI:SS') AS mod_dt
			,TO_CHAR(F.meas_dt, 'YYYY-MM-DD HH24:MI:SS') AS meas_dt
			*/

			const column = [
				//{name: 'checkbox', index: 'checkbox', width: 35, align: 'center', sortable: false, hidden: false, formatter: checkboxFormatter},
				{ name: 'cb', index: 'cb', width: 50, sortable: false, formatter: 'checkbox', formatoptions: { disabled: false }, align: 'center', title: false },
				{name : 'district_nm', index : 'district_nm', width: 100, align : 'center', hidden:false},
				{name : 'sens_no', index : 'sens_no', width: 100, align : 'center', hidden:false},
				{name : 'logr_no', index : 'logr_no', width: 100, align : 'center', hidden:false},
				{name : 'logr_nm', index : 'logr_nm', width: 100, align : 'center', hidden:false},
				{name : 'senstype_no', index : 'senstype_no', width: 100, align : 'center', hidden:false},
				{name : 'sens_tp_nm', index : 'sens_tp_nm', width: 100, align : 'center', hidden:false},
				{name : 'sens_nm', index : 'sens_nm', width: 100, align : 'center', hidden:false},
				{name : 'sens_chnl_nm', index : 'sens_chnl_nm', width: 100, align : 'center', hidden:false},
				{name : 'inst_ymd', index : 'inst_ymd', width: 100, align : 'center', hidden:false},
				{name : 'sect_no', index : 'sect_no', width: 100, align : 'center', hidden:false},
				{name : 'multi_sens_yn', index : 'multi_sens_yn', width: 100, align : 'center', hidden:false},
				{name : 'disp_prior_yn', index : 'disp_prior_yn', width: 100, align : 'center', hidden:false},
				{name : 'multi_senstype_no', index : 'multi_senstype_no', width: 100, align : 'center', hidden:false},
				{name : 'multi_sens_no', index : 'multi_sens_no', width: 100, align : 'center', hidden:false},
				{name : 'nonrecv_limit_min', index : 'nonrecv_limit_min', width: 100, align : 'center', hidden:false},
				{name : 'alarm_use_yn', index : 'alarm_use_yn', width: 100, align : 'center', hidden:false},
				{name : 'sms_snd_yn', index : 'sms_snd_yn', width: 100, align : 'center', hidden:false},
				{name : 'sens_disp_yn', index : 'sens_disp_yn', width: 100, align : 'center', hidden:false},
				{name : 'maint_sts_cd', index : 'maint_sts_cd', width: 100, align : 'center', hidden:false},
				{name : 'maint_sts_nm', index : 'maint_sts_nm', width: 100, align : 'center', hidden:false},
				{name : 'sens_lon', index : 'sens_lon', width: 100, align : 'center', hidden:false},
				{name : 'sens_lat', index : 'sens_lat', width: 100, align : 'center', hidden:false},
				{name : 'sens_maker', index : 'sens_maker', width: 100, align : 'center', hidden:false},
				{name : 'model_nm', index : 'model_nm', width: 100, align : 'center', hidden:false},
				{name : 'logger_maint_sts_cd', index : 'logger_maint_sts_cd', width: 100, align : 'center', hidden:false},
				{name : 'net_err_yn', index : 'net_err_yn', width: 100, align : 'center', hidden:false},
				{name : 'formul_data', index : 'formul_data', width: 100, align : 'center', hidden:false},
				{name : 'reg_dt', index : 'reg_dt', width: 100, align : 'center', hidden:false},
				{name : 'mod_dt', index : 'mod_dt', width: 100, align : 'center', hidden:false},
				{name : 'meas_dt', index : 'meas_dt', width: 100, align : 'center', hidden:false}
			];

			const header = [
				'','현장명','CCTV명','계측사','담당자','전화번호',
				'','','','','','','','','','','','','','','','','','','','','',''
				/*'sens_no','district_no','maint_sts_cd','maint_sts_nm',
                'partner_comp_id','inst_ymd','model_nm','cctv_maker',
                'cctv_ip','web_port','rtsp_port','cctv_conn_id','cctv_conn_pwd',
                'relay_nm','relay_ip','relay_port','cctv_lat','cctv_lon',
                'admin_center','etc1','etc2','etc3'*/
			];

			const gridComplete2 = () => {
				// 검색 행 추가
				if ($("#jqGrid").closest(".ui-jqgrid-view").find(".ui-search-toolbar").length === 0) {
					let $thead = $("#jqGrid").closest(".ui-jqgrid-view").find(".ui-jqgrid-htable thead");
					let $searchRow = $('<tr class="ui-search-toolbar"></tr>');

					// 현재 필터링 조건을 저장할 객체
					let filters = {
						groupOp: "AND",
						rules: []
					};

					$("#jqGrid").jqGrid('getGridParam', 'colModel').forEach(function (col, index) {
						let $cell = $('<th></th>');

						// hidden:true인 컬럼은 검색 행에서 제외
						if (!col.hidden && index > 0) {
							let $input = $('<input type="text" style="width: 98%; box-sizing: border-box;" />');
							$input.on("input", function () {
								const colName = $("#jqGrid").jqGrid("getGridParam", "colModel")[index].name;
								const searchValue = $(this).val();

								// 기존 필터에서 해당 열의 조건을 제거
								filters.rules = filters.rules.filter(rule => rule.field !== colName);

								// 새로운 필터 조건 추가
								if (searchValue) {
									filters.rules.push({
										field: colName,
										op: "cn", // cn = contains (포함 여부)
										data: searchValue
									});
								}

								// 필터링 적용
								$("#jqGrid").jqGrid("setGridParam", {
									postData: {
										filters: JSON.stringify(filters)
									},
									search: true,
									page: 1
								}).trigger("reloadGrid");
							});
							$cell.append($input);
						}
						$searchRow.append($cell);
					});
					$thead.append($searchRow);
				}

				$('#jqGrid_checkbox').html('<input type="checkbox" id="check-all">');

				// 헤더 체크박스 선택 시, 전체 행의 클릭 이벤트 트리거
				$('#check-all').on('click', function() {
					const isChecked = $(this).is(':checked');  // 헤더 체크박스 상태 확인

					if (isChecked) {
						isCheckedAll = true;

						let $rows = $('#jqGrid tr[role=row]'); // 모든 행 가져오기
						let delay = 300; // 지연 시간 (100ms)

						function processRow(index) {
							if (index >= $rows.length) return; // 모든 행을 처리했으면 종료

							let $row = $($rows[index]);
							if (!$row.find('input[type=checkbox]').is(':checked')) {
								$row.trigger('click', { rowId: $row.attr('id'), sens_no: $row.attr('sens_no') });
							}

							// 다음 행을 지연 처리
							setTimeout(() => processRow(index + 1), delay);
						}

						// 첫 번째 행부터 순차적으로 처리 시작
						processRow(0);
					} else {
						isCheckedAll = false;
						uncheckedAllCctvList();
					}
				});

				if (isCheckedAll) {
					$('#check-all').prop("checked", true);
				}
			};

			const getSensor = (obj) => {
				return new Promise((resolve, reject) => {
					$.ajax({
						type: 'GET',
						url: `/modify/sensor/sensor`,
						dataType: 'json',
						contentType: 'application/json; charset=utf-8',
						async: true,
						data: obj
					}).done(function(res) {
						resolve(res);
					}).fail(function(fail) {
						reject(fail);
						console.log('getSensor fail > ', fail);
						alert2('CCTV 정보를 가져오는데 실패했습니다.', function() {});
					});
				});
			};

			const onSelectRow2 = (rowId, status, e) => {
				const data = $("#jqGrid").jqGrid('getRowData', rowId);
				let isExist = false;

				cctvArray.some(cctv => cctv.sens_no === rowId) ? isExist = true : isExist = false;
				cctvArray = cctvArray.filter((cctv) => cctv.sens_no !== data.sens_no);

				if (isExist) {
					try {
						window.videoWs['vid_' + data.sens_no].send(JSON.stringify({ type: "close" }));
						window.videoWs['vid_' + data.sens_no].close();
						console.log('socket close - vid_' + data.sens_no);
					} catch(e) {

					}
					$('.cctv-list li[cctvno=' + data.sens_no + ']').remove();
					$('tr[id='+rowId+'] input[type=checkbox]').prop("checked", false);
				} else {
					cctvArray.push(data);
					$('tr[id='+rowId+'] input[type=checkbox]').prop("checked", true);
					if (cctvArray.length < 7) {
						setCctvVideoList(data);
					}
				}

				reloadCctvList();
				$('.paging_all').remove();
				if (cctvArray.length > 0) {
					const pageHtml = makePage();
					setPage(currentPage, pageHtml);
				}
			};

			const loadComplete2 = () => {
				cctvArray.map((cctv) => {
					$('tr[id='+cctv.sens_no+'] input[type=checkbox]').prop("checked", true);
				});
				if (isCheckedAll) {
					$('#check-all').prop("checked", true);
				}
			};

			$(function() {

				getSensor({limit : limit, offset : offset}).then((res) => {
					console.log('res > ', res);
					setJqGridTable(res.rows, column, header, gridComplete2, onSelectRow2, 'sens_no', 'jqGrid', limit, offset, getSensor, null, loadComplete2);
				}).catch((fail) => {
					console.log('setJqGridTable fail > ', fail);
				});
				
				$('#view-chart').on('click', function() {
					alert('준비중입니다');
				});
			});
        </script>
	
	</head>

<body data-pgcode="0000">
<section
        id="wrap">
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

	<!--[s] 컨텐츠 영역 -->
		<div id="container">
			<h2 class="txt">센서모니터링</h2>

			<div id="contents">
				<div class="contents-re">
					<h3 class="txt">센서현황<div class="visionBtn" id="view-chart">차트조회</div></h3>
					<div class="contents-in">
<%--						<jsp:include page="common/include_jqgrid.jsp" flush="true"></jsp:include>--%>
						<%--<jsp:include page="common/include_jqgrid_old.jsp" flush="true"></jsp:include>--%>
						<table id="jqGrid"></table>
					</div>
				</div>
			</div>
		</div>
	<!--[e] 컨텐츠 영역 -->
</section>
</body>
</html>
