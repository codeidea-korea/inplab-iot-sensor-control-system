-- 공통코드 테이블
CREATE TABLE tb_common_code (
                                code_grp_id VARCHAR(6) DEFAULT '' NOT NULL,
                                code_grp_nm VARCHAR DEFAULT '' NOT NULL,
                                code_id VARCHAR(6) DEFAULT '' NOT NULL,
                                code_nm VARCHAR DEFAULT '' NOT NULL,
                                upper_codedgrp_id VARCHAR(6) DEFAULT '' NOT NULL,
                                upper_code_id VARCHAR(6) DEFAULT '' NOT NULL,
                                use_yn VARCHAR(1) DEFAULT 'Y' NOT null,
                                code_comment VARCHAR DEFAULT '' NOT NULL,
                                reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                mod_dt TIMESTAMP,
                                PRIMARY KEY (code_grp_id, code_id)
);

COMMENT ON TABLE tb_common_code IS '공통코드';
COMMENT ON COLUMN tb_common_code.code_grp_id IS '코드그룹_id';
COMMENT ON COLUMN tb_common_code.code_grp_nm IS '코드그룹명';
COMMENT ON COLUMN tb_common_code.code_id IS '코드_id';
COMMENT ON COLUMN tb_common_code.code_nm IS '코드명';
COMMENT ON COLUMN tb_common_code.upper_codedgrp_id IS '상위그룹코드_id';
COMMENT ON COLUMN tb_common_code.upper_code_id IS '상위코드_id';
COMMENT ON COLUMN tb_common_code.use_yn IS '사용여부';
COMMENT ON COLUMN tb_common_code.code_comment IS '코드코멘트';
COMMENT ON COLUMN tb_common_code.reg_dt IS '등록일시';
COMMENT ON COLUMN tb_common_code.mod_dt IS '수정일시';

-- 기관정보관리 테이블
CREATE TABLE tb_site_info (
                              site_no VARCHAR(3) DEFAULT '' NOT NULL,
                              site_nm VARCHAR DEFAULT '' NOT NULL,
                              site_zip VARCHAR DEFAULT '' NOT NULL,
                              site_addr VARCHAR DEFAULT '' NOT NULL,
                              site_road_addr VARCHAR DEFAULT '' NOT NULL,
                              site_logo BYTEA DEFAULT E'\\x' NOT NULL,
                              site_logo_nm VARCHAR DEFAULT '' NOT NULL,
                              site_sys_nm VARCHAR DEFAULT '' NOT NULL,
                              reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                              mod_dt TIMESTAMP,
                              PRIMARY KEY (site_no)
);

COMMENT ON TABLE tb_site_info IS '기관정보관리';
COMMENT ON COLUMN tb_site_info.site_no IS '사이트_no  S+01 (seq)  단일기관이므로 고정';
COMMENT ON COLUMN tb_site_info.site_nm IS '관리지자체명';
COMMENT ON COLUMN tb_site_info.site_zip IS '우편번호';
COMMENT ON COLUMN tb_site_info.site_addr IS '지번';
COMMENT ON COLUMN tb_site_info.site_road_addr IS '도로명주소  로그인화면. 메인창';
COMMENT ON COLUMN tb_site_info.site_logo IS '지자체로고  로그인화면. 메인창';
COMMENT ON COLUMN tb_site_info.site_logo_nm IS '지자체로고 이름';
COMMENT ON COLUMN tb_site_info.site_sys_nm IS '시스템명칭';
COMMENT ON COLUMN tb_site_info.reg_dt IS '등록일시';
COMMENT ON COLUMN tb_site_info.mod_dt IS '수정일시';

-- 현장정보관리 테이블
CREATE TABLE tb_district_info (
                                  district_no VARCHAR(3) DEFAULT '' NOT NULL,
                                  site_no VARCHAR(3) DEFAULT '' NOT NULL,
                                  district_nm VARCHAR DEFAULT '' NOT NULL,
                                  dist_zip varchar DEFAULT '' NOT NULL,
                                  dist_addr VARCHAR DEFAULT '' NOT NULL,
                                  dist_road_addr VARCHAR DEFAULT '' NOT NULL,
                                  dist_type_cd VARCHAR(6) DEFAULT '' NOT NULL,
                                  dist_abbr VARCHAR(3) DEFAULT '' NOT NULL,
                                  dist_pic BYTEA DEFAULT E'\\x',
                                  dist_view_pic BYTEA DEFAULT E'\\x',
                                  dist_lon FLOAT DEFAULT 0.0 NOT NULL,
                                  dist_lat FLOAT DEFAULT 0.0 NOT NULL,
                                  inst_comp_id1 VARCHAR(3) DEFAULT '' NOT NULL,
                                  meas_comp_id1 VARCHAR(3) DEFAULT '' NOT NULL,
                                  inst_comp_id2 VARCHAR(3) DEFAULT '',
                                  meas_comp_id2 VARCHAR(3) DEFAULT '',
                                  meas_str_ymd VARCHAR(8) DEFAULT '' NOT NULL,
                                  meas_end_ymd VARCHAR(8) DEFAULT '',
                                  dist_offi_nm VARCHAR DEFAULT '',
                                  reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP  NOT NULL,
                                  mod_dt TIMESTAMP,
                                  PRIMARY KEY (district_no),
                                  UNIQUE (district_nm),
                                  UNIQUE (dist_abbr)
);

