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
        </style>

        <script>
            window.jqgridOption = {
                multiselect: true,
                multiboxonly: false
            };

            let $grid;

            // window.jqgrid 
            $(function () {            	
                // $(document).on('timeupdate', '.cctv-list video', function(e) {
                //     console.log($(this).attr('id'));
                // });

                $.get('/cctv/columns', function (res) {
                    console.log(res);

                    $grid = jqgridUtil($('table.grid'), {
                        listPathUrl: "/cctv"
                    }, res, false);

                    $('.ui-th-div input.cbox').hide();
                });

                
                window.videoWs = [];

                let wsUrl = 'ws://localhost:8080';
                if (window.location.href.indexOf('106.245') > -1) {
                    wsUrl = 'ws://106.245.95.116:6099';
                } else if (window.location.href.indexOf('121.159') > -1) {
                    wsUrl = 'ws://121.159.33.107:9090';
                }

                $(window).on('onSelectRow', function(e, data) {
                    console.log('onSelectRow', data);

                    $.each($('.ui-jqgrid-btable tr'), function (idx, ele) {
                        if ($(ele).attr("id") == data.rowId) {
                            if ($('.cctv-list li[assetid=' + data.asset_id + ']').length > 0) {
                                $(ele).removeClass("cctv_selected");
                                $(ele).find('td input:checkbox').prop("checked", false);
                            }else{
                                $(ele).addClass("cctv_selected");
                                $(ele).find('td input:checkbox').prop("checked", true);
                            }
                        }
                    });


                    if ($('.cctv-list li[assetid=' + data.asset_id + ']').length > 0) {
                        try {
                            window.videoWs['vid_' + data.asset_id].send(JSON.stringify({ type: "close" }));
                            window.videoWs['vid_' + data.asset_id].close();
                            console.log('socket close - vid_' + data.asset_id);
                        } catch(e) {
                            
                        }
                        $('.cctv-list li[assetid=' + data.asset_id + ']').remove();
                    } else {
                        if ($('.cctvContainer').length >= 6) {
                            alert('CCTV는 동시에 6개까지 확인할 수 있습니다.');
                            $target = $('.ui-jqgrid-btable tr[id=' + data.rowId + ']');
                            // checkbox 풀기
                            $target.find('td input:checkbox').prop("checked", false);
                            // css 제거
                            $target.removeClass("cctv_selected");
                            return;
                        }
                        // let html = '<li assetid=' + data.asset_id + '><video id="vid_' + data.asset_id +'" class="video-js" controls preload="auto">' +
                        //     + '<p class="vjs-no-js">지원되지 않는 브라우져 입니다.</p></video>';
                        let html = '<li assetid=' + data.asset_id + ' rowId=' + data.rowId + '><div class="cctvContainer nosignal"><div class="container"><div class="title" data-text="No Signal">No Signal</div></div><img id="vid_' + data.asset_id + '"><div class="videoLabel">' + data.name + '</div><div class="videoControl"><a href="' + data.etc3 + '" target="_blank"><i class="fa-solid fa-gear btnControlLink"></i></a> <i class="fa-regular fa-window-maximize btnMaximize"></i> <i class="fa-regular fa-rectangle-xmark btnClose"></i></div><div class="videoClose">X</div></div></li>';
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
                    }
                });

                $(document).on('click', '.cctvContainer .btnClose', function () {
                    let assetid = $(this).closest('li').attr('assetid');
                    let rowId = $(this).closest('li').attr('rowId');

                    let target = $('.ui-jqgrid-btable tr[id=' + rowId + ']');
                    target.find('td input:checkbox').prop("checked", false);
                    target.removeClass("cctv_selected");

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
