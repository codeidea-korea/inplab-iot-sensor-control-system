/**
 * vworld 맵을 이용해 2d, 3d 지도를 동시에 활용하고
 *
 * 오버레이와 메서드를 호환시키는 유틸
 *
 * by Lkj
 *
 */
const vworldKey = '935413DC-CBE2-382F-B307-933501B0DC45';
// zoomLevel 0~25
var level2d = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25];
var level3d = [0, 0, 0, 0, 0, 0, 0, 1622016, 811008, 405504, 202752, 101376, 50688, 25344, 12672, 6336, 3168, 1584, 792, 396, 198, 99, 48, 24, 12];

var Hybrid = new ol.layer.Tile({
    name: "Hybrid",
    source: new ol.source.XYZ({
        url: 'http://api.vworld.kr/req/wmts/1.0.0/' + vworldKey + '/Hybrid/{z}/{y}/{x}.png'
    })
}); //문자 타일 레이어

var Satellite = new ol.layer.Tile({
    name: "mapLayer",
    id: "Satellite",
    source: new ol.source.XYZ({
        url: 'http://api.vworld.kr/req/wmts/1.0.0/' + vworldKey + '/Satellite/{z}/{y}/{x}.jpeg'
    })
}); //항공사진 레이어 타일

var Base = new ol.layer.Tile({
    name: "mapLayer",
    id: "Base",
    source: new ol.source.XYZ({
        url: 'http://api.vworld.kr/req/wmts/1.0.0/' + vworldKey + '/Base/{z}/{y}/{x}.png'
    })
}); // 기본지도 타일

var gray = new ol.layer.Tile({
    name: "mapLayer",
    id: "gray",
    source: new ol.source.XYZ({
        url: 'http://api.vworld.kr/req/wmts/1.0.0/' + vworldKey + '/gray/{z}/{y}/{x}.png'
    })
}); //회색지도 타일

var midnight = new ol.layer.Tile({
    name: "mapLayer",
    id: "midnight",
    source: new ol.source.XYZ({
        url: 'http://api.vworld.kr/req/wmts/1.0.0/' + vworldKey + '/midnight/{z}/{y}/{x}.png'
    })
});

function closestLevel(height) {
    const array = level3d;
    var closestIndex = 0;
    var closestDiff = Math.abs(array[0] - height);
    for (var i = 1; i < array.length; i++) {
        var diff = Math.abs(array[i] - height);
        if (diff < closestDiff) {
            closestIndex = i;
            closestDiff = diff;
        }
    }
    return closestIndex;
}

function closestHeight(zoomLevel) {
    return level3d[zoomLevel];
}

function vwutil(param) {
    this.mapId = param.mapId;
    this.map;
    this.initPosition = param.initPosition;
    this.overlays = [];

    this.overlaysIdx = 0;

    this.tempCtx = document.createElement('canvas');

    let instance = this;

    /**
     *
     * @param {*} x 2D 일땐 EPSG3857, 3D 일땐 EPSG4326
     * @param {*} y
     * @param {*} z 0~25
     */
    this.changeCoords = function(x, y, z) {
        if (instance.map.type == '2D') {
            instance.initPosition.center = ol.proj.transform([x, y], "EPSG:3857", "EPSG:4326");
            instance.initPosition.zoom = z;
        } else {
            instance.initPosition.center = [x, y];
            instance.initPosition.zoom = closestLevel(z);
        }
    }
}

