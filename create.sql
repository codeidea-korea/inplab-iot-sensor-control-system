
CREATE TABLE "tb_cctv_details" (
    mgnt_no int primary key not null,
    cctv_no varchar(3) not null,
    last_recv_dt timestamp not null,
    maint_sts_cd varchar(6) default 'MTN001' not null,
    CONSTRAINT UK1 UNIQUE (cctv_no, last_recv_dt)
);
COMMENT ON table "tb_cctv_details" IS 'cctv상태정보';
COMMENT ON COLUMN "tb_cctv_details".mgnt_no IS '관리_NO, seq';
COMMENT ON COLUMN "tb_cctv_details".cctv_no IS 'cctv_no, T+01, (seq), site내에서는 unique';
COMMENT ON COLUMN "tb_cctv_details".last_recv_dt IS '최종수신일시 YYYY/MM/DD HH:MM:SS';
COMMENT ON COLUMN "tb_cctv_details".maint_sts_cd IS '유지보수상태_cd MTN001';

CREATE TABLE "tb_broadcast_info" (
    brdcast_no varchar(3) primary key not null,
    brdcast_nm varchar not null,
    district_no varchar(3) not null,
    brdcast_svr_ip varchar not null,
    brdcast_svr_port varchar not null,
    brdcast_conn_id varchar not null,
    brdcast_conn_pwd varchar not null,
    inst_ymd varchar(8) default '',
    maint_sts_cd varchar(6)  default 'MTN001' not null,
    brdcast_lat float default 0 not null,
    brdcast_lon float default 0 not null,
    model_nm varchar default '',
    brdcast_maker varchar default '',
    reg_dt timestamp not null,
    mod_dt timestamp
);
COMMENT ON table "tb_broadcast_info" IS '방송장비정보';
COMMENT ON COLUMN "tb_broadcast_info".brdcast_no IS '방송장비_no, B + "01", seq, site내에서는 unique, NA';
COMMENT ON COLUMN "tb_broadcast_info".brdcast_nm IS '방송장비명';
COMMENT ON COLUMN "tb_broadcast_info".district_no IS '현장_no';
COMMENT ON COLUMN "tb_broadcast_info".brdcast_svr_ip IS '방송서버_ip';
COMMENT ON COLUMN "tb_broadcast_info".brdcast_svr_port IS '방송서버_port';
COMMENT ON COLUMN "tb_broadcast_info".brdcast_conn_id IS '서버접속_id';
COMMENT ON COLUMN "tb_broadcast_info".brdcast_conn_pwd IS '서버접속_pwd';
COMMENT ON COLUMN "tb_broadcast_info".inst_ymd IS '설치일자';
COMMENT ON COLUMN "tb_broadcast_info".maint_sts_cd IS '유지보수상태_cd, 0.정상/1.망실/2.점검/3망실(철거)';
COMMENT ON COLUMN "tb_broadcast_info".brdcast_lat IS '위도';
COMMENT ON COLUMN "tb_broadcast_info".brdcast_lon IS '경도, CCVT폴대, 자체적으로';
COMMENT ON COLUMN "tb_broadcast_info".model_nm IS '모델명';
COMMENT ON COLUMN "tb_broadcast_info".brdcast_maker IS '제조사명';
COMMENT ON COLUMN "tb_broadcast_info".reg_dt IS '등록일시';
COMMENT ON COLUMN "tb_broadcast_info".mod_dt IS '수정일시';

