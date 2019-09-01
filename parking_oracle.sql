-- SQLPLUS system/oracle;
-- CREATE USER parking IDENTIFIED by parking;
-- GRANT CONNECT, RESOURCE TO parking;
-- CONN parking/1234;

SELECT user_code, email, pw,phone, user_name, user_addr,
    TO_CHAR(created_date, 'yyyy-MM-dd hh24:mi:ss') AS created_date,
    TO_CHAR(login_date, 'yyyy-MM-dd hh24:mi:ss') AS login_date,
    sms_yn, email_yn, email_verified
FROM MEMBER;
--DELETE FROM MEMBER;

--update member set created_date=TO_DATE('2019/08/26 01:30:44', 'yyyy/mm/dd hh24:mi:ss') where user_code='482581';

SELECT * FROM MEMBER;
SELECT * FROM USERHISTORY;
--SELECT * FROM CAR;
--SELECT * FROM PAYMENTHISTORY;
--SELECT * FROM REVIEW;
--SELECT * FROM QNABOARD;
--SELECT * FROM NOTICE;
--SELECT * FROM BOOKMARK;
--SELECT * FROM COUPON;


-- TABLE
DROP TABLE MEMBER CASCADE CONSTRAINTS;
DROP TABLE USERHISTORY CASCADE CONSTRAINTS;
DROP TABLE CAR CASCADE CONSTRAINTS;
DROP TABLE PAYMENTHISTORY CASCADE CONSTRAINTS;
DROP TABLE REVIEW CASCADE CONSTRAINTS;
DROP TABLE QNABOARD CASCADE CONSTRAINTS;
DROP TABLE NOTICE CASCADE CONSTRAINTS;
DROP TABLE BOOKMARK CASCADE CONSTRAINTS;
DROP TABLE COUPON CASCADE CONSTRAINTS;

DROP SEQUENCE USERHISTORY_SEQ;
DROP SEQUENCE PAYMENTHISTORY_SEQ;
DROP SEQUENCE REVIEW_SEQ;
DROP SEQUENCE QNABOARD_SEQ;
DROP SEQUENCE NOTICE_SEQ;
DROP SEQUENCE BOOKMARK_SEQ;

SELECT * FROM user_constraints WHERE table_name IN
    ('MEMBER', 'USERHISTORY', 'CAR', 'PAYMENTHISTORY', 'REVIEW', 'QNABOARD', 'NOTICE', 'BOOKMARK', 'COUPON');

CREATE TABLE MEMBER (
    user_code CHAR(6) NOT NULL,
    email VARCHAR2(50) NOT NULL,
    pw VARCHAR2(300) NOT NULL,
    phone VARCHAR2(20) NOT NULL,
    user_name VARCHAR2(50) NOT NULL,
    user_addr VARCHAR2(300) NOT NULL,
    created_date DATE DEFAULT SYSDATE,
    login_date DATE,
    sms_yn NUMBER(1,0) NOT NULL,
    email_yn NUMBER(1,0) NOT NULL,
    email_verified NUMBER(1,0) DEFAULT 0
);

COMMENT ON COLUMN MEMBER.user_code IS '회원코드';
COMMENT ON COLUMN MEMBER.email IS '이메일';
COMMENT ON COLUMN MEMBER.pw IS '비밀번호';
COMMENT ON COLUMN MEMBER.phone IS '폰번호';
COMMENT ON COLUMN MEMBER.user_name IS '회원이름';
COMMENT ON COLUMN MEMBER.user_addr IS '회원주소';
COMMENT ON COLUMN MEMBER.created_date IS '가입날짜';
COMMENT ON COLUMN MEMBER.login_date IS '최근 로그인날짜';
COMMENT ON COLUMN MEMBER.sms_yn IS '문자 수신여부(1/0)';
COMMENT ON COLUMN MEMBER.email_yn IS '이메일 수신여부(1/0)';
COMMENT ON COLUMN MEMBER.email_verified IS '이메일 인증여부(1/0)';

ALTER TABLE MEMBER 
    ADD CONSTRAINT pk_user PRIMARY KEY(user_code);
ALTER TABLE MEMBER 
    ADD CONSTRAINT uq_user UNIQUE (email);
ALTER TABLE MEMBER 
    ADD CONSTRAINT chk_user_sms CHECK (sms_yn in (1,0));
ALTER TABLE MEMBER 
    ADD CONSTRAINT chk_user_email CHECK (email_yn in (1,0));
