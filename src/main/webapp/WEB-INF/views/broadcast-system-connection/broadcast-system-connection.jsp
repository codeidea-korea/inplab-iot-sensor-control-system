<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>
    <style>
        .contents-re .gridDataContent > table {
            width: calc(100% + 0px);
        }

        .contents-re .gridDataContent {
            height: 200px;
            overflow: auto;
        }
    </style>
</head>

<body data-pgCode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"></jsp:include>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"></jsp:include>
    </div>
    <div id="container">
        <h2 class="txt">동보방송시스템 연계
        </h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">방송안내 문구 관리</h3>
                <div class="btn-group">
                    <a class="addRow">행추가</a>
                    <a class="insertBtn">저장</a>
                    <a class="deleteBtn">삭제</a>
                    <a class="submitBtn">전송</a>
                </div>
                <div class="contents-in auto">
                    <jsp:include page="./broadcast-text-grid.jsp" flush="true"></jsp:include>
                </div>
            </div>
            <div class="contents-re">
                <h3 class="txt">방송 전송이력 조회</h3>
                <div class="contents-in auto h200">
                    <jsp:include page="./broadcast-history-grid.jsp" flush="true"></jsp:include>
                </div>
            </div>
        </div>
    </div>

    <!--[s] 알람 설정 수정 팝업 -->
    <div id="lay-form-write" class="layer-base">
        <input type="hidden" name="alarm_kind_id"/>
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">업로드</div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>엑셀파일</th>
                        <td><input type="file" id="uploadFile" name="uploadFile" value="" placeholder=""/></td>
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
    <!--[e] 알람 설정 수정 팝업 -->
</section>
</body>
</html>