CREATE TABLE "tb_broadcast_details" (
    mgnt_no int primary key  not null,
    brdcast_no varchar(3) not null,
    brdcast_dt timestamp not null,
    brdcast_msg_dtls varchar not null,
    brdcast_rslt_yn varchar(1) not null,
    brdcast_contnts varchar default '',
    district_no varchar(3) not null,
    reg_dt timestamp not null,
    mod_dt timestamp,
    CONSTRAINT UK1 UNIQUE (brdcast_no, brdcast_dt)
);
COMMENT ON table "tb_broadcast_details" IS '동보전송이력';
COMMENT ON COLUMN "tb_broadcast_details".mgnt_no IS '관리_no, seq, NA';
COMMENT ON COLUMN "tb_broadcast_details".brdcast_no IS '방송장비_no, B + "01", seq, site내에서는 unique';
COMMENT ON COLUMN "tb_broadcast_details".brdcast_dt IS '방송일시, YYYY/MM/DD HH:MM:SS';
COMMENT ON COLUMN "tb_broadcast_details".brdcast_msg_dtls IS '전송문구';
COMMENT ON COLUMN "tb_broadcast_details".brdcast_rslt_yn IS '전송성공여부';
COMMENT ON COLUMN "tb_broadcast_details".brdcast_contnts IS '상세정보';
COMMENT ON COLUMN "tb_broadcast_details".district_no IS '현장_no';
COMMENT ON COLUMN "tb_broadcast_details".reg_dt IS '등록일시';
COMMENT ON COLUMN "tb_broadcast_details".mod_dt IS '수정일시';

CREATE TABLE "tb_dispboard_info" (
    dispbd_no varchar(3) primary key not null,
    dispbd_nm varchar not null,
    district_no varchar(3) not null,
    dispbd_ip varchar not null,
    dispbd_port varchar not null,
    dispbd_conn_id varchar not null,
    dispbd_conn_pwd varchar not null,
    inst_ymd varchar(8) default '',
    maint_sts_cd varchar(6) default 'MTN001' not null,
    dispbd_lon float not null,
    dispbd_lat float not null,
    dispbd_maker varchar default '',
    model_nm varchar default '',
    reg_dt timestamp not null,
    mod_dt timestamp,
    CONSTRAINT UK1 UNIQUE (dispbd_nm)
);
COMMENT ON table "tb_dispboard_info" IS '전광판정보';
COMMENT ON COLUMN "tb_dispboard_info".dispbd_no IS '전광판_no, P+"01", seq, site내에서는 unique';
COMMENT ON COLUMN "tb_dispboard_info".dispbd_nm IS '전광판명, 현장약어+"전광판"+"시점"';
COMMENT ON COLUMN "tb_dispboard_info".district_no IS '현장_no';
COMMENT ON COLUMN "tb_dispboard_info".dispbd_ip IS '전광판_ip';
COMMENT ON COLUMN "tb_dispboard_info".dispbd_port IS '전광판_port';
COMMENT ON COLUMN "tb_dispboard_info".dispbd_conn_id IS '접속_id';
COMMENT ON COLUMN "tb_dispboard_info".dispbd_conn_pwd IS '접속_pwd';
COMMENT ON COLUMN "tb_dispboard_info".inst_ymd IS '설치일자';
COMMENT ON COLUMN "tb_dispboard_info".maint_sts_cd IS '유지보수상태_cd, 0.정상/1.망실/2.점검/3망실(철거)';
COMMENT ON COLUMN "tb_dispboard_info".dispbd_lon IS '경도';
COMMENT ON COLUMN "tb_dispboard_info".dispbd_lat IS '위도';
COMMENT ON COLUMN "tb_dispboard_info".dispbd_maker IS '제조사명';
COMMENT ON COLUMN "tb_dispboard_info".model_nm IS '모델명';
COMMENT ON COLUMN "tb_dispboard_info".reg_dt IS '등록일시';
COMMENT ON COLUMN "tb_dispboard_info".mod_dt IS '수정일시';