COMMENT ON TABLE tb_district_info IS '현장정보관리  D+01 (seq) 사이트내에서 unique';
COMMENT ON COLUMN tb_district_info.district_no IS '현장_no  S+01 (seq) 단일기관이므로 고정';
COMMENT ON COLUMN tb_district_info.site_no IS '사이트_no';
COMMENT ON COLUMN tb_district_info.district_nm IS '현장명';
COMMENT ON COLUMN tb_district_info.dist_zip IS '현장주소_우편번호';
COMMENT ON COLUMN tb_district_info.dist_addr IS '현장주소_지번';
COMMENT ON COLUMN tb_district_info.dist_road_addr IS '현장주소_도로명';
COMMENT ON COLUMN tb_district_info.dist_type_cd IS '현장구분_cd  급경사지/절토사면/비탈사면(암)/비탈사면(암반)/비탈사면(혼합)';
COMMENT ON COLUMN tb_district_info.dist_abbr IS '현장약어  이니셜(3chars).  로거/CCTV/전광판/방송장비 명을 위한 약어 사이트내에서 unique';
COMMENT ON COLUMN tb_district_info.dist_pic IS '현장사진';
COMMENT ON COLUMN tb_district_info.dist_view_pic IS '전경도사진';
COMMENT ON COLUMN tb_district_info.dist_lon IS '경도  지도표출';
COMMENT ON COLUMN tb_district_info.dist_lat IS '위도  지도표출';
COMMENT ON COLUMN tb_district_info.inst_comp_id1 IS '시공사_id1  협력사T의 협력사id(partner_comp_id)';
COMMENT ON COLUMN tb_district_info.meas_comp_id1 IS '계측사_id1  협력사T의 협력사id';
COMMENT ON COLUMN tb_district_info.inst_comp_id2 IS '시공사_id2';
COMMENT ON COLUMN tb_district_info.meas_comp_id2 IS '계측사_id2';
COMMENT ON COLUMN tb_district_info.meas_str_ymd IS '계측시작일';
COMMENT ON COLUMN tb_district_info.meas_end_ymd IS '계측종료일';
COMMENT ON COLUMN tb_district_info.dist_offi_nm IS '관리사업소명';
COMMENT ON COLUMN tb_district_info.reg_dt IS '등록일시';
COMMENT ON COLUMN tb_district_info.mod_dt IS '수정일시';

-- 로거정보관리 테이블
CREATE TABLE tb_logger_info (
                                logr_no VARCHAR(3) DEFAULT '' NOT NULL,
                                district_no VARCHAR(3) DEFAULT '' NOT NULL,
                                logr_nm VARCHAR DEFAULT '' NOT NULL,
                                logr_MAC VARCHAR DEFAULT '' NOT NULL,
                                logr_ip VARCHAR DEFAULT '' NOT NULL,
                                logr_port VARCHAR DEFAULT '' NOT NULL,
                                logr_svr_ip VARCHAR DEFAULT '' NOT NULL,
                                logr_svr_port VARCHAR DEFAULT '' NOT NULL,
                                maint_sts_cd VARCHAR(6) DEFAULT 'MTN001' NOT NULL,
                                logr_lon FLOAT DEFAULT 0.0 NOT NULL,
                                logr_lat FLOAT DEFAULT 0.0 NOT NULL,
                                inst_ymd VARCHAR(8) DEFAULT '' NOT NULL,
                                logr_maker VARCHAR DEFAULT '',
                                model_nm VARCHAR DEFAULT '',
                                reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                mod_dt TIMESTAMP,
                                PRIMARY KEY (logr_no),
                                UNIQUE (logr_nm)
);