vwutil.prototype.vwmap3d = function () {
    const instance = this;
    var initCoords = this.initPosition.center;

    this.clearOverlay();

    if (typeof this.map != 'undefined')
        if (instance.map.type == '3D')
            return;

    if (this.map instanceof ol.Map) {
        this.map.dispose();
        $('#' + this.mapId).find('.ol-viewport').remove();
    }

    this.map = new vw.Map(this.mapId, new vw.MapOptions(
        vw.BasemapType.GRAPHIC,
        "",
        vw.DensityType.FULL,
        vw.DensityType.BASIC,
        false,
        new vw.CameraPosition(
            new vw.CoordZ(initCoords[0], initCoords[1], instance.getZoomHeight()),
            new vw.Direction(-90, 0, 0)
        ),
        new vw.CameraPosition(
            new vw.CoordZ(initCoords[0], initCoords[1], instance.getZoomHeight()),
            new vw.Direction(0, -90, 0)
        )
    ));

    this.map.onClick.addEventListener(function(windowPosition, ecefPosition, cartographic, modelObject) {
        // console.log({ windowPosition : windowPosition, ecefPosition : ecefPosition, cartographic : cartographic, modelObject : modelObject});
        if (typeof cartographic == 'undefined' || cartographic == null) {
            $(document).trigger('map_click', { windowPosition : windowPosition, ecefPosition : ecefPosition, cartographic : undefined, modelObject : modelObject});
        } else {
            $(document).trigger('map_click', { windowPosition : windowPosition, ecefPosition : ecefPosition, cartographic : { latitude : cartographic.latitudeDD, longitude : cartographic.longitudeDD, height : cartographic.height }, modelObject : modelObject});
        }
    });

    var interval = setInterval(() => {
        if (ws3d.viewer.scene.globe.tilesLoaded) {
            // 최소, 최대 resolution 설정
            setTimeout(function () {
                console.log(ws3d.viewer.scene.screenSpaceCameraController);
                ws3d.viewer.scene.screenSpaceCameraController.minimumZoomDistance = 12;
                ws3d.viewer.scene.screenSpaceCameraController.maximumZoomDistance = 811008;

                // 지도가 이동, 줌 되는 경우
                ws3d.viewer.camera.moveEnd.addEventListener(function (e) {
                    try {
                        instance.changeCoords(instance.map.getCurrentPosition().position.x, instance.map.getCurrentPosition().position.y, instance.map.getCurrentPosition().position.z);
                        $(document).trigger('map_action_end', e);
                    } catch (e) {
                        console.log(e);
                    }
                });
            }, 0);   // 빠른 시점에 screenSpaceCameraController 객체에 접근하면 한번 줌인이 됨 (Cesium 버그) 그래서 딜레이 추가

            clearInterval(interval) // clearing setInterval

            console.log('load complete');
            $(document).trigger('map_action_end');

            $.each(this.overlays, function() {
                if (this.imgUrl != null && this.coords != null) {
                    instance.addOverlay3D(this.imgUrl, this.label, this.coords, this.uid, this.cnt);
                }

                if (!this.show)
                    instance.visibleOverlay(this.uid, this.show);
            });

            const handler = new Cesium.ScreenSpaceEventHandler(ws3d.viewer.scene.canvas);

            handler.setInputAction((click) => {
                const pickedObject = ws3d.viewer.scene.pick(click.position);
                if (Cesium.defined(pickedObject) && pickedObject.id) {
                    const entityId = pickedObject.id.id;
                    $(document).trigger('overlay_click', instance.getObjectByEid(entityId));
                }
            }, Cesium.ScreenSpaceEventType.LEFT_CLICK);            
        }
    }, 500);

    instance.map.type = '3D';
}

vwutil.prototype.vwmap2d = function () {
    const instance = this;

    if (typeof this.map != 'undefined') {
        if (instance.map.type == '2D') 
            return;

        if (this.map instanceof vw.Map) {
            $('#' + this.mapId).find('.wsMapContainerContentWrapper').remove();
        }
    }

    this.map = new ol.Map({
        target: this.mapId,
        layers: [Base],
        view: new ol.View({
            center: ol.proj.transform(instance.initPosition.center, "EPSG:4326", "EPSG:3857"),
            zoom: instance.initPosition.zoom,
            minZoom: 8,
            maxZoom: 19
        })
    });

    this.map.type = '2D';

    this.map.on('moveend', function (e) {
        if (instance.map.type != '2D')
            return;

        let center = instance.map.getView().getCenter();
        instance.changeCoords(center[0], center[1], instance.map.getView().getZoom());

        $(document).trigger('map_action_end', e);
    });

    this.map.on('loadend', function (e) {
        $(document).trigger('map_action_end', e);
    });

    this.map.on('click', function (e) {
        let pos = ol.proj.transform(e.coordinate, "EPSG:3857", "EPSG:4326");

        $(document).trigger('map_click', { windowPosition : { x: e.originalEvent.offsetX, y : e.originalEvent.offsetY},
            cartographic : { latitude : pos[1], longitude : pos[0], height : 0 }});
    });

    $(document).on('click', 'div.ol-overlay-container', function(e) {
        $(document).trigger('overlay_click', instance.getObjectByUid($(this).children().attr('uid')));
    });

    this.map.render();

    $.each(this.overlays, function() {
        if (this.htmlContent != null && this.coords != null) {
            instance.addOverlay2D(this.htmlContent, this.coords, this.uid);
        }

        if (!this.show)
            instance.visibleOverlay(this.uid, this.show);
    });
}