CREATE TABLE "tb_dispbd_image" (
    mgnt_no int primary key not null,
    dispbd_imgfile_nm varchar not null,
    img_grp_nm varchar not null,
    dispbd_evnt_flag varchar(1) not null,
    img_effect_cd varchar(6) not null,
    img_disp_min int not null,
    img_file_path varchar not null,
    dispbd_autosnd_yn varchar(1) not null,
    use_yn varchar(1) default 'Y' not null,
    reg_dt timestamp not null,
    mod_dt timestamp,
    CONSTRAINT UK1 UNIQUE (img_grp_nm, dispbd_evnt_flag)
);
COMMENT ON table "tb_dispbd_image" IS '전광판이미지관리';
COMMENT ON COLUMN "tb_dispbd_image".mgnt_no IS '관리_no, seq, tb_send_group';
COMMENT ON COLUMN "tb_dispbd_image".dispbd_imgfile_nm IS '이미지파일명';
COMMENT ON COLUMN "tb_dispbd_image".img_grp_nm IS '전송그룹명, 1번그룹, 2번그룹, 3번그룹, 4번그룹, 5번그룹';
COMMENT ON COLUMN "tb_dispbd_image".dispbd_evnt_flag IS '이벤트구분, 0: 평시, 1:긴급, 2:이벤트';
COMMENT ON COLUMN "tb_dispbd_image".img_effect_cd IS '표시효과_cd';
COMMENT ON COLUMN "tb_dispbd_image".img_disp_min IS '표시시간';
COMMENT ON COLUMN "tb_dispbd_image".img_file_path IS '파일경로, 서버의 이미지저장 파일경로';
COMMENT ON COLUMN "tb_dispbd_image".dispbd_autosnd_yn IS '자동전송여부, dispbd_evnt_flag="2" 이면 "Y"';
COMMENT ON COLUMN "tb_dispbd_image".use_yn IS '사용여부';
COMMENT ON COLUMN "tb_dispbd_image".reg_dt IS '등록일시';
COMMENT ON COLUMN "tb_dispbd_image".mod_dt IS '수정일시';

CREATE TABLE "tb_dispbd_group" (
    mgnt_no int primary key not null,
    img_grp_nm varchar not null,
    img_grp_comment varchar default '',
    use_yn varchar(1) default 'Y' not null,
    reg_dt timestamp not null,
    mod_dt timestamp,
    CONSTRAINT UK1 UNIQUE (img_grp_nm)
);
COMMENT ON table "tb_dispbd_group" IS '전광판전송그룹관리';
COMMENT ON COLUMN "tb_dispbd_group".mgnt_no IS '관리_no, seq';
COMMENT ON COLUMN "tb_dispbd_group".img_grp_nm IS '전송그룹명';
COMMENT ON COLUMN "tb_dispbd_group".img_grp_comment IS '전송그룹설명';
COMMENT ON COLUMN "tb_dispbd_group".use_yn IS '사용여부';
COMMENT ON COLUMN "tb_dispbd_group".reg_dt IS '등록일시';
COMMENT ON COLUMN "tb_dispbd_group".mod_dt IS '수정일시';

CREATE TABLE "tb_dispbd_details" (
    mgnt_no int primary key not null,
    dispbd_no varchar(3) not null,
    sms_trans_dt timestamp not null,
    district_no varchar(3) not null,
    dispbd_evnt_flag varchar(1) not null,
    dispbd_autosnd_yn varchar(1) not null,
    dispbd_rslt_yn varchar(1) not null,
    reg_dt timestamp not null,
    CONSTRAINT UK1 UNIQUE (dispbd_no, sms_trans_dt)
);
COMMENT ON table "tb_dispbd_details" IS '전광판전송이력';
COMMENT ON COLUMN "tb_dispbd_details".mgnt_no IS '관리_no, seq';
COMMENT ON COLUMN "tb_dispbd_details".dispbd_no IS '전광판_no, P + "01", 화면표시 : 전광판 위치';
COMMENT ON COLUMN "tb_dispbd_details".sms_trans_dt IS '전송일시';
COMMENT ON COLUMN "tb_dispbd_details".district_no IS '현장_no, D+01';
COMMENT ON COLUMN "tb_dispbd_details".dispbd_evnt_flag IS '이벤트구분, 0: 평시, 1:긴급, 2:이벤트';
COMMENT ON COLUMN "tb_dispbd_details".dispbd_autosnd_yn IS '자동전송여부, dispbd_evnt_flag = 2 이면 Y';
COMMENT ON COLUMN "tb_dispbd_details".dispbd_rslt_yn IS '전송성공여부';
COMMENT ON COLUMN "tb_dispbd_details".reg_dt IS '등록일시';

