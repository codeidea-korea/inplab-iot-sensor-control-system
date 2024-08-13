<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <jsp:include page="../common/include_head.jsp" flush="true"></jsp:include>

        <style>
            .contents-re .gridDataContent>table{
                width: calc(100% + 0px);
            }
            .contents-re .gridDataContent{
                height: 200px;
                overflow: auto;
            }
        </style>

        <script>
            let $sensorGrid, $dataGrid;
            
            let ch_name_sensor_keys;
            
            let asset_kind_id, download_able_flag;
            
            $(function() {

                $.get('/admin/sensorByChannelList/columns', function(res) {
						res.asset_kind_id.width = 120;
						res.name.width = 120;
						res.zone_name.width = 120;
						res.ch_collect_date.width = 200;
						res.ch_collect_date.title = '마지막 수집일시';
						res.collect_date.type = 'hidden';
						
						res.status.width = 95;
						res.status.title = '센서상태';
						res.install_date.type = 'hidden';
                    	res.real_value.type = 'hidden';

                    $sensorGrid = jqgridUtil($('.gridSensor'), {
                        listPathUrl : "/admin/sensorByChannelList"
                        , sidx : 'ch_collect_date'
                        , sord : 'desc'
                    }, res, true, function subCall(data){
                    	
                    	ch_name_sensor_keys = data.ch_name_sensor_keys;
                    	
                    	asset_kind_id = data.asset_kind_id_hid;
                    	
						$.jgrid.gridUnload('gridData');

    					$("#sensor_name").html(data.name);
                    	
                    	if( '2'==asset_kind_id ){//2:구조물경사계
                    		console.log(asset_kind_id);
                            $.get('/admin/dataMeasure/columns', function(res) {

                                res.collect_date.type = "cal_timestamp_range";
                                res.collect_date.width = 200;
                                res.x_deg.width = 110;
                                res.x_raw_data.width = 110;
                                res.y_deg.width = 110;
                                res.y_raw_data.width = 110;
    							//데이터 값 설정
                                $dataGrid = jqgridUtil($('.gridData'), {
                                    listPathUrl : "/admin/dataMeasure",
                                    ch_name_sensor_keys : data.ch_name_sensor_keys
                                }, res, true, null, function whenGridComplete(){
    					                				$.get('/admin/dataMeasure/newchartData', {ch_name_sensor_keys: ch_name_sensor_keys
    					                														, collect_date: $('#gs_g1_collect_date').val()
    					                														, page : $('.gridData').getGridParam().page
                                                                                                , rows : $('.gridData').getGridParam().rowNum
    					                														, x_raw_data: $('#gs_g1_x_raw_data').val()
    					                														, x_deg: $('#gs_g1_x_deg').val()
    					                														, y_raw_data: $('#gs_g1_y_raw_data').val()
    					                														, y_deg: $('#gs_g1_y_deg').val()
    					                													}
    					                													, function(res) {
                                                                                                // console.log(res);
                                                                                                var data = res.slice(0, res.length - 1);
                                                                                                var manage = res[res.length -1];
    														                					drawChart($('.chart'), $("#sensor_name").val(), data, manage);
    														    		       				}
    					                				);     

                                					 });
    							
//                 				$.get('/admin/dataMeasure/chartData', {ch_name_sensor_keys: data.ch_name_sensor_keys}, function(res) {
//                 					drawChart($('.chart'), data.name, res);
//     		       				});                            
                                
                            });
                    		
                    	}else if( '3'==asset_kind_id ){//3:지표변위계
                    		console.log(asset_kind_id);
                            $.get('/admin/wireDataMeasure/columns', function(res) {
                            	res.deg.title = '변위(mm)';
                                res.collect_date.type = "cal_timestamp_range";
                                res.collect_date.width = 200;
                                res.raw_data.width = 225;
                                res.deg.width = 225;
    							//데이터 값 설정 
                                $dataGrid = jqgridUtil($('.gridData'), {
                                    listPathUrl : "/admin/wireDataMeasure",
                                    ch_name_sensor_keys : data.ch_name_sensor_keys
                                }, res, true, null, function whenGridComplete(){
    					                				$.get('/admin/wireDataMeasure/chartData', {ch_name_sensor_keys: ch_name_sensor_keys
    					                														, collect_date: $('#gs_g1_collect_date').val()
                                                                                                , page : $('.gridData').getGridParam().page
                                                                                                , rows : $('.gridData').getGridParam().rowNum
    					                														, raw_data: $('#gs_g1_raw_data').val()
    					                														, deg: $('#gs_g1_deg').val()
    					                													}
    					                													, function(res) {
                                                                                                var data = res.slice(0, res.length - 1);
                                                                                                var manage = res[res.length -1];
                                                                                                console.log(res, data, manage);

    														                					drawChart($('.chart'), $("#sensor_name").val(), data, manage);
    														    		       				}
    					                				);     

                                					 });
    							
//                 				$.get('/admin/dataMeasure/chartData', {ch_name_sensor_keys: data.ch_name_sensor_keys}, function(res) {
//                 					drawChart($('.chart'), data.name, res);
//     		       				});                            
                                
                            });
                    		
						}else if( '4'==asset_kind_id ){//4:강우량계
                            console.log(asset_kind_id);
                            $.get('/admin/rainDataMeasure/columns', function(res) {
                            	res.deg.title = '강우량(mm)';
                                res.deg.width = 225;
                                res.collect_date.type = "cal_timestamp_range";
                                res.collect_date.width = 200;
                                res.raw_data.width = 225;

                                console.log()
    							//데이터 값 설정 
                                $dataGrid = jqgridUtil($('.gridData'), {
                                    listPathUrl : "/admin/rainDataMeasure",
                                    ch_name_sensor_keys : data.ch_name_sensor_keys
                                }, res, true, null, function whenGridComplete(){
    					                				$.get('/admin/rainDataMeasure/chartData', {ch_name_sensor_keys: ch_name_sensor_keys
    					                														, collect_date: $('#gs_g1_collect_date').val()
                                                                                                , page : $('.gridData').getGridParam().page
                                                                                                , rows : $('.gridData').getGridParam().rowNum
    					                														, raw_data: $('#gs_g1_raw_data').val()
    					                														, deg: $('#gs_g1_deg').val()
    					                													}
    					                													, function(res) {
                                                                                                var data = res.slice(0, res.length - 1);
                                                                                                var manage = res[res.length -1];
    														                					drawChart($('.chart'), $("#sensor_name").val(), data, manage);
    														    		       				}
    					                				);     

                                					 });
    							
//                 				$.get('/admin/dataMeasure/chartData', {ch_name_sensor_keys: data.ch_name_sensor_keys}, function(res) {
//                 					drawChart($('.chart'), data.name, res);
//     		       				});                            
                                
                            });
                    	
                    	}
                    	
                    }//function subCall(data){
                    ,null);//jqgridUtil(
                    
                });
                
				// 등록
				$('.uploadBtn').on('click', function () {
					
					initForm();
	
	                popFancy('#lay-form-write');
	
	                // 저장버튼 클릭시
	                $('#lay-form-write input[type=submit]').off().on('click', function () {
                        //파일업로드
                        if($("#uploadFile")[0].files[0] != undefined){
                        	
                        	if (!validate()) return;
                        	
                        	var call_url = "";

                            console.log(ch_name_sensor_keys);
                            console.log(asset_kind_id);

                        	
                            var form = new FormData();
                            form.append( "uploadFile", $("#uploadFile")[0].files[0] );
                            form.append( "ch_name_sensor_keys", ch_name_sensor_keys );
                            form.append( "asset_kind_id", asset_kind_id );
                            
                            form.append( "collect_date", $('#gs_g1_collect_date').val() );
                            
                            if( '2'==asset_kind_id ){//2:구조물경사계
                            	call_url = "/admin/dataMeasure/addByExcel";
                            	
                                form.append( "x_raw_data", $('#gs_g1_x_raw_data').val() );
                                form.append( "x_deg", $('#gs_g1_x_deg').val() );
                                form.append( "y_raw_data", $('#gs_g1_y_raw_data').val() );
                                form.append( "y_deg", $('#gs_g1_y_deg').val() );
                            }else if( '3'==asset_kind_id ){//3:지표변위계
                            	call_url = "/admin/wireDataMeasure/addByExcel";
                            
                            	form.append( "raw_data", $('#gs_g1_raw_data').val() );
                                form.append( "deg", $('#gs_g1_deg').val() );
                            }else if( '4'==asset_kind_id ){//4:강우량계
                            	call_url = "/admin/rainDataMeasure/addByExcel";

                            	form.append( "raw_data", $('#gs_g1_raw_data').val() );
                                form.append( "deg", $('#gs_g1_deg').val() );
                            }
                            
                            fileUpload(call_url, form);
                        }
                        
					});
				});
	
	            $('.excelBtn').on('click', function () {
	            	
					if( ch_name_sensor_keys == null ){
						alert("좌측 센서 정보목록을 먼저 선택해주세요.");
						return;
					}

                    if(!download_able_flag){
                        alert("다운로드 데이터가 없습니다.");
                        return;
                    }
                    downloadExcel('계측기 데이터 관리');
	            });
            	
            });
            
            function initForm(){
            	$('#lay-form-write input[name=uploadFile]').val('');
            }
            
            function validate() {
            	var maxSizeMb = 10;
            	var maxSize = maxSizeMb * 1024 * 1024; // 10MB
            	
				var fileSize = $("#uploadFile")[0].files[0].size;
				if(fileSize > maxSize){
					alert("파일은 "+maxSizeMb+"MB 이내로 등록 가능합니다.");
					$("#uploadFile").val("");
					return false;
				}
				
				if($("#uploadFile").val() != "") {		
					var ext = $("#uploadFile").val().split(".").pop().toLowerCase();		    
					if($.inArray(ext, ["xlsx", "xls"]) == -1) {
						alert("엑셀 파일만 등록 가능합니다.");
						$("#uploadFile").val("");
						return false;
					}
				}

				if( ch_name_sensor_keys == null ){
					alert("좌측 센서 정보목록을 먼저 선택해주세요.");
					return false;
				}
				
                return true;
            }

            function getPlotLine(color, value, text) {
                return {
                    color: color,
                    value: value,
                    width: 1.5,
                    label: {
                        text: text,
                        align: 'left',
                        style: {
                            fontSize: '12px',
                            color: color
                        }
                    }
                }
            }
            
            function drawChart($el, sensor_name, data, manage) {
                 console.log("dataMeasure : ",data,manage);

                if(data.length == 0){
                    download_able_flag = false;
                    $('.chart').empty();
                    return;
                }
                if(data[0].length == 0 && data[1].length == 0){
                    download_able_flag = false;
                }else{
                    download_able_flag = true;
                }

                let guideLine = [];                                             //가이드 라인 array 를 만들어서 plotLine 데이터를 생성

                guideLine.push(getPlotLine('#FF0000', manage.max4, manage.asset_kind_name + ' 4차 (' + manage.max4 + ')'));
                guideLine.push(getPlotLine('#FF9600', manage.max3, manage.asset_kind_name + ' 3차 (' + manage.max3 + ')'));
                guideLine.push(getPlotLine('#FFD200', manage.max2, manage.asset_kind_name + ' 2차 (' + manage.max2 + ')'));
                guideLine.push(getPlotLine('#90DA00', manage.max1, manage.asset_kind_name + ' 1차 (' + manage.max1 + ')'));
                guideLine.push(getPlotLine('#FF0000', manage.min4, manage.asset_kind_name + ' 4차 (' + manage.min4 + ')'));
                guideLine.push(getPlotLine('#FF9600', manage.min3, manage.asset_kind_name + ' 3차 (' + manage.min3 + ')'));
                guideLine.push(getPlotLine('#FFD200', manage.min2, manage.asset_kind_name + ' 2차 (' + manage.min2 + ')'));
                guideLine.push(getPlotLine('#90DA00', manage.min1, manage.asset_kind_name + ' 1차 (' + manage.min1 + ')'));

                const oneHour = 3600 * 1000; // one hour in milliseconds

                let seriesData, max, min, guide;
                if ('2'==asset_kind_id) {
                    // asset_kind_id가 2인 경우, 두 개의 series 데이터 설정
                    seriesData = [
                        {
                            name: sensor_name + ' - X', // X 그래프 이름
                            data: data[0], // 첫 번째 5개 데이터
                            showInLegend: false // Remove series label
                        },
                        {
                            name: sensor_name + ' - Y', // Y 그래프 이름
                            data: data[1], // 두 번째 5개 데이터
                            showInLegend: false // Remove series label
                        }
                    ];
                    // 값을 추출한다.
                    // 중복값 제거한 list 만들기
                    const uniqueData = [...new Set(data.flatMap(d => d?.map(dt => parseFloat(dt[1]))))];
                    guide = guideLine.map(d => parseFloat(d.value)).sort((a,b) => a-b);

                    // 전체 값 중에 max, min 값을 구한다.
                    max = Math.max(...uniqueData) || 0;
                    min = Math.min(...uniqueData) || 0;
                } else {
                    // 그 외의 경우, 하나의 series 데이터 설정
                    seriesData = [
                        {
                            name: sensor_name,
                            data: data,
                            showInLegend: false // Remove series label
                        }
                    ];
                    // 값을 추출한다.
                    // 중복값 제거한 list 만들기
                    const uniqueData = [...new Set(data.map(dt => parseFloat(dt[1])))];
                    guide = guideLine.map(d => parseFloat(d.value)).sort((a,b) => a-b);

                    // 전체 값 중에 max, min 값을 구한다.
                    max = Math.max(...uniqueData) || 0;
                    min = Math.min(...uniqueData) || 0;
                }

                const maxClosest = findClosest(guide, max);
                const minClosest = findClosest(guide, min);

                // 비교 해서 더 큰 수
                if(max < maxClosest){
                    max = maxClosest;
                }else{
                    if(guide.findIndex(d => d == maxClosest) != -1) {
                        max = guide[guide.findIndex(d => d == maxClosest) + 1] || max;
                    }else{
                        max = Math.max(...uniqueData, guide[guide.length - 1]);
                    }
                }

                // 비교 해서 더 작은 수
                if(min > minClosest) {
                    min = minClosest;
                } else {
                    if(guide.findIndex(d => d == minClosest) != -1) {
                        min = guide[guide.findIndex(d => d == minClosest) - 1] || min;
                    } else {
                        min = Math.min(...uniqueData, guide[0]);
                    }
                }

                guideLine = guideLine.filter(c => {
                    // max 보다 크고 min 보다 작으면 가이드라인에서 없애기
                    return !(max < Number(c.value) || Number(c.value) < min);
                });

                console.log(min, max);


                Highcharts.chart($el[0], {
                    chart: {
                        // marginTop: 0,
                        // marginRight: 0,
                        // marginBottom: 5,
                        // marginLeft: 0,
                        // spacing: [5, 15, 0, 0]
                        height: ($(document).height() - 705) + 'px'
                    },
                    title: {
                        text: null
                    },
                    legend: {

                        enabled: false // Remove series label
                    },
                    tooltip: {
                        dateTimeLabelFormats: {
                            minute: '%m/%d %H:%M',
                            hour: '%m/%d %H:%M'
                        },
                        style: {
                            fontSize: '13px'
                        }
                    },
                    xAxis: {
                        type: 'datetime',
                        tickInterval: oneHour, // 1 hour
                        dateTimeLabelFormats: {
                            hour: '%m/%d %H:%M',
                            day: '%m/%d %H:%M',
                            minute: '%m/%d %H:%M'
                        },
                        labels: {
                            style: {
                                fontSize: '10px'
                            },
                            rotation: 0, // 라벨을 수평으로
                            step: 3 // 두 개씩 건너 뛰어서 라벨 표시
                        }
                    },
                    yAxis: {
                        title: {
                            text: null
                        },
                        labels: {
                            style: {
                                fontSize: '12px'
                            }
                        },
                        min: min*1.3,
                        max: max*1.3,
                        tickInterval: "auto",
                        plotLines: guideLine
                    },
                    series: seriesData
                });
            }
            
            function downloadExcel(fileName, $dataGrid) {
                var url = "";
                
                if( '2'==asset_kind_id ){//2:구조물경사계
                	url = "/admin/dataMeasure/excel/" + fileName + "?ch_name_sensor_keys="+ch_name_sensor_keys;
                }else if( '3'==asset_kind_id ){//3:지표변위계
                	url = "/admin/wireDataMeasure/excel/" + fileName + "?ch_name_sensor_keys="+ch_name_sensor_keys;
                }else if( '4'==asset_kind_id ){//4:강우량계
                	url = "/admin/rainDataMeasure/excel/" + fileName + "?ch_name_sensor_keys="+ch_name_sensor_keys;
                }
                
                var hiddenIFrameId = 'hiddenDownloader';
                var iframe = document.getElementById(hiddenIFrameId);
                if (iframe === null) {
                    iframe = document.createElement('iframe');
                    iframe.id = hiddenIFrameId;
                    iframe.style.display = 'none';
                    document.body.appendChild(iframe);
                }
                iframe.src = url;
            }
            
			function fileUpload( call_url, form ){
	             $.ajax({
	                     url : call_url
	                     , type : "POST"
	                     , processData : false
	                     , contentType : false
	                     , data : form
	                     , success:function(response) {
	                    	$('.gridData').trigger('reloadGrid');
                            let msg = "저장되었습니다.";

                            if(response != null && response.failCnt > 0){
                                msg = "엑셀업로드 중 일부 데이터는 업로드형식에 맞지않아 정상 업로드 되지 않았습니다.</br>총 "+response.totCnt+"건( 성공 "+response.successCnt+"건 , 실패 "+response.failCnt+"건)";
                            }else if(response != null && response.failCnt == 0 && response.totCnt > 0){
                                msg = "저장되었습니다.";
                            }else {
                                msg = "엑셀업로드에 실패하였습니다.";
                            }
                            alert(msg, function () {
                                popFancyClose('#lay-form-write');
                                
//     							//데이터 값 설정 
//                                 $dataGrid = jqgridUtil($('.gridData'), {
//                                     listPathUrl : "/admin/dataMeasure",
//                                     ch_name_sensor_keys : data.ch_name_sensor_keys
//                                 }, res, false);
                                
//                 				$.get('/admin/dataMeasure/chartData', {ch_name_sensor_keys: data.ch_name_sensor_keys}, function(res) {
//                 					drawChart($('.chart'), data.name, res);
//     		       				});                            

                            });
	                     }
	                     ,error: function (jqXHR) { 
	                         alert(jqXHR.responseText); 
	                     }
	         	});
			}
        </script>
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

            <div id="container">
                <h2 class="txt">관리자 전용 
                	<span class="arr">데이터 관리</span> 
                	<span class="arr">계측기 데이터 관리</span>
                </h2>
    
                <div id="contents">
                    <div class="contents-re">
                        <h3 class="txt">센서 정보</h3>
                        <div class="contents-in auto">
                            <div class="bTable">
                                <table class="gridSensor"></table>
                            </div>
                        </div>
                    </div>
                    <div class="contents-re">
                        <h3 class="txt">데이터 값 설정 <span id="sensor_name" class="point"></span></h3>
                        <div class="btn-group asd">
                            <a class="excelBtn">다운로드</a>
							<a class="uploadBtn">업로드</a>
                        </div>
                        <div class="contents-in auto h200">
                            <div class="bTable gridDataContent">
                                <table id="gridData" class="gridData"></table>
                            </div>
                        </div>

                        <h3 class="txt">센서 데이터 그래프</h3>
                        <div class="contents-in auto">
                            <div class="chart"></div>
                        </div>
                    </div>
                </div>
            </div>
            <!--[e] 컨텐츠 영역 -->
            
			<!--[s] 알람 설정 수정 팝업 -->
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
								<col width="130" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th>엑셀파일</th>
									<td><input type="file" id="uploadFile" name="uploadFile" value="" placeholder="" /></td>
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
			<!--[e] 알람 설정 수정 팝업 -->
            
        </section>
    </body>
</html>