ALTER TABLE MEMBER 
    ADD CONSTRAINT chk_user_verified CHECK (email_verified in (1,0));

CREATE TABLE USERHISTORY(
    idx NUMBER(5) NOT NULL,
    user_code CHAR(6) NOT NULL,
    latitude NUMBER(10,8) NOT NULL,
    longitude NUMBER(11,8) NOT NULL,
    parkinglot_name VARCHAR2(50) NOT NULL,
    parkinglot_addr VARCHAR2(200) NOT NULL,
    parking_date DATE DEFAULT SYSDATE
);
COMMENT ON COLUMN USERHISTORY.idx IS '이용내역 코드번호';
COMMENT ON COLUMN USERHISTORY.user_code IS '회원코드';
COMMENT ON COLUMN USERHISTORY.latitude IS '위도(0~90)';
COMMENT ON COLUMN USERHISTORY.longitude IS '경도(0~180)';
COMMENT ON COLUMN USERHISTORY.parkinglot_name IS '주차장이름';
COMMENT ON COLUMN USERHISTORY.parkinglot_addr IS '주차장주소';
COMMENT ON COLUMN USERHISTORY.parking_date IS '주차날짜';

CREATE SEQUENCE USERHISTORY_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER USERHISTORY_TRG
BEFORE INSERT ON USERHISTORY
FOR EACH ROW
BEGIN
  SELECT USERHISTORY_SEQ.NEXTVAL
  INTO :NEW.IDX
  FROM DUAL;
END;
/


ALTER TABLE USERHISTORY
    ADD CONSTRAINT pk_userhistory PRIMARY KEY(idx);
ALTER TABLE USERHISTORY
    ADD CONSTRAINT fk_userhistory_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;


CREATE TABLE CAR(
    user_code CHAR(6) NOT NULL,
    capcity NUMBER(2) DEFAULT 0,
    car_type VARCHAR2(50),
    model VARCHAR2(50)
);
COMMENT ON COLUMN CAR.user_code IS '회원코드';
COMMENT ON COLUMN CAR.capcity IS '차량 인승';
COMMENT ON COLUMN CAR.car_type IS '차량종류';
COMMENT ON COLUMN CAR.model IS '차량모델명';

ALTER TABLE CAR
    ADD CONSTRAINT fk_car_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;


CREATE TABLE PAYMENTHISTORY(
    idx NUMBER(5) NOT NULL,
    purchase_amount NUMBER(7) DEFAULT 0,
    instt_name VARCHAR2(100),
    instt_phone VARCHAR2(20),
    payment_date DATE DEFAULT SYSDATE
);
COMMENT ON COLUMN PAYMENTHISTORY.idx IS '결제내역번호';
COMMENT ON COLUMN PAYMENTHISTORY.purchase_amount IS '주차요금 결제액';
COMMENT ON COLUMN PAYMENTHISTORY.instt_name IS '관리기관명';
COMMENT ON COLUMN PAYMENTHISTORY.instt_phone IS '관리기관 연락처';
COMMENT ON COLUMN PAYMENTHISTORY.payment_date IS '주차요금 결제일';

CREATE SEQUENCE PAYMENTHISTORY_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER PAYMENTHISTORY_TRG
BEFORE INSERT ON PAYMENTHISTORY
FOR EACH ROW
BEGIN
  SELECT PAYMENTHISTORY_SEQ.NEXTVAL
  INTO :NEW.IDX
  FROM DUAL;
END;
/

-- ALTER TABLE PAYMENTHISTORY
--     ADD CONSTRAINT pk_paymenthistory PRIMARY KEY(idx);
ALTER TABLE PAYMENTHISTORY
    ADD CONSTRAINT fk_paymenthistory_userhistory FOREIGN KEY(idx) REFERENCES userhistory(idx)
    ON DELETE CASCADE;


CREATE TABLE REVIEW(
	idx NUMBER(5) NOT NULL,
    review_title VARCHAR2(50) NOT NULL,
    review_content VARCHAR2(300) NOT NULL,
    created_date DATETIME DEFAULT SYSDATE,
    rating NUMBER(1) NOT NULL
);
COMMENT ON COLUMN REVIEW.idx IS '코드번호';
COMMENT ON COLUMN REVIEW.review_title IS '리뷰 제목';
COMMENT ON COLUMN REVIEW.review_content IS '리뷰 작성글';
COMMENT ON COLUMN REVIEW.created_date IS '작성날짜';
COMMENT ON COLUMN REVIEW.rating IS '평점(1~5 정수)';

