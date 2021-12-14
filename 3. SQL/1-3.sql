-- 연산자 실습
-- 더하기, 빼기
SELECT 1+1 plus_test, 1-1 minus_test
  FROM DUAL;
=>
plus_test     minus_test
2	      0

-- 곱하기, 나누기  
SELECT 1+1*3 multiply, 7-4/2 divide
  FROM DUAL;  
=>
multiply     divide
4	     5

-- 괄호  
SELECT (1+1)*3 multiply, (7-4)/2 divide
  FROM DUAL;  
  
-- 문자열 결합
SELECT 'A' || 'B', 'C' || 'D' || 'F'
  FROM DUAL;  
=>
AB	CDF


-- 문자열 결합 사용 예
-- 컬럼 및 표현식 다음에 AS 별칭(Alias)을 기술하면 조회 결과가 별칭으로 보임
SELECT first_name || ' ' || last_name AS full_name
FROM EMPLOYEES;
-- 별칭에서 AS는 생략 가능
SELECT first_name || ' ' || last_name full_name
FROM employees;
=>
full_name
Ellen Abel
Sundar Ande
Mozhe Atkinson



-- 비교연산자
-- 동등연산자
SELECT *
  FROM employees
 WHERE salary = 2500;
 
-- 비동등연산자
SELECT *
  FROM employees
 WHERE salary != 2500;
 
 SELECT *
  FROM employees
 WHERE salary <> 2500;
 
-- 부등호 연산자1
 SELECT *
  FROM employees
 WHERE salary > 3000 
 ORDER BY salary;
 
--  부등호 연산자2
 SELECT *
  FROM employees
 WHERE salary >= 3000 
 ORDER BY salary; 
 
-- 부등호 연산자3
SELECT *
  FROM employees
 WHERE salary < 3000 
 ORDER BY salary desc; 
 
--  부등호 연산자4
SELECT *
  FROM employees
 WHERE salary <= 3000 
 ORDER BY salary desc;  
 
-- 부등호 연산자5
SELECT *
  FROM employees
 WHERE salary >= 3000 
   AND salary <= 5000
 ORDER BY salary;  
 
-- between and  연산자  
SELECT *
  FROM employees
 WHERE salary BETWEEN 3000 AND 5000
 ORDER BY salary;   
 
-- not 연산자   
SELECT *
  FROM employees
 WHERE NOT (salary = 2500 )
 ORDER BY salary; 
 
-- null 비교
-- NULL 연산자 : IS NULL, IS NOT NULL
-- col1 값이 NULL인지 체크
--     - col1 = NULL (X)
--     - col1 IS NULL (O)
-- NULL은 공백(' ')이 아님
-- 오라클에서는 NULL과 empty string('') 을 동일시 함 ( 다른 DBMS에서는 구별)
-- null 비교1
 SELECT *
  FROM employees
 WHERE commission_pct = NULL;
=>
아무것도 안나옴
 
-- null 비교2
SELECT *
  FROM employees
 WHERE commission_pct IS NULL;
=>
성과급 없는 사람 

-- null 비교3
SELECT *
  FROM employees
 WHERE commission_pct IS NOT NULL; 
 
-- LIKE 연산자
-- LIKE : 문자열 비교
--     - last_name like 'da%' : last_name이 da로 시작하는 모든 항목
--     - last_name like '%d‘ : last_name이 d로 끝나는 모든 항목
--     -'%' 는모든문자를의미

-- LIKE 연산자1
SELECT *
  FROM employees
 WHERE phone_number LIKE '011%';
 
-- 2-3-24. LIKE 연산자2
SELECT *
  FROM employees
 WHERE phone_number LIKE '%9'; 
 
-- LIKE 연산자3
SELECT *
  FROM employees
 WHERE phone_number LIKE '%124%';

-- IN 연산자
-- IN : 컬럼 IN (값1, 값2, 값3, ...) -> OR와 동일한 동작
-- 컬럼 의 값이 (값1, 값2, 값3, ...) 인 모든 항목

-- IN 연산자1
-- JOB_ID의 값이 'IT_PROG', 'AD_VP', 'FI_ACCOUNT' 인 모든 항목
SELECT *
  FROM employees
 WHERE JOB_ID IN ('IT_PROG', 'AD_VP', 'FI_ACCOUNT');
 
