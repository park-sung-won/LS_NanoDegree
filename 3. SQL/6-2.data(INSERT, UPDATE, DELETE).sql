-- 1. 데이터 입력, 수정, 삭제
--     · SQL의 DML 문은 SELECT, INSERT, UPDATE, DELETE, MERGE
--     · INSERT : 테이블에 데이터를 신규로 입력
--     · UPDATE : 이미 저장된 데이터를 수정
--     · DELETE : 저장된 데이터를 삭제
--     · MERGE : 조건에 따라 INSERT와 UPDATE 수행

-- 2. INSERT 문
--     · 테이블에 데이터를 신규로 입력, 즉 새로운 ROW를 입력하는 문장
--     · 기본적으로 하나의 INSERT 문장은 한 개의 ROW 입력
--     · INSERT 구문 종류에 따라 한 INSERT 문장으로 여러 개의 ROW를 동시에 입력 가능
--     · 구문1
--            - INSERT INTO 테이블명 (컬럼1, 컬럼2, ...)
--              VALUES (값1, 값2, ....);
--     · 한 번 실행 시 한 개의 ROW 입력
--     · 컬럼1, 컬럼2, ...와 값1, 값2, ... 는 개수, 순서, 데이터 형이 맞아야 함
--     · 테이블 명 다음 (컬럼1, 컬럼2, ...) 부분은 생략 가능, 생략 시 모든 컬럼 값 입력
--     · NOT NULL 속성인 컬럼은 반드시 입력해야 함


-- 데이터 입력/수정/삭제 
-- INSERT 구문1 실습 

-- ·실습용 EMP 테이블 생성
DROP TABLE EMP; -- 테이블이 이미 있는 

CREATE TABLE  EMP (
       emp_no      VARCHAR2(30)  NOT NULL,
       emp_name    VARCHAR2(80)  NOT NULL,
       salary      NUMBER            NULL,
       hire_date   DATE              NULL
);
-- 기본 키 추가
ALTER TABLE EMP
ADD CONSTRAINTS EMP_PK PRIMARY KEY (emp_no);

-- INSERT 구문1
INSERT INTO EMP ( emp_no, emp_name, salary, hire_date)
VALUES (1, '홍길동', 1000, '2020-06-01');

SELECT *
  FROM emp;
--> ※ hire_date는 date 형이지만 묵시적 형변환이 적용되어 문자형 값인 '2019-01-01'이 날짜로 자동 변환됨. 
  

INSERT INTO EMP ( emp_no, emp_name)
VALUES (2, '김유신');

SELECT *
  FROM emp;
--> ※ 테이블의 일부 컬럼만 선정해 입력 가능 
  

INSERT INTO EMP ( emp_name, emp_no )
VALUES ('강감찬', 3);

SELECT *
  FROM emp;
--> ※ 테이블 생성 시 컬럼 순서대로 입력할 필요는 없음, 입력하려는 컬럼과 입력된 값의 순서만 맞추면 정상 입력됨  
  
  
INSERT INTO EMP 
VALUES (4, '세종대왕', 1000, SYSDATE);

SELECT *
  FROM emp;
--> ※ 컬럼명 생략 시, VALUES 절에는 테이블의 모든 컬럼에 입력될 값을 명시해야 함. 입력 순서는 테이블 생성 시 기술한 컬럼 순서  
  
  
INSERT INTO EMP  ( emp_no,  salary, hire_date)
VALUES (5,  1000, SYSDATE);
--> ※ emp_name 컬럼은 Not Null 컬럼, 따라서 반드시 입력해야 하는데, 누락해서 오류 발생

INSERT INTO EMP  
VALUES (4, '신사임당', 1000, SYSDATE);

SELECT *
  FROM emp;
--> ※ emp_no에 4를 입력했으나, 이미 입력되어 있음. 기본 키 컬럼은 중복 값을 허용하지 않음 
  
  
INSERT INTO EMP  
VALUES (5, '신사임당', 1000, TO_DATE('2020-06-29 19:54:30', 'YYYY-MM-DD HH24:MI:SS'));

SELECT *
  FROM emp;