CREATE SEQUENCE REVIEW_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER REVIEW_TRG
BEFORE INSERT ON REVIEW
FOR EACH ROW
BEGIN
  SELECT REVIEW_SEQ.NEXTVAL
  INTO :NEW.IDX
  FROM DUAL;
END;
/

ALTER TABLE REVIEW
    ADD CONSTRAINT fk_review_userhistory FOREIGN KEY(idx) REFERENCES userhistory(idx)
    ON DELETE CASCADE;
ALTER TABLE REVIEW
    ADD CONSTRAINT chk_review_rating CHECK (rating in (1,2,3,4,5));

--DROP TABLE QNABOARD;
--DROP TRIGGER QNABOARD_TRG;
--DROP SEQUENCE QNABOARD_SEQ;
select * from qnaboard;
select count(*) from qnaboard;
insert into qnaboard values(DEFAULT,'a_title', '822353', 'this is a content1', null,null, default, default);
insert into qnaboard values(DEFAULT,'b_title', '822353', 'this is a content2', null,null, default, default);
insert into qnaboard values(DEFAULT,'c_title', '822353', 'this is a content3', null,null, default, default);
insert into qnaboard values(DEFAULT,'d_title', '822353', 'this is a content4', null,null, default, default);
insert into qnaboard values(DEFAULT,'e_title', '822353', 'this is a content5', null,null, default, default);
insert into qnaboard values(DEFAULT,'f_title', '822353', 'this is a content6', null,null, default, default);
insert into qnaboard values(DEFAULT,'g_title', '822353', 'this is a content7', null,null, default, default);
insert into qnaboard values(DEFAULT,'h_title', '822353', 'this is a content8', null,null, default, default);
insert into qnaboard values(DEFAULT,'i_title', '822353', 'this is a content9', null,null, default, default);
insert into qnaboard values(DEFAULT,'j_title', '822353', 'this is a content10', null,null, default, default);
insert into qnaboard values(DEFAULT,'k_title', '822353', 'this is a content11', null,null, default, default);
insert into qnaboard values(DEFAULT,'l_title', '822353', 'this is a content12', null,null, default, default);
insert into qnaboard values(DEFAULT,'m_title', '822353', 'this is a content13', null,null, default, default);
insert into qnaboard values(DEFAULT,'n_title', '822353', 'this is a content14', null,null, default, default);
insert into qnaboard values(DEFAULT,'o_title', '360906', 'this is a content15', null,null, default, default);
insert into qnaboard values(DEFAULT,'p_title', '360906', 'this is a content16', null,null, default, default);
insert into qnaboard values(DEFAULT,'q_title', '360906', 'this is a content17', null,null, default, default);
insert into qnaboard values(DEFAULT,'r_title', '360906', 'this is a content18', null,null, default, default);
insert into qnaboard values(DEFAULT,'s_title', '360906', 'this is a content19', null,null, default, default);
insert into qnaboard values(DEFAULT,'t_title', '360906', 'this is a content20', null,null, default, default);
insert into qnaboard values(DEFAULT,'u_title', '360906', 'this is a content21', null,null, default, default);
insert into qnaboard values(DEFAULT,'v_title', '360906', 'this is a content22', null,null, default, default);
insert into qnaboard values(DEFAULT,'w_title', '360906', 'this is a content23', null,null, default, default);
insert into qnaboard values(DEFAULT,'x_title', '360906', 'this is a content24', null,null, default, default);
insert into qnaboard values(DEFAULT,'y_title', '360906', 'this is a content25', null,null, default, default);
insert into qnaboard values(DEFAULT,'z_title', '360906', 'this is a content26', null,null, default, default);
insert into qnaboard values(DEFAULT,'zzz_title', '360906', 'this is a content27', null,null, default, default);
commit;


CREATE TABLE QNABOARD(
    qna_no NUMBER(5) NOT NULL,
    qna_title VARCHAR2(50) NOT NULL,
    user_code CHAR(6) NOT NULL,
    qna_content VARCHAR2(300) NOT NULL,
    qna_original_filename VARCHAR2(100),
    qna_renamed_filename VARCHAR2(100),
    qna_created_date DATE DEFAULT SYSDATE,
    qna_readcount NUMBER DEFAULT 0
);
COMMENT ON COLUMN QNABOARD.qna_no IS '문의글번호';
COMMENT ON COLUMN QNABOARD.qna_title IS '문의글 제목';
COMMENT ON COLUMN QNABOARD.user_code IS '회원코드';
COMMENT ON COLUMN QNABOARD.qna_content IS '문의글 내용';
COMMENT ON COLUMN QNABOARD.qna_original_filename IS '첨부파일원래이름';
COMMENT ON COLUMN QNABOARD.qna_renamed_filename IS '첨부파일변경이름';
COMMENT ON COLUMN QNABOARD.qna_created_date IS '작성날짜';
COMMENT ON COLUMN QNABOARD.qna_readcount IS '조회수';

