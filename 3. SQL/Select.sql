-- SELECT
-- 1. SELECT 문
-- 기본구문
SELECT 컬럼1, 컬럼2, ...
  FROM 테이블명
 WHERE 조건
 ORDER BY 정렬순서;
--  ·SELECT 절 : 컬럼1,컬럼2,...혹은전체컬럼조회시 *명시
--  ·FROM 절 : 테이블명, 2개 이상 명시할 때는 콤마로 구분

-- employees 테이블 데이터 전체 조회  
SELECT *
FROM EMPLOYEES;

-- employees 테이블 layout  
DESC EMPLOYEES;
=>
이름             널?       유형           
-------------- -------- ------------ 
EMPLOYEE_ID    NOT NULL NUMBER(6)    
FIRST_NAME              VARCHAR2(20) 
LAST_NAME      NOT NULL VARCHAR2(25) 
EMAIL          NOT NULL VARCHAR2(25) 
PHONE_NUMBER            VARCHAR2(20) 
HIRE_DATE      NOT NULL DATE         
JOB_ID         NOT NULL VARCHAR2(10) 
SALARY                  NUMBER(8,2)  
COMMISSION_PCT          NUMBER(2,2)  
MANAGER_ID              NUMBER(6)    
DEPARTMENT_ID           NUMBER(4) 

-- employees 테이블 일부컬럼 조회  
-- ·사원의 사번과 이름, 급여
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEES;
=>
EMPLOYEE_ID  FIRST_NAME   LAST_NAME  SALARY
100	     Steven	  King        24000
101	     Neena	  Kochhar     17000
102	     Lex	  De Haan     17000

-- departmemts 테이블 조회
SELECT *
  FROM departments;
  
  

-- 2. WHERE 절
--  - 문자 혹은 문자열 데이터 비교 시, 오라클은 대소문자를 구분함
--  - 대소문자를 구분하지 않는 DBMS도 상당 수 : 예) MSSQL, MYSQL
--  - 문자 값 비교 시 작은 따옴표(')로 둘러싸야 한다


-- 사번이 100번인 사원 조회 
SELECT *
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 100;

-- 사번이 100번이 아닌 사원 조회1
SELECT *
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID <> 100;
 
-- 사번이 100번이 아닌 사원 조회2
 SELECT *
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID != 100;
 
-- 사번이 100보다 크고 JOB_ID가 ST_CLERK인 사원 조회 
SELECT *
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID > 100
   AND JOB_ID = 'ST_CLERK';
 
-- 급여가 5000 이상인 사원 조회
SELECT *
  FROM EMPLOYEES
 WHERE SALARY >= 5000;
 
-- 급여가 5000 이상인 사원의 사번과 이름, 급여를 조회 
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
  FROM EMPLOYEES
 WHERE SALARY >= 5000;
 =>
 EMPLOYEE_ID   FIRST_NAME  LAST_NAME  SALARY
 100	       Steven	   King       24000
 101	       Neena	   Kochhar    17000
 102	       Lex	   De Haan    17000
 
 
-- 급여가 2400 이하이고 20000 이상인 사원 조회  
SELECT *
  FROM employees
 WHERE salary <= 2400
    OR salary >= 20000; 
    
    
-- last_name이 grant인 사원 조회 
SELECT *
  FROM employees
 WHERE last_name = 'grant' ;
 => 
 없음
 
-- last_name이 Grant인 사원 조회  
SELECT *
  FROM employees
 WHERE last_name = 'Grant' ;
 =>
 EMPLOYEE_ID  FIRST_NAME    LAST_NAME     EMAIL         PHONE_NUMBER         HIRE_DATE                 JOB_ID          SALARY        COMMISSION_PCT       MANAGER_ID    DEPARTMENT_ID
 199	       Douglas	    Grant	  DGRANT	650.507.9844	     2008/01/13 00:00:00	SH_CLERK       2600		                  124	         50
 178	       Kimberely    Grant	  KGRANT	011.44.1644.429263   2007/05/24 00:00:00	SA_REP	       7000	     0.15	          149	
    
   
-- ORDER BY 절 실습     
-- 사번 순으로 정렬
SELECT *
FROM employees
ORDER BY employee_id;

-- 사번 내림차순 정렬
SELECT *
FROM employees
ORDER BY employee_id DESC;

-- 이름, 성 순으로 오름차순 정렬
SELECT *
FROM employees
ORDER BY first_name, last_name
;

-- 이름은 오름차순, 성은 내림차순으로 정렬
SELECT employee_id, first_name, last_name
FROM employees
ORDER BY first_name, last_name desc
;


SELECT employee_id, first_name, last_name, salary
  FROM employees
 WHERE salary >= 5000
 ORDER BY salary desc;


-- 숫자를 명시해 정렬1 
-- 2, 3 : 첫번째 컬럼과 두번째 컬럼 순으로 정렬
SELECT *
FROM employees
ORDER BY 2, 3 DESC
;


-- 숫자를 명시해 정렬2
-- 셀렉트된 항목은 4가지. 5번째 컬럼 없으므로 오류
SELECT employee_id, first_name, last_name, email
FROM employees
ORDER BY 2, 3, 5;


-- 숫자를 명시해 정렬3
-- first_name, last_name, phone_number 기준으로 정렬되지만 phone_number는 보여지지 않음.
SELECT employee_id, first_name, last_name, email
FROM employees
ORDER BY 2, 3, phone_number;


-- commission_pct 컬럼으로 오름차순 정렬
-- 오라클에서는 null 값이 큰 값
SELECT employee_id, first_name, last_name, commission_pct
FROM employees
ORDER BY commission_pct;
=>
employee_id   first_name    last_name     commission_pct
173	      Sundita       Kumar	  0.1
166	      Sundar        Ande	  0.1
163	      Danielle      Greene	  0.15


-- commission_pct 컬럼으로 내림차순 정렬
SELECT employee_id, first_name, last_name, commission_pct
FROM employees
ORDER BY commission_pct DESC;

-- NULL을 먼저  
SELECT employee_id, first_name, last_name, commission_pct
  FROM employees
 ORDER BY commission_pct NULLS FIRST;
 
-- NULL을 나중에 
SELECT employee_id, first_name, last_name, commission_pct
  FROM employees
 ORDER BY commission_pct NULLS LAST; 
