<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
	    <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>
	
	    <style></style>

		<%--<script type="text/javascript" src="/admin_add.js"></script>--%>
        <script>
			(function() {
				setTimeout(function() {
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
					location.href = '/adminAdd/siteInfo';

				}, 1000);
			})();
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
								<input type="text" name="search_dispbd_nm" placeholder="CCTV 명" style="background-color: white; font-size: medium;"/>
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
								<tr id="tr_dispbd_no">
									<th>CCTV NO <span style="color: red">*</span></th>
									<td colspan="3">
										<input type="text" name="dispbd_no" value="" readonly>
									</td>
								</tr>
								<tr>
									<th>CCTV 명 <span style="color: red">*</span></th>
									<td colspan="3">
										<input type="text" name="dispbd_nm"/>
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