CREATE SEQUENCE QNABOARD_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER QNABOARD_TRG
BEFORE INSERT ON QNABOARD
FOR EACH ROW
BEGIN
  SELECT QNABOARD_SEQ.NEXTVAL
  INTO :NEW.qna_no
  FROM DUAL;
END;
/

ALTER TABLE QNABOARD
    ADD CONSTRAINT pk_qnaboard PRIMARY KEY(qna_no);
ALTER TABLE QNABOARD
    ADD CONSTRAINT fk_qnaboard_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;


CREATE TABLE NOTICE(
    idx NUMBER(5) NOT NULL,
    user_code CHAR(6) NOT NULL,
    notice_title VARCHAR2(50) NOT NULL,
    notice_content VARCHAR2(300) NOT NULL,
    created_date DATE DEFAULT SYSDATE,
    view_count NUMBER(7)
);
COMMENT ON COLUMN NOTICE.idx IS '공지사항글번호';
COMMENT ON COLUMN NOTICE.user_code IS '회원코드';
COMMENT ON COLUMN NOTICE.notice_title IS '공지사항 제목';
COMMENT ON COLUMN NOTICE.notice_content IS '공지사항 내용';
COMMENT ON COLUMN NOTICE.created_date IS '작성날짜';
COMMENT ON COLUMN NOTICE.view_count IS '조회수';

CREATE SEQUENCE NOTICE_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER NOTICE_TRG
BEFORE INSERT ON NOTICE
FOR EACH ROW
BEGIN
  SELECT NOTICE_SEQ.NEXTVAL
  INTO :NEW.IDX
  FROM DUAL;
END;
/

ALTER TABLE NOTICE 
    ADD CONSTRAINT pk_notice PRIMARY KEY(idx);
ALTER TABLE NOTICE
    ADD CONSTRAINT fk_notice_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;


CREATE TABLE BOOKMARK(
    idx NUMBER(3) NOT NULL,
    user_code CHAR(6) NOT NULL,
    latitude NUMBER(10,8) NOT NULL,
    longitude NUMBER(11,8) NOT NULL
);
COMMENT ON COLUMN BOOKMARK.idx IS '북마크번호';
COMMENT ON COLUMN BOOKMARK.user_code IS '회원코드';
COMMENT ON COLUMN BOOKMARK.latitude IS '위도(0~90)';
COMMENT ON COLUMN BOOKMARK.longitude IS '경도(0~180)';

CREATE SEQUENCE BOOKMARK_SEQ START WITH 1;

CREATE OR REPLACE TRIGGER BOOKMARK_TRG
BEFORE INSERT ON BOOKMARK
FOR EACH ROW
BEGIN
  SELECT BOOKMARK_SEQ.NEXTVAL
  INTO :NEW.IDX
  FROM DUAL;
END;
/

ALTER TABLE BOOKMARK 
    ADD CONSTRAINT pk_bookmark PRIMARY KEY(idx);
ALTER TABLE BOOKMARK
    ADD CONSTRAINT fk_bookmark_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;


CREATE TABLE COUPON(
    coupon_code CHAR(16) NOT NULL,
    user_code CHAR(6) NOT NULL,
    expired_yn NUMBER(1,0)
);
COMMENT ON COLUMN COUPON.coupon_code IS '쿠폰번호';
COMMENT ON COLUMN COUPON.user_code IS '회원코드';
COMMENT ON COLUMN COUPON.expired_yn IS '쿠폰 사용기한 초과여부(1/0)'; 

ALTER TABLE COUPON
    ADD CONSTRAINT pk_coupon PRIMARY KEY(coupon_code);
ALTER TABLE COUPON
    ADD CONSTRAINT fk_coupon_member FOREIGN KEY(user_code) REFERENCES MEMBER(user_code)
    ON DELETE CASCADE;
ALTER TABLE COUPON
    ADD CONSTRAINT chk_coupon_expired_yn CHECK (expired_yn in(1, 0));


COMMIT;