COMMENT ON TABLE tb_logger_info IS '로거정보관리';
COMMENT ON COLUMN tb_logger_info.logr_no IS '로거_no  L+01 (seq). GNSS의 경우 L+91부터 시작 사이트별로 unique. GNSS 수만큼 등록';
COMMENT ON COLUMN tb_logger_info.district_no IS '현장_no D+01 (seq)';
COMMENT ON COLUMN tb_logger_info.logr_nm IS '로거명 현장약어(3chars)+LOG + 01 GNSS는 현장약어+GNS+01';
COMMENT ON COLUMN tb_logger_info.logr_MAC IS '로거_MAC';
COMMENT ON COLUMN tb_logger_info.logr_ip IS '로거_ip';
COMMENT ON COLUMN tb_logger_info.logr_port IS '로거_port';
COMMENT ON COLUMN tb_logger_info.logr_svr_ip IS '서버_ip';
COMMENT ON COLUMN tb_logger_info.logr_svr_port IS '서버_port';
COMMENT ON COLUMN tb_logger_info.maint_sts_cd IS '유지보수상태_cd  0.정상/1.망실/2.점검/3망실(철거)';
COMMENT ON COLUMN tb_logger_info.logr_lon IS '경도';
COMMENT ON COLUMN tb_logger_info.logr_lat IS '위도';
COMMENT ON COLUMN tb_logger_info.inst_ymd IS '설치일자';
COMMENT ON COLUMN tb_logger_info.logr_maker IS '제조사명';
COMMENT ON COLUMN tb_logger_info.model_nm IS '모델명';
COMMENT ON COLUMN tb_logger_info.reg_dt IS '등록일시';
COMMENT ON COLUMN tb_logger_info.mod_dt IS '수정일시';

-- 센서타입관리 테이블
CREATE TABLE tb_sensor_type (
                                senstype_no VARCHAR DEFAULT '' NOT NULL,
                                site_no VARCHAR(3) DEFAULT '' NOT NULL,
                                sens_tp_nm VARCHAR DEFAULT '' NOT NULL,
                                sens_abbr VARCHAR DEFAULT '' NOT NULL,
                                basic_formul VARCHAR DEFAULT '' NOT NULL,
                                sens_chnl_cnt INT DEFAULT 0 NOT NULL,
                                logr_idx_str VARCHAR(3) DEFAULT '' NOT NULL,
                                logr_idx_end VARCHAR(3) DEFAULT '' NOT NULL,
                                reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                mod_dt TIMESTAMP,
                                PRIMARY KEY (senstype_no)
);

COMMENT ON TABLE tb_sensor_type IS '센서타입관리';
COMMENT ON COLUMN tb_sensor_type.senstype_no IS '센서종류_no  001 (seq) 사이트별로 unique. Legacy에서 000타입으로 관리';
COMMENT ON COLUMN tb_sensor_type.site_no IS '사이트_no  S+01 (seq) 동일기관의 모든 현장의 로거idx의 범위는 동일 (현장별로 다르지 않음)';
COMMENT ON COLUMN tb_sensor_type.sens_tp_nm IS '센서종류명  구조물경사계, 지표변위경사계, 지표변위계 ';
COMMENT ON COLUMN tb_sensor_type.sens_abbr IS '센서 약어  TM, TILT, TTW.. (지자체마다 다름). GNSS 지차제(RFP)에 따라 달라지므로 수정 가능해야함';
COMMENT ON COLUMN tb_sensor_type.basic_formul IS '기본 계산식  2. 센서종류 및 계산식.xlsx 참조. 수식은 소스에 반영';
COMMENT ON COLUMN tb_sensor_type.sens_chnl_cnt IS '채널 수';
COMMENT ON COLUMN tb_sensor_type.logr_idx_str IS '로거_Idx_S  000 site내에서는 unique';
COMMENT ON COLUMN tb_sensor_type.logr_idx_end IS '로거_Idx_E  000 GNSS는 L+91 (seq)';
COMMENT ON COLUMN tb_sensor_type.reg_dt IS '등록일시';
COMMENT ON COLUMN tb_sensor_type.mod_dt IS '수정일시';

-- 센서정보관리 테이블
CREATE TABLE tb_sensor_info (
                                sens_no VARCHAR(5) DEFAULT '' NOT NULL,
                                logr_no VARCHAR(3) DEFAULT '' NOT NULL,
                                senstype_no VARCHAR DEFAULT '' NOT NULL,
                                sens_nm VARCHAR DEFAULT '' NOT NULL,
                                inst_ymd VARCHAR(8) DEFAULT '',
                                sect_no INT DEFAULT 0 NOT NULL,
                                multi_sens_yn VARCHAR(1) DEFAULT 'N' NOT NULL,
                                disp_prior_yn VARCHAR(1) DEFAULT '',
                                multi_senstype_no VARCHAR(5) DEFAULT '',
                                multi_sens_no VARCHAR DEFAULT '',
                                nonrecv_limit_min INT DEFAULT 10 NOT NULL,
                                alarm_use_yn VARCHAR(1) DEFAULT 'Y' NOT NULL,
                                sms_snd_yn VARCHAR(1) DEFAULT 'Y' NOT NULL,
                                sens_disp_yn VARCHAR(1) DEFAULT 'Y' NOT NULL,
                                maint_sts_cd VARCHAR(6) DEFAULT 'MTN001' NOT NULL,
                                sens_lon FLOAT DEFAULT 0.0 NOT NULL,
                                sens_lat FLOAT DEFAULT 0.0 NOT null,
                                sesn_maker VARCHAR DEFAULT '',
                                model_nm VARCHAR DEFAULT '',
                                reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                mod_dt TIMESTAMP,
                                PRIMARY KEY (sens_no),
                                UNIQUE (logr_no, sens_nm)
);

