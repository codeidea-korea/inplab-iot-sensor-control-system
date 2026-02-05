<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>
    <script type="text/javascript" src="/colorpicker/jquery.colorpicker.bygiro.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/colorpicker/jquery.colorpicker.bygiro.min.css"/>
    <style>
        #footer {
            width: 100%;
            max-width: calc(100%);
            background-color: #2b2946;
            margin-top: 1vh;
            border-radius: 1rem;
            display: flex;
            justify-content: space-between;
        }

        #footer .footerItem {
            width: 100%;
            padding: 1rem;
            color: #ddd;
            font-size: larger;
        }

        #footer .contents-in {
            height: calc(100% - 4.6rem);
            padding: 4rem;
            background-color: #fff;
            border-radius: 1rem;
            position: relative;
        }

        #contents .contents-in {
            padding: 20px;
        }

        .stepTable {
            width: 100%;
        }

        .stepTable tr td {
            font-size: 14px;
        }

        .stepTable tr td.label {
            text-align: center;
            font-weight: bold;
            font-size: 15px;
        }

        .stepTable span {
            height: 30px;
            line-height: 30px;
            display: flex;
        }

        .stepTable input[type=radio] {
            -webkit-appearance: radio;
            margin-right: 10px;
        }

        .stepTable span input[type=text] {
            margin: 2px 0;
            height: 22px;
            font-size: 12px;
            border: 1px solid #bbb;
        }

        #contents button {
            height: 30px;
            width: 120px;
            padding: 0 2rem;
            background-color: #6975ac;
            font-weight: 500;
            font-size: 1.4rem;
            line-height: 1;
            color: #fff;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
            margin-left: calc(50% - 60px);
        }

        .cp-values > :not(:first-child) {
            margin-left: 0;
        }

        .cp-buttons .btn-close {
            width: 50px;
            height: 22px;
            font-size: 12px;
            line-height: 20px;
            margin-left: calc(50% - 25px) !important;
            border-radius: 5px;
            border: 1px solid #bbb;
            cursor: pointer;
        }

        .setupCanvas {
            margin-bottom: 2.2rem;
        }

        * + h3.txt {
            margin-top: 0;
        }

        .myColorPicker-preview {
            border: 1px solid #555;
        }

        .btn-group2 {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            margin-bottom: 5px;
        }

        .btn-group2 > a {
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
    </style>
    <script>
        let canvas, ctx;
        let texts = [];

        $(function () {
            $('.canvasBtn').hide();
            $('.setupText').hide();

            $('.myColorPicker').colorPickerByGiro({
                preview: '.myColorPicker-preview',
                text: {
                    close: '확인'
                }
            });

            $('span.myColorPicker-preview').css('background-color', '#ffffff');
            $('input[name=color]').val('rgba(255,255,255,1)');

            $('.btnCreateCanvas').on('click', function () {
                if ($('input[name=option]:checked').val() == '160x32') {
                    createCanvas(160, 32);
                } else if ($('input[name=option]:checked').val() == '320x64') {
                    createCanvas(320, 64);
                } else if ($('input[name=option]:checked').val() == 'custom') {
                    if (isNaN(parseInt($('input[name=canvasWidth]').val())) || isNaN(parseInt($('input[name=canvasHeight]').val()))) {
                        alert('가로 세로 사이즈를 정확하게 입력해 주세요.');
                        return;
                    } else {
                        createCanvas(parseInt($('input[name=canvasWidth]').val()), parseInt($('input[name=canvasHeight]').val()));
                    }
                }

                $('.setupCanvas').hide();
                $('.canvasBtn').show();
                $('.setupText').show();
            });

            $('.btnAddText').on('click', function () {
                if ($('input[name=displayText]').val() == '') {
                    alert('입력 문구를 입력해주세요.');
                    return;
                }

                if ($(this).html() == '추가') {
                    texts.push({
                        content: $('input[name=displayText]').val(),
                        x: 0,
                        y: $('input[name=fontSize]').val(),
                        dragging: false,
                        color: $('input[name=color]').val(),
                        fontSize: $('input[name=fontSize]').val()
                    });
                } else {
                    let idx = parseInt($(this).attr('idx'));

                    texts[idx].content = $('input[name=displayText]').val();
                    texts[idx].color = $('input[name=color]').val();
                    texts[idx].fontSize = $('input[name=fontSize]').val();
                }

                drawTexts();
            });

            $('.btnDel').on('click', function () {
                let idx = parseInt($('.btnAddText').attr('idx'));
                texts.splice(idx, 1);
                drawTexts();
                setDisplayInputText(-1);
            });

            $('.btnSave').on('click', function () {
                var imageData = canvas.toDataURL('image/png');
                var link = document.createElement('a');

                link.href = imageData;
                link.download = 'create_text.png';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            });

            $('.btnCancel').on('click', function () {
                confirm('작업을 삭제하시겠습니까?', function () {
                    $('.canvasContainer canvas').remove();

                    $('.canvasBtn').hide();
                    $('.setupText').hide();

                    $('span.myColorPicker-preview').css('background-color', '#ffffff');
                    $('input[name=color]').val('rgba(255,255,255,1)');

                    texts = [];

                    $('.setupCanvas').show();
                });
            });
        });

        function drawTexts() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            texts.forEach(function (text, index) {
                ctx.font = text.fontSize + "px Arial";
                ctx.fillStyle = text.color;
                ctx.fillText(text.content, text.x, text.y);

                // 선택된 텍스트에 대한 테두리 그리기
                if (selectedTextIndex === index) {
                    var metrics = ctx.measureText(text.content);
                    var textWidth = metrics.width;
                    var textHeight = parseInt(text.fontSize);
                    var padding = 5; // 테두리와 텍스트 간의 여백

                    // 점선 테두리 스타일 설정
                    ctx.strokeStyle = "#eee";
                    ctx.setLineDash([5, 3]); // 점선 패턴 설정
                    ctx.strokeRect(text.x - padding, text.y - textHeight, textWidth + padding * 2, textHeight + padding);
                    ctx.setLineDash([]); // 다음 그리기를 위해 패턴 초기화
                }
            });
        }

        function getMousePos(canvas, evt) {
            var rect = canvas.getBoundingClientRect();
            return {
                x: (evt.clientX - rect.left) / (rect.right - rect.left) * canvas.width,
                y: (evt.clientY - rect.top) / (rect.bottom - rect.top) * canvas.height
            };
        }

        var selectedTextIndex = -1;

        function createCanvas(w, h) {
            canvas = document.createElement('canvas');
            canvas.width = w;
            canvas.height = h;

            canvas.style.border = '1px solid #bbb';
            canvas.style.backgroundColor = '#000';

            // 기존 캔버스를 제거하고 새 캔버스를 컨테이너에 추가합니다
            var container = $('.canvasContainer');
            container.empty();
            container.append(canvas); // 새 캔버스를 추가합니다

            ctx = canvas.getContext('2d');

            canvas.onmousedown = function (e) {
                var mousePos = getMousePos(canvas, e);
                selectedTextIndex = -1;

                texts.forEach(function (text, index) {
                    ctx.font = text.fontSize + "px Arial";
                    var metrics = ctx.measureText(text.content);
                    var textWidth = metrics.width;
                    var textHeight = parseInt(text.fontSize); // parseInt는 'px'을 제거합니다.
                    if (mousePos.x > text.x && mousePos.x < text.x + textWidth &&
                        mousePos.y > text.y - textHeight && mousePos.y < text.y) {
                        text.dragging = true;
                        selectedTextIndex = index;
                    }
                });

                drawTexts();

                setDisplayInputText(selectedTextIndex);
            };

            canvas.onmousemove = function (e) {
                if (selectedTextIndex !== -1) {
                    var mousePos = getMousePos(canvas, e);
                    var text = texts[selectedTextIndex];

                    var metrics = ctx.measureText(text.content);
                    var textWidth = metrics.width;
                    var textHeight = parseInt(text.fontSize); // 'px'을 제거하고 정수로 변환

                    // 텍스트의 중앙이 마우스 위치에 오도록 조정
                    text.x = mousePos.x - textWidth / 2;
                    text.y = mousePos.y + textHeight / 2;

                    drawTexts();
                }
            };

            canvas.onmouseup = function (e) {
                setDisplayInputText(selectedTextIndex);

                if (selectedTextIndex !== -1) {
                    texts[selectedTextIndex].dragging = false;
                    selectedTextIndex = -1;
                }
            };

            canvas.onmouseleave = function (e) {
                if (selectedTextIndex !== -1) {
                    texts[selectedTextIndex].dragging = false;
                    selectedTextIndex = -1;
                }
            };
        }

        function setDisplayInputText(index) {
            console.log(index);

            if (index == -1) {
                $('input[name=displayText]').val('');
                $('input[name=fontSize]').val('20');
                $('span.myColorPicker-preview').css('background-color', '#ffffff');
                $('input[name=color]').val('rgba(255,255,255,1)');
                $('button.btnAddText').attr('idx', index);
                $('button.btnAddText').html('추가');
                $('button.btnDel').hide();
            } else {
                $('input[name=displayText]').val(texts[index].content);
                $('input[name=fontSize]').val(texts[index].fontSize);
                $('span.myColorPicker-preview').css('background-color', texts[index].color);
                $('input[name=color]').val(texts[index].color);
                $('button.btnAddText').attr('idx', index);
                $('button.btnAddText').html('수정');
                $('button.btnDel').show();
            }
        }
    </script>

    <script>
        window.jqgridOption = {
            columnAutoWidth: true,
            multiselect: true,
            multiboxonly: false
        }; // 그리드의 다중선택기능을 on, multiboxonly 를 true 로 하는 경우 무조건 1건만 선택

        var _popupClearData;

        $(function () {
            _popupClearData = getSerialize('#lay-form-write2');

            // 삭제
            $('.deleteBtn').on('click', function () {
                const targetArr = getSelectedCheckData();

                if (!targetArr) {
                    return false;
                }

                if (targetArr.length > 0) {
                    confirm(targetArr.length + '건의 데이터를 삭제하시겠습니까?', function () {
                        $.each(targetArr, function (idx) {
                            $.get('/display-connection/display-img-management/del', this, function () {
                                if ((idx + 1) === targetArr.length) {
                                    reloadJqGrid();
                                }
                            });
                        });
                        popFancyClose();
                    });
                } else {
                    alert('삭제하실 그룹를 선택해주세요.');
                    return;
                }
            });

            // 등록
            $('.insertBtn').on('click', function () {

                $("#form_sub_title").html('등록');

                setSerialize('#lay-form-write2', _popupClearData);
                $('#lay-form-write2 .btn-btm .deleteBtn').hide();

                popFancy('#lay-form-write2');

                // 저장버튼 클릭시
                $('#lay-form-write2 input[type=submit]').off().on('click', function () {
                    if (!validate())
                        return;

                    $.ajax({
                        url: '/display-connection/display-img-management/add-group',
                        type: 'POST',
                        data: getSerialize('#lay-form-write2'),
                        success: function (_res) {
                            alert('저장되었습니다.', function () {
                                popFancyClose('#lay-form-write2');
                            });
                            reloadJqGrid();
                        },
                        error: function (err) {
                            alert('알 수 없는 오류가 발생했습니다.');
                        }
                    });
                });
            });

            // 수정 팝업
            $('.modifyBtn').on('click', function () {
                $("#form_sub_title").html('수정');
                const targetArr = getSelectedCheckData();

                if (!targetArr) {
                    return false;
                }

                if (targetArr.length > 1) {
                    alert('수정 할 데이터를 1건만 선택해주세요.');
                    return;
                } else if (targetArr.length === 0) {
                    alert('수정할 데이터를 선택해주세요.');
                    return;
                }

                setSerialize('#lay-form-write2', targetArr[0]); // 선택값 세팅
                $('#lay-form-write2 .btn-btm .deleteBtn').show();

                popFancy('#lay-form-write2');

                // 저장버튼 클릭시
                $('#lay-form-write2 input[type=submit]').off().on('click', function () {
                    if (!validate())
                        return;

                    $.get('/display-connection/display-img-management/mod', getSerialize('#lay-form-write2'), function (res) {
                        alert('저장되었습니다.', function () {
                            popFancyClose('#lay-form-write2');
                        });
                        reloadJqGrid();
                    });
                });
            });
        });

        function validate() {
            if ($('#lay-form-write2 input[name=img_grp_nm]').val().trim() === '') {
                $('#lay-form-write2 input[name=img_grp_nm]').focus();
                alert('전송그룹을 입력해주세요.');
                return false;
            }

            return true;
        }
    </script>

