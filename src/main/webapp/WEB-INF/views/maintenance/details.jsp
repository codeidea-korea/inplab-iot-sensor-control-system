<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
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

        .bTable {
            overflow: visible;
        }

        .bTable span {
            display: inline-block;
            color: #47474c;
            font-size: 1.5rem;
            width: 7.2rem;
        }

        .left_contents {
            width: 50%;
            height: 50rem;
        }

        .right_contents {
            width: 50%;
            height: 50rem;
        }

        .tableLine {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .table2Column {
            display: flex;
        }

        .table2Column > .tableLine {
            width: 50%;
        }

        .table2Column > .tableLine:first-child {
            margin-right: 1rem;
        }

        .table2Column > .tableLine:last-child span {
            margin-left: 1rem;
        }
    </style>
    <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>
    <script>
        window.jqgridOption = {
            multiselect: true,
            multiboxonly: false
        };
        $(function () {
            $('.insertBtn').on('click', function () {
                $("#form_sub_title").html('등록');

                initForm();

                $('#uploadFileImg').css("cursor", "");
                $('#uploadFileImg').off('click');

                $("[datepicker]").flatpickr({
                    locale: "ko",
                    dateFormat: "Y-m-d",
                    onClose: function (selectedDates, dateStr, instance) {
                    },
                });

                popFancy('#lay-maintenance-history');

                $('#lay-form-write input[type=submit]').off().on('click', function () {
                    if (!validate()) return;

                    if ($("#uploadFile")[0].files[0] != undefined) {
                        var call_url = "/common/file/upload"
                        var serverFileName = genServerFileName() + getExtName($("#uploadFile")[0].files[0].name);
                        $("#serverFileName").val(serverFileName);//for db insert

                        var form = new FormData();
                        form.append("uploadFile", $("#uploadFile")[0].files[0]);
                        form.append("serverFileName", serverFileName);

                        fileUpload(call_url, form);
                    }

                    $.get('/maintenance/add', getSerialize('#lay-form-write'), function (res) { // todo : true가 아닌 경우 실패된것을 알릴것인지?
                        alert('저장되었습니다.', function () {
                            popFancyClose('#lay-form-write');
                        });
                        reloadJqGrid();
                    });

                });
            });

            $('.excelBtn').on('click', function () {
                downloadExcel('유지보수');
            });
        });

        function initForm() {
            $('#lay-form-write select[name=zone_id_hid]').val('');
            $('#lay-form-write select[name=type_hid]').val('');
            $('#lay-form-write input[name=mt_date]').val('');
            $('#lay-form-write select[name=asset_id_hid]').val('');
            $('#lay-form-write input[name=manager_name]').val('');
            $('#lay-form-write input[name=manager_tel]').val('');
            $("#description").val('');
            $('#lay-form-write input[name=uploadFile]').val('');
            $("#uploadFileImg").attr("src", '');
        }

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
                    <jsp:include page="../common/include_jqgrid.jsp" flush="true"></jsp:include>
                </div>
            </div>
        </div>
    </div>

    <div id="lay-maintenance-history" class="layer-base">
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="./images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
        </div>
        <div class="layer-base-title">유지보수 이력 등록</div>
        <div class="layer-base-conts">
            <div class="left_contents">
                <div class="bTable">
                    <div class="tableLine">
                        <span>현장명</span>
                        <select name="any">
                            <option value="">선택</option>
                        </select>
                    </div>
                    <div class="tableLine">
                        <span>센서타입</span>
                        <select name="any">
                            <option value="">선택</option>
                        </select>
                    </div>
                    <div class="tableLine">
                        <span>센서ID</span>
                        <select name="any">
                            <option value="">선택</option>
                        </select>
                    </div>
                    <div class="tableLine">
                        <span>접수일</span>
                        <input type="date" name="" value="" placeholder=""/>
                    </div>
                    <div class="table2Column">
                        <div class="tableLine">
                            <span>작업시작일</span>
                            <input type="date" name="" value="" placeholder=""/>
                        </div>
                        <div class="tableLine">
                            <span>작업종료일</span>
                            <input type="date" name="" value="" placeholder=""/>
                        </div>
                    </div>
                    <div class="tableLine">
                        <span>작업내역</span>
                        <td><textarea name=""></textarea></td>
                    </div>
                    <div class="tableLine">
                        <span>작업업체</span>
                        <select name="">
                            <option value="">선택</option>
                        </select>
                    </div>
                    <div class="table2Column">
                        <div class="tableLine">
                            <span>작업담당자</span>
                            <select name="">
                                <option value="">선택</option>
                            </select>
                        </div>
                        <div class="tableLine">
                            <span>연락처</span>
                            <input type="number" name="" value="" placeholder=""/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="right_contents">
                <div class="bTable">
                    <div class="tableLine">
                        <span>작업결과</span>
                        <select name="">
                            <option value="">선택</option>
                        </select>
                    </div>
                    <div class="tableLine">
                        <span>작업사진</span>
                        <div class="photo_area">
                            <div>사진1</div>
                            <div>사진2</div>
                            <div>사진3</div>
                            <div>사진4</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="btn-btm">
            <input type="submit" blue value="저장"/>
            <button type="button" data-fancybox-close>취소</button>
        </div>
    </div>
    </div>
</section>
</body>
</html>