COMMENT ON TABLE tb_sensor_info IS '센서정보관리';
COMMENT ON COLUMN tb_sensor_info.sens_no IS '센서_no  S+0001 (seq) site내에서는 unique';
COMMENT ON COLUMN tb_sensor_info.logr_no IS '로거_no  L+01 (seq) GNSS는 L+91 (seq)';
COMMENT ON COLUMN tb_sensor_info.senstype_no IS '센서종류_no';
COMMENT ON COLUMN tb_sensor_info.sens_nm IS '센서명  센서약어 + - + 01  (seq)';
COMMENT ON COLUMN tb_sensor_info.inst_ymd IS '설치일자';
COMMENT ON COLUMN tb_sensor_info.sect_no IS '단면번호';
COMMENT ON COLUMN tb_sensor_info.multi_sens_yn IS '복합센서여부  defalut = N, 복합센서인경우 화면에 표출시 지표변위계 우선 표출 (중첩처리)';
COMMENT ON COLUMN tb_sensor_info.disp_prior_yn IS '표출우선여부  복합센서여부 = N인 경우 null. 복합센서여부 = Y인 경우 센서ID가 지표변위계(TTW)인 경우 Y';
COMMENT ON COLUMN tb_sensor_info.multi_senstype_no IS '상대센서종류_no  복합센서여부 = N인 경우 null';
COMMENT ON COLUMN tb_sensor_info.multi_sens_no IS '상대센서_no  복합센서여부 = N인 경우 null';
COMMENT ON COLUMN tb_sensor_info.nonrecv_limit_min IS '미수신허용시간  시간 또는 미수신횟수(?)';
COMMENT ON COLUMN tb_sensor_info.alarm_use_yn IS '경보사용여부  (알람사용여부) 유지보수상태 "0"이 아닌경우 ';
COMMENT ON COLUMN tb_sensor_info.sms_snd_yn IS '문자발송대상여부';
COMMENT ON COLUMN tb_sensor_info.sens_disp_yn IS '화면표시대상여부';
COMMENT ON COLUMN tb_sensor_info.maint_sts_cd IS '유지보수상태_cd  0.정상/1.망실/2.점검/3망실(철거) 화면에서는 센서상태';
COMMENT ON COLUMN tb_sensor_info.sens_lon IS '경도';
COMMENT ON COLUMN tb_sensor_info.sens_lat IS '위도';
COMMENT ON COLUMN tb_sensor_info.sesn_maker IS '제조사명';
COMMENT ON COLUMN tb_sensor_info.model_nm IS '모델명';
COMMENT ON COLUMN tb_sensor_info.reg_dt IS '등록일시';
COMMENT ON COLUMN tb_sensor_info.mod_dt IS '수정일시';

-- 로거인덱스매핑 테이블
CREATE TABLE tb_logr_idx_map (
                                 mapping_no INT DEFAULT 0 NOT NULL,
                                 sens_no VARCHAR(5) DEFAULT '' NOT NULL,
                                 sens_chnl_id VARCHAR(1) DEFAULT '' NOT NULL,
                                 logr_no VARCHAR(3) DEFAULT '' NOT NULL,
                                 logr_idx_no VARCHAR(3) DEFAULT '' NOT NULL,
                                 sens_chnl_nm VARCHAR DEFAULT '' NOT NULL,
                                 logr_chnl_seq INT DEFAULT 0 NOT NULL,
                                 sect_no INT DEFAULT 0 NOT NULL,
                                 district_no VARCHAR(3) DEFAULT '' NOT NULL,
                                 reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                 mod_dt TIMESTAMP,
                                 PRIMARY KEY (mapping_no, sens_no),
                                 UNIQUE (sens_chnl_id, logr_no, logr_idx_no)
);