vwutil.prototype.getObjectByEid = function(target_eid) {
    const instance = this;
    let overlay = null;
    
    $.each(this.overlays, function() {
        let eid = instance.map.getObjectById(this.uid).ws3dGraphics.entities[0].id;
        if (eid == target_eid) {      
            overlay = this;
            return false;
        }
    });

    return overlay;
}

vwutil.prototype.getObjectByUid = function(target_uid) {
    let overlay = null;
    
    $.each(this.overlays, function() {
        if (this.uid == target_uid) {      
            overlay = this;
            return false;
        }
    });

    return overlay;
}

vwutil.prototype.clearOverlay = function () {

}

vwutil.prototype.getMap = function () {
    return this.map;
}

vwutil.prototype.addOverlay = function(htmlContent, coords, imgUrl, label, markerCnt, param) {
    this.overlaysIdx++;

    var uid = 'uid_' + this.overlaysIdx;
    var obj = {coords : coords, uid : uid, show : true, cnt : markerCnt};

    if (typeof param != 'undefined' && param != null)
        obj = Object.assign(obj, param);
    
    if (htmlContent != null && coords != null) {
        this.addOverlay2D(htmlContent, coords, uid);
        obj = Object.assign(obj, {htmlContent : htmlContent});
    }

    if (imgUrl != null && label != null && coords != null) {
        this.addOverlay3D(imgUrl, label, coords, uid, markerCnt);        
        obj = Object.assign(obj, {imgUrl : imgUrl, label : label});
    }
    this.overlays.push(obj);

    return uid;
}

vwutil.prototype.addOverlay3D = function(imgUrl, label, coords, uid , cnt) {
    const instance = this;

    if (this.map.type != '2D') {
        if (imgUrl.indexOf('icon_area1') > -1 && cnt != null && cnt >= 0) {
            const image = new Image();
            image.src = imgUrl;
            image.onload = function() {         // 아이콘 내부에 라벨이 하나더 위치하는 경우
                const canvas = instance.tempCtx;
                const ctx = canvas.getContext('2d');
                canvas.width = image.width;
                canvas.height = image.height;
                ctx.drawImage(image, 0, 0);
                instance.addNumberToCanvas(ctx, canvas.width / 2, canvas.height / 1.55, cnt);
    
                const dataUrl = canvas.toDataURL();
    
                pt = new vw.geom.Point(new vw.Coord(coords[0], coords[1]));
                pt.setImage(dataUrl);
                pt.setName(label);
                pt.setFont("고딕");
                pt.setId(uid)
                pt.setFontSize(13);
                pt.setFillColor('#fff');
                pt.create();

                instance.setLabelStyle(uid, '#000000', '#ffffff', .7);
            }
        } else {
            pt = new vw.geom.Point(new vw.Coord(coords[0], coords[1]));
            pt.setImage(imgUrl);
            pt.setName(label);
            pt.setFont("고딕");
            pt.setId(uid)
            pt.setFontSize(13);
            pt.setFillColor('#fff');
            pt.create();

            instance.setLabelStyle(uid, '#000000', '#ffffff', .7);
        }        
    }

    // console.log('create - ' + uid);
}

