<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=1440, user-scalable=no,viewport-fit=cover">
	<meta name="HandheldFriendly" content="true">
	<meta http-equiv="imagetoolbar" content="no">
	<meta name="format-detection" content="telephone=no, address=no, email=no, date=no" />

	<!-- <link rel="shortcut icon" type="image/x-icon" href="/img/favicon.ico" /> -->
	<link rel="canonical" href="http://goldencity.iceserver.co.kr">
	<meta name="title" content="${sessionScope.site_sys_nm}">
	<meta name="keywords" content="">
	<meta name="description" content="">
	<meta property="og:type" content="website">
	<meta property="og:title" content="${sessionScope.site_sys_nm}">
	<meta property="og:url" content="http://goldencity.iceserver.co.kr">
	<meta property="og:image" content="/images/og_images.jpg">
	<meta property="og:description" content="">
	<meta name="twitter:card" content="summary">
	<meta name="twitter:title" content="${sessionScope.site_sys_nm}">
	<meta name="twitter:url" content="http://goldencity.iceserver.co.kr">
	<meta name="twitter:image" content="/images/og_images.jpg">
	<meta name="twitter:description" content="">

	<title>${sessionScope.site_sys_nm}</title>

	<link rel="stylesheet" type="text/css" href="/common/font/SUIT-Variable.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/jquery.ui.lastest.css" />

	<script type="text/javascript" src="/common/js/jquery.lastest.js"></script>
	<script type="text/javascript" src="/common/js/jquery.ui.lastest.js"></script>
	<script type="text/javascript" src="/common/js/TweenMax.min.js"></script>
	<script type="text/javascript" src="/common/js/jquery.throttledresize.js"></script>

	<link rel="stylesheet" type="text/css" href="/common/css/contents.css" />

	<script type="text/javascript" src="/common/js/prefixfree.min.js"></script>

	<link rel="stylesheet" type="text/css" href="/common/css/slick.css" />
	<script type="text/javascript" src="/common/js/slick.js"></script>

	<link rel="stylesheet" href="/common/css/jquery.fancybox.5.0.css">
	<script type="text/javascript" src="/common/js/jquery.fancybox.5.0.js"></script>

	<!-- chart api -->
	<script type="text/javascript" src="/build/donutty-jquery.js"></script>
	<link rel="stylesheet" type="text/css" href="/build/morris/morris.css" />
	<script type="text/javascript" src="/build/morris/raphael-min.js"></script>
	<script type="text/javascript" src="/build/morris/morris.js"></script>
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
</head>