-- IN 연산자2
-- JOB_ID의 값이 'IT_PROG', 'AD_VP', 'FI_ACCOUNT' 이 아닌 모든 항목
SELECT *
  FROM employees
 WHERE JOB_ID NOT IN ('IT_PROG', 'AD_VP', 'FI_ACCOUNT');

-- 집합(SET) 연산자 : UNION, UNION ALL, INTERSECT, MINUS, ... · EXISTS

-- SQL 표현식

-- CASE 표현식
-- IF ~ THEN ~ ELSE 로직을 구현한 표현식
-- 여러 조건을 체크해 조건별 값을 반환하는 표현식
-- 단순형과 검색형이 있음
-- CASE expr WHEN 비교표현식1 THEN 값1 
--           WHEN 비교표현식2 THEN 값2
--           ....
--           ELSE 값n
-- END
-- expr 이 비교표현식1과 같으면 값1, 비교표현식2와 같으면 값2를 반환 어느 비교표현식과도 같지 않으면 ELSE 다음의 값n을 반환

SELECT *
FROM regions;

SELECT *
FROM countries;


-- 단순형 CASE 
SELECT country_id
      ,country_name
      ,CASE region_id WHEN 1 THEN '유럽'
                      WHEN 2 THEN '아메리카'
                      WHEN 3 THEN '아시아'
                      WHEN 4 THEN '중동 및 아프리카'
       END region_name
FROM countries;

=>
country_id    country_name  region_name
AR	      Argentina	       아메리카
AU	      Australia	       아시아
BE	      Belgium	       유럽
BR	      Brazil	       아메리카

-- 검색형 CASE1
SELECT employee_id, first_name, last_name, salary, job_id
      ,CASE WHEN salary BETWEEN 1     AND 5000  THEN '낮음'
            WHEN salary BETWEEN 5001  AND 10000 THEN '중간'
            WHEN salary BETWEEN 10000 AND 15000 THEN '높음'
            ELSE '최상위'
       END salary_rank     
FROM employees;
=>
employee_id   first_name    last_name     salary  job_id   salary_rank
102	      Lex	    De Haan	  17000	  AD_VP	   최상위
103	      Alexander	    Hunold	  9000	  IT_PROG  중간
104	      Bruce	    Ernst	  6000	  IT_PROG  중간
105	      David	    Austin	  4800	  IT_PROG  낮음

-- ???
SELECT employee_id, first_name, last_name, salary, job_id
      ,CASE WHEN salary BETWEEN 1     AND 5000  THEN '낮음'
            WHEN salary BETWEEN 5001  AND 10000 THEN '중간'
            WHEN salary BETWEEN 10000 AND 15000 THEN '높음'
            ELSE '최상위'
       END salary_rank     
FROM employees;
order by 6
-- 6번째에 있으므로 6번을 기준으로 정렬해라???


-- 검색형 CASE2
SELECT employee_id, first_name, last_name, salary, job_id
      ,CASE WHEN salary BETWEEN 1     AND 5000  THEN '낮음'
            WHEN salary BETWEEN 5001  AND 10000 THEN '중간'
            WHEN salary BETWEEN 10000 AND 15000 THEN '높음'
            ELSE 9
       END salary_rank     
FROM employees;
=>
오류
일관성 없는 데이터 유형(CHAR이 필요하지만 NUMBER임)

-- 검색형 CASE3
SELECT employee_id, first_name, last_name, salary, job_id
      ,CASE WHEN salary BETWEEN 1     AND 5000  THEN 1
            WHEN salary BETWEEN 5001  AND 10000 THEN 2
            WHEN salary BETWEEN 10000 AND 15000 THEN 3
            ELSE 9
       END salary_rank     
FROM employees;

-- 의사컬럼 (pseudocolumn)
-- 테이블에 있는 컬럼 처럼 동작하지만 실제 컬럼은 아닌 가상 컬럼
-- ROWNUM 의사컬럼
--     - 쿼리 수행 후 조회된 각 로우에 대해 ROWNUM 의사컬럼은 그 순서를 가리키는 수를 반환
--     - 첫 번째 선택된 로우는 1, 두 번째는 2, ... 순으로 증가됨
--     - 주로 where 절에서 쿼리 결과로 반환되는 로우 수를 제어할 때 사용
-- 이 외에도 계층형 쿼리, 시퀀스, XML 관련 의사컬럼이 있음

-- rownum 1
SELECT employee_id, first_name, last_name, rownum
FROM employees;

--  rownum 2
SELECT employee_id, first_name, last_name, rownum
FROM employees
WHERE rownum <= 5;