--> ※ hire_date 입력 시, TO_DATE 함수를 사용해 정확한 날짜 형식을 주고 입력


-- 2. INSERT 문
--     · 구문2
--            - INSERT INTO 테이블명 (컬럼1, 컬럼2, ...)
--              SELECT exp1, exp2, ..
--                 FROM ...
--     · 한 번 실행 시 여러 개의 ROW 입력 가능SELECT 문이 반환하는 데이터에 따라 좌우됨
--     · 컬럼1, 컬럼2, ...와 exp1, exp2, ... 는 개수, 순서, 데이터 형이 맞아야 함
--     · 테이블명 다음 (컬럼1, 컬럼2, ...) 부분은 생략 가능, 생략 시 모든 컬럼 값 입력
--     · NOT NULL 속성인 컬럼은 반드시 입력해야 함

-- INSERT 구문2 실습 

INSERT INTO EMP
SELECT emp_no + 10, emp_name, salary, hire_date
  FROM emp;

SELECT *
  FROM emp;
--> ※ 기존에 입력된 5건을 select 해 다시 입력. 단, emp_no 기본 키 컬럼 중복 값 입력 방지를 위해 기존 값에 + 10 해서 입력  
  
TRUNCATE TABLE EMP;

INSERT INTO EMP
SELECT employee_id, first_name || ' ' || last_name, salary, hire_date
  FROM EMPLOYEES
 WHERE department_id = 90;

SELECT *
  FROM emp;
--> ※ employees 테이블에서 부서번호가 90번인 사원의 데이터를 조회해 emp 테이블에 입력

INSERT INTO EMP
SELECT employee_id, first_name || ' ' || last_name, salary, hire_date
FROM employees;
--> ※ employees 테이블에서 90번 부서 사원 이미 입력. 다시 전체 사원 입력을 시도하니 기본키인 emp_no 중복 값 오류 발생

-- ·실습용 EMP_INFO1 테이블 생성
CREATE TABLE EMP_INFO1 (
   emp_no          VARCHAR2(30)  NOT NULL,
   emp_name        VARCHAR2(80)  NOT NULL,
   salary          NUMBER            NULL,
   hire_date       DATE              NULL,
   department_name VARCHAR2(80)      NULL,
   country_name    VARCHAR2(80)      NULL
);

INSERT INTO EMP_INFO1
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name, 
       a.salary, a.hire_date,
       b.department_name,
       d.country_name
  FROM employees a,
       departments b,
       locations c,
       countries d
 WHERE a.department_id = b.department_id
   AND b.location_id   = c.location_id
   AND c.country_id    = d.country_id;

SELECT *
  FROM EMP_INFO1;
--> ※ 조인을 사용한 쿼리를 사용해 그 결과를 emp_info1 테이블에 입력


-- 2. INSERT 문
-- **잘 사용 안함**
--     · 구문3 ( Unconditional Multitable Insert)
--            - INSERT ALL
--                 INTO 테이블명1 (컬럼1, 컬럼2, ...)
--                      VALUES ( 값1, 값2, ...)
--                 INTO 테이블명2 (컬럼1, 컬럼2, ...)
--                      VALUES ( 값1, 값2, ...)
--                 ....
--              SELECT exp1, exp2, ..
--                 FROM ...
--     · 한 번 실행 시 여러 테이블에 동시 INSERT
--     · 컬럼과 값의 쌍 개수, 순서 데이터 형이 맞아야 함
--     · 입력하고자 하는 컬럼은 조정 가능
--     · 실제 사용하는 경우는 별로 없음

-- INSERT 구문3 실습
CREATE TABLE  EMP1 (
       emp_no      VARCHAR2(30)  NOT NULL,
       emp_name    VARCHAR2(80)  NOT NULL,
       salary      NUMBER            NULL,
       hire_date   DATE              NULL,
       dept_id     NUMBER            NULL       
);

ALTER TABLE EMP1
ADD CONSTRAINTS EMP1_PK PRIMARY KEY (emp_no);

