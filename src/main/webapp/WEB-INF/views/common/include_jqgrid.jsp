<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<table class="jqGrid"></table>

<c:set var="path" value="${requestScope['javax.servlet.forward.servlet_path']}"/>

<script>
    const _columns = ${columns};

    $(function () {
        const $grid = $(".jqGrid");
        const _labels = [];
        const _names = [];
        const _widths = [];
        const _types = [];
        const columnData = {
            model: []
        };

        $.each(_columns, function () {
            _names.push(this.columnName);
            _labels.push(this.title);
            _widths.push(this.width);
            _types.push(this.type);
        });

        if (window.jqgridOption.columnAutoWidth) {
            window.jqgridOption.autowidth = true;
            window.jqgridOption.shrinkToFit = true;
        }

        $.each(_names, function (idx) {
            var column = {
                name: this,
                label: _labels[idx],
                width: _widths[idx],
                title: false,
                fixed: true
            };

            if (window.jqgridOption.columnAutoWidth) {
                delete column.width;
                delete column.fixed;
            }

            if (_types[idx].indexOf('range') > -1) {
                column.sorttype = 'date';
                column.formatter = 'date';
                column.formatoptions = {
                    srcformat: 'Y/m/d',
                    newformat: 'Y-m-d'
                };
                column.searchoptions = {
                    dataInit: function (element) {
                        setRangePicker($(element), function () {
                            reloadJqGrid($grid);
                        });
                    }
                }
            }
            if (_types[idx].indexOf('hidden') > -1) {
                column.hidden = true;
            }
            if (_types[idx].indexOf('editable') > -1) {
                column.editable = true;
            }
            columnData.model.push(column);
        });

        $.jgrid.defaults.width = $grid.parent().width();

        $(window).trigger('beforeLoadGrid', columnData);

        var jqGridOption = {
            url: `${path}/list`,
            datatype: "json",
            mtype: "GET",
            colModel: columnData.model,
            rowNum: 50,
            scroll: true, // 스크롤 페이징 활성화
            scrollrows: true, // 스크롤된 행에 포커스 유지
            height: "auto", // 높이를 자동으로 설정
            viewrecords: true, // 총 레코드 수 표시
            loadonce: false, // 서버에서 추가 로딩을 허용
            autowidth: true,
            shrinkToFit: true,
            emptyrecords: "조회된 데이터가 없습니다",
            jsonReader: {
                root: "rows",
                page: "page",
                total: "total",
                records: "records",
                repeatitems: false
            },
            loadComplete: function () {
                $(window).trigger('gridComplete');
            },
            gridComplete: function () {
                if (window.jqgridOption.columnAutoWidth) {
                    $(window).trigger('resize');
                }
            },
            beforeRequest: function () {
                let currentPage = $grid.getGridParam('page');
                let postData = $grid.jqGrid('getGridParam', 'postData');
                postData.page = currentPage; // 현재 페이지 유지
            },
            onSelectRow: function (rowId) {
                var rowData = {rowId, ...$grid.jqGrid('getRowData', rowId)};
                $(window).trigger('onSelectRow', rowData);
            }
        };

        $grid.jqGrid(jqGridOption);

        // 스크롤 이벤트 핸들러 수정
        $grid.on("scroll", function () {
            if (isFetching) return;  // 로딩 중일 경우 추가 요청 방지

            const scrollTop = this.scrollTop;
            const scrollHeight = this.scrollHeight;
            const clientHeight = this.clientHeight;

            if (scrollTop + clientHeight >= scrollHeight - 50) {  // 끝에 근접하면 로드 시도
                let currentPage = $grid.getGridParam('page');
                let lastPage = $grid.getGridParam('lastpage');

                if (currentPage < lastPage) {
                    isFetching = true;  // 로딩 시작 플래그 설정
                    $grid.jqGrid('setGridParam', {
                        page: currentPage + 1
                    }).trigger('reloadGrid');
                }
            }
        });

        // 로딩 완료 시 플래그 해제
        $grid.on('jqGridLoadComplete', function () {
            isFetching = false;  // 로딩 완료 후 플래그 해제
        });

        $grid.jqGrid(jqGridOption);

        let isFetching = false;  // 데이터 로드 중인지 체크하는 플래그

        $(document).on('keydown', '#search', function (e) {
            if (e.keyCode === 13) {  // Enter 키 감지
                if (isFetching) return;  // 로딩 중이면 새로운 요청 방지

                const searchValue = $('#search').val();  // 검색어 가져오기

                // 페이지 및 로딩 상태 초기화
                isFetching = true;
                $(".jqGrid").jqGrid('setGridParam', {
                    postData: {
                        searchKeyword: searchValue
                    },
                    page: 1,              // 첫 페이지로 이동
                    lastpage: 1,           // 마지막 페이지 초기화
                    datatype: "json"       // 서버로부터 새 데이터 요청
                }).trigger('reloadGrid');

                // 데이터 로딩 완료 후 플래그 해제
                $(".jqGrid").on('jqGridLoadComplete', function () {
                    isFetching = false;  // 로딩 완료 시 플래그 해제
                });
            }
        });

        $(document).on('click', '.searchBtn', function () {
            var searchValue = $('#search').val();  // 검색어 가져오기

            $(".jqGrid").jqGrid('setGridParam', {
                postData: {
                    searchKeyword: searchValue
                },
                page: 1,              // 검색 시 첫 페이지로 이동
                lastpage: 1,          // 마지막 페이지 초기화
                datatype: "json"      // 검색 시 서버에서 새로운 데이터 요청
            }).trigger('reloadGrid');  // 그리드 새로고침
        });

        $(window).trigger('afterLoadGrid', columnData);

        if (window.jqgridOption.columnAutoWidth) {
            $(window).resize(function () {
                const gridWidth = $(".contents-in").width();
                $grid.jqGrid('setGridWidth', gridWidth, true);

                const gridHeight = $(".contents-in").height() - 35;
                $grid.jqGrid('setGridHeight', gridHeight);
            });

            $(window).trigger('resize');
        }
    });


    function downloadExcel(fileName, $grid = $('.jqGrid')) {
        const gridData = $grid.getGridParam('postData');
        const urlParameters = Object.entries(gridData).map(e => e.join('=')).join('&');
        const url = "${path}/excel/" + fileName + '?' + urlParameters;
        const hiddenIFrameId = 'hiddenDownloader';
        let iframe = document.getElementById(hiddenIFrameId);
        if (iframe === null) {
            iframe = document.createElement('iframe');
            iframe.id = hiddenIFrameId;
            iframe.style.display = 'none';
            document.body.appendChild(iframe);
        }
        iframe.src = url;
    }
</script>

