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
            background: -moz-linear-gradient(-45deg, rgba(43, 46, 108, 1) 0%, rgba(34, 36, 74, 1) 100%); /* FF3.6-15 */
            background: -webkit-linear-gradient(-45deg, rgba(43, 46, 108, 1) 0%, rgba(34, 36, 74, 1) 100%); /* Chrome10-25,Safari5.1-6 */
            background: linear-gradient(135deg, rgba(43, 46, 108, 1) 0%, rgba(34, 36, 74, 1) 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#2b2e6c', endColorstr='#22244a', GradientType=1); /* IE6-9 fallback on horizontal gradient */
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

            $('.login-form input[name=userPw]').on('keypress', function (e) {
                if (e.keyCode == '13') {
                    $('.loginBtn').click();
                }
            });

            $('.loginBtn').on('click', function () {
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
            } catch (e) {
            }

            // $('.main').show();
        });

        function validate_form() {
            if ($('#login_auto_login').is(':checked')) {
                const login = {
                    userId: $('form input[name=userId]').val(),
                    userPw: $('form input[name=userPw]').val()
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
    <div id="intro-area" style="display:flex; justify-content: center; flex-direction: column; align-items: center;">
        <div class="donutty"></div>
        <dl class="donut-ps">
            <dt style="max-width: 700px">${site_sys_nm}</dt>
            <dd>
                로딩중입니다.<br/>잠시만 기다려주세요.
            </dd>
        </dl>
    </div>
    <div id="login-area">
        <h2 style="max-width: 700px">
            <span data-font="Prompt">Hello,</span><br/>
            <strong>
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
                    </div>
                </div>
                <input type="submit" class="loginBtn" data-font="Prompt" value="Log in"/>
            </div>
        </form>
        <p class="logo-img" style="margin-top: 25px">
            <img src="data:image/jpeg;base64,${site_title_logo}" alt="" width="460" height="310"/>
        </p>
        <p class="login-arr"><img src="/images/icon_login_arr.png" alt=""/></p>
    </div>
</section>
</body>
</html>