vwutil.prototype.addNumberToCanvas = function(ctx, x, y, number) {
    ctx.font = '14px serif';  // 폰트 설정
    ctx.fillStyle = '#333';    // 텍스트 색상 설정
    ctx.textAlign = 'center'; // 가운데 정렬
    ctx.fillText(number, x, y); // 숫자 그리기
}

vwutil.prototype.addOverlay2D = function(htmlContent, coords, uid) {
    let $el = $(htmlContent);

    $el.attr('uid', uid);

    if (this.map.type != '3D') {
        let overlay = new ol.Overlay({
            position: ol.proj.transform(coords, "EPSG:4326", "EPSG:3857"),
            positioning: 'bottom-center',
            element: $el[0],
            stopEvent: true
        });

        this.map.addOverlay(overlay);
    }

    // console.log('create - ' + uid);
}

/**
 * 오버레이의 라벨부분 스타일링적용
 * 
 * 각 색상은 '#ffffff' 와 같은 형태로
 * @param {*} uid 
 * @param {*} fontColor 
 * @param {*} backgroudColor 
 */
vwutil.prototype.setLabelStyle = function(uid, fontColor, backgroundColor, backgroundAlpha) {
    if (typeof backgroundAlpha == 'undefined') {
        backgroundAlpha = 1.0;
    }

    let getCesiumColor = function(hexColor, alpha) {
        var red = parseInt(hexColor.substr(1, 2), 16) / 255;
        var green = parseInt(hexColor.substr(3, 2), 16) / 255;
        var blue = parseInt(hexColor.substr(5, 2), 16) / 255;

        return new Cesium.Color(red, green, blue, alpha);
    };

    if (this.map.type != '2D') {
        let eid = this.map.getObjectById(uid).ws3dGraphics.entities[0].id;

        $.each(ws3d.viewer.entities.values, function() {
            if (this.id == eid) {
                this.label.backgroundColor = getCesiumColor(backgroundColor, backgroundAlpha)
                this.label.fillColor = getCesiumColor(fontColor, 1.0); 
                this.label.showBackground = true;
            }
        });
    } else {
        $.each(window.vworld.getMap().getOverlays().getArray(), function() {
            if ($(this.getElement()).attr('uid') == uid) {
                $(this.getElement()).find('span.title').css('color', fontColor);                   // element에 직접 css 적용
                $(this.getElement()).find('span.title').css('background', backgroundColor);        // element에 직접 css 적용
            }
        });
    }
}

vwutil.prototype.removeOverlay = function(uid) {
    function removeItemsWithUid(array, uid) {
        return array.filter(item => item.uid !== uid);
    }

    if (this.map.type != '2D') {
        let obj = this.map.removeObjectById(uid);
    } else {
        $('div[uid=' + uid + ']').closest('.ol-overlay-container').remove();
    }

    this.overlays = removeItemsWithUid(this.overlays, uid);
}

vwutil.prototype.setPositionOverlay = function(uid, coords) {
    if (this.map.type != '2D') {
        try {
            let eid = this.map.getObjectById(uid).ws3dGraphics.entities[0].id;

            $.each(ws3d.viewer.entities.values, function() {
                if (this.id == eid) {
                    this.position = Cesium.Cartesian3.fromDegrees(coords[0], coords[1]);
                }
            });
        } catch(e) { }
    } else {
        $.each(window.vworld.getMap().getOverlays().getArray(), function() {
            if ($(this.getElement()).attr('uid') == uid) {
                this.setPosition(ol.proj.transform(coords, "EPSG:4326", "EPSG:3857"));
                return false;
            }
        });
    }
}

vwutil.prototype.getPositionOverlay = function(uid) {
    let result;

    if (this.map.type != '2D') {
        try {
            let eid = this.map.getObjectById(uid).ws3dGraphics.entities[0].id;

            $.each(ws3d.viewer.entities.values, function() {
                if (this.id == eid) {
                    result = this.position.getValue();
                    return false;
                }
            });
        } catch(e) { }
    } else {
        $.each(window.vworld.getMap().getOverlays().getArray(), function() {
            if ($(this.getElement()).attr('uid') == uid) {
                result = ol.proj.transform(this.getPosition(), "EPSG:3857", "EPSG:4326");
                return false;
            }
        });
    }

    return result;
}

