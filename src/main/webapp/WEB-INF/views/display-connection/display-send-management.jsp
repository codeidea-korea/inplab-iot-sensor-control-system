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

    .btn-group a:nth-of-type(2), #dispbd-send-btn {
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
        /*overflow: auto; !* 스크롤 필요 시 표시 *!*/
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

                    $('#send_group').append(
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

        $(".insert-btn").click((e) => {
            const eventFlag = e.target.dataset.image;
            if (eventFlag === '0') {
                $('#event_flag').val('평시');
            } else if (eventFlag === '1') {
                $('#event_flag').val('긴급');
            } else {
                $('#event_flag').val('센서 경보');
            }
            popFancy('#lay-form-write');
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

        function readFileAsBase64(file) {
            return new Promise((resolve, reject) => {
                if (!file) {
                    reject(new Error("이미지 파일을 선택해주세요."));
                } else {
                    const reader = new FileReader();
                    reader.onload = (e) => resolve(e.target.result);
                    reader.onerror = () => reject(new Error("파일을 읽는 도중 에러가 발생했습니다."));
                    reader.readAsDataURL(file);
                }
            });
        }

        $("#form-submit-btn").click( async () => {
            let eventFlagCode = $("#event_flag").val();
            let eventFlag;
            let base64Image;

            if (eventFlagCode === '평시') {
                eventFlag = 0;
            } else if (eventFlagCode === '긴급') {
                eventFlag = 1;
            } else {
                eventFlag = 2;
            }

            try {
                base64Image = await readFileAsBase64($("#image_file")[0].files[0]);
            } catch (error) {
                alert(error.message);
                return;
            }

            if ($("#send_group").val() === '') {
                alert('전송그룹을 선택해주세요.');
                return;
            }

            if ($("#effect").val() === '') {
                alert('표시효과를 선택해주세요.');
                return;
            }

            if ($("#effect_sec").val() === '') {
                alert('표시시간을 입력해주세요.');
                return;
            }

            if ($("#dispbd_autosnd_yn").val() === '') {
                alert('자동여부를 선택해주세요.');
                return;
            }

            if ($("#use_yn").val() === '') {
                alert('사용여부를 선택해주세요.');
                return;
            }

            $.ajax({
                url: '/display-connection/display-img-management/add',
                type: 'POST',
                data: {
                    img_grp_nm: $("#send_group").val(),
                    img_file_path: base64Image,
                    dispbd_evnt_flag: eventFlag,
                    img_effect_cd: $("#effect").val(),
                    img_disp_min: $("#effect_sec").val(),
                    dispbd_autosnd_yn: $("#dispbd_autosnd_yn").val(),
                    use_yn: $("#use_yn").val(),
                    dispbd_imgfile_nm: 'temp'
                },
                success: function (_res) {
                    alert('이미지가 등록되었습니다.');
                    popFancyClose('#lay-form-write');
                },
                error: function (err) {
                    if (err?.responseJSON?.trace?.toString()?.includes('Duplicate')) {
                        alert('해당 그룹에 이미지가 등록되어 있습니다.');
                    } else {
                        alert('알 수 없는 오류가 발생했습니다.');
                    }
                }
            });

        })
    });
</script>

<body data-pgCode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"/>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"/>
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
                            <a data-image="0" class="insert-btn">등록</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <jsp:include page="./display-send-management-normal-grid.jsp" flush="true"/>
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
                            <a data-image="1" class="insert-btn">등록</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <jsp:include page="./display-send-management-emer-grid.jsp" flush="true"/>
                </div>
            </div>
            <div class="contents-re">
                <div class="contents-head">
                    <h3 class="txt">전광판 전송 이력</h3>
                    <div class="search-top">
                    </div>
                </div>
                <div class="contents-in">
                    <jsp:include page="./display-send-history-grid.jsp" flush="true"/>
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
                            <a data-image="2" class="insert-btn">등록</a>
                        </div>
                    </div>
                </div>
                <div class="contents-in">
                    <div class="bTable">
                        <jsp:include page="./display-send-management-sensor-grid.jsp" flush="true"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--[e] 컨텐츠 영역 -->

    <!-- 팝업 -->
    <div id="lay-form-write" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">전송그룹별 이미지 등록</div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>이벤트 구분</th>
                        <td><input type="text" id="event_flag" placeholder="Ex) 평시" readonly/></td>
                    </tr>
                    <tr>
                        <th>이미지 파일</th>
                        <td><input type="file" id="image_file" accept="image/*" /></td>
                    </tr>
                    <tr>
                        <th>전송그룹명</th>
                        <td>
                            <select id="send_group">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>표시효과</th>
                        <td>
                            <select id="effect">
                                <option value="">선택</option>
                                <option value="DSP001">바로 표시</option>
                                <option value="DSP002">우에서 좌로 스크롤</option>
                                <option value="DSP003">하에서 상으로 스크롤</option>
                                <option value="DSP004">상에서 하로 스크롤</option>
                                <option value="DSP005">레이저효과</option>
                                <option value="DSP006">중앙에서 상하로 떨어짐</option>
                                <option value="DSP007">상하에서 중앙으로 모임</option>
                                <option value="DSP008">1단으로 좌측 스크롤</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>표시시간(초)</th>
                        <td><input type="number" id="effect_sec" placeholder="Ex) 4"/></td>
                    </tr>
                    <tr>
                        <th>자동여부</th>
                        <td><select id="dispbd_autosnd_yn">
                            <option value="">선택</option>
                            <option value="Y">자동</option>
                            <option value="N">수동</option>
                        </select></td>
                    </tr>
                    <tr>
                        <th>사용여부</th>
                        <td><select id="use_yn">
                            <option value="">선택</option>
                            <option value="Y">사용</option>
                            <option value="N">미사용</option>
                        </select></td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <input type="button" id="form-submit-btn" blue value="저장"/>
                <button type="button" data-fancybox-close>닫기</button>
            </div>
        </div>
    </div>
    <!-- 팝업 -->

</body>
</html>
