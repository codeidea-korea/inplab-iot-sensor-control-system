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
        width: 100%;
        display: grid;
        align-items: stretch;
        grid-template-columns: 1fr 1fr;
    }
    .contents-re {
        width: 100%;
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

    .bTable {
        width: 100%; /* 부모 컨테이너에 맞춤 */
        height: 100%; /* 높이도 최대로 확장 */
        overflow: auto; /* 스크롤 필요 시 표시 */
        display: grid;
    }

    .contents-in {
        width: 100%;
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
<script>
    window.jqgridOption = {
        columnAutoWidth: true
    };

    $(document).ready(() => {

        const $normalGrid = $('#display-send-management-normal');
        const $emerGrid = $('#display-send-management-emer');
        const $sensorGrid = $('#display-send-management-sensor');
        const $historyGrid = $("#display-send-history-grid");

        $(window).on("resize", () => {
            $normalGrid.jqGrid('setGridWidth', $normalGrid.closest('.contents-in').width());
            $emerGrid.jqGrid('setGridWidth', $emerGrid.closest('.contents-in').width());
            $sensorGrid.jqGrid('setGridWidth', $sensorGrid.closest('.contents-in').width());
            $historyGrid.jqGrid('setGridWidth', $historyGrid.closest('.contents-in').width());
        })

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

        $.ajax({
            url: '/display-connection/display-send-management/group',
            type: 'GET',
            success: function (res) {
                res.forEach((item) => {
                    $('#normal-group, #emer-group, #sensor-group').append(
                        "<option value='" + item.img_grp_nm + "'>" + item.img_grp_nm + "</option>"
                    );

                    $('#dispbd_group').append(
                        "<option value='" + item.img_grp_nm + "'>" + item.img_grp_nm + "</option>"
                    );
                });
            },
            complete: function (res) {
                $('#normal-group, #emer-group, #sensor-group').val(res.responseJSON[0].img_grp_nm);

                setTimeout(() => {
                    setGridData($normalGrid, res.responseJSON[0].img_grp_nm, 0);
                    setGridData($emerGrid, res.responseJSON[0].img_grp_nm, 1);
                    setGridData($sensorGrid, res.responseJSON[0].img_grp_nm, 2);
                    $normalGrid.trigger('reloadGrid');
                    $emerGrid.trigger('reloadGrid');
                    $sensorGrid.trigger('reloadGrid');
                }, 100);
            },
            error: function () {
                alert('알 수 없는 오류가 발생했습니다.');
            }
        });

        $("#normal-group").on('change', function () {
            setGridData($normalGrid, $("#normal-group").val(), 0);
            $normalGrid.trigger('reloadGrid');
        });

        $("#emer-group").on('change', function () {
            setGridData($emerGrid, $("#emer-group").val(), 1);
            $emerGrid.trigger('reloadGrid');
        });

        $("#sensor-group").on('change', function () {
            setGridData($sensorGrid, $("#sensor-group").val(), 2);
            $sensorGrid.trigger('reloadGrid');
        });

        $("#district-no").on('change', () => {
            if ($("#district-no").val() === '') {
                $('#dispbd_nm').empty()
                $('#dispbd_nm').append(
                    "<option value=''>선택</option>"
                );
                return;
            } else {
                $.ajax({
                    url: '/adminAdd/displayBoard/all-by-district',
                    type: 'GET',
                    data: {
                        district_no: $("#district-no").val()
                    },
                    success: function (res) {
                        res.forEach((item) => {
                            $('#dispbd_nm').append(
                                "<option value='" + item.dispbd_no + "'>" + item.dispbd_nm + "</option>"
                            );
                        });
                    },
                    error: function () {
                        alert('알 수 없는 오류가 발생했습니다.');
                    }
                });
            }
        });

        $("#dispbd-send-btn").click(() => {
            if ($("#district-no").val() === '') {
                alert('현장명을 선택해주세요.');
                return;
            }

            if ($("#dispbd_nm").val() === '') {
                alert('전광판을 선택해주세요.');
                return;
            }

            if ($("#dispbd_group").val() === '') {
                alert('전송그룹을 선택해주세요.');
                return;
            }
            $.ajax({
                url: '/adminAdd/displayBoard/send-history',
                type: 'POST',
                dataType: 'json',
                async: true,
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({
                    dispbd_no: $("#dispbd_nm").val(),
                    district_no: $("#district-no").val(),
                    dispbd_evnt_flag: $("#event-select").val(),
                    dispbd_rslt_yn: 'N'
                }),
                success: function (_res) {
                    alert('전송이 완료되었습니다.');
                    $historyGrid.trigger('reloadGrid');
                },
                error: function (_err) {
                    alert('알 수 없는 오류가 발생했습니다.');
                }
            });
        })

        function setGridData($grid, img_grp_nm, dispbd_evnt_flag) {
            $grid.setGridParam({
                postData: {
                    ...$grid.jqGrid('getGridParam', 'postData'),
                    img_grp_nm: img_grp_nm,
                    dispbd_evnt_flag: dispbd_evnt_flag
                }
            }, true);
        }
    });
</script>

<body data-pgCode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"></jsp:include>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"></jsp:include>
    </div>
    <div id="container">
        <h2 class="txt">전광판 연계 > 전광판 전송 관리</h2>
        <div id="contents">
            <div id="normal-grid-div" class="contents-re">
                <div class="contents-head">
                    <h3 class="txt">평시 이미지</h3>
                    <div class="search-top">
                        <div class="btn-group">
                            <a href="javascript:void(0);">전송그룹</a>
                            <select id="normal-group" style="margin-left: 10px">
                                <option value="">선택</option>
                            </select>
                            <a href="javascript:void(0);">등록</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <jsp:include page="./display-send-management-normal-grid.jsp" flush="true"></jsp:include>
                </div>
            </div>
            <div class="contents-re">
                <div class="contents-head">
                    <h3 class="txt">전광판 전송</h3>
                    <div class="search-top">
                        <div class="btn-group">
                            <a id="dispbd-send-btn">전송</a>
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
                                    <select id="district-no">
                                        <option value="">선택</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>전광판</th>
                                <td>
                                    <select id="dispbd_nm">
                                        <option value="">선택</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>전송그룹</th>
                                <td>
                                    <select id="dispbd_group">
                                        <option value="">선택</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>이벤트 구분</th>
                                <td>
                                    <select id="event-select">
                                        <option value="0">평시</option>
                                        <option value="1">긴급</option>
                                        <option value="2">센서경보</option>
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
                            <select id="emer-group" style="margin-left: 10px">
                                <option value="">선택</option>
                            </select>
                            <a href="javascript:void(0);">등록</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <jsp:include page="./display-send-management-emer-grid.jsp" flush="true"></jsp:include>
                </div>
            </div>
            <div class="contents-re">
                <div class="contents-head">
                    <h3 class="txt">전광판 전송 이력</h3>
                    <div class="search-top">
                    </div>
                </div>
                <div class="contents-in">
                    <jsp:include page="./display-send-history-grid.jsp" flush="true"></jsp:include>
                </div>
            </div>
            <div class="contents-re">
                <div class="contents-head">
                    <h3 class="txt">센서 경보 이미지</h3>
                    <div class="search-top">
                        <div class="btn-group">
                            <a href="javascript:void(0);">전송그룹</a>
                            <select id="sensor-group" style="margin-left: 10px">
                                <option value="">선택</option>
                            </select>
                            <a href="javascript:void(0);">등록</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <div class="bTable">
                        <jsp:include page="./display-send-management-sensor-grid.jsp" flush="true"></jsp:include>
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
