<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>
        <style>
            .cctv-list li video {
                width: 315px;
            }

            .cctvzoom{
                position: relative;
                height:auto;
                overflow: hidden;
                background:#dedede;
            }
            .cctvzoom .cctvcontrol{
                position:absolute;
                width:100%;
                height:40px;
                background:#00000060;
                color:white;
                bottom:0;
                display: flex;
                align-items: center;
                padding:0 10px;
            }
            .cctvzoom img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                position: absolute;
                left: 0;
                top: 0;
                cursor: grab;
                transition: transform 0.1s ease;
                border-radius: 0;
            }
            .cctvzoom .cctvcontrol span{
                font-size:1.4rem;
            }
            .cctvzoom .cctvcontrol .conbtn_area{
                margin-left:auto;
            }
            .cctvzoom .cctvcontrol .plusbtn,
            .cctvzoom .cctvcontrol .minusbtn{
                font-size:2rem;
                color:white;
                background:#00000060;
                width:30px;
                text-align: center;
                border-radius: 4px;
            }
            .cctvzoom .cctvcontrol .plusbtn:hover,
            .cctvzoom .cctvcontrol .minusbtn:hover{
                background:#000000;
            }
            .cctvzoom .cctvcontrol .minusbtn{
                margin-left:4px;
            }

            /* 검색 행의 input 필드에 border 추가 */
            .ui-search-toolbar input {
                border: 1px solid #ccc; /* 원하는 border 색상 */
                padding: 2px;
            }

            .ui-search-toolbar th:first-child {
                border-left: none !important;
            }

            .ui-jqgrid tr.ui-search-toolbar th {
                border: 1px solid #d3d3d3;
            }

            .ui-jqgrid .ui-jqgrid-htable {
                border-collapse: collapse;
            }
        </style>
        <script src="https://cdn.jsdelivr.net/npm/hammerjs@2.0.8/hammer.min.js"></script>
        <script type="text/javascript" src="/admin_add.js"></script>
        <script>
            window.jqgridOption = {
                multiselect: true,
                multiboxonly: false
            };

            let $grid;
            let cctvArray = [];
            let currentPage = 1;
            let wsUrl = '';

            const limit = 25;
            let offset = 0;
            let isCheckedAll = false;

            const makePage = () => {
                let html = '';
                html=  '<nav class="paging_all">' +
                            '<a class="btns pg_prev prev">처음</a>' +
                            '<span class="num">';
                let totalPage = Math.ceil(cctvArray.length / 6);

                for (let i = 1; i <= totalPage; i++) {
                    if (i === Number(currentPage)) {
                        html += '<strong class="pg_current">' + i + '</strong>';
                    } else {
                        html += '<a href="javascript:void(0);" class="pg_page" page_num="'+i+'">' + i + '</a>';
                    }
                }
                html += '</span>' +
                        '<a class="btns pg_next next">다음</a>' +
                    '</nav>';
                return html;
            };

            const setPage = (page, html) => {
                $('.pageBtn').remove();
                $('.cctv-list').append(html);
            };
            
            const setCctvVideoList = (data) => {
                let html = '<li cctvno=' + data.cctv_no + ' rowId=' + data.rowId + '>' +
                    '<div class="cctvContainer nosignal cctvzoom">' +
                    '<div class="container">' +
                    '<div class="title" data-text="No Signal">No Signal</div>' +
                    '</div>' +
                    '<img id="vid_' + data.cctv_no + '">' +
                    '<div class="videoLabel">' + data.cctv_nm + '</div>' +
                    '<div class="videoControl">' +
                    '<a href="' + data.etc3 + '" target="_blank">' +
                    '<i class="fa-solid fa-gear btnControlLink"></i>' +
                    '</a>' +
                    '<i class="fa-regular fa-window-maximize btnMaximize"></i>' +
                    '<i class="fa-regular fa-rectangle-xmark btnClose"></i>' +
                    '</div>' +
                    '<div class="videoClose">X</div>' +
                    '<div class="cctvcontrol"><span>ZOOM</span> <div class="conbtn_area"> <button type="button" class="plusbtn">+</button> <button type="button" class="minusbtn">-</button> </div> </div>'
                '</div>' +
                '</li>';
                // let html = '<li cctvno=' + data.cctv_no + '><video id="vid_' + data.cctv_no +'" src="/video/proxy?url=' + data.etc1 + '" controls autoplay></video>';
                $('.cctv-list').append(html);

                $('#vid_' + data.cctv_no).on('ended', function (e) {
                    console.log($(this).attr('id'));
                });

                // 한번만 로드 됨. 실행되면 no signal 지우기
                $('#vid_' + data.cctv_no).one('load', function (e) {
                    $('#vid_' + data.cctv_no).siblings('.cctvContainer.nosignal .container').remove();
                });
                window.videoWs['vid_' + data.cctv_no] = new WebSocket(wsUrl + '/video/stream?url=' + data.etc1);

                window.videoWs['vid_' + data.cctv_no].onmessage = function (event) {
                    let blob = new Blob([event.data], {type: "image/jpeg"});
                    let url = URL.createObjectURL(blob);
                    let video = $('#vid_' + data.cctv_no)[0];

                    if (video === undefined) {
                        return;
                    }

                    video.src = url;

                    try {
                        video.src = url;
                        // 객체 URL을 해제하여 메모리 누수 방지
                        setTimeout(() => {
                            URL.revokeObjectURL(url);
                        }, 300);
                    } catch (e) {
                        console.log('socket close');
                    }
                };
            };

            const uncheckedAllCctvList = () => {
                $('#jqGrid tr[role=row]').removeClass("cctv_selected");

                let $rows = $('#jqGrid tr[role=row]').filter(function () {
                    return $(this).find('input[type=checkbox]').is(':checked'); // 체크된 행만 선택
                }).get().reverse(); // 역순으로 가져오기

                let delay = 300; // 각 행 처리 사이에 100ms 지연

                function processRow(index) {
                    if (index >= $rows.length) {
                        // 모든 행 처리 완료 후 실행할 작업
                        $('#contents .cctv-list .btnClose').trigger('click');
                        $('.paging_all').remove();

                        // WebSocket 닫기
                        /*Object.keys(window.videoWs).forEach((key) => {
                            try {
                                window.videoWs[key].send(JSON.stringify({ type: "close" }));
                                window.videoWs[key].close();
                                console.log('socket close - ' + key);
                            } catch (e) {
                                console.error('WebSocket close error:', e);
                            }
                        });*/
                        return; // 모든 행을 처리했으면 종료
                    }

                    let $row = $($rows[index]);
                    $row.find('td input:checkbox').trigger('click');

                    // 다음 행을 지연 처리
                    setTimeout(() => processRow(index + 1), delay);
                }

                // 첫 번째 행부터 시작
                processRow(0);
            };


            const reloadCctvList = () => {
                if (cctvArray.length % 6 === 0 && currentPage > 1) {
                    currentPage = currentPage - 1;
                }

                removeAllCctvVideo();
                cctvArray.forEach((data, idx) => {
                    if (idx >= (currentPage - 1) * 6 && idx < currentPage * 6) {
                        if ($('.cctv-list li[cctvno=' + data.cctv_no + ']').length === 0) {
                            setCctvVideoList(data);
                        }
                    }
                });
            };

            const removeAllCctvVideo = () => {
                $('.paging_all').remove();
                cctvArray.forEach((data, idx) => {
                    if ($('.cctv-list li[cctvno=' + data.cctv_no + ']').length > 0) {
                        try {
                            window.videoWs['vid_' + data.cctv_no].send(JSON.stringify({ type: "close" }));
                            window.videoWs['vid_' + data.cctv_no].close();
                            console.log('socket close - vid_' + data.cctv_no);
                        } catch(e) {

                        }
                        $('.cctv-list li[cctvno=' + data.cctv_no + ']').remove();
                    }
                });
            };

            const updateTransform = (img, scale = 1, posX = 0, posY = 0) => {
                img.style.transform = 'translate(' + posX + 'px, ' + posY + 'px) scale(' + scale + ')';
            };

            const checkboxFormatter = (cellValue, options, rowObject) => {
                return '<input type="checkbox" class="row-checkbox" value="'+rowObject.cctv_no+'">';
            };

            const column = [
                {name: 'checkbox', index: 'checkbox', width: 35, align: 'center', sortable: false, hidden: false, formatter: checkboxFormatter},
                {name : 'district_nm', index : 'district_nm', width: 100, align : 'center', hidden:false},
                {name : 'cctv_nm', index : 'cctv_nm', align : 'center', hidden:false},
                {name : 'partner_comp_nm', index : 'partner_comp_nm', align : 'center', hidden:false},
                {name : 'partner_comp_user_nm', index : 'partner_comp_user_nm', width: 100, align : 'center', hidden:false},
                {name : 'partner_comp_user_phone', index : 'partner_comp_user_phone', width: 100, align : 'center', hidden:false},

                {name : 'cctv_no', index : 'cctv_no', align : 'center', hidden:true},
                {name : 'district_no', index : 'district_no', align : 'center', hidden:true},
                {name : 'maint_sts_cd', index : 'maint_sts_cd', align : 'center', hidden:true},
                {name : 'maint_sts_nm', index : 'maint_sts_nm', align : 'center', hidden:true},
                {name : 'partner_comp_id', index : 'partner_comp_id', align : 'center', hidden:true},
                {name : 'inst_ymd', index : 'inst_ymd', align : 'center', hidden:true},
                {name : 'model_nm', index : 'model_nm', align : 'center', hidden:true},
                {name : 'cctv_maker', index : 'cctv_maker', align : 'center', hidden:true},
                {name : 'cctv_ip', index : 'cctv_ip', align : 'center', hidden:true},
                {name : 'web_port', index : 'web_port', align : 'center', hidden:true},
                {name : 'rtsp_port', index : 'rtsp_port', align : 'center', hidden:true},
                {name : 'cctv_conn_id', index : 'cctv_conn_id', align : 'center', hidden:true},
                {name : 'cctv_conn_pwd', index : 'cctv_conn_pwd', align : 'center', hidden:true},
                {name : 'relay_nm', index : 'relay_nm', align : 'center', hidden:true},
                {name : 'relay_ip', index : 'relay_ip', align : 'center', hidden:true},
                {name : 'relay_port', index : 'relay_port', align : 'center', hidden:true},
                {name : 'cctv_lat', index : 'cctv_lat', align : 'center', hidden:true},
                {name : 'cctv_lon', index : 'cctv_lon', align : 'center', hidden:true},
                {name : 'admin_center', index : 'admin_center', align : 'center', hidden:true},
                {name : 'etc1', index : 'etc1', align : 'center', hidden:true},
                {name : 'etc2', index : 'etc2', align : 'center', hidden:true},
                {name : 'etc3', index : 'etc3', align : 'center', hidden:true},
            ];

            const header = [
                '','현장명','CCTV명','계측사','담당자','전화번호',
                '','','','','','','','','','','','','','','','','','','','','',''
                /*'cctv_no','district_no','maint_sts_cd','maint_sts_nm',
                'partner_comp_id','inst_ymd','model_nm','cctv_maker',
                'cctv_ip','web_port','rtsp_port','cctv_conn_id','cctv_conn_pwd',
                'relay_nm','relay_ip','relay_port','cctv_lat','cctv_lon',
                'admin_center','etc1','etc2','etc3'*/
            ];

            const gridComplete2 = () => {
                // 검색 행 추가
                if ($("#jqGrid").closest(".ui-jqgrid-view").find(".ui-search-toolbar").length === 0) {
                    let $thead = $("#jqGrid").closest(".ui-jqgrid-view").find(".ui-jqgrid-htable thead");
                    let $searchRow = $('<tr class="ui-search-toolbar"></tr>');
                    let distinctDistrict = [];
                    let distinctSensType = [];

                    // 현재 필터링 조건을 저장할 객체
                    let filters = {
                        groupOp: "AND",
                        rules: []
                    };

                    getDistinct().then((res) => {
                        distinctDistrict = res.district;
                        distinctSensType = res.sensor_type;

                        $("#jqGrid").jqGrid('getGridParam', 'colModel').forEach(function (col, index) {
                            let $cell = setFilterControls(col, index, distinctDistrict, distinctSensType, filters, "jqGrid");
                            $searchRow.append($cell);
                        });
                        $thead.append($searchRow);
                    }).catch((fail) => {
                        console.log('getDistinct fail > ', fail);
                    });
                }
                if ($('#check-all').length === 0) {
                    $('#jqGrid_checkbox div').prepend('<input type="checkbox" id="check-all">');
                }

                // 헤더 체크박스 선택 시, 전체 행의 클릭 이벤트 트리거
                $('#check-all').on('click', function() {
                    const isChecked = $(this).is(':checked');  // 헤더 체크박스 상태 확인

                    if (isChecked) {
                        isCheckedAll = true;

                        let $rows = $('#jqGrid tr[role=row]'); // 모든 행 가져오기
                        let delay = 300; // 지연 시간 (100ms)

                        function processRow(index) {
                            if (index >= $rows.length) return; // 모든 행을 처리했으면 종료

                            let $row = $($rows[index]);
                            if (!$row.find('input[type=checkbox]').is(':checked')) {
                                $row.trigger('click', { rowId: $row.attr('id'), cctv_no: $row.attr('cctv_no') });
                            }

                            // 다음 행을 지연 처리
                            setTimeout(() => processRow(index + 1), delay);
                        }

                        // 첫 번째 행부터 순차적으로 처리 시작
                        processRow(0);
                    } else {
                        isCheckedAll = false;
                        uncheckedAllCctvList();
                    }
                });

                if (isCheckedAll) {
                    $('#check-all').prop("checked", true);
                }
            };

            const getCctv = (obj) => {
                return new Promise((resolve, reject) => {
                    $.ajax({
                        type: 'GET',
                        url: `/modify/cctv/cctv`,
                        dataType: 'json',
                        contentType: 'application/json; charset=utf-8',
                        async: true,
                        data: obj
                    }).done(function(res) {
                        resolve(res);
                    }).fail(function(fail) {
                        reject(fail);
                        console.log('getCctv fail > ', fail);
                        alert2('CCTV 정보를 가져오는데 실패했습니다.', function() {});
                    });
                });
            };

            const onSelectRow2 = (rowId, status, e) => {
                const data = $("#jqGrid").jqGrid('getRowData', rowId);
                let isExist = false;

                cctvArray.some(cctv => cctv.cctv_no === rowId) ? isExist = true : isExist = false;
                cctvArray = cctvArray.filter((cctv) => cctv.cctv_no !== data.cctv_no);

                if (isExist) {
                    try {
                        window.videoWs['vid_' + data.cctv_no].send(JSON.stringify({ type: "close" }));
                        window.videoWs['vid_' + data.cctv_no].close();
                        console.log('socket close - vid_' + data.cctv_no);
                    } catch(e) {

                    }
                    $('.cctv-list li[cctvno=' + data.cctv_no + ']').remove();
                    $('tr[id='+rowId+'] input[type=checkbox]').prop("checked", false);
                } else {
                    cctvArray.push(data);
                    $('tr[id='+rowId+'] input[type=checkbox]').prop("checked", true);
                    if (cctvArray.length < 7) {
                        setCctvVideoList(data);
                    }
                }

                reloadCctvList();
                $('.paging_all').remove();
                if (cctvArray.length > 0) {
                    const pageHtml = makePage();
                    setPage(currentPage, pageHtml);
                }
            };

            const loadComplete2 = () => {
                cctvArray.map((cctv) => {
                    $('tr[id='+cctv.cctv_no+'] input[type=checkbox]').prop("checked", true);
                });
                if (isCheckedAll) {
                    $('#check-all').prop("checked", true);
                }
            };

            // window.jqgrid 
            $(function () {
                // $(document).on('timeupdate', '.cctv-list video', function(e) {
                //     console.log($(this).attr('id'));
                // });

                /*$.get('/cctv/columns', function (res) {
                    console.log(res);

                    $grid = jqgridUtil($('table.grid'), {
                        listPathUrl: "/cctv",
                        gridComplete: function() {
                            setTimeout(function() {
                                const gridHeight = $('.contents-in:eq(0)').height();
                                $('.ui-jqgrid-bdiv:eq(0) div').height(gridHeight-80);
                            }, 150);
                        },
                        reorderColumns: true,
                    }, res, false);

                    $('.ui-th-div input.cbox').hide();
                    $('.ui-th-div input.cbox').after('<input type="checkbox" id="check-all">');
                    // 헤더 체크박스 선택 시, 전체 행의 클릭 이벤트 트리거
                    $('#check-all').on('click', function() {
                        const isChecked = $(this).is(':checked');  // 헤더 체크박스 상태 확인

                        if (isChecked) {
                            $.each($('tr[id^=g0_]'), function (idx, ele) {
                                if (!$(ele).hasClass("cctv_selected")) {
                                    $(ele).trigger('click', { rowId: $(ele).attr('id'), asset_id: $(ele).attr('asset_id') });
                                }
                            });
                        } else {
                            uncheckedAllCctvList();
                        }
                    });
                });*/

                getCctv({limit : limit, offset : offset}).then((res) => {
                    console.log('res > ', res);
                    setJqGridTable(res.rows, column, header, gridComplete2, onSelectRow2, ['cctv_no'], 'jqGrid', limit, offset, getCctv, null, loadComplete2);
                }).catch((fail) => {
                    console.log('setJqGridTable fail > ', fail);
                });
                
                window.videoWs = [];

                wsUrl = 'ws://localhost:8080';
                if (window.location.href.indexOf('106.245') > -1) {
                    wsUrl = 'ws://106.245.95.116:6099';
                } else if (window.location.href.indexOf('121.159') > -1) {
                    wsUrl = 'ws://121.159.33.107:9090';
                }

                $(window).on('onSelectRow', function(e, data) {
                    console.log('onSelectRow', data);

                    //$.each($('.ui-jqgrid-btable tr'), function (idx, ele) {
                    $.each($('#jqGrid tr'), function (idx, ele) {
                        if ($(ele).attr("id") == data.rowId) {
                            if ($('.cctv-list li[cctvno=' + data.cctv_no + ']').length > 0
                                || $(ele).hasClass("cctv_selected")) {
                                $(ele).removeClass("cctv_selected");
                                $(ele).find('td input:checkbox').prop("checked", false);
                                cctvArray = cctvArray.filter((cctv) => cctv.cctv_no !== data.cctv_no);
                            }else{
                                $(ele).addClass("cctv_selected");
                                $(ele).find('td input:checkbox').prop("checked", true);
                                cctvArray.push(data);
                            }
                        }
                    });

                    const isChecked = $('tr[id='+data.rowId+'] input[type=checkbox]').is(':checked');
                    //if ($('.cctv-list li[cctvno=' + data.cctv_no + ']').length > 0) {
                    if (!isChecked) {
                        try {
                            window.videoWs['vid_' + data.cctv_no].send(JSON.stringify({ type: "close" }));
                            window.videoWs['vid_' + data.cctv_no].close();
                            console.log('socket close - vid_' + data.cctv_no);
                        } catch(e) {

                        }
                        $('.cctv-list li[cctvno=' + data.cctv_no + ']').remove();
                    } else {
                        /*if ($('.cctvContainer').length >= 6) {
                            alert('CCTV는 동시에 6개까지 확인할 수 있습니다.');
                            $target = $('.ui-jqgrid-btable tr[id=' + data.rowId + ']');
                            // checkbox 풀기
                            $target.find('td input:checkbox').prop("checked", false);
                            // css 제거
                            $target.removeClass("cctv_selected");
                            return;
                        }*/
                        // let html = '<li cctvno=' + data.cctv_no + '><video id="vid_' + data.cctv_no +'" class="video-js" controls preload="auto">' +
                        //     + '<p class="vjs-no-js">지원되지 않는 브라우져 입니다.</p></video>';
                        if (cctvArray.length < 7) {
                            setCctvVideoList(data);
                        }
                    }

                    reloadCctvList();
                    $('.paging_all').remove();
                    if (cctvArray.length > 0) {
                        const pageHtml = makePage();
                        setPage(currentPage, pageHtml);
                    }
                });

                $(document).on('click', '.cctvContainer .btnClose', function () {
                    let cctvno = $(this).closest('li').attr('cctvno');
                    let rowId = $(this).closest('li').attr('rowId');

                    let target = $('.ui-jqgrid-btable tr[id=' + rowId + ']');
                    target.find('td input:checkbox').prop("checked", false);
                    target.removeClass("cctv_selected");
                    cctvArray = cctvArray.filter((cctv) => cctv.cctv_no !== cctvno);

                    try {
                        window.videoWs['vid_' + cctvno].send(JSON.stringify({ type: "close" }));
                        window.videoWs['vid_' + cctvno].close();
                        console.log('socket close - vid_' + cctvno);
                    } catch(e) {
                        console.log(e);
                    }

                    $('.cctv-list li[cctvno=' + cctvno + ']').remove();

                    if ($('.cctv-list .cctvContainer').length === 0) {
                        try {
                            document.documentElement.exitFullscreen();
                        } catch(e) { }
                        $('.dimm').removeClass('on');
                        $('.btnFullScreenClose').hide();
                    }
                    reloadCctvList();
                    $('.paging_all').remove();
                    if (cctvArray.length > 0) {
                        const pageHtml = makePage();
                        setPage(currentPage, pageHtml);
                    }
                });

                $(document).on('click', '.btnFullScreenClose', function() {
                    $.each($('ul.cctv-list .cctvContainer'), function() {
                        $(this).removeAttr('style');
                        $(this).removeClass('full');
                        $(this).removeClass('fullscreen');
                    });

                    try {
                        document.exitFullscreen();
                    } catch(e) { }
                    $('.dimm').removeClass('on');
                    $('.btnFullScreenClose').hide();
                });

                $(document).on('click', '.cctvContainer .btnMaximize', function() {
                    let cctvno = $(this).closest('li').attr('cctvno');
                    let $container = $(this).closest('div.cctvContainer');
                    if ($container.hasClass('full')) {
                        $container.removeClass('full');
                    } else {
                        $container.addClass('full');
                    }
                });

                $('.visionBtn').on('click', function() {
                    adjustVideoContainers();
                });

                $(document).on('click', '.plusbtn', function() {
                    const container = $(this).closest('.cctvzoom');
                    const img = container.find('img')[0];
                    let scale = parseFloat(img.dataset.scale) || 1;
                    scale = Math.min(scale + 0.1, 5);  // 최대 스케일 값 제한
                    img.dataset.scale = scale;  // 데이터 속성에 스케일 저장
                    img.style.transform = 'translate(' + (img.dataset.posX || 0) + 'px, ' + (img.dataset.posY || 0) + 'px) scale(' + scale + ')';  // 변환 적용
                });

                $(document).on('click', '.minusbtn', function() {
                    const container = $(this).closest('.cctvzoom');
                    const img = container.find('img')[0];
                    let scale = parseFloat(img.dataset.scale) || 1;
                    scale = Math.max(scale - 0.1, 1);  // 최소 스케일 값 제한
                    img.dataset.scale = scale;  // 데이터 속성에 스ケ일 저장
                    img.style.transform = 'translate(' + (img.dataset.posX || 0) + 'px, ' + (img.dataset.posY || 0) + 'px) scale(' + scale + ')';  // 변환 적용
                });

                $(document).on('click', '.cctvzoom', function() {
                    const _this = this;
                    const img = $(this).find('img')[0];
                    let posX = 0;
                    let posY = 0;
                    let lastPosX = 0;
                    let lastPosY = 0;

                    // Hammer.js 인스턴스 생성
                    const hammer = new Hammer(img);
                    hammer.get('pinch').set({ enable: true });
                    hammer.get('pan').set({ direction: Hammer.DIRECTION_ALL });

                    // 핀치 줌 이벤트
                    hammer.on('pinchmove', function(ev) {
                        let scale = parseFloat(img.dataset.scale) || 1;
                        scale = Math.max(1, Math.min(lastScale * ev.scale, 5));  // 스케일 값 제한
                        img.dataset.scale = scale;  // 데이터 속성에 스케일 저장
                        img.style.transform = 'translate(' + posX + 'px, ' + posY + 'px) scale(' + scale + ')';  // 변환 적용
                    });

                    hammer.on('pinchend', function() {
                        lastScale = parseFloat(img.dataset.scale) || 1;  // 마지막 스케일 값 저장
                    });

                    // 팬 (드래그) 이벤트
                    hammer.on('panmove', function(ev) {
                        posX = lastPosX + ev.deltaX;  // 이동한 X 좌표 계산
                        posY = lastPosY + ev.deltaY;  // 이동한 Y 좌표 계산
                        img.style.transform = 'translate(' + posX + 'px, ' + posY + 'px) scale(' + (img.dataset.scale || 1) + ')';  // 변환 적용
                    });

                    hammer.on('panend', function() {
                        lastPosX = posX;  // 마지막 X 좌표 저장
                        lastPosY = posY;  // 마지막 Y 좌표 저장
                    });
                });

                $(document).on('click', '.pg_page', function() {
                    removeAllCctvVideo();
                    currentPage = Number($(this).attr('page_num')) || currentPage;
                    cctvArray.forEach((data, idx) => {
                        if (idx >= (currentPage - 1) * 6 && idx < currentPage * 6) {
                            setCctvVideoList(data);
                        } else {
                            $('.cctv-list li[cctvno=' + data.cctv_no + ']').remove();
                        }
                    });
                    const pageHtml = makePage();
                    setPage(currentPage, pageHtml);
                });

                $(document).on('click', '.pg_prev', function() {
                    if (currentPage === 1) {
                        return;
                    }
                    removeAllCctvVideo();
                    currentPage = currentPage - 1;
                    cctvArray.forEach((data, idx) => {
                        if (idx >= (currentPage - 1) * 6 && idx < currentPage * 6) {
                            setCctvVideoList(data);
                        } else {
                            $('.cctv-list li[cctvno=' + data.cctv_no + ']').remove();
                        }
                    });
                    const pageHtml = makePage();
                    setPage(currentPage, pageHtml);
                });

                $(document).on('click', '.pg_next', function() {
                    if (currentPage === Math.ceil(cctvArray.length / 6)) {
                        return;
                    }
                    removeAllCctvVideo();
                    currentPage = currentPage + 1;
                    cctvArray.forEach((data, idx) => {
                        if (idx >= (currentPage - 1) * 6 && idx < currentPage * 6) {
                            setCctvVideoList(data);
                        } else {
                            $('.cctv-list li[cctvno=' + data.cctv_no + ']').remove();
                        }
                    });
                    const pageHtml = makePage();
                    setPage(currentPage, pageHtml);
                });

                // row 의 체크박스를 해제하기 위해 클릭했을때 onselectrow 이 반응하지 않기에 추가된 이벤트
                $(document).on('change', '#jqGrid input[type=checkbox]', function(e) {
                    e.stopImmediatePropagation(); // 현재 이벤트가 다른 이벤트 핸들러로 전파되는 것을 방지
                    const isChecked = $(this).is(':checked');
                    const rowId = $(this).closest('tr').attr('id');

                    // row클릭시 cctvArray 에 등록되고 동작해야한다
                    loadComplete2();

                    if (!isChecked) {
                        onSelectRow2(rowId, isChecked, e);
                    }
                });
            });

            function adjustVideoContainers() {
                if ($('ul.cctv-list li').length == 0)
                    return;

                const grid = $(document);
                const containers = $(".cctvContainer");
                const gridWidth = grid.width();
                const gridHeight = grid.height();
                const aspectRatio = 315.5 / 176;

                let cols, rows;
                switch(containers.length) {
                    case 1: cols = 1; rows = 1; break;
                    case 2: cols = 2; rows = 1; break;
                    case 3: case 4: cols = 2; rows = 2; break;
                    case 5: case 6: cols = 3; rows = 2; break;
                    default: cols = 1; rows = 1;
                }

                const containerWidth = gridWidth / cols;
                const containerHeight = containerWidth / aspectRatio;
                const totalContainerHeight = containerHeight * rows;
                let topOffset = (gridHeight - totalContainerHeight) / 2;  // 전체 그리드 높이와 컨테이너 높이 차이를 계산

                topOffset = Math.max(topOffset, 0);

                containers.each(function(index) {
                    const row = Math.floor(index / cols);
                    const topPosition = topOffset + row * containerHeight;  // 각 행의 세로 중앙 위치 계산
                    $(this).addClass('full');
                    $(this).addClass('fullscreen');
                    $(this).css({
                        width: containerWidth + 'px',
                        height: containerHeight + 'px',
                        top: topPosition + 'px',
                        left: ((index % cols) * containerWidth) + 'px'
                    });
                });

                $('.dimm').addClass('on');
                $('.btnFullScreenClose').show();

                try {
                    document.documentElement.requestFullscreen();
                } catch(e) { }
            }

            function handleVideoError(videoElement) {
                $(videoElement).attr('src', $(videoElement).attr('src'));
            }
        </script>
    </head>

    <body data-pgcode="0000">
        <section id="wrap">
            <!--[s] 상단 -->
            <jsp:include page="common/include_top.jsp" flush="true"></jsp:include>
            <!--[e] 상단 -->

            <!--[s] 왼쪽 메뉴 -->
            <div id="global-menu">
                <!--[s] 주 메뉴 -->
                <jsp:include page="common/include_sidebar.jsp" flush="true"></jsp:include>
                <!--[e] 주 메뉴 -->
            </div>
            <!--[e] 왼쪽 메뉴 -->

            <div id="container">
                <h2 class="txt">CCTV</h2>

                <div id="contents" class="cctvList">
                    <div class="contents-re">
                        <h3 class="txt">CCTV 리스트</h3>
                        <div class="contents-in">
                            <%--<table class="grid"></table>--%>
                            <table id="jqGrid"></table>
                        </div>
                    </div>

                    <div class="contents-re">
                        <h3 class="txt">현장 CCTV<div class="visionBtn"><i class="fa-solid fa-tv"></i> &nbsp; 전체화면</div>
                        </h3>
                        <div class="contents-in">
                            <div class="scrollY">
                                <ul class="cctv-list">
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--[e] 컨텐츠 영역 -->

            <div class="dimm"></div>
            <i class="fa-regular fa-rectangle-xmark btnFullScreenClose"></i>
        </section>
    </body>
</html>
