<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>
    <style>
        h3.txt {
            margin: 0;
            width: 15rem;
        }

        .contents_header {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .search-top {
            position: static;
        }

        #contents .contents-re {
            position: static;
        }

        .search-top-label {
            color: #ffffff76;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            padding: 1rem;
        }

        #contents .contents-re {
            padding: 3rem;
            width: 40rem;
        }

        #contents .contents-in {
            position: static;
            height: auto;
            padding: 3rem;
            margin-top: 3rem;
        }

        .filter-area .select_filter .search-top-label {
            padding: 0;
        }

        .cctv_area .contents-in {
            height: auto !important;
            overflow: hidden;
        }

        .search-top {
            align-items: center;
            flex-wrap: wrap;
            gap: 0.5rem
        }

        .search-top > div {
            display: flex;
            flex-direction: row;
        }

        .search-top div:nth-child(2) > p {
            margin-right: 1rem;
        }

        #container input[type="datetime-local"] {
            width: 100%;
            height: 3.6rem;
            padding: 0 2rem;
            background-color: #fff;
            border: 1px solid rgba(0, 0, 0, 0.2);
            font-weight: 300;
            font-size: 1.5rem;
            line-height: 3.4rem;
            color: #47474c;
            text-align: center;
            display: inline-block;
            vertical-align: top;
        }

        .btn-group-2 > a {
            height: 2.8rem;
            margin-left: 1rem;
            padding: 0 1rem;
            background-color: #237149;
            font-weight: 500;
            font-size: 1.4rem;
            line-height: 1;
            color: #fff; /* text-align:center; */
            border-radius: 99px;
            display: flex;
            align-items: center;
            cursor: text;
            justify-content: center;
            white-space: nowrap;
        }

        .search-btn-wrapper a {
            height: 2.8rem;
            margin-left: 1rem;
            padding: 0 2rem;
            background-color: #6975ac;
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
</head>

<script>
    $(function () {
        const $grpGrid = $("#measure-details-grid");
        const $detailsGrid = $("#measure-details-data-grid");

        $.ajax({
            url: '/adminAdd/districtInfo/all',
            type: 'GET',
            success: function (res) {
                res.forEach((item) => {
                    $('#district-no').append(
                        "<option value='" + item.district_no + "'>" + item.district_nm + "</option>"
                    );
                });
            },
            error: function () {
                alert('알 수 없는 오류가 발생했습니다.');
            }
        });

        $("#district-no").on('change', function () {
            setGridData();
            $grpGrid.trigger('reloadGrid');
        });

        function setGridData() {
            $grpGrid.setGridParam({
                postData: {
                    ...$grpGrid.jqGrid('getGridParam', 'postData'),
                    district_no: $('#district-no').val()
                }
            }, true);
        }

        $("#search-btn").on('click', function () {
            const targetArr = getSelectedCheckData($grpGrid);
            if (targetArr.length > 1) {
                alert('조회할 데이터를 1건만 선택해주세요.');
                return;
            } else if (targetArr.length === 0) {
                alert('조회할 데이터를 선택해주세요.');
                return;
            } else {
                $detailsGrid.trigger('reloadGrid');
            }
        });
    });
</script>


<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="common/include_top.jsp" flush="true"></jsp:include>
    <div id="global-menu">
        <jsp:include page="common/include_sidebar.jsp" flush="true"></jsp:include>
    </div>

    <!--[s] 컨텐츠 영역 -->
    <div id="container">
        <h2 class="txt">
            관리자 전용
            <span class="arr">데이터 관리</span>
            <span class="arr">계측기 데이터 관리</span>
        </h2>
        <div id="contents">
            <div class="contents-re" style="width: 40%">
                <div class="contents_header">
                    <h3 class="txt">센서 계측 현황</h3>
                    <div class="search-top">
                        <p class="search-top-label">현장명</p>
                        <select id="district-no">
                            <option value="">선택</option>
                        </select>
                        <div class="search-btn-wrapper">
                            <a id="search-btn">조회</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <div class="bTable">
                        <jsp:include page="./measure-details-grid.jsp" flush="true"></jsp:include>
                    </div>
                </div>
            </div>

            <div class="contents-re cctv_area">
                <div class="contents_header">
                    <h3 class="txt">데이터값 수정</h3>
                    <div class="btn-group-2" style="display: flex; gap: 2px; align-items: start">
                        <a id="district_nm">현장명</a>
                        <a id="sens_tp_nm">센서타입</a>
                        <a id="sens_nm">센서명</a>
                    </div>
                </div>

                <div class="contents-in">
                    <div class="bTable">
                        <jsp:include page="./measure-details-data-grid.jsp" flush="true"></jsp:include>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <!--[e] 컨텐츠 영역 -->

</section>
</body>
</html>
