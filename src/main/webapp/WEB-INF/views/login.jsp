<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <jsp:include page="common/include_head.jsp" flush="true"></jsp:include>

        <style>
            #wrap.intro {
                width: 100vw;
                min-height: 100vh;
                padding: 5rem 0;
                display: flex;
                align-items: center;
                justify-content: center;
                background: rgb(43, 46, 108); /* Old browsers */
                background: -moz-linear-gradient(-45deg, rgba(43,46,108,1) 0%, rgba(34,36,74,1) 100%); /* FF3.6-15 */
                background: -webkit-linear-gradient(-45deg, rgba(43,46,108,1) 0%,rgba(34,36,74,1) 100%); /* Chrome10-25,Safari5.1-6 */
                background: linear-gradient(135deg, rgba(43,46,108,1) 0%,rgba(34,36,74,1) 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#2b2e6c', endColorstr='#22244a',GradientType=1); /* IE6-9 fallback on horizontal gradient */
            }
            #intro-area {
                position: relative;
            }
            #intro-area .donutty {
                width: 384px;
                height: 384px;
                box-shadow: 0 0 3rem rgba(0, 0, 0, 0.1);
                border-radius: 999px;
                overflow: hidden;
                opacity: 0.7;
                transform: scale(0.8);
            }
            #intro-area .donut-text {
                width: 100%;
                height: 100%;
                line-height: 0.75;
                color: #36383b;
                text-align: center;
                position: absolute;
                left: 0;
                top: 0;
                display: flex;
                flex-wrap: wrap;
                flex-direction: row;
                align-content: center;
                justify-content: center;
            }
            #intro-area .donut-text > strong {
                font-weight: 300;
                font-size: 154px;
                color: #fff;
                letter-spacing: -0.04em !important;
                display: inline-block;
                vertical-align: top;
            }
            #intro-area .donut-text > strong > span {
                font-size: 34px;
                line-height: 1;
                color: #c9cad7;
                display: inline-block;
                vertical-align: top;
            }

            #intro-area .donut-ps {
                width: 100%;
                margin-top: 55px;
                text-align: center;
            }
            #intro-area .donut-ps > dt {
                font-weight: 500;
                font-size: 34px;
                line-height: 1;
                color: rgba(255, 255, 255, 0.85);
            }
            #intro-area .donut-ps > dd {
                margin-top: 20px;
                font-size: 20px;
                line-height: 30px;
                color: rgba(255, 255, 255, 0.65);
            }
            .donut-fill {
                opacity: 1 !important;
            }

            #login-area {
                display: none;
            }
        </style>

        <script>
            $(function () {
                window.myChart = new Donutty(".donutty", {
                    min: 0,
                    max: 100,
                    value: 0,
                    round: true,
                    circle: true,
                    padding: 0,
                    radius: 50,
                    thickness: 7,
                    bg: "#edeeef",
                    color: "#16bbff",
                    transition: "all 0.1s linear",
                    dir: "rtl",
                    anchor: "top",

                    text: function (state) { // console.log(state.value / ( state.max - state.min ) * 100)
                        return "<strong>" + state.value + "<span>%</span></strong>";
                        // return the percentage of the donut
                    }
                });
                TweenMax.to(".donutty", 0.9, {
                    top: 0,
                    opacity: 1,
                    scale: 1,
                    ease: Back.easeOut,
                    onComplete: function () {
                        var cnt = 0,
                            set_intro;

                        function intro_cnt() {
                            cnt++;
                            if (cnt > 99) {
                                clearInterval(set_intro);
                                $('#intro-area').fadeOut(500, function () {
                                    $('#login-area').fadeIn();
                                });
                            }

                            myChart.set("value", cnt)
                        }

                        intro_cnt();

                        set_intro = setInterval(function () {
                            intro_cnt();
                        }, 10);
                    }
                });

                $('.login-form input[name=userId]').focus();

                // setTimeout(function(){
                //     $('.login-form input[name=userId]').focus();
                // },100);

                $('.login-form input[name=userPw]').on('keypress', function(e){
                    if(e.keyCode == '13') {
                        $('.loginBtn').click();
                    }
                });

                $('.loginBtn').on('click', function() {
                    $('form.p-t-40').submit();
                });

                try {
                    const autoLogin = JSON.parse(localStorage.getItem('autoLogin'));
                    const loginSucc = JSON.parse(localStorage.getItem('loginSuccess'));
                    if (autoLogin) {
                        if (loginSucc) {
                            const login = JSON.parse(localStorage.getItem('login'));
                            $('form input[name=userId]').val(login.userId);
                            $('form input[name=userPw]').val(login.userPw);
                            $('#login_auto_login').prop('checked', true);

                            $('form.p-t-40').submit();
                        }
                    }
                } catch(e) { }

                // $('.main').show();
            });

            function validate_form() {
                if ($('#login_auto_login').is(':checked')) {
                    const login = {
                        userId : $('form input[name=userId]').val(),
                        userPw : $('form input[name=userPw]').val()
                    };

                    localStorage.setItem('login', JSON.stringify(login));
                    localStorage.setItem('autoLogin', true);
                } else {
                    localStorage.setItem('autoLogin', false);
                }

                localStorage.setItem('loginRetry', 1);
                return true;
            }
        </script>
    </head>

    <body>
        <section id="wrap" class="intro login">
            <div id="intro-area">
                <div class="donutty"></div>
                <dl class="donut-ps">