CREATE TABLE  EMP2 (
       emp_no      VARCHAR2(30)  NOT NULL,
       emp_name    VARCHAR2(80)  NOT NULL,
       salary      NUMBER            NULL,
       hire_date   DATE              NULL,
       dept_id     NUMBER            NULL       
);

ALTER TABLE EMP2
ADD CONSTRAINTS EMP2_PK PRIMARY KEY (emp_no);

CREATE TABLE  EMP3 (
       emp_no      VARCHAR2(30)  NOT NULL,
       emp_name    VARCHAR2(80)  NOT NULL,
       salary      NUMBER            NULL,
       hire_date   DATE              NULL,
       dept_id     NUMBER            NULL       
);

ALTER TABLE EMP3
ADD CONSTRAINTS EMP3_PK PRIMARY KEY (emp_no);

INSERT ALL
  INTO EMP1 (emp_no, emp_name, salary, hire_date)
    VALUES  (emp_no, emp_name, salary, hire_date)
  INTO EMP2 (emp_no, emp_name, salary, hire_date)
    VALUES  (emp_no, emp_name, salary, hire_date)    
SELECT employee_id emp_no, first_name || ' ' || last_name emp_name, salary, hire_date
  FROM employees;
  
SELECT *
FROM EMP1;

SELECT *
FROM EMP2;

  
TRUNCATE TABLE emp1;
TRUNCATE TABLE emp2;  

INSERT ALL
  INTO EMP1 (emp_no, emp_name, salary, hire_date)
    VALUES  (emp_no, emp_name, salary, hire_date)
  INTO EMP2 (emp_no, emp_name, salary)
    VALUES  (emp_no, emp_name, salary)
  INTO EMP3 (emp_no, emp_name)
    VALUES  (emp_no, emp_name)        
SELECT employee_id emp_no, first_name || ' ' || last_name emp_name, salary, hire_date
  FROM employees;


-- 2. INSERT 문
--     · 구문 4-1 ( Conditional Multitable Insert)
          - INSERT ALL
              WHEN 조건1 THEN
                INTO 테이블명1 (컬럼1, 컬럼2, ...)
                     VALUES ( 값1, 값2, ...)
              WHEN 조건2 THEN
                 INTO 테이블명2 (컬럼1, 컬럼2, ...)
                     VALUES ( 값1, 값2, ...)
              ELSE INTO ...
              ....
            SELECT exp1, exp2, ..
              FROM ...
--     · WHEN 조건을 체크해 조건이 맞으면 INSERT
--     · WHEN 조건과 INTO 절을 여러 개 명시할 수 있음
--     · 한 번 실행 시 여러 테이블에 동시 INSERT
--     · ELSE 절 추가 가능              

--     · 구문 4-2 ( Conditional Multitable Insert)
          - INSERT FIRST
              WHEN 조건1 THEN
                INTO 테이블명1 (컬럼1, 컬럼2, ...)
                     VALUES ( 값1, 값2, ...)
              WHEN 조건2 THEN
                 INTO 테이블명2 (컬럼1, 컬럼2, ...)
                     VALUES ( 값1, 값2, ...)
              ....
              ELSE
                INTO ...
            SELECT exp1, exp2, ..
              FROM ...
--     · ALL 대신 FIRST 사용
--     · 각 ROW 데이터 기준으로 첫 번째 WHEN 조건을 만족하면 이후 INTO 절 수행
--     · 첫 번째 조건을 만족한 데이터(ROW)가 두 번째 조건을 만족하더라도 두 번째 테이블에는 INSERT 되지 않음, 이후 조건도 동일하게 처리됨
--     ·CASE 표현식과 동작 방식 흡사              


-- INSERT 구문 4-1 
TRUNCATE TABLE emp1;
TRUNCATE TABLE emp2;  
TRUNCATE TABLE emp3;  
 
INSERT ALL
  WHEN dept_id = 20 THEN
    INTO EMP1 (emp_no, emp_name, salary, hire_date, dept_id)
       VALUES (emp_no, emp_name, salary, hire_date, dept_id)
  WHEN dept_id BETWEEN 30 AND 50 THEN        
    INTO EMP2 (emp_no, emp_name, salary, hire_date, dept_id)
       VALUES (emp_no, emp_name, salary, hire_date, dept_id)
  WHEN dept_id > 50 THEN        
    INTO EMP3 (emp_no, emp_name, salary, hire_date, dept_id)
       VALUES (emp_no, emp_name, salary, hire_date, dept_id)