COMMENT ON TABLE tb_logr_idx_map IS '로거인덱스매핑';
COMMENT ON COLUMN tb_logr_idx_map.mapping_no IS '관리_no  seq';
COMMENT ON COLUMN tb_logr_idx_map.sens_no IS '센서_no  S+0001 (seq) 사이트에서 unique';
COMMENT ON COLUMN tb_logr_idx_map.sens_chnl_id IS '채널_id  X, Y ,Z (채널이 1개인경우 " " 공백 처리)';
COMMENT ON COLUMN tb_logr_idx_map.logr_no IS '로거_no  L+01 (seq). 1개의 로거에 최대 256개 채널연결 사이트에서 unique';
COMMENT ON COLUMN tb_logr_idx_map.logr_idx_no IS '로거_Idx  센서_id/채널_id를 로거_idx에 매핑.  (000~255 ) GNSS의 경우 센서명의 seq +채널_id';
COMMENT ON COLUMN tb_logr_idx_map.sens_chnl_nm IS '채널명  센서명+ - +채널_id';
COMMENT ON COLUMN tb_logr_idx_map.logr_chnl_seq IS '채널_seq  default = 0 으로 0(X), 1(Y), 2(Z)';
COMMENT ON COLUMN tb_logr_idx_map.sect_no IS '단면 번호';
COMMENT ON COLUMN tb_logr_idx_map.district_no IS '현장_no  로거no를 통해 현장을 추출가능';
COMMENT ON COLUMN tb_logr_idx_map.reg_dt IS '등록일시';
COMMENT ON COLUMN tb_logr_idx_map.mod_dt IS '수정일시';

-- 경보기준관리 테이블
CREATE TABLE tb_alarm_info (
                               sens_no VARCHAR(5) DEFAULT '' NOT NULL,
                               sens_chnl_id VARCHAR(1) DEFAULT '' NOT NULL,
                               sens_chnl_nm VARCHAR DEFAULT '' NOT NULL,
                               lvl_apply_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                               "1st_lvl_min" FLOAT DEFAULT 0.0 NOT NULL,
                               "1st_lvl_max" FLOAT DEFAULT 0.0 NOT NULL,
                               "1st_lvl_nm" VARCHAR DEFAULT '관심' NOT NULL,
                               "2nd_lvl_min" FLOAT DEFAULT 0.0 NOT NULL,
                               "2nd_lvl_max" FLOAT DEFAULT 0.0 NOT NULL,
                               "2nd_lvl_nm" VARCHAR DEFAULT '주의' NOT null,
                               "3rd_lvl_min" FLOAT DEFAULT 0.0 NOT NULL,
                               "3rd_lvl_max" FLOAT DEFAULT 0.0 NOT NULL,
                               "3rd_lvl_nm" VARCHAR DEFAULT '경계' NOT NULL,
                               "4th_lvl_min" FLOAT DEFAULT 0.0 NOT NULL,
                               "4th_lvl_max" FLOAT DEFAULT 0.0 NOT NULL,
                               "4th_lvl_nm" VARCHAR DEFAULT '심각' NOT NULL,
                               reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                               mod_dt TIMESTAMP,
                               PRIMARY KEY (sens_no, sens_chnl_id)
);

COMMENT ON TABLE tb_alarm_info IS '경보기준관리';
COMMENT ON COLUMN tb_alarm_info.sens_no IS '센서_no  S+0001 (seq) site내에서는 unique';
COMMENT ON COLUMN tb_alarm_info.sens_chnl_id IS '채널_id';
COMMENT ON COLUMN tb_alarm_info.sens_chnl_nm IS '채널명  센서명+ - +채널_id';
COMMENT ON COLUMN tb_alarm_info.lvl_apply_dt IS '적용일시';
COMMENT ON COLUMN tb_alarm_info."1st_lvl_min" IS '1차기준_min';
COMMENT ON COLUMN tb_alarm_info."1st_lvl_max" IS '1차기준_max  화면에서 알람상태는 1차초과시 : "관심", 2차 "주의", 3차 "경계", 4차 "심각"';
COMMENT ON COLUMN tb_alarm_info."1st_lvl_nm" IS '1차기준명';
COMMENT ON COLUMN tb_alarm_info."2nd_lvl_min" IS '2차기준_min';
COMMENT ON COLUMN tb_alarm_info."2nd_lvl_max" IS '2차기준_max';
COMMENT ON COLUMN tb_alarm_info."2nd_lvl_nm" IS '2차기준명';
COMMENT ON COLUMN tb_alarm_info."3rd_lvl_min" IS '3차기준_min';
COMMENT ON COLUMN tb_alarm_info."3rd_lvl_max" IS '3차기준_max';
COMMENT ON COLUMN tb_alarm_info."3rd_lvl_nm" IS '3차기준명';
COMMENT ON COLUMN tb_alarm_info."4th_lvl_min" IS '4차기준_min';
COMMENT ON COLUMN tb_alarm_info."4th_lvl_max" IS '4차기준_max';
COMMENT ON COLUMN tb_alarm_info."4th_lvl_nm" IS '4차기준명';
COMMENT ON COLUMN tb_alarm_info.reg_dt IS '등록일시  최초 적용일시와 동일';
COMMENT ON COLUMN tb_alarm_info.mod_dt IS '수정일시  적용일시와 동일';

