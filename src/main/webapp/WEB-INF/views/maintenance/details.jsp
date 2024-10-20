<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>
    <style>
        input[type=date], input[type=number] {
            text-align: left !important;
        }

        textarea {
            text-align: left !important;
        }

        .layer-base-conts {
            display: flex;
            gap: 3rem;
        }

        .layer-base .layer-base-conts {
            padding: 3rem;
        }

        .photo_area {
            display: grid;
            grid-template-columns: 1fr 1fr;
            width: 100%;
            height: auto !important;
            gap: 1.5rem;
        }

        .photo_area div {
            width: 100%;
            background-color: rgb(238, 238, 238);
            vertical-align: center;
            padding: 6rem 0;
            font-size: 1.5rem;
            color: #47474c;
            text-align: center;
        }

        .photo {
            width: 100px;
            height: 100px;
            border: 1px solid #ccc;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            cursor: pointer;
        }

        .photo img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            position: absolute;
            top: 0;
            left: 0;
        }

        .delete-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background: rgba(255, 0, 0, 0.7);
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            z-index: 10;
        }
    </style>
    <script>
        window.jqgridOption = {
            columnAutoWidth: true,
            multiselect: true,
            multiboxonly: false
        };
        $(function () {
            initDistrict();
            initMaintComp();

            let imageStorage = {};

            $('.insertBtn').on('click', () => {
                resetForm();
                initInsertForm();
                popFancy('#lay-maintenance-history');
            });

            $('.modifyBtn').on('click', () => {
                resetForm();
                const targetArr = getSelectedCheckData();
                if (targetArr.length > 1) {
                    alert('수정할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length === 0) {
                    alert('수정할 데이터를 선택해주세요.');
                    return;
                }
                initModifyForm(targetArr[0]);
                popFancy('#lay-maintenance-history');
            });

            function initModifyForm(data) {
                $("#form_sub_title").html('상세 정보');

                $("#deleteBtn").show();
                $("#form-submit-btn").hide();
                $("#form-update-btn").show();
                $('#district_no').val(data.district_no);

                getAllSensorInfoByDistrictNo(data.district_no, () => {
                    $('#sens_nm').val(data.sens_no);

                    const selectedSensTypeNo = $('#sens_nm').find(':selected').data('senstypeno');

                    getAllSensorTypesBySensTypeNo(selectedSensTypeNo, () => {
                        $('#senstype_no').val(selectedSensTypeNo);
                    });
                });

                $('#mgnt_no').val(data.mgnt_no);
                $('#maint_accpt_ymd').val(data.maint_accpt_ymd);
                $('#maint_str_ymd').val(data.maint_str_ymd);
                $('#maint_end_ymd').val(data.maint_end_ymd);
                $('#maint_dtls').val(data.maint_dtls);
                $('#maint_comp_nm').val(data.maint_comp_nm);
                $('#maint_chgr_nm').val(data.maint_chgr_nm);
                $('#maint_chgr_ph').val(data.maint_chgr_ph);
                $('#maint_rslt_cd').val(data.maint_rslt_cd);

                data.maint_pic_path1 && setInitialPhoto(1, data.maint_pic_path1);
                data.maint_pic_path2 && setInitialPhoto(2, data.maint_pic_path2);
                data.maint_pic_path3 && setInitialPhoto(3, data.maint_pic_path3);
                data.maint_pic_path4 && setInitialPhoto(4, data.maint_pic_path4);
            }

            $('#district_no').on('change', () => {
                emptySensorInfo();
                emptySensorTypes()
                const selectedDistrictNo = $('#district_no').val();
                if (selectedDistrictNo) {
                    getAllSensorInfoByDistrictNo(selectedDistrictNo);
                }
            })

            function resetForm() {
                $('#mgnt_no').val('');
                $('#district_no').val('');
                $('#sens_nm').val('');
                $('#senstype_no').val('');
                $('#maint_accpt_ymd').val('');
                $('#maint_str_ymd').val('');
                $('#maint_end_ymd').val('');
                $('#maint_dtls').val('');
                $('#maint_comp_nm').val('');
                $('#maint_chgr_nm').val('');
                $('#maint_chgr_ph').val('');
                $('#maint_rslt_cd').val('');
                emptySensorInfo();
                emptySensorTypes()
                imageStorage = {};
                $('.photo').empty();
                $('.photo1').append('<span>사진1</span>');
                $('.photo2').append('<span>사진2</span>');
                $('.photo3').append('<span>사진3</span>');
                $('.photo4').append('<span>사진4</span>');
            }

            function initInsertForm() {
                $("#form_sub_title").html('등록');
                $("#form-submit-btn").show()
                $("#deleteBtn").hide();
                $("#form-update-btn").hide();
            }

            $('#sens_nm').on('change', () => {
                emptySensorTypes();
                const selectedSensTypeNo = $('#sens_nm').find(':selected').data('senstypeno');
                if (selectedSensTypeNo) {
                    getAllSensorTypesBySensTypeNo(selectedSensTypeNo);
                }
            })

            $('.excelBtn').on('click', () => {
                downloadExcel('maintenance details');
            });

            function getAllSensorTypesBySensTypeNo(senstypeNo, callback) {
                $.ajax({
                    url: '/adminAdd/sensorType/all-by-sens-type-no',
                    type: 'GET',
                    data: {senstype_no: senstypeNo},
                    success: function (res) {
                        if (res.length === 0) {
                            emptySensorTypes();
                        } else {
                            res.forEach((item) => {
                                $('#senstype_no').append(
                                    "<option value='" + item.senstype_no + "'>" + item.sens_abbr + "</option>"
                                )
                            })
                        }
                        if (callback) {
                            callback();
                        }

                    },
                    error: function () {
                        alert('알 수 없는 오류가 발생했습니다.');
                    }
                });
            }

            function getAllSensorInfoByDistrictNo(districtNo, callback) {
                $.ajax({
                    url: '/adminAdd/sensorInfo/all-by-district-no',
                    type: 'GET',
                    data: {district_no: districtNo},
                    success: function (res) {
                        if (res.length === 0) {
                            emptySensorInfo();
                        } else {
                            res.forEach((item) => {
                                $('#sens_nm').append(
                                    "<option data-senstypeno=" + item.senstype_no + " value='" + item.sens_no + "'>" + item.sens_nm + "</option>"
                                )
                            })
                        }
                        if (callback) {
                            callback();
                        }

                    },
                    error: function () {
                        alert('알 수 없는 오류가 발생했습니다.');
                    }
                });
            }

            function initMaintComp() {
                $.ajax({
                    url: '/maintenance/company-management/all',
                    type: 'GET',
                    success: function (res) {
                        res.forEach((item) => {
                            $('#maint_comp_nm').append(
                                "<option value='" + item.partner_comp_nm + "'>" + item.partner_comp_nm + "</option>"
                            )
                        })
                    },
                    error: function () {
                        alert('알 수 없는 오류가 발생했습니다.');
                    }
                });
            }

            function initDistrict() {
                $.ajax({
                    url: '/adminAdd/districtInfo/all',
                    type: 'GET',
                    success: function (res) {
                        res.forEach((item) => {
                            $('#district_no').append(
                                "<option value='" + item.district_no + "'>" + item.district_nm + "</option>"
                            )
                        })
                    },
                    error: function () {
                        alert('알 수 없는 오류가 발생했습니다.');
                    }
                });
            }

            function emptySensorInfo() {
                $('#sens_nm').empty();
                $('#sens_nm').append(
                    "<option value=''>선택</option>"
                )
            }

            function emptySensorTypes() {
                $('#senstype_no').empty();
                $('#senstype_no').append(
                    "<option value=''>선택</option>"
                )
            }

            $('.photo').on('click', function () {
                const index = $(this).data('index');
                $('#fileInput').data('photo-index', index).click();
            });

            $('#fileInput').on('change', function (event) {
                const file = event.target.files[0];
                const index = $(this).data('photo-index');

                if (file) {
                    const reader = new FileReader();

                    reader.onload = function (e) {
                        const base64String = e.target.result;
                        imageStorage[index] = base64String;

                        const photoDiv = $('.photo[data-index="' + index + '"]');
                        photoDiv.empty();
                        photoDiv.append('<img src="' + base64String + '" alt="Selected Image">');
                        photoDiv.append('<button class="delete-btn" data-index="' + index + '">삭제</button>');
                    };

                    reader.readAsDataURL(file);
                }
                $(this).val('');
            });

            $(document).on('click', '.delete-btn', function (event) {
                event.stopPropagation();
                const index = $(this).data('index');

                delete imageStorage[index];
                const photoDiv = $('.photo[data-index="' + index + '"]');
                photoDiv.empty();
                photoDiv.append('<span>사진' + index + '</span>');
            });

            function setInitialPhoto(index, imageUrl) {
                const photoDiv = $('.photo[data-index="' + index + '"]');
                photoDiv.empty();
                photoDiv.append('<img src="' + imageUrl + '" alt="Initial Image">'); // 기본 이미지 설정
                photoDiv.append('<button class="delete-btn" data-index="' + index + '">삭제</button>');
                imageStorage[index] = imageUrl; // 기본 이미지 저장
            }

            $("#form-submit-btn").on('click', function () {
                $.ajax({
                    url: '/maintenance/details/add',
                    type: 'POST',
                    data: {
                        district_no: $('#district_no').val(),
                        sens_no: $('#sens_nm').val(),
                        maint_accpt_ymd: $('#maint_accpt_ymd').val().replaceAll('-', ''),
                        maint_str_ymd: $('#maint_str_ymd').val().replaceAll('-', ''),
                        maint_end_ymd: $('#maint_end_ymd').val().replaceAll('-', ''),
                        maint_dtls: $('#maint_dtls').val(),
                        maint_comp_nm: $('#maint_comp_nm').val(),
                        maint_chgr_nm: $('#maint_chgr_nm').val(),
                        maint_chgr_ph: $('#maint_chgr_ph').val(),
                        maint_rslt_cd: $('#maint_rslt_cd').val(),
                        maint_pic_path1: imageStorage[1] || '',
                        maint_pic_path2: imageStorage[2] || '',
                        maint_pic_path3: imageStorage[3] || '',
                        maint_pic_path4: imageStorage[4] || ''
                    },
                    success: function () {
                        popFancyClose('#lay-maintenance-history');
                        reloadJqGrid();
                    },
                    error: function () {
                        alert('잘못된 입력입니다. 다시 시도해 주세요.');
                    }
                });
            });

            $("#form-update-btn").on('click', function () {
                $.ajax({
                    url: '/maintenance/details/mod',
                    type: 'POST',
                    data: {
                        mgnt_no: $('#mgnt_no').val(),
                        district_no: $('#district_no').val(),
                        sens_no: $('#sens_nm').val(),
                        maint_accpt_ymd: $('#maint_accpt_ymd').val().replaceAll('-', ''),
                        maint_str_ymd: $('#maint_str_ymd').val().replaceAll('-', ''),
                        maint_end_ymd: $('#maint_end_ymd').val().replaceAll('-', ''),
                        maint_dtls: $('#maint_dtls').val(),
                        maint_comp_nm: $('#maint_comp_nm').val(),
                        maint_chgr_nm: $('#maint_chgr_nm').val(),
                        maint_chgr_ph: $('#maint_chgr_ph').val(),
                        maint_rslt_cd: $('#maint_rslt_cd').val(),
                        maint_pic_path1: imageStorage[1] || '',
                        maint_pic_path2: imageStorage[2] || '',
                        maint_pic_path3: imageStorage[3] || '',
                        maint_pic_path4: imageStorage[4] || ''
                    },
                    success: function () {
                        popFancyClose('#lay-maintenance-history');
                        reloadJqGrid();
                    },
                    error: function () {
                        alert('잘못된 입력입니다. 다시 시도해 주세요.');
                    }
                });
            });

            $('#deleteBtn').on('click', () => {
                confirm('삭제하시겠습니까?', () => {
                    $.ajax({
                        url: '/maintenance/details/del',
                        type: 'POST',
                        data: {
                            mgnt_no: $('#mgnt_no').val()
                        },
                        success: function (_res) {
                            popFancyClose('#lay-maintenance-history');
                            reloadJqGrid();
                        },
                        error: function (_err) {
                            alert('삭제에 실패했습니다. 다시 시도해 주세요.');
                        }
                    });
                })
            });

        });

    </script>
</head>

<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"></jsp:include>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"></jsp:include>
    </div>
    <div id="container">
        <h2 class="txt">유지보수관리</h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">유지보수이력</h3>
                <div class="btn-group">
                    <a class="insertBtn">신규등록</a>
                    <a class="modifyBtn">상세정보</a>
                    <a class="excelBtn">다운로드</a>
                </div>
                <div class="contents-in">
                    <jsp:include page="../common/include_jqgrid_old.jsp" flush="true"></jsp:include>
                </div>
            </div>
        </div>
    </div>

    <div id="lay-maintenance-history" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">유지보수업체 <span id="form_sub_title"></span></div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <input type="hidden" id="mgnt_no"/>
                    <tbody>
                    <tr>
                        <th>현장명</th>
                        <td>
                            <select id="district_no">
                                <option value="">Ex) 이월지구</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>센서ID</th>
                        <td><select id="sens_nm">
                            <option value="">Ex) TM-01</option>
                        </select></td>
                    </tr>
                    <tr>
                        <th>센서타입</th>
                        <td><select id="senstype_no">
                            <option value="">Ex) TM</option>
                        </select></td>
                    </tr>
                    <tr>
                        <th>접수일</th>
                        <td>
                            <input id="maint_accpt_ymd" type="date" placeholder="Ex) 2024-01-01"/>
                        </td>
                    </tr>
                    <tr>
                        <th>작업시작일</th>
                        <td>
                            <input id="maint_str_ymd" type="date" placeholder="Ex) 2024-01-01"/>
                        </td>
                    </tr>
                    <tr>
                        <th>작업종료일</th>
                        <td>
                            <input id="maint_end_ymd" type="date" placeholder="Ex) 2024-01-01"/>
                        </td>
                    </tr>
                    <tr>
                        <th>작업내역</th>
                        <td>
                            <textarea id="maint_dtls" placeholder="Ex) 1. 센서 교체"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>작업업체</th>
                        <td>
                            <select id="maint_comp_nm">
                                <option value="">Ex) 디피에스 글로벌</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>작업담당자</th>
                        <td>
                            <input id="maint_chgr_nm" type="text" placeholder="Ex) 홍길동"/>
                        </td>
                    </tr>
                    <tr>
                        <th>연락처</th>
                        <td>
                            <input id="maint_chgr_ph" type="text" placeholder="Ex) 010-1234-5678"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="bTable" style="margin-top: 0">
                <table>
                    <tbody>
                    <tr>
                        <th>작업결과</th>
                        <td><select id="maint_rslt_cd">
                            <option value="">Ex) 정상</option>
                            <option value="MTN001">정상</option>
                            <option value="MTN002">망실</option>
                            <option value="MTN003">점검</option>
                            <option value="MTN004">철거</option>
                        </select></td>
                    </tr>
                    <tr>
                        <th>작업사진</th>
                        <td>
                            <div class="photo_area">
                                <div class="photo photo1" data-index="1">
                                    <span>사진1</span>
                                </div>
                                <div class="photo photo2" data-index="2">
                                    <span>사진2</span>
                                </div>
                                <div class="photo photo3" data-index="3">
                                    <span>사진3</span>
                                </div>
                                <div class="photo photo4" data-index="4">
                                    <span>사진4</span>
                                </div>
                            </div>
                        </td>
                        <input type="file" id="fileInput" style="display: none;" accept="image/*">
                    </tr>
                    </tbody>
                </table>

                <div class="btn-btm">
                    <input type="button" id="form-submit-btn" blue value="저장"/>
                    <button type="button" style="margin-right: auto" id="deleteBtn">삭제</button>
                    <input type="button" id="form-update-btn" blue value="수정"/>
                    <button type="button" data-fancybox-close>닫기</button>
                </div>
            </div>

        </div>
    </div>

    </div>
</section>
</body>
</html>