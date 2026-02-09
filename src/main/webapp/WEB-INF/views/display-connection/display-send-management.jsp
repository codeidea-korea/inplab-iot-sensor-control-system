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
        grid-template-rows: repeat(3, minmax(0, 1fr));
        gap: 1.2rem;
        overflow: hidden;
    }

    .contents-re {
        width: 100%;
        min-height: 0;
        display: flex;
        flex-direction: column;
    }

    .contents-re:nth-of-type(4) {
        grid-column: 2;
        grid-row: 2/ span 2;
        grid-template-columns: repeat(3, 1fr);
    }

    .contents-head {
        display: flex;
        margin-bottom: 1rem;
        flex-shrink: 0;
    }

    .search-top {
        position: static;
    }

    .btn-group {
        position: static;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 1rem;
    }

    .btn-group .group-label {
        margin-left: 1rem;
        font-weight: 500;
        font-size: 1.4rem;
        line-height: 2.8rem;
        color: #fff;
    }

    .btn-group .insert-btn, #dispbd-send-btn {
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
        flex: 1;
        min-height: 0;
        overflow: hidden;
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

    .detail-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        height: 2.6rem;
        padding: 0 1.2rem;
        border-radius: 99px;
        background: #244ea3;
        color: #fff;
        font-size: 1.2rem;
        cursor: pointer;
    }

    .detail-btn,
    .detail-btn:visited,
    .detail-btn:hover,
    .detail-btn:active {
        color: #fff !important;
        text-decoration: none;
    }

    #lay-form-write,
    #lay-form-detail {
        width: 560px;
        max-width: calc(100vw - 40px);
        height: auto !important;
    }

    #lay-form-write .layer-base-conts,
    #lay-form-detail .layer-base-conts {
        max-height: none !important;
        overflow-y: visible !important;
    }

    #lay-form-write .bTable,
    #lay-form-detail .bTable {
        height: auto !important;
        display: block;
    }

    .fancybox-slide--html .fancybox-content {
        max-height: none !important;
        overflow: visible !important;
    }

    .fancybox__content > .f-button.is-close-btn {
        display: none !important;
    }

    #lay-form-write .btn-btm,
    #lay-form-detail .btn-btm {
        position: static;
        background: #fff;
        padding-top: 1rem;
    }

    @media (max-width: 1280px) {
        #contents {
            height: auto !important;
            grid-template-columns: 1fr;
            grid-template-rows: auto;
            overflow: visible;
        }

        .contents-re:nth-of-type(4) {
            grid-column: auto;
            grid-row: auto;
        }
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

        const syncLayoutHeight = () => {
            if (window.matchMedia("(max-width: 1280px)").matches) {
                $("#contents").css("height", "");
                return;
            }
            const $contents = $("#contents");
            const top = $contents.offset()?.top || 0;
            const available = Math.max(0, window.innerHeight - top - 20);
            $contents.css("height", available + "px");
        };

        const resizeGrid = ($grid) => {
            if (!$grid.length) {
                return;
            }
            const $container = $grid.closest('.contents-in');
            const width = $container.width();
            const height = Math.max(120, $container.height() - 38);
            if (width > 0) {
                $grid.jqGrid('setGridWidth', width, true);
                $grid.jqGrid('setGridHeight', height);
            }
        };

        $(window).on("resize", () => {
            syncLayoutHeight();
            resizeGrid($normalGrid);
            resizeGrid($emerGrid);
            resizeGrid($sensorGrid);
            resizeGrid($historyGrid);
        });
        syncLayoutHeight();

        const reloadAllImageGrids = () => {
            $normalGrid.trigger('reloadGrid');
            $emerGrid.trigger('reloadGrid');
            $sensorGrid.trigger('reloadGrid');
        };

        window.renderDisplayDetailButtons = () => {};

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
                    reloadAllImageGrids();
                    $(window).trigger('resize');
                }, 100);
            },
            error: function () {
                alert('알 수 없는 오류가 발생했습니다.');
            }
        });

        $("#normal-group").on('change', function () {
            setGridData($normalGrid, $("#normal-group").val(), 0);
            reloadAllImageGrids();
        });

        $("#emer-group").on('change', function () {
            setGridData($emerGrid, $("#emer-group").val(), 1);
            reloadAllImageGrids();
        });

        $("#sensor-group").on('change', function () {
            setGridData($sensorGrid, $("#sensor-group").val(), 2);
            reloadAllImageGrids();
        });

        $("#district-no").on('change', () => {
            $('#dispbd_nm').empty()
            $('#dispbd_nm').append(
                "<option value=''>선택</option>"
            );
            if ($("#district-no").val() === '') {
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
                    img_grp_nm: $("#dispbd_group").val(),
                    dispbd_rslt_yn: 'Y'
                }),
                success: function (_res) {
                    alert('전송 이력이 저장되었습니다.');
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
            enforceModalNoScroll('#lay-form-write');
        })

        $(document).on("click", ".detail-btn", function () {
            const gridId = $(this).data("grid");
            const rowId = $(this).data("row-id");
            const mgntNo = $(this).data("mgnt-no");
            const $grid = $("#" + gridId);
            const rowData = $grid.jqGrid("getRowData", rowId);
            const resolvedMgntNo = mgntNo || rowData.mgnt_no;
            if (!rowData || !resolvedMgntNo) {
                alert("상세정보를 불러오지 못했습니다.");
                return;
            }

            const eventMap = {"0": "평시", "1": "긴급", "2": "센서경보"};
            $("#detail_mgnt_no").val(resolvedMgntNo);
            $("#detail_event_flag").val(eventMap[rowData.dispbd_evnt_flag] || rowData.dispbd_evnt_flag);
            $("#detail-modal-title").text((eventMap[rowData.dispbd_evnt_flag] || rowData.dispbd_evnt_flag) + " 이미지 상세정보");
            $("#detail_img_grp_nm").val(rowData.img_grp_nm);
            $("#detail_dispbd_imgfile_nm").val(rowData.dispbd_imgfile_nm);
            $("#detail_effect").val(rowData.img_effect_cd);
            $("#detail_effect_sec").val(rowData.img_disp_min);
            $("#detail_use_yn").val(rowData.use_yn || "Y");

            popFancy("#lay-form-detail");
            enforceModalNoScroll('#lay-form-detail');
        });

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

        function parsePositiveInt(value) {
            const parsed = parseInt(value, 10);
            if (Number.isNaN(parsed) || parsed <= 0) {
                return null;
            }
            return parsed;
        }

        function enforceModalNoScroll(targetId) {
            const applyStyles = () => {
                const $layer = $(targetId);
                $layer.css({
                    maxHeight: 'none',
                    height: 'auto',
                    overflow: 'visible'
                });
                $layer.find('.layer-base-conts').css({
                    maxHeight: 'none',
                    height: 'auto',
                    overflow: 'visible'
                });

                const $content = $layer.closest('.fancybox__content');
                const $slide = $layer.closest('.fancybox__slide');
                $content.css({
                    maxHeight: 'none',
                    height: 'auto',
                    overflow: 'visible'
                });
                $slide.css({
                    maxHeight: 'none',
                    height: 'auto',
                    overflow: 'visible'
                });

                $content.find('> .f-button.is-close-btn').hide();
            };

            [0, 80, 180].forEach((delay) => setTimeout(applyStyles, delay));
        }

        $("#form-submit-btn").click(async () => {
            let eventFlagCode = $("#event_flag").val();
            let eventFlag;
            let base64Image;
            let fileName;

            if (eventFlagCode === '평시') {
                eventFlag = 0;
            } else if (eventFlagCode === '긴급') {
                eventFlag = 1;
            } else {
                eventFlag = 2;
            }

            const imageFile = $("#image_file")[0].files[0];
            if (!imageFile) {
                alert('이미지 파일을 선택해주세요.');
                return;
            }

            try {
                const originalName = imageFile.name || "image.png";
                const extension = originalName.includes(".") ? originalName.split(".").pop() : "png";
                fileName = "dispbd_" + Date.now() + "_" + Math.floor(Math.random() * 1000) + "." + extension;
                base64Image = await readFileAsBase64(imageFile);
            } catch (_error) {
                alert('이미지 파일을 읽는 중 오류가 발생했습니다.');
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

            const effectSeconds = parsePositiveInt($("#effect_sec").val());
            if (effectSeconds === null) {
                alert('표시시간은 1 이상의 숫자로 입력해주세요.');
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
                    img_disp_min: effectSeconds,
                    use_yn: $("#use_yn").val(),
                    img_size: "1920x1080",
                    img_bg_color: "#000000",
                    font_size: "24",
                    font_color: "#FFFFFF",
                    dispbd_imgfile_nm: fileName
                },
                success: function (_res) {
                    alert('이미지가 등록되었습니다.');
                    popFancyClose('#lay-form-write');
                    reloadAllImageGrids();
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

        $(document).on("click", "#detail-update-btn", () => {
            const detailMgntNo = $.trim($("#detail_mgnt_no").val());
            if (!detailMgntNo) {
                alert("관리번호를 찾지 못했습니다. 상세정보를 다시 열어주세요.");
                return;
            }

            if ($("#detail_effect").val() === '') {
                alert("표시효과를 선택해주세요.");
                return;
            }
            const detailEffectSeconds = parsePositiveInt($("#detail_effect_sec").val());
            if (detailEffectSeconds === null) {
                alert("표시시간은 1 이상의 숫자로 입력해주세요.");
                return;
            }

            $.ajax({
                url: '/display-connection/display-send-management/mod',
                type: 'GET',
                cache: false,
                data: {
                    mgnt_no: detailMgntNo,
                    img_effect_cd: $("#detail_effect").val(),
                    img_disp_min: detailEffectSeconds,
                    use_yn: $("#detail_use_yn").val(),
                    dispbd_evnt_flag: {"평시": "0", "긴급": "1", "센서경보": "2"}[$("#detail_event_flag").val()] || "",
                    img_grp_nm: $("#detail_img_grp_nm").val(),
                    dispbd_imgfile_nm: $("#detail_dispbd_imgfile_nm").val()
                },
                success: function () {
                    alert("수정되었습니다.");
                    popFancyClose('#lay-form-detail');
                    reloadAllImageGrids();
                },
                error: function () {
                    alert("수정 중 오류가 발생했습니다.");
                }
            });
        });

        $(document).on("click", "#detail-delete-btn", () => {
            const detailMgntNo = $.trim($("#detail_mgnt_no").val());
            if (!detailMgntNo) {
                alert("관리번호를 찾지 못했습니다. 상세정보를 다시 열어주세요.");
                return;
            }

            confirm("해당 이미지를 삭제하시겠습니까?", function () {
                $.ajax({
                    url: '/display-connection/display-send-management/del',
                    type: 'GET',
                    cache: false,
                    data: {
                        mgnt_no: detailMgntNo
                    },
                    success: function (res) {
                        if (Number(res) > 0) {
                            alert("삭제되었습니다.");
                            popFancyClose('#lay-form-detail');
                            reloadAllImageGrids();
                        } else {
                            alert("삭제 대상이 없습니다.");
                        }
                    },
                    error: function () {
                        alert("삭제 중 오류가 발생했습니다.");
                    }
                });
            });
        });
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
                            <span class="group-label">전송그룹</span>
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
                            <span class="group-label">전송그룹</span>
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
                            <span class="group-label">전송그룹</span>
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
                        <td><input type="file" id="image_file" accept="image/*"/></td>
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
                        <td><input type="number" id="effect_sec" placeholder="Ex) 4" min="1"/></td>
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

    <div id="lay-form-detail" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title" id="detail-modal-title">이미지 상세정보</div>
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
                        <td>
                            <input type="hidden" id="detail_mgnt_no"/>
                            <input type="text" id="detail_event_flag" readonly/>
                        </td>
                    </tr>
                    <tr>
                        <th>전송그룹명</th>
                        <td><input type="text" id="detail_img_grp_nm" readonly/></td>
                    </tr>
                    <tr>
                        <th>이미지 파일명</th>
                        <td><input type="text" id="detail_dispbd_imgfile_nm" readonly/></td>
                    </tr>
                    <tr>
                        <th>표시효과</th>
                        <td>
                            <select id="detail_effect">
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
                        <td><input type="number" id="detail_effect_sec" placeholder="Ex) 4" min="1"/></td>
                    </tr>
                    <tr>
                        <th>사용여부</th>
                        <td>
                            <select id="detail_use_yn">
                                <option value="Y">사용</option>
                                <option value="N">미사용</option>
                            </select>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <input type="button" id="detail-delete-btn" value="삭제"/>
                <input type="button" id="detail-update-btn" blue value="수정"/>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>
    <!-- 팝업 -->

</body>
</html>