<body data-pgCode="0000">
<section id="wrap">
	<!--[s] 상단 -->
	<jsp:include page="../common/include_top.jsp" flush="true"></jsp:include>
	<!--[e] 상단 -->

	<!--[s] 왼쪽 메뉴 -->
		<div id="global-menu">
			<!--[s] 주 메뉴 -->
			<jsp:include page="../common/include_sidebar.jsp" flush="true"></jsp:include>
			<!--[e] 주 메뉴 -->
		</div>
	<!--[e] 왼쪽 메뉴 -->

	<!--[s] 컨텐츠 영역 -->
		<div id="container">
			<h2 class="txt">관리자 전용 <span class="arr">데이터 관리</span></h2>

			<div id="contents">
				<div class="contents-re">
					<h3 class="txt">Loger 관리</h3>
					<div class="btn-group">
						<a href="javascript:void(0);" data-fancybox data-src="#lay-form-write">수정</a>
						<a href="javascript:void(0);" down data-fancybox data-src="#lay-form-text">다운로드</a>
					</div>
					<div class="contents-in">
						<div class="bTable">
							<table>
								<colgroup>
									<col width="60" />
									<col span="4" width="120" />
									<col span="6" width="80" />
									<col width="140" />
									<col width="80" />
								</colgroup>
								<thead>
									<tr>
										<th>선택</th>
										<th>센서명</th>
										<th>채널이름</th>
										<th>로거명</th>
										<th>초기치 값</th>
										<th>초기치 온도</th>
										<th>로거 인덱스</th>
										<th>로거 인덱스1</th>
										<th>로거 인덱스2</th>
										<th>템포 인덱스1</th>
										<th>템포 인덱스2</th>
										<th>사용 여부</th>
										<th>초기치 날짜</th>
									</tr>
								</thead>
								<tbody>
									<tr class="btns">
										<td class="tac">
											<p class="check-box" notxt>
												<input type="checkbox" id="checkAll" name="checkAll" value=""/>
												<label for="checkAll"><span class="graphic"></span></label>
											</p>
										</td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
										<td><a href="javascript:void(0);" class="f_arr">X</a></td>
									</tr>
									<tr>
										<td>
											<p class="check-box" notxt>
												<input type="checkbox" id="check01" name="check01" value=""/>
												<label for="check01"><span class="graphic"></span></label>
											</p>
										</td>
										<td>TM-02-02</td>
										<td>TM-02-02-X</td>
										<td>01220587551</td>
										<td>-0.0204550000000</td>
										<td>0</td>
										<td>255</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td>
											<p class="check-box">
												<input type="radio" id="check01_on" name="check01_01" value=""/>
												<label for="check01_on"><span class="graphic"></span>On</label>
											</p>
											<p class="check-box">
												<input type="radio" id="check01_off" name="check01_01" value=""/>
												<label for="check01_off"><span class="graphic"></span>Off</label>
											</p>
										</td>
										<td>22.12.22 11:35:00</td>
									</tr>
									<tr>
										<td>
											<p class="check-box" notxt>
												<input type="checkbox" id="check02" name="check02" value=""/>
												<label for="check02"><span class="graphic"></span></label>
											</p>
										</td>
										<td>TM-02-02</td>
										<td>TM-02-02-X</td>
										<td>01220587551</td>
										<td>-0.0204550000000</td>
										<td>0</td>
										<td>255</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td>
											<p class="check-box">
												<input type="radio" id="check02_on" name="check02_01" value=""/>
												<label for="check02_on"><span class="graphic"></span>On</label>
											</p>
											<p class="check-box">
												<input type="radio" id="check02_off" name="check02_01" value=""/>
												<label for="check02_off"><span class="graphic"></span>Off</label>
											</p>
										</td>
										<td>22.12.22 11:35:00</td>
									</tr>
									<tr>
										<td>
											<p class="check-box" notxt>
												<input type="checkbox" id="check03" name="check03" value=""/>
												<label for="check03"><span class="graphic"></span></label>
											</p>
										</td>
										<td>TM-02-02</td>
										<td>TM-02-02-X</td>
										<td>01220587551</td>
										<td>-0.0204550000000</td>
										<td>0</td>
										<td>255</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td>
											<p class="check-box">
												<input type="radio" id="check03_on" name="check03_01" value=""/>
												<label for="check03_on"><span class="graphic"></span>On</label>
											</p>
											<p class="check-box">
												<input type="radio" id="check03_off" name="check03_01" value=""/>
												<label for="check03_off"><span class="graphic"></span>Off</label>
											</p>
										</td>
										<td>22.12.22 11:35:00</td>
									</tr>
									<tr>
										<td>
											<p class="check-box" notxt>
												<input type="checkbox" id="check04" name="check04" value=""/>
												<label for="check04"><span class="graphic"></span></label>
											</p>
										</td>
										<td>TM-02-02</td>
										<td>TM-02-02-X</td>
										<td>01220587551</td>
										<td>-0.0204550000000</td>
										<td>0</td>
										<td>255</td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td>
											<p class="check-box">
												<input type="radio" id="check04_on" name="check04_01" value=""/>
												<label for="check04_on"><span class="graphic"></span>On</label>
											</p>
											<p class="check-box">
												<input type="radio" id="check04_off" name="check04_01" value=""/>
												<label for="check04_off"><span class="graphic"></span>Off</label>
											</p>
										</td>
										<td>22.12.22 11:35:00</td>
									</tr>
								</tbody>
							</table>
						</div>

						<nav class="paging_all">
							<a class="btns pg_page prev">처음</a>
							<span class="num">
								<strong class="pg_current">1</strong>
								<a href="javascript:void(0);" class="pg_page">2</a>
								<a href="javascript:void(0);" class="pg_page">3</a>
								<a href="javascript:void(0);" class="pg_page">4</a>
								<a href="javascript:void(0);" class="pg_page">5</a>
							</span>
							<a class="btns pg_page next">다음</a>
						</nav>
					</div>
				</div>
			</div>
		</div>
	<!--[e] 컨텐츠 영역 -->

	<!--[s] Loger 관리 수정 팝업 -->
	<div id="lay-form-write" class="layer-base">
		<div class="layer-base-btns">
			<a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>
		</div>
		<div class="layer-base-title">Loger 관리 수정</div>
		<div class="layer-base-conts">
			<div class="bTable">
				<table>
					<colgroup>
						<col width="130" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th>센서명</th>
							<td>
								<select name="">
									<option value="">선택</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>채널이름</th>
							<td><input type="text" id="" name="" value="" placeholder="" /></td>
						</tr>
						<tr>
							<th>로거명</th>
							<td><input type="text" id="" name="" value="" placeholder="" /></td>
						</tr>
						<tr>
							<th>초기치값</th>
							<td><input type="text" id="" name="" value="" placeholder="" /></td>
						</tr>
						<tr>
							<th>초기치온도</th>
							<td><input type="text" id="" name="" value="" placeholder="" /></td>
						</tr>
						<tr>
							<th>로거인덱스</th>
							<td><input type="text" id="" name="" value="" placeholder="" /></td>
						</tr>
						<tr>
							<th>로거인덱스1</th>
							<td><input type="text" id="" name="" value="" placeholder="" /></td>
						</tr>
						<tr>
							<th>로거인덱스2</th>
							<td><input type="text" id="" name="" value="" placeholder="" /></td>
						</tr>
						<tr>
							<th>템포인덱스1</th>
							<td><input type="text" id="" name="" value="" placeholder="" /></td>
						</tr>
						<tr>
							<th>템포인덱스2</th>
							<td><input type="text" id="" name="" value="" placeholder="" /></td>
						</tr>
						<tr>
							<th>사용여부</th>
							<td class="tal">
								<p class="check-box">
									<input type="radio" id="check01_on" name="check01_01" value=""/>
									<label for="check01_on"><span class="graphic"></span>On</label>
								</p>
								<p class="check-box">
									<input type="radio" id="check01_off" name="check01_01" value=""/>
									<label for="check01_off"><span class="graphic"></span>Off</label>
								</p>
							</td>
						</tr>
						<tr>
							<th>초기치날짜</th>
							<td><input type="text" id="" name="" value="" placeholder="" /></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn-btm">
				<input type="submit" blue value="저장" />
				<button type="button" data-fancybox-close>취소</button>
			</div>
		</div>
	</div>
	<!--[e] Loger 관리 수정 팝업 -->
	<!--[s] 안내 팝업 -->
	<div id="lay-form-text" class="layer-alarm">
		<div class="layer-alarm-btns">
			<a href="javascript:popFancyClose();"><img src="/images/btn_lay_close.png" alt="닫기"></a>
		</div>
		<div class="layer-base-title">안내</div>
		<div class="layer-alarm-conts">
			<!-- <p class="txt"><strong point>선택한 항목</strong>을 삭제하겠습니까?</p> -->
			<p class="txt"><strong point>선택한 항목</strong>을 다운로드하시겠습니까?</p>
			<p class="btn">
				<a href="javascript:popFancyClose();" blue>확인</a>
			</p>
		</div>
	</div>
	<!--[e] 안내 팝업 -->

	<!--[s] EDIT MODE 팝업 -->
	<div id="lay-edit-mode" class="layer-alarm">
		<div class="layer-alarm-btns">
			<a href="javascript:popFancyClose();"><img src="/images/btn_lay_close.png" alt="닫기"></a>
		</div>
		<div class="layer-alarm-conts">
			<p class="tit">자산 위치관리</p>
			<p class="txt"><strong point>EDIT MODE</strong>로 변환 하시겠습니까?</p>
			<p class="btn">
				<a href="javascript:editMode('open');" blue>예</a>
				<a href="javascript:popFancyClose();">아니오</a>
			</p>
		</div>
	</div>
	<!--[e] EDIT MODE 팝업 -->

	<!--[s] EDIT MODE 사용중 -->
	<div class="edit-mode-use">
		<p class="tit">Edit Mode를 사용중입니다.</p>
		<p class="btn">
			<a href="javascript:editMode('close');" blue>저장</a>
			<a href="javascript:editMode('close');">취소</a>
		</p>
	</div>
	<!--[e] EDIT MODE 사용중 -->