SELECT employee_id emp_no, 
       first_name || ' ' || last_name emp_name, 
       salary, hire_date, department_id dept_id
  FROM employees;

SELECT *
FROM EMP1;
SELECT *
FROM EMP2; 
SELECT *
FROM EMP3;
  
-- INSERT 구문 4-1
TRUNCATE TABLE emp1;
TRUNCATE TABLE emp2;  
TRUNCATE TABLE emp3;

INSERT ALL
  WHEN salary >= 2500 THEN
    INTO EMP1 (emp_no, emp_name, salary, hire_date, dept_id)
       VALUES (emp_no, emp_name, salary, hire_date, dept_id)
  WHEN salary >= 5000 THEN        
    INTO EMP2 (emp_no, emp_name, salary, hire_date, dept_id)
       VALUES (emp_no, emp_name, salary, hire_date, dept_id)
  WHEN salary >= 7000 THEN        
    INTO EMP3 (emp_no, emp_name, salary, hire_date, dept_id)
       VALUES (emp_no, emp_name, salary, hire_date, dept_id)
SELECT employee_id emp_no, 
       first_name || ' ' || last_name emp_name, 
       salary, hire_date, department_id dept_id
  FROM employees;
  
SELECT MIN(salary), MAX(salary)
FROM EMP1;

SELECT MIN(salary), MAX(salary)
FROM EMP2;

SELECT MIN(salary), MAX(salary)
FROM EMP3;

-- INSERT 구문 4-2
TRUNCATE TABLE emp1;
TRUNCATE TABLE emp2;  
TRUNCATE TABLE emp3;
  
INSERT FIRST
  WHEN salary >= 2500 THEN
    INTO EMP1 (emp_no, emp_name, salary, hire_date, dept_id)
       VALUES (emp_no, emp_name, salary, hire_date, dept_id)
  WHEN salary >= 5000 THEN        
    INTO EMP2 (emp_no, emp_name, salary, hire_date, dept_id)
       VALUES (emp_no, emp_name, salary, hire_date, dept_id)
  WHEN salary >= 7000 THEN        
    INTO EMP3 (emp_no, emp_name, salary, hire_date, dept_id)
       VALUES (emp_no, emp_name, salary, hire_date, dept_id)
SELECT employee_id emp_no, 
       first_name || ' ' || last_name emp_name, 
       salary, hire_date, department_id dept_id
  FROM employees;  
  
  
SELECT MIN(salary), MAX(salary)
FROM EMP1;

SELECT MIN(salary), MAX(salary)
FROM EMP2;

SELECT MIN(salary), MAX(salary)
FROM EMP3;  


-- 3. UPDATE 문
--     · 테이블에 저장된 데이터를 수정하는 문장
--     · 컬럼 값을 수정, 조건에 따라 여러 개의 ROW 처리 가능
--     · 한 번 실행으로 여러 개의 컬럼 값, 여러 개의 ROW 처리 가능
--     · 어떤 ROW를 수정할 것인지는 WHERE 절에서 처리
--     · 구문
            UPDATE 테이블명
              SET 컬럼1 = 변경값1,
                  컬럼2 = 변경값2,
                  ...
             WHERE 조건
--     · 변경 하려는 컬럼과 변경값은 데이터 형이 맞아야 함
--     · 변경값 항목에는 표현식, 서브쿼리도 사용 가능
--     · WHERE 조건을 만족하는 ROW 만 처리됨, WHERE 절 생략 시 전체 ROW에 대해 컬럼 값 변경

-- UPDATE
SELECT *
  FROM EMP;
  
UPDATE emp
   SET salary = 0
 WHERE salary < 20000;

SELECT *
  FROM EMP;

ALTER TABLE emp
ADD retire_date DATE ;

UPDATE emp
   SET retire_date = SYSDATE
 WHERE emp_no = 102;

