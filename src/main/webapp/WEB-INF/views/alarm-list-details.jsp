<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<div id="lay-sensor-message" class="layer-base">
    <div class="layer-base-btns">
        <a href="javascript:void(0);"><img src="./images/btn_lay_full.png" data-fancybox-full alt="전체화면"></a>
        <a href="javascript:void(0);"><img src="./images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
    </div>
    <div class="layer-base-title">문자 전송 상세내역</div>
    <div class="layer-base-conts min bTable">
        <jsp:include page="common/include_jqgrid_old.jsp" flush="true"></jsp:include>
        <table class="message_text">
            <thead>
            <tr>
                <th>문자내역</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>

                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
