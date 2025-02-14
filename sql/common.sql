INSERT INTO tb_common_code (code_grp_id,code_grp_nm,code_id,code_nm,upper_codedgrp_id,upper_code_id,use_yn,code_comment,reg_dt,mod_dt) VALUES
                                                                                                                                           ('MTN000','유지보수상태','MTN001','정상','RTCODE','MTN000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('MTN000','유지보수상태','MTN002','망실','RTCODE','MTN000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('MTN000','유지보수상태','MTN003','점검','RTCODE','MTN000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('MTN000','유지보수상태','MTN004','철거','RTCODE','MTN000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('ARM000','알람상태','ARM001','관심','RTCODE','ARM000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('ARM000','알람상태','ARM002','주의','RTCODE','ARM000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('ARM000','알람상태','ARM003','경계','RTCODE','ARM000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('ARM000','알람상태','ARM004','심각','RTCODE','ARM000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('DSP000','표시효과','DSP001','바로표시','RTCODE','DSP000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('DSP000','표시효과','DSP002','우에서 좌로 스크롤','RTCODE','DSP000','Y','','2024-08-14 13:56:23.905509',NULL);
INSERT INTO tb_common_code (code_grp_id,code_grp_nm,code_id,code_nm,upper_codedgrp_id,upper_code_id,use_yn,code_comment,reg_dt,mod_dt) VALUES
                                                                                                                                           ('DSP000','표시효과','DSP003','하에서 상으로 스크롤','RTCODE','DSP000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('DSP000','표시효과','DSP004','상에서 하로 스크롤','RTCODE','DSP000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('DSP000','표시효과','DSP005','레이저 효과','RTCODE','DSP000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('DSP000','표시효과','DSP006','중앙에서 상하로 스크롤','RTCODE','DSP000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('DSP000','표시효과','DSP007','상하에서 중앙으로 스크롤','RTCODE','DSP000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('DSP000','표시효과','DSP008','1단으로 좌측 스크롤','RTCODE','DSP000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('DTT000','현장구분','DTT001','급경사지','RTCODE','DTT000','Y','급경사지/절토사면/비탈사면(암)/비탈사면(암반)/비탈사면(혼합)','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('DTT000','현장구분','DTT002','절토사면','RTCODE','DTT000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('DTT000','현장구분','DTT003','비탈사면(암)','RTCODE','DTT000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('DTT000','현장구분','DTT004','비탈사면(암반)','RTCODE','DTT000','Y','','2024-08-14 13:56:23.905509',NULL);
INSERT INTO tb_common_code (code_grp_id,code_grp_nm,code_id,code_nm,upper_codedgrp_id,upper_code_id,use_yn,code_comment,reg_dt,mod_dt) VALUES
                                                                                                                                           ('DTT000','현장구분','DTT005','비탈사면(혼합)','RTCODE','DTT000','Y','','2024-08-14 13:56:23.905509',NULL),
                                                                                                                                           ('ROL000','회원구분','0','관리자','RTCODE','ROL000','Y','','2024-08-16 09:24:21.786639',NULL),
                                                                                                                                           ('ROL000','회원구분','1','일반','RTCODE','ROL000','Y','','2024-08-16 09:24:21.786639',NULL),
                                                                                                                                           ('PRT000','협력사구분','0','시공사','RTCODE','PRT000','Y','','2024-08-19 19:09:20.165107',NULL),
                                                                                                                                           ('PRT000','협력사구분','1','계측사','RTCODE','PRT000','Y','','2024-08-19 19:09:21.846611',NULL),
                                                                                                                                           ('LOG000','로거구분','L','LOGR','RTCODE','LOG000','Y','','2024-08-22 11:41:58.205814',NULL),
                                                                                                                                           ('LOG000','로거구분','G','GNSS','RTCODE','LOG000','Y','','2024-08-22 11:41:58.205814',NULL),
                                                                                                                                           ('LOG000','로거구분','R','RAIN','RTCODE','LOG000','Y','','2024-08-22 11:41:58.205814',NULL),
                                                                                                                                           ('YN0000','사용유무','Y','Y','RTCODE','YN0000','Y','','2024-08-22 15:35:49.177313',NULL),
                                                                                                                                           ('YN0000','사용유무','N','N','RTCODE','YN0000','Y','','2024-08-22 15:35:49.177313',NULL);



CREATE OR REPLACE FUNCTION district_nofn_common(code_id character varying, code_grp_nm character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE
value character varying;
BEGIN
SELECT code_nm INTO value
FROM tb_common_code a
WHERE a.code_grp_nm = $2
  AND a.code_id = $1;
RETURN value;
END; $function$
;


CREATE TABLE generation_key (
                                table_nm VARCHAR(100) NOT NULL DEFAULT '', -- table명
                                column_nm VARCHAR(100) NOT NULL DEFAULT '', -- column명
                                pre_code VARCHAR(30) NOT NULL DEFAULT '', -- 생성코드 시작문자
                                pre_type VARCHAR(30) NOT NULL DEFAULT '', -- 생성코드 타입
                                length INT DEFAULT 0 NOT NULL, -- pre_code 뒤에 붙는 숫자길이
                                max INT DEFAULT 0 NOT NULL, -- 현재 max값
                                PRIMARY KEY (table_nm, column_nm, pre_type)
);

COMMENT ON TABLE generation_key IS '키 생성';
COMMENT ON COLUMN generation_key.table_nm IS 'table명';
COMMENT ON COLUMN generation_key.column_nm IS 'column명';
COMMENT ON COLUMN generation_key.pre_code IS '생성코드 시작문자';
COMMENT ON COLUMN generation_key.pre_type IS '생성코드 타입';
COMMENT ON COLUMN generation_key.length IS 'pre_code 뒤에 붙는 숫자길이';
COMMENT ON COLUMN generation_key.max IS '현재 max값';

INSERT INTO generation_key(table_nm, column_nm, pre_code, pre_type, length, max) VALUES
                                                                                     ('tb_site_info', 'site_no', 'S', '', 2, 0),
                                                                                     ('tb_district_info', 'district_no', 'D', '', 2, 0),
                                                                                     ('tb_logger_info', 'logr_no', 'L', '', 2, 0),
                                                                                     ('tb_logger_info', 'logr_no', 'L', 'GNSS', 2, 90),
                                                                                     ('tb_sensor_type', 'senstype_no', '', '', 3, 0),
                                                                                     ('tb_sensor_info', 'sens_no', 'S', '', 4, 0),
                                                                                     ('tb_logr_idx_map', 'mapping_no', '', '', 1, 0),
                                                                                     ('tb_measure_details', 'mgnt_no', '', '', 1, 0),
                                                                                     ('tb_alarm_details', 'mgnt_no', '', '', 1, 0),
                                                                                     ('tb_CCTV_info', 'cctv_no', 'T', '', 2, 0),
                                                                                     ('tb_CCTV_details', 'mgnt_no', '', '', 1, 0),
                                                                                     ('tb_broadcast_info', 'brdcast_no', 'B', '', 2, 0),
                                                                                     ('tb_broadcast_details', 'mgnt_no', '', '', 1, 0),
                                                                                     ('tb_dispboard_info', 'dispbd_no', 'P', '', 2, 0),
                                                                                     ('tb_dispbd_image', 'mgnt_no', '', '', 1, 0),
                                                                                     ('tb_dispbd_group', 'mgnt_no', '', '', 1, 0),
                                                                                     ('tb_dispbd_details', 'mgnt_no', '', '', 1, 0),
                                                                                     ('tb_maintcomp_info', 'partner_comp_id', 'C', '', 2, 0),
                                                                                     ('tb_maint_details', 'mgnt_no', '', '', 1, 0),
                                                                                     ('tb_SMS_details', 'mgnt_no', '', '', 1, 0),
                                                                                     ('tb_emerg_contact', 'mgnt_no', '', '', 1, 0),
                                                                                     ('tb_SMS_receiver', 'mgnt_no', '', '', 1, 0)
;