-- 센서초기값관리 테이블
CREATE TABLE tb_sensor_init (
                                sens_no VARCHAR(5) DEFAULT '' NOT NULL,
                                sens_chnl_id VARCHAR(1) DEFAULT '' NOT NULL,
                                init_raw_data FLOAT DEFAULT 0.0 NOT NULL,
                                gauge_fac1 FLOAT DEFAULT 0.0,
                                gauge_fac2 FLOAT DEFAULT 0.0,
                                sens_offset FLOAT DEFAULT 0.0 NOT NULL,
                                formul_data FLOAT DEFAULT 0.0 NOT NULL,
                                init_apply_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                mod_dt TIMESTAMP,
                                PRIMARY KEY (sens_no, sens_chnl_id)
);

COMMENT ON TABLE tb_sensor_init IS '센서초기값관리';
COMMENT ON COLUMN tb_sensor_init.sens_no IS '센서_no  S+0001 (seq) site내에서는 unique';
COMMENT ON COLUMN tb_sensor_init.sens_chnl_id IS '채널_id  채널수에 따라 X,Y,Z. 채널수가 1인 경우는 공백';
COMMENT ON COLUMN tb_sensor_init.init_raw_data IS '초기 Raw데이터값';
COMMENT ON COLUMN tb_sensor_init.gauge_fac1 IS '게이지팩터1  GF1';
COMMENT ON COLUMN tb_sensor_init.gauge_fac2 IS '게이지팩터2  GF2';
COMMENT ON COLUMN tb_sensor_init.sens_offset IS '오프셋  offset';
COMMENT ON COLUMN tb_sensor_init.formul_data IS '보정데이터  센서타입T의 보정식을 적용한 결과값 보정된 데이터';
COMMENT ON COLUMN tb_sensor_init.init_apply_dt IS '초기값설정일시';
COMMENT ON COLUMN tb_sensor_init.reg_dt IS '등록일시';
COMMENT ON COLUMN tb_sensor_init.mod_dt IS '수정일시';

-- 센서측정데이터 테이블
CREATE TABLE tb_measure_details (
                                    mgnt_no INT DEFAULT 0 NOT NULL,
                                    sens_no VARCHAR(5) DEFAULT '' NOT NULL,
                                    sens_chnl_id VARCHAR(1) DEFAULT '' NOT NULL,
                                    meas_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                    raw_data FLOAT DEFAULT 0.0 NOT NULL,
                                    formul_data FLOAT DEFAULT 0.0 NOT NULL,
                                    net_err_yn VARCHAR(1) DEFAULT '' NOT NULL,
                                    net_err_cnt INT DEFAULT 0 NOT NULL,
                                    alarm_lvl_cd VARCHAR(6) DEFAULT 'ARM001' NOT NULL,
                                    reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                    PRIMARY KEY (mgnt_no),
                                    UNIQUE (sens_no, sens_chnl_id, meas_dt)
);

COMMENT ON TABLE tb_measure_details IS '센서측정데이터';
COMMENT ON COLUMN tb_measure_details.mgnt_no IS '관리_no  seq';
COMMENT ON COLUMN tb_measure_details.sens_no IS '센서_no  S+0001 (seq)';
COMMENT ON COLUMN tb_measure_details.sens_chnl_id IS '채널_id';
COMMENT ON COLUMN tb_measure_details.meas_dt IS '계측일시  YYYY/MM/DD HH:MM:SS';
COMMENT ON COLUMN tb_measure_details.raw_data IS 'Raw데이터';
COMMENT ON COLUMN tb_measure_details.formul_data IS '보정데이터  센서타입T의 보정식을 적용한 결과값 보정된 데이터';
COMMENT ON COLUMN tb_measure_details.net_err_yn IS '통신이상여부  "센서정보"T의  미수신기준"에 따라 통신이상 셋팅 Y : 통신이상.';
COMMENT ON COLUMN tb_measure_details.net_err_cnt IS '통신이상횟수  데이터 수집시 수신된 값이 연속해서 없는경우 증가 미수신 분단위 cnt';
COMMENT ON COLUMN tb_measure_details.alarm_lvl_cd IS '알람상태_cd  "경보기준관리"T의 초과한 level';
COMMENT ON COLUMN tb_measure_details.reg_dt IS '등록일시';

-- 알람발생이력 테이블
CREATE TABLE tb_alarm_details (
                                  mgnt_no INT DEFAULT 0 NOT NULL,
                                  sens_no VARCHAR(5) DEFAULT '' NOT NULL,
                                  sens_chnl_id VARCHAR(1) DEFAULT '' NOT NULL,
                                  meas_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                  raw_data FLOAT DEFAULT 0.0 NOT NULL,
                                  formul_data FLOAT DEFAULT 0.0 NOT NULL,
                                  alarm_lvl_cd VARCHAR(6) DEFAULT '' NOT NULL,
                                  maint_sts_cd VARCHAR(6) DEFAULT 'MTN001' NOT NULL,
                                  net_err_yn VARCHAR(1) DEFAULT '' NOT NULL,
                                  reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                  PRIMARY KEY (mgnt_no),
                                  UNIQUE (sens_no, sens_chnl_id, meas_dt)
);

