<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
        </style>

        <script src="https://cdn.jsdelivr.net/npm/hammerjs@2.0.8/hammer.min.js"></script>
        <script>
            window.jqgridOption = {
                multiselect: true,
                multiboxonly: false
            };

            let $grid;
            let cctvArray = [];
            let currentPage = 1;
            let wsUrl = '';

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
                let html = '<li assetid=' + data.asset_id + ' rowId=' + data.rowId + '>' +
                    '<div class="cctvContainer nosignal cctvzoom">' +
                    '<div class="container">' +
                    '<div class="title" data-text="No Signal">No Signal</div>' +
                    '</div>' +
                    '<img id="vid_' + data.asset_id + '">' +
                    '<div class="videoLabel">' + data.name + '</div>' +
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
                // let html = '<li assetid=' + data.asset_id + '><video id="vid_' + data.asset_id +'" src="/video/proxy?url=' + data.etc1 + '" controls autoplay></video>';
                $('.cctv-list').append(html);

                $('#vid_' + data.asset_id).on('ended', function (e) {
                    console.log($(this).attr('id'));
                });

                // 한번만 로드 됨. 실행되면 no signal 지우기
                $('#vid_' + data.asset_id).one('load', function (e) {
                    $('#vid_' + data.asset_id).siblings('.cctvContainer.nosignal .container').remove();
                });
                window.videoWs['vid_' + data.asset_id] = new WebSocket(wsUrl + '/video/stream?url=' + data.etc1);

                window.videoWs['vid_' + data.asset_id].onmessage = function (event) {
                    let blob = new Blob([event.data], {type: "image/jpeg"});
                    let url = URL.createObjectURL(blob);
                    let video = $('#vid_' + data.asset_id)[0];
                    video.src = url;

                    try {
                        video.src = url;
                        // 객체 URL을 해제하여 메모리 누수 방지
                        setTimeout(() => {
                            URL.revokeObjectURL(url);
                        }, 100);
                    } catch (e) {
                        console.log('socket close');
                    }
                };
            };

            const uncheckedAllCctvList = () => {
                $('.paging_all').remove();
                $('#contents .cctv-list .btnClose').trigger('click');
                $('tr[id^=g0_]').removeClass("cctv_selected");
                $('tr[id^=g0_]').each(function (idx, ele) {
                    if ($(ele).find('td input:checkbox').is(':checked')) {
                        $(ele).find('td input:checkbox').prop("checked", false);
                        cctvArray = cctvArray.filter((cctv) => cctv.rowId !== $(ele).attr('id'));
                    }
                });
            };

            const reloadCctvList = () => {
                if (cctvArray.length % 6 === 0 && currentPage > 1) {
                    currentPage = currentPage - 1;
                }

                cctvArray.forEach((data, idx) => {
                    if (idx >= (currentPage - 1) * 6 && idx < currentPage * 6) {
                        if ($('.cctv-list li[assetid=' + data.asset_id + ']').length === 0) {
                            setCctvVideoList(data);
                        }
                    }
                });
            };

            const removeAllCctvVideo = () => {
                $('.paging_all').remove();
                cctvArray.forEach((data, idx) => {
                    if ($('.cctv-list li[assetid=' + data.asset_id + ']').length > 0) {
                        try {
                            window.videoWs['vid_' + data.asset_id].send(JSON.stringify({ type: "close" }));
                            window.videoWs['vid_' + data.asset_id].close();
                            console.log('socket close - vid_' + data.asset_id);
                        } catch(e) {

                        }
                        $('.cctv-list li[assetid=' + data.asset_id + ']').remove();
                    }
                });
            };

            // window.jqgrid 
            $(function () {
                // $(document).on('timeupdate', '.cctv-list video', function(e) {
                //     console.log($(this).attr('id'));
                // });

                $.get('/cctv/columns', function (res) {
                    console.log(res);

                    $grid = jqgridUtil($('table.grid'), {
                        listPathUrl: "/cctv",
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

                    const isChecked = $('tr[id='+data.rowId+'] input[type=checkbox]').is(':checked');

                    $.each($('.ui-jqgrid-btable tr'), function (idx, ele) {
                        if ($(ele).attr("id") == data.rowId) {
                            if ($('.cctv-list li[assetid=' + data.asset_id + ']').length > 0
                                || $(ele).hasClass("cctv_selected")) {
                                $(ele).removeClass("cctv_selected");
                                $(ele).find('td input:checkbox').prop("checked", false);
                                cctvArray = cctvArray.filter((cctv) => cctv.asset_id !== data.asset_id);
                            }else{
                                $(ele).addClass("cctv_selected");
                                $(ele).find('td input:checkbox').prop("checked", true);
                                cctvArray.push(data);
                            }
                        }
                    });


                    //if ($('.cctv-list li[assetid=' + data.asset_id + ']').length > 0) {
                    if (!isChecked) {
                        try {
                            window.videoWs['vid_' + data.asset_id].send(JSON.stringify({ type: "close" }));
                            window.videoWs['vid_' + data.asset_id].close();
                            console.log('socket close - vid_' + data.asset_id);
                        } catch(e) {

                        }
                        $('.cctv-list li[assetid=' + data.asset_id + ']').remove();

                        reloadCctvList();
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
                        // let html = '<li assetid=' + data.asset_id + '><video id="vid_' + data.asset_id +'" class="video-js" controls preload="auto">' +
                        //     + '<p class="vjs-no-js">지원되지 않는 브라우져 입니다.</p></video>';
                        if (cctvArray.length < 7) {
                            setCctvVideoList(data);
                        }
                    }

                    $('.paging_all').remove();
                    if (cctvArray.length > 0) {
                        const pageHtml = makePage();
                        setPage(currentPage, pageHtml);
                    }
                });

                $(document).on('click', '.cctvContainer .btnClose', function () {
                    let assetid = $(this).closest('li').attr('assetid');
                    let rowId = $(this).closest('li').attr('rowId');

                    let target = $('.ui-jqgrid-btable tr[id=' + rowId + ']');
                    target.find('td input:checkbox').prop("checked", false);
                    target.removeClass("cctv_selected");
                    cctvArray = cctvArray.filter((cctv) => cctv.asset_id !== assetid);

                    try {
                        window.videoWs['vid_' + assetid].send(JSON.stringify({ type: "close" }));
                        window.videoWs['vid_' + assetid].close();
                        console.log('socket close - vid_' + assetid);
                    } catch(e) {
                        console.log(e);
                    }

                    $('.cctv-list li[assetid=' + assetid + ']').remove();

                    if ($('.cctv-list .cctvContainer').length == 0) {
                        try {
                            document.documentElement.exitFullscreen();
                        } catch(e) { }
                        $('.dimm').removeClass('on');
                        $('.btnFullScreenClose').hide();
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
                    let assetid = $(this).closest('li').attr('assetid');
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
                            $('.cctv-list li[assetid=' + data.asset_id + ']').remove();
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
                            $('.cctv-list li[assetid=' + data.asset_id + ']').remove();
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
                            $('.cctv-list li[assetid=' + data.asset_id + ']').remove();
                        }
                    });
                    const pageHtml = makePage();
                    setPage(currentPage, pageHtml);
                });
            });

            function updateTransform(img, scale = 1, posX = 0, posY = 0) {
                img.style.transform = 'translate(' + posX + 'px, ' + posY + 'px) scale(' + scale + ')';
            }


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
                            <table class="grid"></table>
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