vwutil.prototype.getVisible = function(uid) {
    if (this.map.type != '2D') {
        try {
            let eid = this.map.getObjectById(uid).ws3dGraphics.entities[0].id;

            $.each(ws3d.viewer.entities.values, function() {
                if (this.id == eid) {
                    return this.show;
                }
            });
        } catch(e) { }
    } else {
        return $('div[uid=' + uid + ']').is(':visible');
    }
}

vwutil.prototype.visibleOverlay = function(uid, visible) {
    if (this.map.type != '2D') {
        try {
            let eid = this.map.getObjectById(uid).ws3dGraphics.entities[0].id;

            $.each(ws3d.viewer.entities.values, function() {
                if (this.id == eid) {
                    this.show = visible;
                }
            });
        } catch(e) { }
    } else {
        if (visible) {
            $('div[uid=' + uid + ']').show();
        } else {
            $('div[uid=' + uid + ']').hide();
        }
    }

    $.each(this.overlays, function() {
        if (this.uid == uid)
            this.show = visible;
    });
}

vwutil.prototype.getCenter = function() {
    let instance = this;
    
    if (this.map.type != '2D') {
        return [instance.map.getCurrentPosition().position.x, instance.map.getCurrentPosition().position.y];
    } else {
        return ol.proj.transform(instance.map.getView().getCenter(), "EPSG:3857", "EPSG:4326");
    }
}

vwutil.prototype.getZoom = function() {
    let instance = this;
    if (this.map.type != '2D') {
        let height = ws3d.viewer.camera.positionCartographic.height;
        return closestLevel(height);
    } else {
        return this.map.getView().getZoom();
    }
}

vwutil.prototype.getZoomHeight = function() {
    var resolution = this.map.getView().getResolution();
    var projection = this.map.getView().getProjection();            // 현재 지도 뷰의 Projection을 가져옵니다.
    var radius = projection.getMetersPerUnit() * 6378137;           // Projection의 metersPerUnit 값으로 지구 반지름 값을 구합니다.
    var height = radius * 2 * Math.PI * resolution / 256;           // 해당 줌 레벨에서의 높이 값을 계산합니다.

    height = height / 102;

    console.log(this.map.getView().getZoom() + ' / ' + height);
    return height;
}

/**
 *
 * @param {EPSG 4326 형태의 [x, y]} coordinates
 * @param {0~25} zoomLevel
 * @returns
 */
vwutil.prototype.setPanBy = function (coordinates, zoomLevel, callback) {
    let completeFunction = function() {
        try {
            callback();
        } catch(e) { }
    };

    if (this.map.type == '2D') {
        if (typeof zoomLevel == 'undefined') {
            zoomLevel = this.map.getView().getZoom();
        }

        if (typeof coordinates == 'undefined' || coordinates == null) {
            coordinates = this.map.getView().getCenter();
        } else {
            coordinates = ol.proj.transform(coordinates, "EPSG:4326", "EPSG:3857");
        }

        let view = this.map.getView();
        view.animate({
            center: coordinates,
            zoom:   zoomLevel
        }, completeFunction);
    } else {
        let height = ws3d.viewer.camera.positionCartographic.height;

        if (typeof zoomLevel != 'undefined') {
            height = closestHeight(zoomLevel);
        }

        if (typeof coordinates == 'undefined' || coordinates == null) {
            coordinates = [window.vworld.getMap().getCurrentPosition().position.x, window.vworld.getMap().getCurrentPosition().position.y];
        }

        ws3d.viewer.camera.flyTo({
            destination: Cesium.Cartesian3.fromDegrees(coordinates[0], coordinates[1], height),
            complete: completeFunction
        });
    }

    this.changeCoords(coordinates[0], coordinates[1], zoomLevel);

    return this.map;
}