COMMENT ON TABLE tb_alarm_details IS '알람발생이력';
COMMENT ON COLUMN tb_alarm_details.mgnt_no IS '관리_no  seq';
COMMENT ON COLUMN tb_alarm_details.sens_no IS '센서_no  S+0001 (seq)';
COMMENT ON COLUMN tb_alarm_details.sens_chnl_id IS '채널_id  센서명 + - + X';
COMMENT ON COLUMN tb_alarm_details.meas_dt IS '계측일시  화면항목명은 "발생일시"';
COMMENT ON COLUMN tb_alarm_details.raw_data IS 'Raw데이터';
COMMENT ON COLUMN tb_alarm_details.formul_data IS '보정데이터  센서타입T의 보정식을 적용한 결과값 보정된 데이터';
COMMENT ON COLUMN tb_alarm_details.alarm_lvl_cd IS '알람상태_cd  "경보기준관리"T의 초과한 level';
COMMENT ON COLUMN tb_alarm_details.maint_sts_cd IS '유지보수상태_cd  화면항목명은 "센서상태"';
COMMENT ON COLUMN tb_alarm_details.net_err_yn IS '통신이상여부  "센서정보"T의  미수신기준"에 따라 통신이상 셋팅 Y : 통신이상.';
COMMENT ON COLUMN tb_alarm_details.reg_dt IS '등록일시';

-- CCTV정보 테이블
CREATE TABLE tb_CCTV_info (
                              cctv_no VARCHAR(3) DEFAULT '' NOT NULL,
                              cctv_nm VARCHAR DEFAULT '' NOT NULL,
                              district_no VARCHAR(3) DEFAULT '' NOT NULL,
                              model_nm VARCHAR DEFAULT '',
                              cctv_maker VARCHAR DEFAULT '',
                              inst_ymd VARCHAR(8) DEFAULT '',
                              cctv_ip VARCHAR DEFAULT '' NOT NULL,
                              WEB_port VARCHAR DEFAULT '9000' NOT NULL,
                              RTSP_port VARCHAR DEFAULT '5540' NOT NULL,
                              cctv_conn_id VARCHAR DEFAULT '' NOT NULL,
                              cctv_conn_pwd VARCHAR DEFAULT '' NOT NULL,
                              relay_nm VARCHAR DEFAULT '' NOT NULL,
                              relay_ip VARCHAR DEFAULT '' NOT NULL,
                              relay_port VARCHAR DEFAULT '5119' NOT NULL,
                              maint_sts_cd VARCHAR(6) DEFAULT 'MTN001' NOT NULL,
                              cctv_lon FLOAT DEFAULT 0.0 NOT NULL,
                              cctv_lat FLOAT DEFAULT 0.0 NOT NULL,
                              admin_center varchar DEFAULT '' NOT NULL,
                              partner_comp_id varchar(3) DEFAULT '' NOT NULL,
                              partner_comp_user_nm varchar DEFAULT '' NOT NULL,
                              partner_comp_user_phone varchar DEFAULT '' NOT NULL,
                              reg_dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
                              mod_dt TIMESTAMP,
                              PRIMARY KEY (cctv_no),
                              UNIQUE (cctv_nm)
);

COMMENT ON TABLE tb_CCTV_info IS 'CCTV정보';
COMMENT ON COLUMN tb_CCTV_info.cctv_no IS 'CCTV_no  T+01 (seq) site내에서는 unique';
COMMENT ON COLUMN tb_CCTV_info.cctv_nm IS 'CCTV명  현장약어(3 chars) + CCTV + - + 01 (seq)';
COMMENT ON COLUMN tb_CCTV_info.district_no IS '현장_no  D+01 (seq)';
COMMENT ON COLUMN tb_CCTV_info.model_nm IS '모델명  selectbox';
COMMENT ON COLUMN tb_CCTV_info.cctv_maker IS '제조사명';
COMMENT ON COLUMN tb_CCTV_info.inst_ymd IS '설치일자';
COMMENT ON COLUMN tb_CCTV_info.cctv_ip IS 'CCTV_ip';
COMMENT ON COLUMN tb_CCTV_info.WEB_port IS 'WEB_port';
COMMENT ON COLUMN tb_CCTV_info.RTSP_port IS 'RTSP_port';
COMMENT ON COLUMN tb_CCTV_info.cctv_conn_id IS 'CCTV접속_id';
COMMENT ON COLUMN tb_CCTV_info.cctv_conn_pwd IS 'CCTV접속_pwd';
COMMENT ON COLUMN tb_CCTV_info.relay_nm IS '릴레이명';
COMMENT ON COLUMN tb_CCTV_info.relay_ip IS '릴레이_ip';
COMMENT ON COLUMN tb_CCTV_info.relay_port IS '릴레이_port';
COMMENT ON COLUMN tb_CCTV_info.maint_sts_cd IS '유지보수상태_cd  0.정상/1.망실/2.점검/3망실(철거)';
COMMENT ON COLUMN tb_CCTV_info.cctv_lon IS '경도';
COMMENT ON COLUMN tb_CCTV_info.cctv_lat IS '위도';
COMMENT ON COLUMN tb_CCTV_info.admin_center IS '관리사무소';
COMMENT ON COLUMN tb_CCTV_info.partner_comp_id IS '계측사';
COMMENT ON COLUMN tb_CCTV_info.partner_comp_user_nm IS '계측사담당자';
COMMENT ON COLUMN tb_CCTV_info.partner_comp_user_phone IS '계측사담당자연락처';
COMMENT ON COLUMN tb_CCTV_info.reg_dt IS '등록일시';
COMMENT ON COLUMN tb_CCTV_info.mod_dt IS '수정일시';