</head>

<body data-pgCode="0000">
<section id="wrap">
    <jsp:include page="../common/include_top.jsp" flush="true"/>
    <div id="global-menu">
        <jsp:include page="../common/include_sidebar.jsp" flush="true"/>
    </div>
    <div id="container">
        <h2 class="txt">전광판 연계
            <span class="arr">전광판 이미지 관리</span>
        </h2>
        <div id="contents">
            <div class="contents-re" style="flex: .5">
                <div class="setupCanvas">
                    <h3 class="txt">이미지 영역 설정</h3>
                    <div class="contents-in auto">
                        <table class="stepTable" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td rowspan="3" width="30%" class="label">사이즈</td>
                                <td><span><input type="radio" name="option" value="160x32" checked>2단 10열 (160px * 32px)</span>
                                </td>
                            </tr>
                            <tr>
                                <td><span><input type="radio" name="option" value="320x64">4단 20열 (320px * 64px)</span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span><input type="radio" name="option" value="custom">사용자 지정</span>
                                    <span>가로 &nbsp;<input type="text" name="canvasWidth" style="width: 50px;">&nbsp; &nbsp; 세로 &nbsp;<input
                                            type="text" name="canvasHeight" style="width: 50px;"></span>
                                </td>
                            </tr>
                        </table>

                        <button type="button" class="btnCreateCanvas">영역 생성</button>
                    </div>
                </div>
                <div class="setupText">
                    <h3 class="txt">이미지 문구 설정</h3>
                    <div class="btn-group asd canvasBtn" style="background: none">
                        <button type="button" class="btnAddText" style="margin: 0 10px 0 0; width: 70px">추가</button>
                        <button type="button" class="btnDel" style="margin:0; width: 70px">삭제</button>
                    </div>
                    <div class="contents-in auto">
                        <table class="stepTable" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td width="30%" class="label">입력문구</td>
                                <td><span><input type="text" name="displayText" style="width: 100%;"></span></td>
                            </tr>
                            <tr>
                                <td width="30%" class="label">폰트 사이즈</td>
                                <td><span><input type="text" name="fontSize" style="width: 50px;" value="20"> &nbsp;(픽셀)</span>
                                </td>
                            </tr>
                            <tr>
                                <td width="30%" class="label">폰트 색 변경</td>
                                <td class="myColorPicker">
                                    <span class="myColorPicker-preview"
                                          style="display: inline-block; width: 80px; height: 25px">&nbsp;<input
                                            type="hidden" name="color"/></span>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="contents-re" style="flex: 1.5">
                <h3 class="txt">생성 이미지 및 문구 디자인</h3>
                <div class="btn-group asd canvasBtn" style="background: none">
                    <button type="button" class="btnSave" style="margin: 0 10px 0 0; width: 140px">이미지 저장</button>
                    <button type="button" class="btnCancel" style="margin: 0">취소</button>
                </div>
                <div class="contents-in auto canvasContainer">
                </div>
            </div>
        </div>
        <div id="footer">
            <div class="footerItem">
                <div class="btn-group2">
                    <h3 class="txt">전송 그룹 관리</h3>
                    <a class="insertBtn">신규등록</a>
                    <a class="modifyBtn">상세정보</a>
<%--                    <a class="deleteBtn">삭제</a>--%>
                </div>
                <div class="contents-in">
                    <jsp:include page="../common/include_jqgrid_old.jsp" flush="true"/>
                </div>
            </div>
        </div>
    </div>
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
    <div id="lay-form-write2" class="layer-base">
        <input type="hidden" id="mgnt_no" name="mgnt_no"/>
        <div class="layer-base-btns">
            <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"/></a>
        </div>
        <div class="layer-base-title">전송그룹 <span id="form_sub_title">등록/수정</span></div>
        <div class="layer-base-conts">
            <div class="bTable">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>전송그룹</th>
                        <td>
                            <input type="text" name="img_grp_nm"/>
                        </td>
                    </tr>
                    <tr>
                        <th>설명</th>
                        <td>
                            <textarea name="img_grp_comment"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>사용 여부</th>
                        <td>
                            <select name="use_yn">
                                <option value="Y">사용</option>
                                <option value="N">사용중지</option>
                            </select>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-btm">
                <input type="submit" blue value="저장"/>
                <a class="deleteBtn">삭제</a>
                <button type="button" data-fancybox-close>취소</button>
            </div>
        </div>
    </div>
</section>
</body>
</html>
