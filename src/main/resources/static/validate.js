function validate() {
    // 파일 검증 for file1
    if ($(".file1").length > 0 && $(".file1")[0].files && $(".file1")[0].files[0] != undefined) {
        var maxSizeMb = 10;
        var maxSize = maxSizeMb * 1024 * 1024; // 10MB
        var fileSize = $(".file1")[0].files[0].size;
        if (fileSize > maxSize) {
            alert("파일은 " + maxSizeMb + "MB 이내로 등록 가능합니다.");
            $(".file1").val(""); // 파일1 입력 필드 초기화
            return false;
        }

        var ext = $(".file1").val().split(".").pop().toLowerCase();
        if ($.inArray(ext, ['jpg', 'jpeg', 'gif', 'png']) == -1) {
            ㄲ
            alert("파일은 이미지 파일만 등록 가능합니다.");
            $(".file1").val(""); // 파일1 입력 필드 초기화
            return false;
        }
    }

    // 파일 검증 for file2
    if ($(".file2").length > 0 && $(".file2")[0].files && $(".file2")[0].files[0] != undefined) {
        var maxSizeMb = 10;
        var maxSize = maxSizeMb * 1024 * 1024; // 10MB
        var fileSize = $(".file2")[0].files[0].size;
        if (fileSize > maxSize) {
            alert("파일은 " + maxSizeMb + "MB 이내로 등록 가능합니다.");
            $(".file2").val(""); // 파일2 입력 필드 초기화
            return false;
        }

        var ext = $(".file2").val().split(".").pop().toLowerCase();
        if ($.inArray(ext, ['jpg', 'jpeg', 'gif', 'png']) == -1) {
            alert("파일은 이미지 파일만 등록 가능합니다.");
            $(".file2").val(""); // 파일2 입력 필드 초기화
            return false;
        }
    }

    // 사용자 ID 검증 (최소 8자 이상)
    if ($('.user_id').length > 0 && $('.user_id').val().trim().length < 8) {
        alert($('.user_id').closest('tr').find('.required_th').text() + "은(는) 최소 8자 이상이어야 합니다.");
        $('.user_id').focus();
        return false;
    }

    // 비밀번호 검증 (영문자, 숫자, 특수문자 각각 최소 1자 포함)
    if ($('.password').length > 0) {
        var password = $('.password').val();
        var passwordPattern = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*_\-+=?])/;
        if (!passwordPattern.test(password)) {
            alert($('.password').closest('tr').find('.required_th').text() + "은(는) 영문자, 숫자, 특수문자를 각각 최소 1자 이상 포함해야 합니다.");
            $('.password').focus();
            return false;
        }

        // 비밀번호 확인 검증 추가
        var passwordConfirm = $('.password_confirm').val(); // 'usr_pwd_confm' 필드의 값을 가져옴
        if (password !== passwordConfirm) {
            alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            $('.password_confirm').focus(); // 'password_confirm' 클래스를 가진 필드에 포커스 이동
            return false;
        }


    }

    // 사용자명 검증 (10자 이내)
    if ($('.username').length > 0 && $('.username').val().trim().length > 10) {
        alert($('.username').closest('tr').find('.required_th').text() + "은(는) 10자 이내로 입력해주세요.");
        $('.username').focus();
        return false;
    }

    // 휴대폰 번호 검증 (010-1234-5678 형식)
    if ($('.phone').length > 0) {
        var phonePattern = /^010\d{4}\d{4}$/;
        if (!phonePattern.test($('.phone').val().trim())) {
            alert($('.phone').closest('tr').find('.required_th').text() + "은(는) 01012345678 형식으로 입력해주세요.");
            $('.phone').focus();
            return false;
        }
    }

    // 이메일 검증 (abc@nate.com 형식)
    if ($('.e_mail').length > 0) {
        var e_mailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        if (!e_mailPattern.test($('.e_mail').val().trim())) {
            alert($('.e_mail').closest('tr').find('.required_th').text() + "은(는) 올바른 이메일 형식이어야 합니다.");
            $('.e_mail').focus();
            return false;
        }
    }

    // 필수값 체크
    // $('.required').each(function() {
    //     if ($(this).val().trim() == '') {
    //         var thText = $(this).closest('tr').find('.required_th').text();  // 해당 <th>의 텍스트를 가져옴
    //         alert(thText + "은(는) 필수값입니다.");
    //         $(this).focus();  // 포커스를 현재 요소에 맞춤
    //         return false;  // 첫 번째 빈 필드에서 반복문을 멈춤
    //     }
    // });

    var isValid = true;
    // 필수값 체크
    $('.required').each(function () {
        var elementType = $(this).prop('tagName').toLowerCase();  // 요소의 태그 이름을 소문자로 가져옴
        var value = '';

        if (elementType === 'select') {
            value = $(this).find('option:selected').val();  // select 요소의 선택된 값 가져오기

            // "선택"이라는 텍스트가 선택된 상태를 빈 값으로 처리
            if (value === '선택') {
                value = '';
            }
        } else {
            value = $(this).val().trim();  // input 또는 다른 요소의 값 가져오기
        }

        if (value === '') {
            var thText = $(this).closest('tr').find('.required_th').text();  // 해당 <th>의 텍스트를 가져옴
            alert(thText + "은(는) 필수값입니다.");
            $(this).focus();  // 포커스를 현재 요소에 맞춤
            isValid = false;  // 검증 실패
            return false;  // each 반복문을 종료하고, validate 함수도 종료
        }
    });

    if (!isValid) {
        return false;  // 검증 실패 시 함수 종료
    }


    // 현장약어 검증 (영어로 3자)
    if ($('.site_abbreviation').length > 0) {
        var siteAbbreviation = $('.site_abbreviation').val().trim();
        var abbreviationPattern = /^[A-Za-z]{3}$/;
        if (!abbreviationPattern.test(siteAbbreviation)) {
            alert($('.site_abbreviation').closest('tr').find('.required_th').text() + "은(는) 3자 영어로 입력해주세요.");
            $('.site_abbreviation').focus();
            return false;
        }
    }

    // L, R, G 값 검증
    if ($('.logr_flag').length > 0 && $('.logr_idx').length > 0) {
        var flag = $('.logr_flag').val().trim();
        var logr_idxValue = $('.logr_idx').val().trim();

        if (flag === 'L') {
            // L 값 검증: 000부터 254 사이의 3자리 숫자
            var L = logr_idxValue;
            var lPattern = /^[0-2]\d{2}$/; // 000부터 299까지의 세 자리 숫자 (앞자리가 0, 1, 2 중 하나)
            if (!lPattern.test(L) || parseInt(L, 10) > 254) {
                alert($('.logr_flag').closest('tr').find('.required_th').text() + "에 해당하는 L 값은 000부터 254 사이의 3자리 숫자여야 합니다.");
                $('.logr_idx').focus();
                return false;
            }
        } else if (flag === 'R') {
            // R 값 검증: 255여야 함
            var R = logr_idxValue;
            if (R !== '255') {
                alert($('.logr_flag').closest('tr').find('.required_th').text() + "에 해당하는 R 값은 255여야 합니다.");
                $('.logr_idx').focus();
                return false;
            }
        } else if (flag === 'G') {
            // G 값 검증: 공백이어야 함
            if (logr_idxValue !== '') {
                alert($('.logr_flag').closest('tr').find('.required_th').text() + "에 해당하는 G 값은 공백이어야 합니다.");
                $('.logr_idx').focus();
                return false;
            }
        } else {
            alert("flag 값을 선택하세요.");
            $('.logr_flag').focus();
            return false;
        }
    }

    // 숫자 필드 검증 (숫자가 아닌 값이 입력된 경우)
    if ($('.number-only').length > 0) {
        $('.number-only').each(function () {
            var value = $(this).val().trim();
            var thText = $(this).closest('tr').find('.required_th').text();

            if (value !== '' && isNaN(value)) {  // 필수값이 아니더라도, 입력된 값이 숫자가 아니면 검증
                alert(thText + "은(는) 숫자만 입력 가능합니다.");
                $(this).focus();
                isValid = false;
                return false;  // 첫 번째 오류에서 반복을 중지
            }
        });

        if (!isValid) {
            return false;  // 숫자 검증 실패 시 함수 종료
        }
    }


    // 약어 검증 (3글자 영문자 형식)
    if ($('.abbr').length > 0) {
        var distAbbrPattern = /^[A-Za-z]{3}$/;
        if (!distAbbrPattern.test($('.abbr').val().trim())) {
            alert($('.dist_abbr').closest('tr').find('.required_th').text() + "은(는) 정확히 3글자의 영문자 형식이어야 합니다.");
            $('.dist_abbr').focus();
            return false;
        }
    }



    return true; // 모든 검증 통과 시 true 반환
}