CREATE TABLE "tb_maintcomp_info" (
    partner_comp_id varchar(3) primary key not null,
    partner_comp_nm varchar not null,
    partner_type_flag varchar(1) default 0 not null,
    partner_comp_addr varchar default '',
    comp_biz_no varchar default '',
    maint_rep_nm varchar not null,
    maint_rep_ph varchar not null,
    reg_dt timestamp not null,
    mod_dt timestamp
);
COMMENT ON table "tb_maintcomp_info" IS '유지보수업체정보';
COMMENT ON COLUMN "tb_maintcomp_info".partner_comp_id IS '협력사_id, C + 01, seq';
COMMENT ON COLUMN "tb_maintcomp_info".partner_comp_nm IS '협력사명';
COMMENT ON COLUMN "tb_maintcomp_info".partner_type_flag IS '협력사구분, 0.시공사/1.계측사';
COMMENT ON COLUMN "tb_maintcomp_info".partner_comp_addr IS '주소';
COMMENT ON COLUMN "tb_maintcomp_info".comp_biz_no IS '사업자번호';
COMMENT ON COLUMN "tb_maintcomp_info".maint_rep_nm IS '대표명';
COMMENT ON COLUMN "tb_maintcomp_info".maint_rep_ph IS '대표연락처';
COMMENT ON COLUMN "tb_maintcomp_info".reg_dt IS '등록일시';
COMMENT ON COLUMN "tb_maintcomp_info".mod_dt IS '수정일시';

CREATE TABLE "tb_maint_details" (
    mgnt_no int primary key not null,
    sens_no varchar(5) not null,
    district_no varchar(3) not null,
    maint_accpt_ymd varchar(8) not null,
    maint_str_ymd varchar(8) not null,
    maint_end_ymd varchar(8) not null,
    maint_dtls varchar default '',
    maint_comp_nm varchar not null,
    maint_chgr_nm varchar not null,
    maint_chgr_ph varchar not null,
    maint_rslt_cd varchar(6) not null,
    maint_pic_path varchar default '',
    reg_dt timestamp not null,
    mod_dt timestamp,
    CONSTRAINT UK1 UNIQUE (sens_no)
);
COMMENT ON table "tb_maint_details" IS '유지보수내역';
COMMENT ON COLUMN "tb_maint_details".mgnt_no IS '관리_no, seq';
COMMENT ON COLUMN "tb_maint_details".sens_no IS '센서_no, S+0001, seq';
COMMENT ON COLUMN "tb_maint_details".district_no IS '현장_no';
COMMENT ON COLUMN "tb_maint_details".district_no IS 'D+01, seq';
COMMENT ON COLUMN "tb_maint_details".maint_accpt_ymd IS '접수일';
COMMENT ON COLUMN "tb_maint_details".maint_str_ymd IS '작업시작일';
COMMENT ON COLUMN "tb_maint_details".maint_end_ymd IS '작업종료일';
COMMENT ON COLUMN "tb_maint_details".maint_dtls IS '작업내역';
COMMENT ON COLUMN "tb_maint_details".maint_comp_nm IS '업체명, 협력사T의 협력사id(partner_comp_id)';
COMMENT ON COLUMN "tb_maint_details".maint_chgr_nm IS '담당자명';
COMMENT ON COLUMN "tb_maint_details".maint_chgr_ph IS '연락처';
COMMENT ON COLUMN "tb_maint_details".maint_rslt_cd IS '작업결과cd, 유지보수상태cd';
COMMENT ON COLUMN "tb_maint_details".maint_pic_path IS '사진경로';
COMMENT ON COLUMN "tb_maint_details".reg_dt IS '등록일시';
COMMENT ON COLUMN "tb_maint_details".mod_dt IS '수정일시';