SELECT *
  FROM EMP;


UPDATE EMP_INFO1 
   SET emp_name = emp_name || '(middle)'
 WHERE salary BETWEEN 10000 AND 20000;
 
SELECT *
  FROM EMP_INFO1
 WHERE INSTR(emp_name, 'middle') > 0 ;

-- update 확인
SELECT *
  FROM EMP_INFO1
 WHERE INSTR(emp_name, 'middle') > 0 
   AND salary NOT BETWEEN 10000 AND 20000;
     
UPDATE EMP_INFO1
   SET emp_name = emp_name || ' (1)',
       department_name = department_name || ' (1)'
 WHERE hire_date < TO_DATE('2005-01-01', 'YYYY-MM-DD');


SELECT *
  FROM EMP_INFO1
 WHERE INSTR(department_name, '(1)') > 0 ;


SELECT *
  FROM EMP1
 WHERE dept_id IS NULL;
 
 
UPDATE EMP1
   SET dept_id = ( SELECT MAX(department_id)
                     FROM DEPARTMENTS
                    WHERE manager_id IS NULL
                 )
 WHERE dept_id IS NULL;
 
SELECT *
  FROM EMP1
 WHERE emp_no = 178;
 

-- 4. DELETE 문
--     · 테이블에 저장된 데이터를 삭제 하는 문장
--     · ROW 단위로 삭제됨
--     · WHERE 절 조건에 맞는 ROW가 삭제
--     · WHERE 절 생략 시 테이블에 있는 모든 ROW 삭제
--     ·구문
          DELETE [FROM] 테이블명
            WHERE 조건
--     · FROM 은 생략 가능
--     · WHERE 조건을 만족하는 ROW 에 한해 삭제됨 
--     · WHERE 조건 생략 시 테이블의 전체 ROW 삭제
     

-- DELETE
SELECT *
  FROM emp;
  
DELETE emp
 WHERE emp_no in (101, 102);
 

DELETE emp1
 WHERE emp_name LIKE 'J%';

SELECT *
  FROM emp1
 ORDER BY emp_name;

COMMIT; 



-- 5. SQL Developer에서 파일 Import
--     · SQL Developer를 이용해 csv, excel 파일을 읽어 테이블에 데이터 저장
--     · titanic.csv 파일 준비
--     · SQL Developer 실행 후 로그인
--     · 왼쪽 접속 창에서 테이블 선택 -> 오른쪽 마우스 클릭 -> 데이터 임포트(A) 선택
--     · 데이터 임포트 마법사 창 -> 파일 선택 : titanic.csv -> 다음 버튼 클릭
--     · 데이터 임포트 마법사 창 -> 테이블 이름 : titanic 입력 -> 다음 버튼 클릭
--     · 데이터 임포트 마법사 창 -> 다음 버튼 클릭
--     · 데이터 임포트 마법사 창 -> 각 컬럼 데이터 형 확인 후 다음 버튼 클릭
--     · 데이터 임포트 마법사 창 -> 완료 버튼 클릭

-- titanic 데이터 확인
SELECT *
  FROM titanic;
  

-- 6. 테이블 생성과 데이터 복사를 동시에
       CREATE TABLE 테이블명 AS
       SELECT *
          FROM 복사대상테이블;
--     · 테이블이 생성됨과 동시에 SELECT 문이 반환하는 데이터도 함께 입력됨
--     · DDL로 COMMIT 이 필요 없음

-- 테이블 생성과 데이터 복사를 동시에 
CREATE TABLE employees_copy AS
 SELECT *
   FROM employees; 
   
SELECT *
  FROM employees_copy;
   

-- 정리
--     · SQL의 DML 중 데이터를 가공하는 문장에는 INSERT, UPDATE, DELETE 가 있다.
--     · 테이블에 신규 데이터를 입력하는 문장은 INSERT 문이다.
--     · UPDATE 문은 저장된 데이터를 수정하는 문장이다.
--     · DELETE 문은 저장된 데이터를 삭제하는 문장이다.
--     · UPDATE와 DELETE 문 사용 시 WHERE 조건절 사용에 유의해야 한다.