</section>

<!-- Datepicker -->
<link rel="stylesheet" href="/build/flatpickr/dist/flatpickr.css">
<link rel="stylesheet" href="/build/flatpickr/dist/plugins/confirmDate/confirmDate.css">
<link rel="stylesheet" href="/build/flatpickr/dist/plugins/monthSelect/style.css">

<script type="text/javascript" src="/build/flatpickr/dist/flatpickr.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/confirmDate/confirmDate.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/weekSelect/weekSelect.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/rangePlugin.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/minMaxTimePlugin.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/monthSelect/index.js"></script>
<script type="text/javascript" src="/build/flatpickr/dist/plugins/l10n/ko.js"></script>
<script>
	// $("[datetimepicker]").flatpickr({
	// 	"locale": "ko",
	// 	mode: "range",
	// 	dateFormat: "Y-m-d",
	// 	onClose: function(selectedDates, dateStr, instance){
	// 	}
	// });

	setRangePicker($("[datetimepicker]"));

	$("[datetimepicker-one]").flatpickr({
		"locale": "ko",
		//mode: "range",
		dateFormat: "Y-m-d",
		onClose: function(selectedDates, dateStr, instance){
		}
	});
</script>
<!-- 사용자 -->
<script type="text/javascript">
	$(function () {
		var gm_move = $("#gnb-menu>li.active").offset().top;
		$("#gnb-menu").stop().animate({scrollTop: gm_move}, 300, "easeOutExpo"); // 페이지 로딩 시 메뉴 위치 이동

	/*[s] 공통 */
		$("body").on("mouseenter", ".right-utill>.login", function(){// Login Over
			$("#header .login-info").show();
		});
		$("body").on("mouseleave", ".right-utill>.login", function(){// Login Out
			$("#header .login-info").hide();
		});

		$("body").on("click", ".right-utill .iconlayer", function(){// 레이어 열기/닫기
			if(!$(this).hasClass("active")){
				$(this).addClass("active");
				$(".right-utill .map-option").show();
			}else{
				$(this).removeClass("active");
				$(".right-utill .map-option").hide();
			}
		});

		$("body").on("click", ".right-utill .editmode", function(){// Edit Mode 열기
			if(!$("#wrap").hasClass("editMode")){
				$(this).addClass("active");
				popFancy('#lay-edit-mode');
			}else{
				alert("Edit Mode 실행 중입니다.")
			}
		});
	/*[e] 공통 */
	});
	function popFancy(name){// 팝업 열기
		new Fancybox([{src:name, type: "inline"},],
			{
				on: {
					"*": (event, fancybox, slide) => {
						//console.log(`event: ${event}`);
					},
				},
			}
		);
	}
	function popFancyClose(){// 팝업닫기
		$(".right-utill .editmode").removeClass("active");
		$(".fancybox__slide").removeClass('fullscreen');
		Fancybox.close();
	}
</script>
</body>
</html>