CREATE TABLE "tb_sms_details" (
    mgnt_no int primary key not null,
    alarm_mgnt_no int not null,
    sms_trans_dt timestamp not null,
    sms_subj varchar not null,
    sms_recv_ph varchar not null,
    sms_recv_chgr varchar not null,
    sms_recv_dept varchar,
    sms_msg_dtls varchar,
    district_nm varchar not null,
    dist_biz_office varchar,
    dist_addr varchar,
    inst_comp_nm varchar not null,
    inst_comp_chgr varchar not null,
    inst_comp_ph varchar not null,
    sms_trns_cnt int,
    alarm_lvl_nm varchar not null,
    sens_recv_rate float default 100 not null,
    accum_rain double precision default 0 not null,
    send_tp_nm varchar not null,
    inst_sens_cnt int not null,
    alarm_sens_cnt int not null,
    nonrecv_sens_cnt varchar not null,
    sens_nm varchar not null,
    DPS_chgr_nm varchar not null,
    DPS_chgr_ph varchar not null,
    mobil_link_url varchar,
    sms_rslt_yn varchar(1) not null,
    CONSTRAINT UK1 UNIQUE (alarm_mgnt_no, sms_trans_dt)
);
COMMENT ON table "tb_sms_details" IS 'sms전송이력';
COMMENT ON COLUMN "tb_sms_details".mgnt_no IS '관리_no, seq';
COMMENT ON COLUMN "tb_sms_details".alarm_mgnt_no IS '알람발생no, 알람발생이력T의 관리no';
COMMENT ON COLUMN "tb_sms_details".sms_trans_dt IS 'sms전송일시';
COMMENT ON COLUMN "tb_sms_details".sms_subj IS 'sms제목, 현장 이상경보 문자 메세지타이틀';
COMMENT ON COLUMN "tb_sms_details".sms_recv_ph IS '경보수신_전화번호';
COMMENT ON COLUMN "tb_sms_details".sms_recv_chgr IS '경보수신_담당자';
COMMENT ON COLUMN "tb_sms_details".sms_recv_dept IS '경보수신_부서, 지자체-관리사업소';
COMMENT ON COLUMN "tb_sms_details".sms_msg_dtls IS '전송정보, Iot상시계측 관제시스템 경보문자, sms발송시스템명';
COMMENT ON COLUMN "tb_sms_details".district_nm IS '현장명, 현장정보';
COMMENT ON COLUMN "tb_sms_details".dist_biz_office IS '현장관리사업소';
COMMENT ON COLUMN "tb_sms_details".dist_addr IS '현장주소';
COMMENT ON COLUMN "tb_sms_details".inst_comp_nm IS '시공업체_협력사명, 시공업체정보';
COMMENT ON COLUMN "tb_sms_details".inst_comp_chgr IS '시공업체_담당자명';
COMMENT ON COLUMN "tb_sms_details".inst_comp_ph IS '시공업체_연락처';
COMMENT ON COLUMN "tb_sms_details".sms_trns_cnt IS '회차수, 24시간내 전송된 회차';
COMMENT ON COLUMN "tb_sms_details".alarm_lvl_nm IS '경보요약_관리기준상태, 관심/주의/경계/심각, 경보요약';
COMMENT ON COLUMN "tb_sms_details".sens_recv_rate IS '경보요약_수신율 %';
COMMENT ON COLUMN "tb_sms_details".accum_rain IS '경보요약_누적강수량 mm';
COMMENT ON COLUMN "tb_sms_details".send_tp_nm IS '센서상태_센서종류명, 센서상태 통계';
COMMENT ON COLUMN "tb_sms_details".inst_sens_cnt IS '센서상태_설치수량';
COMMENT ON COLUMN "tb_sms_details".alarm_sens_cnt IS '센서상태_초과수량';
COMMENT ON COLUMN "tb_sms_details".nonrecv_sens_cnt IS '센서상태_미측정';
COMMENT ON COLUMN "tb_sms_details".sens_nm IS '센서명, 이상센서리스트';
COMMENT ON COLUMN "tb_sms_details".DPS_chgr_nm IS 'DPS담당자명, 시스템관련문의';
COMMENT ON COLUMN "tb_sms_details".DPS_chgr_ph IS 'DPS담당자연락처';
COMMENT ON COLUMN "tb_sms_details".mobil_link_url IS '모바일링크주소, 모바일링크';
COMMENT ON COLUMN "tb_sms_details".sms_rslt_yn IS '전송성공여부, 성공/실패(sms시스템 return 결과저장)';

