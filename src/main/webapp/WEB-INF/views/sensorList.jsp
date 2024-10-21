<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> <%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
	    <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>
	
	    <style>
			/* 검색 행의 input 필드에 border 추가 */
			.ui-search-toolbar input {
				border: 1px solid #ccc; /* 원하는 border 색상 */
				padding: 2px;
			}
			.ui-search-toolbar th:first-child {
				border-left: none !important;
			}
			.ui-jqgrid tr.ui-search-toolbar th {
				border: 1px solid #d3d3d3;
			}
			.ui-jqgrid .ui-jqgrid-htable {
				table-layout: fixed;
				margin: 0;
				border-collapse: collapse;
			}
		</style>

		<script type="text/javascript" src="/admin_add.js"></script>
        <script>
            window.jqgridOption = {
                multiselect: true,
                multiboxonly: false
            }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

			let $grid;
			const limit = 25;
			let offset = 0;
			let selectArrary = [];

			const checkboxFormatter = (cellValue, options, rowObject) => {
				return '<input type="checkbox" class="row-checkbox" value="'+rowObject.id+'">';
			};

			const netErrorYnFormatter = (cellValue, options, rowObject) => {
				if (cellValue === 'Y') {
					return '<span style="color: red;">오류</span>';
				} else {
					return '<span style="color: green;">수신</span>';
				}
			};

			const column = [
				{name: 'checkbox', index: 'checkbox', width: 35, align: 'center', sortable: false, hidden: false, formatter: checkboxFormatter},
				//{ name: 'cb', index: 'cb', width: 50, sortable: false, formatter: 'checkbox', formatoptions: { disabled: false }, align: 'center', title: false },
				{name : 'district_nm', index : 'district_nm', width: 100, align : 'center', hidden:false},
				{name : 'sens_tp_nm', index : 'sens_tp_nm', width: 100, align : 'center', hidden:false},
				{name : 'sens_nm', index : 'sens_nm', width: 100, align : 'center', hidden:false},
				{name : 'sens_chnl_nm', index : 'sens_chnl_nm', width: 100, align : 'center', hidden:false},
				{name : 'logr_nm', index : 'logr_nm', width: 100, align : 'center', hidden:false},
				{name : 'sect_no', index : 'sect_no', width: 50, align : 'center', hidden:false},
				{name : 'inst_ymd', index : 'inst_ymd', width: 100, align : 'center', hidden:false},
				{name : 'meas_dt', index : 'meas_dt', width: 120, align : 'center', hidden:false},
				{name : 'maint_sts_nm', index : 'maint_sts_nm', width: 70, align : 'center', hidden:false},
				{name : 'net_err_yn', index : 'net_err_yn', width: 70, align : 'center', hidden:false, formatter: netErrorYnFormatter},
				{name : '', index : '', width: 70, align : 'center', hidden:false},

				{name : 'senstype_no', index : 'senstype_no', width: 100, align : 'center', hidden:true},
				{name : 'sens_no', index : 'sens_no', width: 100, align : 'center', hidden:true},
				{name : 'logr_no', index : 'logr_no', width: 100, align : 'center', hidden:true},
				{name : 'multi_sens_yn', index : 'multi_sens_yn', width: 100, align : 'center', hidden:true},
				{name : 'disp_prior_yn', index : 'disp_prior_yn', width: 100, align : 'center', hidden:true},
				{name : 'multi_senstype_no', index : 'multi_senstype_no', width: 100, align : 'center', hidden:true},
				{name : 'multi_sens_no', index : 'multi_sens_no', width: 100, align : 'center', hidden:true},
				{name : 'nonrecv_limit_min', index : 'nonrecv_limit_min', width: 100, align : 'center', hidden:true},
				{name : 'alarm_use_yn', index : 'alarm_use_yn', width: 100, align : 'center', hidden:true},
				{name : 'sms_snd_yn', index : 'sms_snd_yn', width: 100, align : 'center', hidden:true},
				{name : 'sens_disp_yn', index : 'sens_disp_yn', width: 100, align : 'center', hidden:true},
				{name : 'maint_sts_cd', index : 'maint_sts_cd', width: 100, align : 'center', hidden:true},
				{name : 'sens_lon', index : 'sens_lon', width: 100, align : 'center', hidden:true},
				{name : 'sens_lat', index : 'sens_lat', width: 100, align : 'center', hidden:true},
				{name : 'sens_maker', index : 'sens_maker', width: 100, align : 'center', hidden:true},
				{name : 'model_nm', index : 'model_nm', width: 100, align : 'center', hidden:true},
				{name : 'logger_maint_sts_cd', index : 'logger_maint_sts_cd', width: 100, align : 'center', hidden:true},
				{name : 'formul_data', index : 'formul_data', width: 100, align : 'center', hidden:true},
				{name : 'reg_dt', index : 'reg_dt', width: 100, align : 'center', hidden:true},
				{name : 'mod_dt', index : 'mod_dt', width: 100, align : 'center', hidden:true},

			];

			const header = [
				'','현장명','센서타입명','센서명','채널명','로거명','단면번호','설치일자','최종계측일시','센서상태','통신상태','센서값',
				'','','','','','','','','','',
				'','','','','','','','','',''
			];

			const gridComplete2 = () => {
				// 검색 행 추가
				if ($("#jqGrid").closest(".ui-jqgrid-view").find(".ui-search-toolbar").length === 0) {
					let $thead = $("#jqGrid").closest(".ui-jqgrid-view").find(".ui-jqgrid-htable thead");
					let $searchRow = $('<tr class="ui-search-toolbar"></tr>');
					let distinctDistrict = [];
					let distinctSensType = [];

					// 현재 필터링 조건을 저장할 객체
					let filters = {
						groupOp: "AND",
						rules: []
					};

					getDistinct().then((res) => {
						distinctDistrict = res.district;
						distinctSensType = res.sensor_type;

						$("#jqGrid").jqGrid('getGridParam', 'colModel').forEach(function (col, index) {
							let $cell = setFilterControls(col, index, distinctDistrict, distinctSensType, filters, "jqGrid");
							$searchRow.append($cell);
						});
						$thead.append($searchRow);
					}).catch((fail) => {
						console.log('getDistinct fail > ', fail);
					});
				}
			};

			const onSelectRow2 = (rowId, status, e) => {
				const data = $("#jqGrid").jqGrid('getRowData', rowId);
				let isExist = false;

				selectArrary.some(select => select.sens_no+'_'+select.sens_chnl_nm === rowId) ? isExist = true : isExist = false;
				selectArrary = selectArrary.filter((select) => select.sens_no+'_'+select.sens_chnl_nm !== data.sens_no+'_'+data.sens_chnl_nm);

				if (isExist) {
					$('tr[id='+rowId+'] input[type=checkbox]').prop("checked", false);
				} else {
					selectArrary.push(data);
					$('tr[id='+rowId+'] input[type=checkbox]').prop("checked", true);
				}
			};

			const loadComplete2 = () => {
				selectArrary.map((select) => {
					$('tr[id='+select.sens_no+'_'+select.sens_chnl_nm+'] input[type=checkbox]').prop("checked", true);
				});
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
						alert2('센서 정보를 가져오는데 실패했습니다.', function() {});
					});
				});
			};

			$(function() {

				getSensor({limit : limit, offset : offset}).then((res) => {
					console.log('res > ', res);
					setJqGridTable(res.rows, column, header, gridComplete2, onSelectRow2, ['sens_no','sens_chnl_nm'], 'jqGrid', limit, offset, getSensor, null, loadComplete2);
				}).catch((fail) => {
					console.log('setJqGridTable fail > ', fail);
				});

				// row 의 체크박스를 해제하기 위해 클릭했을때 onselectrow 이 반응하지 않기에 추가된 이벤트
				$(document).on('change', '#jqGrid input[type=checkbox]', function(e) {
					e.stopImmediatePropagation(); // 현재 이벤트가 다른 이벤트 핸들러로 전파되는 것을 방지
					const isChecked = $(this).is(':checked');
					const rowId = $(this).closest('tr').attr('id');

					// row클릭시 selectArray 에 등록되고 동작해야한다
					loadComplete2();

					if (!isChecked) {
						onSelectRow2(rowId, isChecked, e);
					}
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
						<%--<jsp:include page="common/broadcast-text-grid.jsp" flush="true"></jsp:include>--%>
						<table id="jqGrid"></table>
					</div>
				</div>
			</div>
		</div>
	<!--[e] 컨텐츠 영역 -->
</section>
</body>
</html>