<%--                    <dt>IoT센서 상시계측 관제시스템</dt>--%>
                    <dt>${site_sys_nm}</dt>
                    <dd>
                        로딩중입니다.<br/>잠시만 기다려주세요.
                    </dd>
                </dl>
            </div>
            <div id="login-area">
                <h2>
                    <span data-font="Prompt">Hello,</span><br/>
                    <strong>
<%--                        <span data-font="Prompt">IoT</span>--%>
<%--                            센서 상시계측 관제시스템--%>
                        ${site_sys_nm}
                        </strong>
                </h2>
                <form class="p-t-40" method="post" action="/login/process" onsubmit="return validate_form();">
                    <div class="login_in">
                        <div class="login-form">
                            <input type="text" name="userId" value="" required placeholder="아이디를 입력해주세요">
                            <input type="password" name="userPw" value="" required placeholder="비밀번호를 입력해주세요">
                        </div>
                        <div class="login-option">
                            <p class="check-box save_id">
                                <input type="checkbox" id="login_auto_login" name="auto_login"/>
                                <label for="login_auto_login">
                                    <span class="graphic"></span>로그인상태 유지</label>
                            </p>
                            <div>
                                <!-- <a href="javascript:popFancy('#lay-find-id');">아이디 찾기</a>
                                                                <a href="javascript:popFancy('#lay-find-pw');">비밀번호 찾기</a> -->
                            </div>
                        </div>

                        <input type="submit" class="loginBtn" data-font="Prompt" value="Log in"/>

                    <!-- <div class="login-join">
                                                아직 회원가입을 안하셨나요? <a href="javascript:popFancy('#lay-join');">회원가입하기 <img
                                                        src="/images/icon_join.png" alt="" /></a>
                                            </div> -->
                    </div>
                </form>
<%--                <p class="logo-img"><img src="/images/img_login.png" alt=""/></p>--%>
                <p class="logo-img"><img src="data:image/jpeg;base64,${site_logo}" alt="" /></p>


                <p class="login-arr"><img src="/images/icon_login_arr.png" alt=""/></p>
            </div>

            <!--[s] 아이디 찾기 팝업 -->
<%--            <div id="lay-find-id" class="layer-base layer-member">--%>
<%--                <div class="layer-base-btns">--%>
<%--                    <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>--%>
<%--                </div>--%>
<%--                <div class="layer-base-title">아이디 찾기</div>--%>
<%--                <div class="layer-base-conts">--%>
<%--                    <dl class="mem-title">--%>
<%--                        <dt>아이디 찾기</dt>--%>
<%--                        <dd>--%>
<%--                            등록된 이메일로 아이디 찾기--%>
<%--                            <p>(회원정보에 등록된 이메일을 정확히 입력하세요.)</p>--%>
<%--                        </dd>--%>
<%--                    </dl>--%>

<%--                    <div class="mem-form">--%>
<%--                        <dl>--%>
<%--                            <dt>이름</dt>--%>
<%--                            <dd><input type="text" name="" value="" id="" required placeholder="이름 입력"></dd>--%>
<%--                        </dl>--%>
<%--                        <dl>--%>
<%--                            <dt>이메일</dt>--%>
<%--                            <dd><input type="text" name="" value="" id="" required placeholder="이메일 입력"></dd>--%>
<%--                        </dl>--%>
<%--                    </div>--%>

<%--                    <div class="mem-btn">--%>
<%--                        <a href="javascript:void(0);">인증 번호 전송</a>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <!--[e] 아이디 찾기 팝업 -->--%>

<%--            <!--[s] 비밀번호 찾기 팝업 -->--%>
<%--            <div id="lay-find-pw" class="layer-base layer-member">--%>
<%--                <div class="layer-base-btns">--%>
<%--                    <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>--%>
<%--                </div>--%>
<%--                <div class="layer-base-title">비밀번호 찾기</div>--%>
<%--                <div class="layer-base-conts">--%>
<%--                    <dl class="mem-title">--%>
<%--                        <dt>비밀번호 찾기</dt>--%>
<%--                        <dd>새로 사용할 비밀번호를 입력해주세요</dd>--%>
<%--                    </dl>--%>

