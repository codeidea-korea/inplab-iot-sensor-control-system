<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>
    <script type="text/javascript" src="/colorpicker/jquery.colorpicker.bygiro.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/colorpicker/jquery.colorpicker.bygiro.min.css"/>
</head>
<style>
    #contents {
        display: grid;
        align-items: stretch;
        grid-template-columns: 1fr 1fr;
    }

    .contents-re:nth-of-type(4) {
        grid-column: 2;
        grid-row: 2/ span 2;
        grid-template-columns: repeat(3, 1fr);
    }

    .contents-head {
        display: flex;
        margin-bottom: 2rem;
    }

    .search-top {
        position: static;
    }

    .btn-group {
        position: static;
        justify-content: center;
        margin-bottom: 1rem;
    }

    .btn-group a:nth-of-type(1) {
        height: 2.8rem;
        margin-left: 1rem;
        padding: 0 2rem;
        background-color: #2e5fc3;
        font-weight: 500;
        font-size: 1.4rem;
        line-height: 1;
        color: #fff;
        text-align: center;
        border-radius: 99px;
        display: flex;
        align-items: center;
        cursor: pointer;
    }

    .btn-group a:nth-of-type(2) {
        height: 2.8rem;
        margin-left: 1rem;
        padding: 0 2rem;
        background-color: #fff;
        font-weight: 500;
        font-size: 1.4rem;
        line-height: 1;
        color: #000;
        text-align: center;
        border-radius: 99px;
        display: flex;
        align-items: center;
        cursor: pointer;
    }

    .btn-group a:nth-of-type(3) {
        height: 2.8rem;
        margin-left: 1rem;
        padding: 0 2rem;
        background-color: #6975ac;
        font-weight: 500;
        font-size: 1.4rem;
        line-height: 1;
        color: #fff;
        text-align: center;
        border-radius: 99px;
        display: flex;
        align-items: center;
        cursor: pointer;
    }

    h3.txt {
        margin-bottom: 0;
        height: 3.8rem;
    }

    #contents .contents-in {
        position: static;
    }

    .board_test {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40rem;
        height: 4em;
        background-color: #000;
        color: #fff;
        font-size: 4rem;
        padding: 20px;
        border-radius: 1rem;
        text-wrap: nowrap;
        overflow: scroll;
    }

    .textfield_group {
        display: flex;
        flex-direction: row;
        gap: 1rem;
        margin-left: 1rem;
    }

    .textfield_group p {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .hide {
        display: none;
    }

    .hide_size .check-box {
        margin-bottom: 1rem;
    }
</style>

<body data-pgCode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"></jsp:include>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"></jsp:include>
    </div>
    <div id="container">
        <h2 class="txt">전광판 연계 > 전광판 전송 관리</h2>
        <div id="contents">
            <div class="contents-re">
                <div class="contents-head">
                    <h3 class="txt">평시 이미지</h3>
                    <div class="search-top">
                        <div class="btn-group">
                            <a href="javascript:void(0);">전송그룹</a>
                            <a href="javascript:void(0);">전송그룹1</a>
                            <a href="javascript:void(0);">등록</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <div class="bTable">
                        <jsp:include page="./display-send-management-normal-grid.jsp" flush="true"></jsp:include>
                    </div>
                </div>
            </div>
            <div class="contents-re">
                <div class="contents-head">
                    <h3 class="txt">전광판 전송</h3>
                    <div class="search-top">
                        <div class="btn-group">
                            <a href="javascript:void(0);">전송</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <div class="bTable">
                        <table>
                            <colgroup>
                                <col width="130"/>
                                <col width="*"/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>현장명</th>
                                <td>
                                    <select name="">
                                        <option value="">이월지구</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>전광판</th>
                                <td>
                                    <select name="">
                                        <option value="">이월지구시점</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>전송그룹</th>
                                <td>
                                    <select name="">
                                        <option value="">전송그룹1</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>이벤트 구분</th>
                                <td>
                                    <select name="">
                                        <option value="">평시</option>
                                        <option value="">긴급</option>
                                    </select>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="contents-re">
                <div class="contents-head">
                    <h3 class="txt">긴급 이미지</h3>
                    <div class="search-top">
                        <div class="btn-group">
                            <a href="javascript:void(0);">전송그룹</a>
                            <a href="javascript:void(0);">전송그룹1</a>
                            <a href="javascript:void(0);">등록</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <div class="bTable">
                        <table>
                            <thead>
                            <tr>
                                <th>이미지</th>
                                <th>효과</th>
                                <th>표시시간(Sec)</th>
                                <th>사용여부</th>
                                <th>수정</th>
                                <th>삭제</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>이미지</td>
                                <td>바로표시</td>
                                <td>4(Sec)</td>
                                <td>Y</td>
                                <td>
                                    <button><img src="./images/square-pen.svg" alt=""></button>
                                </td>
                                <td>
                                    <button><img src="./images/trash-2.svg" alt=""></button>
                                </td>
                            </tr>
                            <tr>
                                <td>이미지</td>
                                <td>바로표시</td>
                                <td>4(Sec)</td>
                                <td>Y</td>
                                <td>
                                    <button><img src="./images/square-pen.svg" alt=""></button>
                                </td>
                                <td>
                                    <button><img src="./images/trash-2.svg" alt=""></button>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="contents-re">
                <div class="contents-head">
                    <h3 class="txt">전광판 전송 이력</h3>
                    <div class="search-top">
                    </div>
                </div>
                <div class="contents-in">
                    <div class="bTable">
                        <table>
                            <thead>
                            <tr>
                                <th>No</th>
                                <th>전송일시</th>
                                <th>현장명</th>
                                <th>전광판 위치</th>
                                <th>이벤트 구분</th>
                                <th>전송 그룹</th>
                                <th>자동전송 여부</th>
                                <th>전송 결과</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>1</td>
                                <td>2024-01-01 14:00:00</td>
                                <td>이월지구</td>
                                <td>이월지구시점</td>
                                <td>평시</td>
                                <td>전송 그룹1</td>
                                <td>수동</td>
                                <td>Y</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>2024-01-01 14:00:00</td>
                                <td>수점지구</td>
                                <td>수점지구시점</td>
                                <td>센서경보</td>
                                <td>전송 그룹2</td>
                                <td>자동</td>
                                <td>Y</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="contents-re">
                <div class="contents-head">
                    <h3 class="txt">센서 경보 이미지</h3>
                    <div class="search-top">
                        <div class="btn-group">
                            <a href="javascript:void(0);">전송그룹</a>
                            <a href="javascript:void(0);">전송그룹1</a>
                            <a href="javascript:void(0);">등록</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <div class="bTable">
                        <table>
                            <thead>
                            <tr>
                                <th>이미지</th>
                                <th>효과</th>
                                <th>표시시간(Sec)</th>
                                <th>사용여부</th>
                                <th>수정</th>
                                <th>삭제</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>이미지</td>
                                <td>바로표시</td>
                                <td>4(Sec)</td>
                                <td>Y</td>
                                <td>
                                    <button><img src="./images/square-pen.svg" alt=""></button>
                                </td>
                                <td>
                                    <button><img src="./images/trash-2.svg" alt=""></button>
                                </td>
                            </tr>
                            <tr>
                                <td>이미지</td>
                                <td>바로표시</td>
                                <td>4(Sec)</td>
                                <td>Y</td>
                                <td>
                                    <button><img src="./images/square-pen.svg" alt=""></button>
                                </td>
                                <td>
                                    <button><img src="./images/trash-2.svg" alt=""></button>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--[e] 컨텐츠 영역 -->

    <!-- 팝업 -->
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
    <!-- 팝업 -->
</section>
</body>
</html>
