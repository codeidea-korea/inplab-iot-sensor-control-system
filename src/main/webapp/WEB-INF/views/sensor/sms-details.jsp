<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<style>
    .layer-base-conts {
        display: flex;
        gap: 1rem;
    }

    .sms-detail-search {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.6rem;
    }

    .sms-detail-search .search-top {
        position: static;
        align-items: center;
        gap: 0.5rem;
        margin-bottom: 0;
    }

    .sms-detail-search .search-top > div {
        display: flex;
        flex-direction: row;
        align-items: center;
    }

    .sms-detail-search .search-top-label {
        color: #00000099;
        font-size: 1.4rem;
        display: flex;
        align-items: center;
        padding: 0 0.8rem;
    }

    .sms-detail-search input[type="date"] {
        width: 18rem;
        height: 3.6rem;
        padding: 0 1.2rem;
        background-color: #fff;
        border: 1px solid rgba(0, 0, 0, 0.2);
        font-weight: 300;
        font-size: 1.4rem;
        line-height: 3.4rem;
        color: #47474c;
        text-align: center;
    }
</style>

<div id="lay-sensor-message" class="layer-base">
    <div class="layer-base-btns">
        <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
    </div>
    <div class="layer-base-title">문자 전송 상세내역</div>
    <div class="sms-detail-search">
        <div class="search-top">
            <div>
                <p class="search-top-label">조회기간</p>
                <input id="sms-start-date" type="date"/>
            </div>
            <div>
                <p class="search-top-label">~</p>
                <input id="sms-end-date" type="date"/>
            </div>
        </div>
        <div class="search-top_">
            <a id="sms-search-btn" class="btns">조회</a>
        </div>
    </div>
    <div class="layer-base-conts min bTable" style="width: 100%">
        <div class="flex-item" style="width: 50%">
            <jsp:include page="./sms-details-grid.jsp" flush="true"/>
        </div>
        <div class="flex-item-right" style="width: 50%">
            <table class="message_text">
                <thead>
                <tr>
                    <th>문자내역</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>
                        <textarea id="sms-content" style="min-width: 555px; min-height: 555px"></textarea>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