<%--                    <div class="mem-form">--%>
<%--                        <dl>--%>
<%--                            <dt>이름</dt>--%>
<%--                            <dd><input type="text" name="" value="" id="" required placeholder="이름 입력"></dd>--%>
<%--                        </dl>--%>
<%--                        <dl>--%>
<%--                            <dt>비밀번호</dt>--%>
<%--                            <dd><input type="password" name="" value="" id="" required placeholder="영문+숫자 8자리 이상">--%>
<%--                            </dd>--%>
<%--                        </dl>--%>
<%--                        <dl>--%>
<%--                            <dt>비밀번호 확인</dt>--%>
<%--                            <dd><input type="password" name="" value="" id="" required placeholder="비밀번호 다시 입력">--%>
<%--                            </dd>--%>
<%--                        </dl>--%>
<%--                    </div>--%>

<%--                    <div class="mem-btn">--%>
<%--                        <a href="javascript:void(0);">저장</a>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <!--[e] 아이디 찾기 팝업 -->--%>

<%--            <!--[s] 회원가입 팝업 -->--%>
<%--            <div id="lay-join" class="layer-base layer-member">--%>
<%--                <div class="layer-base-btns">--%>
<%--                    <a href="javascript:void(0);"><img src="/images/btn_lay_close.png" data-fancybox-close alt="닫기"></a>--%>
<%--                </div>--%>
<%--                <div class="layer-base-title">회원가입</div>--%>
<%--                <div class="layer-base-conts">--%>
<%--                    <dl class="mem-title">--%>
<%--                        <dt>회원가입</dt>--%>
<%--                        <dd>--%>
<%--                            회원가입을 위한 다음의 정보를 입력해 주세요--%>
<%--                            <p>(이용에 불편함이 없도록 정확한 정보를 입력해주세요)</p>--%>
<%--                        </dd>--%>
<%--                    </dl>--%>

<%--                    <div class="mem-form">--%>
<%--                        <dl>--%>
<%--                            <dt>ID</dt>--%>
<%--                            <dd><input type="text" name="" value="" id="" required placeholder="아이디 입력"></dd>--%>
<%--                        </dl>--%>
<%--                        <dl>--%>
<%--                            <dt>이름</dt>--%>
<%--                            <dd><input type="text" name="" value="" id="" required placeholder="본인 이름 입력"></dd>--%>
<%--                        </dl>--%>
<%--                        <dl>--%>
<%--                            <dt>PW</dt>--%>
<%--                            <dd><input type="password" name="" value="" id="" required placeholder="영문+숫자 8자리 이상">--%>
<%--                            </dd>--%>
<%--                        </dl>--%>
<%--                        <dl>--%>
<%--                            <dt>PW 확인</dt>--%>
<%--                            <dd><input type="password" name="" value="" id="" required placeholder="영문+숫자 8자리 이상">--%>
<%--                            </dd>--%>
<%--                        </dl>--%>
<%--                        <dl>--%>
<%--                            <dt>연락처</dt>--%>
<%--                            <dd><input type="text" name="" value="" id="" required placeholder="본인 연락처 입력"></dd>--%>
<%--                        </dl>--%>
<%--                        <dl>--%>
<%--                            <dt>이메일</dt>--%>
<%--                            <dd><input type="text" name="" value="" id="" required placeholder="인증 가능한 이메일 주소"></dd>--%>
<%--                        </dl>--%>
<%--                        <dl>--%>
<%--                            <dt>회사</dt>--%>
<%--                            <dd><input type="text" name="" value="" id="" required placeholder="입력"></dd>--%>
<%--                        </dl>--%>
<%--                        <dl>--%>
<%--                            <dt>소속</dt>--%>
<%--                            <dd><input type="text" name="" value="" id="" required placeholder="입력"></dd>--%>
<%--                        </dl>--%>
<%--                        <dl disabled>--%>
<%--                            <dt>권한</dt>--%>
<%--                            <dd><input type="text" name="" value="" id="" required placeholder="일반관제사" disabled>--%>
<%--                            </dd>--%>
<%--                        </dl>--%>
<%--                    </div>--%>

<%--                    <div class="mem-btn">--%>
<%--                        <a href="javascript:void(0);">가입하기</a>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <!--[s] 회원가입 팝업 -->--%>
<%--        </section>--%>

        <script type="text/javascript">
            $(function () {
            <%--function popFancy(name) { // 팝업 열기--%>
            <%--    new Fancybox([--%>
            <%--        {--%>
            <%--            src: name,--%>
            <%--            type: "inline"--%>
            <%--        },--%>
            <%--    ], {--%>
            <%--        on: {--%>
            <%--            "*": (event, fancybox, slide) => { // console.log(`event: ${event}`);--%>
            <%--            }--%>
            <%--        }--%>
            <%--    });--%>
            <%--}--%>
            <%--function popFancyClose() { // 팝업닫기--%>
            <%--    Fancybox.close();--%>
            });
        </script>
    </body>

</html>
