<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>

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
				var filteredData = allRowData.filter(function(item) {					// 값이 있는것들만 가져온다
					return item.range_value1 || item.range_value2 || item.range_value3 || item.range_value4 || item.range_value5;
				});
            	
				$.ajax({
					method: 'post',
					url: '/admin/alarmRange/mod',
					traditional: true,
					data: { jsonData: JSON.stringify(filteredData) },
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
					<span class="arr">알람 관리</span>
				</h2>
	
				<div id="contents">
					<div class="contents-re">
<!-- 						<h3 class="txt">계측기 알람 범위 설정 -->
<!-- 							<a href="javascript:modifySave();" class="btn blue">수정</a> -->
<!-- 						</h3> -->
						<h3 class="txt">계측기 알람 범위 설정</h3>
						<div class="btn-group">
							<a href="javascript:modifySave();">수정</a>
						</div>
	
						<div class="contents-in">
							<jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>
						</div>
					</div>
				</div>
			</div>
            <!--[e] 컨텐츠 영역 -->
        </section>
    </body>
</html>