CREATE TABLE "tb_user_info" (
    usr_id varchar primary key not null,
    usr_nm varchar not null,
    usr_pwd varchar not null,
    usr_pwd_confm varchar not null,
    use_yn varchar(1) default 'Y' not null,
    usr_ph varchar not null,
    e_mail varchar default '',
    usr_flag varchar(1) not null,
    usr_exp_ymd varchar(8) default '',
    reg_dt timestamp not null,
    mod_dt timestamp
);
COMMENT ON table "tb_user_info" IS 'sms전송이력';
COMMENT ON COLUMN "tb_user_info".usr_id IS '사용자_id, 초기설치시 관리자가 운영자 등록. 이후 운영자가 등록';
COMMENT ON COLUMN "tb_user_info".usr_nm IS '사용자명';
COMMENT ON COLUMN "tb_user_info".usr_pwd IS '비밀번호';
COMMENT ON COLUMN "tb_user_info".usr_pwd_confm IS '비밀번호 확인';
COMMENT ON COLUMN "tb_user_info".use_yn IS '사용여부';
COMMENT ON COLUMN "tb_user_info".usr_ph IS '휴대전화';
COMMENT ON COLUMN "tb_user_info".e_mail IS 'e-메일';
COMMENT ON COLUMN "tb_user_info".usr_flag IS '사용자구분, 0.관리자, 1:운영자';
COMMENT ON COLUMN "tb_user_info".usr_exp_ymd IS '사용만료일';
COMMENT ON COLUMN "tb_user_info".reg_dt IS '등록일시';
COMMENT ON COLUMN "tb_user_info".mod_dt IS '수정일시';

CREATE TABLE "tb_emerg_contact" (
    mgnt_no int primary key not null,
    district_id varchar(3) not null,
    emerg_chgr_nm varchar not null,
    emerg_recv_ph varchar not null,
    emerg_tel varchar default '',
    partner_comp_id varchar(3) not null,
    emerg_chgr_role varchar default '',
    e_mail varchar default '',
    reg_dt timestamp not null,
    mod_dt timestamp,
    CONSTRAINT UK1 UNIQUE (district_id, emerg_recv_ph)
);
COMMENT ON table "tb_emerg_contact" IS '비상연락망';
COMMENT ON COLUMN "tb_emerg_contact".mgnt_no IS '관리_no, seq';
COMMENT ON COLUMN "tb_emerg_contact".district_id IS '현장_id';
COMMENT ON COLUMN "tb_emerg_contact".emerg_chgr_nm IS '담당자명';
COMMENT ON COLUMN "tb_emerg_contact".emerg_recv_ph IS '휴대전화';
COMMENT ON COLUMN "tb_emerg_contact".emerg_tel IS '일반전화';
COMMENT ON COLUMN "tb_emerg_contact".partner_comp_id IS '협력사_id, 시공사/계측사';
COMMENT ON COLUMN "tb_emerg_contact".emerg_chgr_role IS '역할';
COMMENT ON COLUMN "tb_emerg_contact".e_mail IS 'e-메일';
COMMENT ON COLUMN "tb_emerg_contact".reg_dt IS '등록일시';
COMMENT ON COLUMN "tb_emerg_contact".mod_dt IS '수정일시';

CREATE TABLE "tb_sms_receiver" (
    mgnt_no int primary key not null,
    district_no varchar(3) not null,
    sms_recvr_dept varchar not null,
    sms_chgr_nm varchar not null,
    sms_recv_ph varchar not null,
    alarm_lvl_nm varchar not null,
    sms_autosnd_yn varchar(1) not null,
    reg_dt timestamp not null,
    mod_dt timestamp,
    CONSTRAINT UK1 UNIQUE (district_no, sms_recv_ph)
);
COMMENT ON table "tb_sms_receiver" IS 'sms수신처';
COMMENT ON COLUMN "tb_sms_receiver".mgnt_no IS '관리_no, seq, NA';
COMMENT ON COLUMN "tb_sms_receiver".district_no IS '현장_no';
COMMENT ON COLUMN "tb_sms_receiver".sms_recvr_dept IS '소속기관';
COMMENT ON COLUMN "tb_sms_receiver".sms_chgr_nm IS '운영자이름';
COMMENT ON COLUMN "tb_sms_receiver".sms_recv_ph IS '휴대전화';
COMMENT ON COLUMN "tb_sms_receiver".alarm_lvl_nm IS '경보단계, 지정단계이상시 문자전송	';
COMMENT ON COLUMN "tb_sms_receiver".sms_autosnd_yn IS '자동전송여부, 알람발생시 자동전송대상 여부';
COMMENT ON COLUMN "tb_sms_receiver".reg_dt IS '등록일시';
COMMENT ON COLUMN "tb_sms_receiver".mod_dt IS '수정일시';