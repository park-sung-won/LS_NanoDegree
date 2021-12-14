-- 사용자 정의 함수

-- 사용자 정의 함수
--    · 직접 함수 만들어 사용
--    · PL/SQL을 사용해 개발

-- 부서 번호로 부서명을 가져오는 함수를 만들어 보자
--    -> 부서명을 가져오기 위해서는 EMPLOYEES와 DEPARTMENTS 테이블 조인해야 함
-- 함수는 매개변수를 받아 결과를 반환
--    -> 부서번호(DEPARTMENT_ID)를 매개변수로 받아 부서명(DEPARTMENT_NAME)을 반환

-- (1) get_dept_name 함수 생성
CREATE OR REPLACE FUNCTION get_dept_name (p_dept_id NUMBER)
      RETURN VARCHAR2
IS
      v_return VARCHAR2(80);
BEGIN
      SELECT department_name
       INTO v_return
       FROM departments
       WHERE department_id = p_dept_id;
 RETURN v_return;
END;

-- (1) get_dept_name 함수 활용
SELECT get_dept_name(10),
       get_dept_name(100)
FROM DUAL;

-- (1) get_dept_name 함수 활용
SELECT employee_id,
      first_name || ' ' || last_name emp_name,
      department_id,
      get_dept_name(department_id) dept_name
 FROM employees;
 
-- (2) IsNumber 함수
--    ·문자형 매개변수 값을 받아 이 값이 숫자인지 판별하는 함수
--    · MSSQL에는 빌트인 함수로 제공됨 (IsDate 함수도 제공)
--    ·오라클에서는 제공되지 않으므로, 직접 만들어 보자
--    ·숫자가 맞으면 0을 반환, 틀리면 1을 반환

-- (2) IsNumber 함수 생성
CREATE OR REPLACE FUNCTION IsNumber (p_number VARCHAR2)
 RETURN NUMBER
IS
 v_return NUMBER;
BEGIN
 SELECT TO_NUMBER(p_number)
  INTO v_return
  FROM DUAL;
 RETURN 0;
EXCEPTION WHEN OTHERS THEN
 RETURN 1;
END;

-- (2) IsNumber 함수 사용
SELECT IsNumber('123')
      ,IsNumber('ABc')
 FROM DUAL;
 
-- (2) IsNumber 함수 사용
  CREATE TABLE TO_NUMBER_TEST ( NUMBER_CONF VARCHAR2(100)
);
INSERT INTO TO_NUMBER_TEST VALUES ('1');
INSERT INTO TO_NUMBER_TEST VALUES ('2');
INSERT INTO TO_NUMBER_TEST VALUES ('3');
INSERT INTO TO_NUMBER_TEST VALUES ('4');
INSERT INTO TO_NUMBER_TEST VALUES ('5');
INSERT INTO TO_NUMBER_TEST VALUES ('6');
INSERT INTO TO_NUMBER_TEST VALUES ('7');
INSERT INTO TO_NUMBER_TEST VALUES ('8');
INSERT INTO TO_NUMBER_TEST VALUES ('9');
INSERT INTO TO_NUMBER_TEST VALUES ('10');
INSERT INTO TO_NUMBER_TEST VALUES ('11');
INSERT INTO TO_NUMBER_TEST VALUES ('1a');
INSERT INTO TO_NUMBER_TEST VALUES ('13');
INSERT INTO TO_NUMBER_TEST VALUES ('14');
COMMIT;

SELECT *
FROM TO_NUMBER_TEST;

SELECT TO_NUMBER(NUMBER_CONF)
 FROM TO_NUMBER_TEST;
 ==> 오류  1a 때문

SELECT CASE WHEN IsNumber(number_conf) = 0 THEN
                 TO_NUMBER(number_conf)
            ELSE 0
       END TONUMBERS
FROM TO_NUMBER_TEST;

--------------------------------------------------------------

-- 문제 풀이 
--1. 서기 1년 1월 1일부터 오늘까지 1조원을 쓰려면 매일 얼마를 써야 하는지 구하시오. 
--   최종 결과는 소수점 첫 째 자리에서 반올림 할 것 

SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - 1 LAST_YEAR
      ,TO_NUMBER(TO_CHAR(SYSDATE, 'DDD')) DAYS
      ,( ( TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - 1) * 365 ) + TO_NUMBER(TO_CHAR(SYSDATE, 'DDD')) DAYS_ALL
      , ROUND(1000000000000 / ( (( TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - 1) * 365 ) + TO_NUMBER(TO_CHAR(SYSDATE, 'DDD'))),0) TRILLIONS
FROM DUAL;

-- 필요한 내용 : 1조 (1000000000000), 서기시작 ~ 오늘까지 일 수
-- 오늘까지 일 수 -> 1년은 365일, 년도를 구하면 년도까지 일 수는 구할 수 있음
              -> 작년 12월 31일까지 일 수 + 금년 오늘까지 일 수
-- 1조 / (작년 12월 31일까지 일 수 + 금년 오늘까지 일 수 )
-- 작년 12월 31일까지 일 수
--    -> (현재년도 – 1 ) * 365
--    select (TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - 1) * 365
--     from dual;
-- 금년 오늘까지 일 수
--    -> SELECT TO_NUMBER(TO_CHAR(sysdate, 'ddd'))
--        FROM DUAL;

--2. 2021년 10월 26일 애인과 처음 만났다. 100일, 500일, 1000일 기념파티를 하고 싶은데, 언제인지 계산!  
SELECT TO_DATE('2021-10-26', 'YYYY-MM-DD') + 100 AS "100일"
      ,TO_DATE('2021-10-26', 'YYYY-MM-DD') + 500 AS "500일"
      ,TO_DATE('2021-10-26', 'YYYY-MM-DD') + 1000 AS "1000일"
FROM DUAL ;

-- 3. 524288 이란 숫자가 있다. 이 수는 2의 몇 승일까? 
SELECT log(2, 524288)
  FROM DUAL;

-- 4. 2050년 2월의 마지막 날은 무슨 요일일까?
SELECT TO_CHAR(LAST_DAY(TO_DATE('20500201', 'YYYYMMDD')), 'DAY')
FROM DUAL;

-- 5. 현재일자(2021-12-13) 기준 ROUND(SYSDATE, 'YYYY') 를 실행하면 2022-01-01이 반환된다.
--    그럼 언제 시점부터 2022-01-01이 반환될까?
SELECT ROUND(TO_DATE('2021-06-30 23:59:59', 'YYYY-MM-DD HH24:MI:SS'), 'YYYY') 
               AS THIS_YEAR
             ,ROUND(TO_DATE('2021-07-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'YYYY') 
              AS NEXT_YEAR
  FROM DUAL;
