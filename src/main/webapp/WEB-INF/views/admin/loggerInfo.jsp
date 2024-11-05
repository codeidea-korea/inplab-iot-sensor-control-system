<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true" />
    <style>
        #map {
            width: 100%;
            height: 500px;
        }

        .centerMarker {
            position: absolute;
            left: calc(50% - 15px);
            top: calc(50% - 27px);
        }
    </style>
    <script>
        window.jqgridOption = {
            columnAutoWidth: true,
            multiselect: true,
            multiboxonly: false
        };

        var _popupClearData;

        $(function () {
            $('.deleteBtn').hide();
            window.vworld = new vwutil({
                mapId: "map",
                initPosition: {
                    center: [
                        // 126.88624657982738, 37.480957215573261
                        127.449482276989, 36.9317789946793
                    ], // [14124968.051077379, 4506389.894300204],
                    zoom: 18,
                    rotation: 0.5
                }
            });

            window.vworld.vwmap2d();
            _popupClearData = getSerialize('#lay-form-write');

            $.get('/adminAdd/common/code/list', {code_grp_nm: "로거구분"}, function (res) {
                let option = '<option value="">선택</option>';
                $.each(res, function (idx) {
                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#logr_flag').html(option);
            });

            $.get('/adminAdd/common/code/list', {code_grp_nm: "유지보수상태"}, function (res) {
                let option = '<option value="">선택</option>';
                $.each(res, function (idx) {
                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#maint_sts_cd').html(option);
            });

            $.get('/adminAdd/common/code/districtInfoList', null, function (res) {
                let option = '<option value="">선택</option>';
                $.each(res, function (idx) {
                    option += '<option value="' + res[idx].code + '">' + res[idx].name + '</option>';
                });
                $('#district_no').html(option);
            });

            // 팝업에서 삭제 버튼 클릭 시
            $('#lay-form-write .deleteBtn').on('click', function() {
                var logrNo = $('#logr_no').val();

                if (!logrNo) {
                    alert('삭제할 로거가 선택되지 않았습니다.');
                    return;
                }
                confirm('삭제하시겠습니까?', function() {
                    $.get('/adminAdd/loggerInfo/del', {logr_no: logrNo}, function(res) {
                        if (res === 1) {  // 성공 시
                            alert('삭제되었습니다.');
                            popFancyClose('#lay-form-write');
                            reloadJqGrid();  // 그리드를 리로드하여 변경 사항을 반영
                        } else if (res === -1) {  // 검증 실패 시
                            alert('이 로거는 삭제할 수 없습니다. 이미 사용 중이거나 다른 제약이 있습니다.');
                        } else {
                            alert('삭제 실패: ' + res);
                        }
                    });
                });
            });


            $('.insertBtn').on('click', function () {
                $('.deleteBtn').hide();
                $("#form_sub_title").html('신규 등록');
                $('input[type="submit"]').val('저장');
                setSerialize('#lay-form-write', _popupClearData);

                popFancy('#lay-form-write');

                $('#logr_flag').off('change').on('change', function () {
                    var logrFlag = $(this).val(); // 로거 구분 값

                    // logrFlag 값 변환
                    var preType;
                    if (logrFlag === 'L' || logrFlag === 'R') {
                        preType = ""; // LOG일 경우 preType은 빈 문자열
                    } else if (logrFlag === 'G') {
                        preType = "GNSS"; // GNS일 경우 preType은 GNSS
                    }

                    // logr_no 값 새로 조회하여 설정
                    if (preType !== undefined) {
                        $.get('/adminAdd/common/code/getNewGenerationKey', {
                            table_nm: "tb_logger_info",
                            column_nm: "logr_no",
                            pre_type: preType
                        }, function (res) {
                            if (res.length > 0) {
                                $('#lay-form-write input[name="logr_no"]').val(res[0].new_id);
                                $('#lay-form-write select[name="district_no"]').val('');
                                $('#lay-form-write input[name="logr_nm"]').val('');
                            }
                        });
                    }
                });

                // 현장명 선택 시 로거명 자동 생성
                $('#district_no').off('change').on('change', function () {
                    var districtNo = $(this).val(); // 현장명 값
                    var logrFlag = $('#logr_flag').val(); // 현재 선택된 로거 구분 값

                    // 로거 구분이 선택되지 않았다면 경고를 표시하고 진행 중지
                    if (logrFlag === "") {
                        alert("먼저 로거 구분을 선택하세요.");
                        $('#district_no').val(''); // 현장명 선택을 초기화
                        return;
                    }

                    var logrNo = $('#lay-form-write input[name="logr_no"]').val(); // 현재 설정된 로거 ID 값

                    if (districtNo !== "" && logrFlag !== "" && logrNo !== "") {
                        getDistrictAbbr(districtNo, function (districtAbbr) {
                            // logrFlag 값을 로거명 형식에 맞게 변환
                            if (logrFlag === 'L') {
                                logrFlag = 'LOG';
                            } else if (logrFlag === 'G') {
                                logrFlag = 'GNS';
                            }

                            // 로거명 생성: 현장약어 + 변환된 로거 구분 + 로거 ID
                            var logrNm = districtAbbr + logrFlag + logrNo;
                            $('#lay-form-write input[name="logr_nm"]').val(logrNm); // 로거명 필드에 설정
                        });
                    } else {
                        $('#lay-form-write input[name="logr_nm"]').val(''); // 로거명 초기화
                    }
                });


                // 저장버튼 클릭시
                $('#lay-form-write input[type=submit]').off().on('click', function () {
                    if (!validate())
                        return;

                    $.get('/adminAdd/loggerInfo/add', getSerialize('#lay-form-write'), function (res) {
                        alert('저장되었습니다.', function () {
                            popFancyClose('#lay-form-write');
                        });
                        reloadJqGrid();
                    });
                });
            });

            function getDistrictAbbr(districtNo, callback) {
                $.get('/adminAdd/common/code/districtInfoDistAbbr', {district_no: districtNo}, function (res) {
                    var dist_abbr = res[0].dist_abbr;
                    callback(dist_abbr);  // 결과를 콜백 함수로 전달
                });
            }

            // 수정 팝업
            $('.modifyBtn').on('click', function () {

                $("#form_sub_title").html('상세정보');
                $('input[type="submit"]').val('수정');
                var targetArr = getSelectedCheckData();

                if (targetArr.length > 1) {
                    alert('수정 할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length == 0) {
                    alert('수정할 데이터를 선택해주세요.');
                    return;
                }

                setSerialize('#lay-form-write', targetArr[0]); // 선택값 세팅
                $('.deleteBtn').show();
                popFancy('#lay-form-write');

                // 저장버튼 클릭시
                $('#lay-form-write input[type=submit]').off().on('click', function () {
                    if (!validate())
                        return;

                    $.get('/adminAdd/loggerInfo/mod', getSerialize('#lay-form-write'), function (res) {
                        alert('저장되었습니다.', function () {
                            popFancyClose('#lay-form-write');
                        });
                        reloadJqGrid();
                    });
                });
            });

            $('.excelBtn').on('click', function () {
                downloadExcel('로거관리');
            });


            $('input[name=logr_lat], input[name=logr_lon]').on('click', function () {
                if ($('#lay-form-write input[name=logr_lat]').val() != '' && $('#lay-form-write input[name=logr_lon]').val() != '') {
                    try {
                        window.vworld.setPanBy([parseFloat($('#lay-form-write input[name=logr_lon]').val()), parseFloat($('#lay-form-write input[name=logr_lat]').val())]);
                    } catch (e) {
                    }
                }

                popFancy('#lay-form-address', {dragToClose: false, touch: false});
            });


            $('.locationApply').on('click', function () {
                let coords = window.vworld.getCenter();
                $('#lay-form-write input[name=logr_lat]').val(coords[1]);
                $('#lay-form-write input[name=logr_lon]').val(coords[0]);
                popFancyClose('#lay-form-address');
            });

        });

        function triggerFileUpload() {
            // 파일 선택 창을 열기 위해 숨겨진 input[type="file"] 요소를 클릭합니다.
            document.getElementById('file').click();
        }

        function uploadFile() {
            var fileInput = document.getElementById('file');

            // 사용자가 파일을 선택한 경우
            if (fileInput.files.length > 0) {
                var formData = new FormData();
                formData.append("file", fileInput.files[0]);

                $.ajax({
                    url: "/adminAdd/loggerInfo/upload",
                    type: "POST",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (response) {
                        alert(response);
                    },
                    error: function (response) {
                        alert("Error: " + response.responseText);
                    }
                });
            } else {
                alert("No file selected.");
            }

            reloadJqGrid();
        }

    </script>
</head>

<body data-pgcode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true" />
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true" />
    </div>
    <div id="container">
        <h2 class="txt">
            관리자 전용
            <span class="arr">관리자</span>
        </h2>
        <div id="contents">
            <div class="contents-re">
                <h3 class="txt">로거 관리</h3>
                <div class="btn-group">
                    <input class="search_input" type="text" id="search" name="search"
                           placeholder="로거명 / 현장명 / 모델명 / 제조사명"/>
                    <a class="searchBtn">검색</a>
                    <a class="insertBtn">신규 등록</a>
                    <a class="modifyBtn">상세정보</a>
                    <a class="uploadBtn" href="javascript:void(0);" onclick="triggerFileUpload()">업로드</a>
                    <form id="uploadForm" style="display:none;">
                        <input type="file" id="file" name="file" accept=".xlsx" onchange="uploadFile()">
                    </form>
                    <a class="excelBtn">다운로드</a>
                </div>
                <div class="contents-in">
                    <jsp:include page="../common/include_jqgrid.jsp" flush="true" />
                </div>
            </div>
        </div>
    </div>
    <div id="lay-form-write" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
        </div>
        <div class="layer-base-title">로거 <span id="form_sub_title">등록/수정</span></div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="*"/>
                        <col width="*"/>
                        <col width="*"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th class="required_th">로거 구분</th>
                        <td colspan="3">
                            <select id="logr_flag" name="logr_flag" class="required">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>로거 ID</th>
                        <td colspan="3">
                            <input type="text" id="logr_no" name="logr_no" readonly/>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">현장명</th>
                        <td colspan="3">
                            <select id="district_no" name="district_no" class="required">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th>로거명</th>
                        <td colspan="3">
                            <input type="text" name="logr_nm" readonly/>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">로거명 MAC</th>
                        <td colspan="3">
                            <input type="text" name="logr_MAC" class="required"/>
                        </td>
                    </tr>


                    <tr>
                        <th class="required_th">로거 IP</th>
                        <td>
                            <input type="text" name="logr_ip" class="required"/>
                        </td>
                        <th class="required_th">로거 Port</th>
                        <td>
                            <input type="text" name="logr_port" class="required"/>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">서버 IP</th>
                        <td>
                            <input type="text" name="logr_svr_ip" class="required"/>
                        </td>
                        <th class="required_th">서버 Port</th>
                        <td>
                            <input type="text" name="logr_svr_port" class="required"/>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">설치일자</th>
                        <td colspan="3">
                            <input type="text" name="inst_ymd" class="datetimepickerOne required"/>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">설치상태</th>
                        <td colspan="3">
                            <select id="maint_sts_cd" name="maint_sts_cd" class="required">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">위도</th>
                        <td>
                            <input type="text" name="logr_lon" class="required"/>
                        </td>

                        <th class="required_th">경도</th>
                        <td>
                            <input type="text" name="logr_lat" class="required"/>
                        </td>
                    </tr>

                    <tr>
                        <th class="required_th">모델명</th>
                        <td>
                            <input type="text" name="model_nm" class="required"/>
                        </td>
                        <th class="required_th">제조사</th>
                        <td>
                            <input type="text" name="logr_maker" class="required"/>
                        </td>
                    </tr>


                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <button type="button" class="deleteBtn" style="display:none;">삭제</button>
                <input type="submit" blue value="저장"/>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>
    <!--[e] 로거 등록 팝업 -->

    <div id="lay-form-address" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">위치 찾기</div>
        <div class="layer-base-conts">
            <div class="map" id="map" style="min-height: 400px;"></div>
            <img src="/images/rv_marker.png" width="30px" class="centerMarker"/>
            <div class="btn-btm">
                <input type="button" class="locationApply" blue value="확인"/>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>
</section>
</body>
</html>