CREATE TABLE "tb_cctv_details" (
                                   mgnt_no int primary key not null,
                                   cctv_no varchar(3) not null,
                                   last_recv_dt timestamp not null,
                                   maint_sts_cd varchar(6) default 'MTN001' not null,
                                   UNIQUE (cctv_no, last_recv_dt)
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
                                        UNIQUE (brdcast_no, brdcast_dt)
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
                                     UNIQUE (dispbd_nm)
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
                                   UNIQUE (img_grp_nm, dispbd_evnt_flag)
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
                                   UNIQUE (img_grp_nm)
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
                                     UNIQUE (dispbd_no, sms_trans_dt)
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
                                    UNIQUE (sens_no)
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
                                  UNIQUE (alarm_mgnt_no, sms_trans_dt)
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
                                    district_no varchar(3) not null,
                                    emerg_chgr_nm varchar not null,
                                    emerg_recv_ph varchar not null,
                                    emerg_tel varchar default '',
                                    partner_comp_id varchar(3) not null,
                                    emerg_chgr_role varchar default '',
                                    e_mail varchar default '',
                                    reg_dt timestamp not null,
                                    mod_dt timestamp,
                                    UNIQUE (district_no, emerg_recv_ph)
);
COMMENT ON table "tb_emerg_contact" IS '비상연락망';
COMMENT ON COLUMN "tb_emerg_contact".mgnt_no IS '관리_no, seq';
COMMENT ON COLUMN "tb_emerg_contact".district_no IS '현장_id';
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
                                   sms_recv_dept varchar not null,
                                   sms_chgr_nm varchar not null,
                                   sms_recv_ph varchar not null,
                                   alarm_lvl_nm varchar not null,
                                   sms_autosnd_yn varchar(1) not null,
                                   reg_dt timestamp not null,
                                   mod_dt timestamp,
                                   UNIQUE (district_no, sms_recv_ph)
);
COMMENT ON table "tb_sms_receiver" IS 'sms수신처';
COMMENT ON COLUMN "tb_sms_receiver".mgnt_no IS '관리_no, seq, NA';
COMMENT ON COLUMN "tb_sms_receiver".district_no IS '현장_no';
COMMENT ON COLUMN "tb_sms_receiver".sms_recv_dept IS '소속기관';
COMMENT ON COLUMN "tb_sms_receiver".sms_chgr_nm IS '운영자이름';
COMMENT ON COLUMN "tb_sms_receiver".sms_recv_ph IS '휴대전화';
COMMENT ON COLUMN "tb_sms_receiver".alarm_lvl_nm IS '경보단계, 지정단계이상시 문자전송	';
COMMENT ON COLUMN "tb_sms_receiver".sms_autosnd_yn IS '자동전송여부, 알람발생시 자동전송대상 여부';
COMMENT ON COLUMN "tb_sms_receiver".reg_dt IS '등록일시';
COMMENT ON COLUMN "tb_sms_receiver".mod_dt IS '수정일시';


CREATE TABLE tb_login_log (
                              usr_id varchar DEFAULT '',
                              login_date timestamp NULL,
                              login_ip varchar DEFAULT '',
                              login_pc_name varchar DEFAULT '',
                              status varchar DEFAULT '',
                              login_log_id varchar NOT NULL DEFAULT '',
                              CONSTRAINT tb_login_log_pk PRIMARY KEY (login_log_id)
);

COMMENT ON COLUMN tb_login_log.usr_id IS '로그인 사용자 id';
COMMENT ON COLUMN tb_login_log.login_date IS '로그인 일시';
COMMENT ON COLUMN tb_login_log.login_ip IS '로그인 ip';
COMMENT ON COLUMN tb_login_log.login_pc_name IS '로그인 pc 이름';
COMMENT ON COLUMN tb_login_log.status IS '로그인 상태';
COMMENT ON COLUMN tb_login_log.login_log_id IS '로그 ID';