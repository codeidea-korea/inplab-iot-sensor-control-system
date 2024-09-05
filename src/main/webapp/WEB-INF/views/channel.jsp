<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>

        <style></style>

        <script>
            window.jqgridOption = {
                multiselect: false,
                multiboxonly: false
            }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

            $(function () {
            });

            function modifySave() {
            	var allRowData = $(".jqGrid").jqGrid("getRowData");
            	
				$.ajax({
					method: 'post',
					url: '/channel/mod',
					traditional: true,
					data: { jsonData: JSON.stringify(allRowData) },
					dataType: 'json',
					success: function (res) {
	            	    alert('저장되었습니다.', function () {
//	 						reloadJqGrid();//1페이지로 안가도록
	            	    });

					}
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
						<h3 class="txt">센서 정보 변경
							<a href="javascript:modifySave();" class="btn blue">저장</a>
						</h3>
	
<!-- 						<div class="search-bg"> -->
<!-- 							<dl> -->
<!-- 								<dt>센서타입</dt> -->
<!-- 								<dd> -->
<!-- 									<select name=""> -->
<!-- 										<option value="">강우량계</option> -->
<!-- 									</select> -->
<!-- 								</dd> -->
<!-- 							</dl> -->
<!-- 						</div> -->
						<div class="tab-three">
							<a href="/calc">센서 정보 변경</a>
							<a href="/manage">관리 기준값 변경</a>
							<a href="/channel" class="active">채널 정보 변경</a>
						</div>
						<!-- 센서 정보 변경/관리 기준값 변경/채널 정보 변경 -->
						<div class="contents-in" style="min-height: calc(94% - 4.6rem)"><!--  sensor_modify"> -->
<%--							<jsp:include page="common/include_jqgrid.jsp" flush="true"></jsp:include>--%>
							<jsp:include page="common/include_jqgrid_old.jsp" flush="true"></jsp:include>
						</div>
					</div>
				</div>
			</div>
            <!--[e] 컨텐츠 영역 -->
        </section>
    </body>
</html>
