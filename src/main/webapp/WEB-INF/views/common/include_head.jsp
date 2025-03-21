<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=1440, user-scalable=no,viewport-fit=cover" />
<meta name="HandheldFriendly" content="true" />
<meta http-equiv="imagetoolbar" content="no" />
<meta name="format-detection" content="telephone=no, address=no, email=no, date=no" />
<link rel="canonical" href="http://goldencity.iceserver.co.kr" />
<meta name="title" content="${sessionScope.site_sys_nm}" />
<meta name="keywords" content="" />
<meta name="description" content="" />
<meta property="og:type" content="website" />
<meta property="og:title" content="${sessionScope.site_sys_nm}" />
<meta property="og:url" content="http://goldencity.iceserver.co.kr" />
<meta property="og:image" content="/images/og_images.jpg" />
<meta property="og:description" content="" />
<meta name="twitter:card" content="summary" />
<meta name="twitter:title" content="${sessionScope.site_sys_nm}" />
<meta name="twitter:url" content="http://goldencity.iceserver.co.kr" />
<meta name="twitter:image" content="/images/og_images.jpg" />
<meta name="twitter:description" content="" />
<title>${sessionScope.site_sys_nm}</title>

<script type="text/javascript" src="https://map.vworld.kr/js/webglMapInit.js.do?version=2.0&apiKey=935413DC-CBE2-382F-B307-933501B0DC45"></script>
<script type="text/javascript" src="https://cesium.com/downloads/cesiumjs/releases/1.82/Build/Cesium/Cesium.js"></script>
<link href="https://fonts.cdnfonts.com/css/source-code-pro" rel="stylesheet">

<script type="text/javascript" src="/v7.2.2-package/dist/ol.js"></script>
<link rel="stylesheet" href="/v7.2.2-package/ol.css" />

<link rel="stylesheet" type="text/css" href="/common/font/SUIT-Variable.css" />
<link rel="stylesheet" type="text/css" href="/common/css/jquery.ui.lastest.css" />

<script type="text/javascript" src="/common/js/jquery.lastest.js"></script>
<script type="text/javascript" src="/common/js/jquery.ui.lastest.js"></script>
<script type="text/javascript" src="/common/js/TweenMax.min.js"></script>
<script type="text/javascript" src="/common/js/jquery.throttledresize.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<link rel="stylesheet" type="text/css" href="/common/css/contents.css" />

<script type="text/javascript" src="/common/js/prefixfree.min.js"></script>

<link rel="stylesheet" href="/common/css/jquery.fancybox.5.0.css" />
<script type="text/javascript" src="/common/js/jquery.fancybox.5.0.js"></script>

<script type="text/javascript" src="/build/donutty-jquery.js"></script>
<link rel="stylesheet" type="text/css" href="/build/morris/morris.css" />
<script type="text/javascript" src="/build/morris/raphael-min.js"></script>
<script type="text/javascript" src="/build/morris/morris.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="https://cdn.jsdelivr.net/npm/moment"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-moment"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-zoom@2.0.0"></script>
<script src="/Guriddo_jqGrid_JS_5.4.0/plugins/chartjs-plugin-annotation.min.js"></script>

<script src="/Highcharts-11.2.0/highcharts.js"></script>
<script src="/Highcharts-11.2.0/modules/stock.js"></script>
<script src="/Highcharts-11.2.0/modules/exporting.js"></script>
<script src="/Highcharts-11.2.0/modules/accessibility.js"></script>

<link rel="stylesheet" href="/build/flatpickr/dist/flatpickr.css" />
<link rel="stylesheet" href="/build/flatpickr/dist/plugins/confirmDate/confirmDate.css" />
<link rel="stylesheet" href="/build/flatpickr/dist/plugins/monthSelect/style.css" />

<script type="text/javascript" src="/build/flatpickr/dist/flatpickr.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/confirmDate/confirmDate.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/weekSelect/weekSelect.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/rangePlugin.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/minMaxTimePlugin.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/monthSelect/index.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/l10n/ko.js"></script>

<script type="text/ecmascript" src="/Guriddo_jqGrid_JS_5.4.0/js/i18n/grid.locale-kr.js"></script>
<script type="text/ecmascript" src="/Guriddo_jqGrid_JS_5.4.0/js/jquery.jqGrid.min.js"></script>
<script src="https://kit.fontawesome.com/81a554dc3a.js" crossorigin="anonymous"></script>

<link rel="stylesheet" type="text/css" media="screen" href="/Guriddo_jqGrid_JS_5.4.0/css/ui.jqgrid.css" />
<link rel="stylesheet" type="text/css" href="/common/css/grid.css" />

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?libraries=services,panorama&appkey=afbf8c33dbc9da541f59a1fa8dc9a442"></script>
<script type="text/javascript" src="/moment.js"></script>

<script type="text/javascript" src="/common/js/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="/common/css/daterangepicker.css" />

<script type="text/javascript" src="/html2canvas.min.js"></script>
<script type="text/javascript" src="/vwmap_util.js"></script>
<script type="text/javascript" src="/jqgrid_util.js"></script>
<script type="text/javascript" src="/common.js"></script>

<script type="text/javascript" src="/validate.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
    /* 팝업(모달)관련 css */
    .fancybox__backdrop {
        position: fixed;
        top: 0;
        left: 0;
        bottom: 0;
        right: 0;
        z-index: -1;
        background: rgba(0, 0, 0, 0.7); /* 블랙(70% 투명) */
        backdrop-filter: blur(10px); /* 블러 10px */
        opacity: var(--fancybox-opacity, 1);
        will-change: opacity
    }

    .required_th::after {
        content: " *";
        color: red;
    }
</style>
<script>
    google.charts.load('current', {'packages': ['corechart']});

    Highcharts.setOptions({
        global: {
            useUTC: false
        }
    });
</script>