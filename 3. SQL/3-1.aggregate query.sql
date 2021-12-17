-- 1. 집계 쿼리
--  ·GROUP BY 절과 집계 함수를 사용한 쿼리
--  ·특정 항목(컬럼)별 최소, 최대, 평균 값 등을 산출
--  ·과목별 평균 점수, 월별 전체 매출액 등 기본적인 데이터 분석에 사용됨
--  ·GROUP BY 절과 집계 함수 단독 사용 가능하나, 일반적으로 둘 모두를 함께 사용

-- 2. GROUP BY 절
--  ·구문
    SELECT expr1, expr2, ...
      FROM ...
     WHERE ...
     GROUP BY expr1, expr2 ...
     ORDER BY ... ;
--  ·WHERE 절과 ORDER BY 절 사이에 위치
--  · GROUP BY 절에 기술한 컬럼이나 표현식 별로 데이터가 집계
--  · GROUP BY 절에 기술한 컬럼, 표현식 이외의 항목은 SELECT 절에 명시 불가. 단, 집계 함수는 가능
--  · GROUP BY 절과 집계 함수를 함께 사용해야 의미 있는 결과를 도출


-- 3. 집계함수
--  ·여러 건의 데이터를 집계 연산한 결과를 반환하는 함수

--  ·COUNT ( expr )
--    - expr의 전체 개수 반환
--    - expr은컬럼을포함한표현식,보통 *사용
--  ·MAX ( expr )
--    - expr의 최댓값 반환
--  ·MIN ( expr )
--    - expr의 최솟값 반환
--  ·SUM ( expr )
--    - expr의 합계 반환
--  ·AVG ( expr )
--    - expr의 평균값 반환
--  ·VARIANCE ( expr )
--    - expr의 분산 반환
--  ·STDDEV ( expr )
--    - expr의 표준편차 반환
--  ·GROUP BY 절 없이 집계 함수만 사용 시 조회되는 데이터 전체에 대한 집계 값 계산
--  ·GROUP BY 절과 함께 사용 시, GROUP BY 절에 명시한 항목별 집계 값 계산
--  ·매개변수 '*'는 COUNT 함수에서만 사용

-- 4. Group by절, 집계 함수
-- 1
SELECT employee_id
FROM employees
GROUP BY employee_id;
-->  employee_id 컬럼은 기본 키이므로 유일한 값만 들어 있어 GROUP BY 절을 사용해 집계하는 의미가 없음

-- 2
SELECT employee_id, job_id
FROM employees
ORDER by 2;

SELECT job_id
FROM employees
GROUP BY job_id;
--> job_id 컬럼을 기준으로 집계
--> 즉, job_id 컬럼의 유일한 값들을 모아 집계됨
-->> 유일한 job_id 컬럼 값 수로 로우 수가 줄어 듬

-- 3
SELECT TO_CHAR(hire_date, 'YYYY') HIRE_YEAR
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY') ;
--> 입사년도 별 집계를 하므로 총 조회되는 로우 수는 8개
--> GROUP BY 절에는 SELECT 절에 기술한 형태 그대로 사용해야 함 별칭은 기술하면 안됨

-- 4
SELECT TO_CHAR(hire_date, 'YYYY') HIRE_YEAR
FROM employees
GROUP BY hire_date;
--> 입사년도 별 집계를 하고자 했으나, GROUP BY 절에 입사일자를 명시해 결과적으로 입사년도가 아닌 입사일자별로 집계 되었음
--> 잘못된 집계 쿼리

-- 5
SELECT hire_date, COUNT(*)
FROM employees
GROUP BY hire_date
ORDER BY 2 DESC;

-- 6
SELECT COUNT(*)
FROM employees;
--> EMPLOYEES 테이블의 전체 로우 건 수

-- 7
SELECT COUNT(*) total_cnt, MIN(salary) min_salary, MAX(salary) max_salary
FROM employees;
--> EMPLOYEES 테이블의 전체 로우 건 수
--> Salary 컬럼의 최소와 최댓값

-- 8
SELECT job_id,
       COUNT(*) total_cnt,
       MIN(salary) min_salary,
       MAX(salary) max_salary
  FROM employees
GROUP BY job_id
ORDER BY job_id;
--> EMPLOYEES 테이블의 job_id 별 건수, salary 컬럼의 최소와 최댓값

-- 9
SELECT TO_CHAR(hire_date, 'YYYY') HIRE_YEAR,
       department_id,
       COUNT(*), SUM(salary), AVG(salary)
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY'), department_id
ORDER BY 1, 2;
--> 입사 년도와 부서별 총 인원수와 급여 총액, 급여 평균

-- 10
SELECT TO_CHAR(hire_date, 'YYYY') HIRE_YEAR,
       department_id,
       COUNT(*), SUM(salary), AVG(salary)
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') >= '2004'
GROUP BY TO_CHAR(hire_date, 'YYYY'), department_id
ORDER BY 1, 2;
--> 2004년 이후 입사 년도와 부서별 총 인원수와 급여 총액, 급여 평균

-- 11
SELECT TO_CHAR(hire_date, 'YYYY') HIRE_YEAR,
       department_id,
       COUNT(*), SUM(salary), ROUND(AVG(salary),0)
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') >= '2004'
GROUP BY TO_CHAR(hire_date, 'YYYY'), department_id
ORDER BY 1, 2;
-->  ROUND 함수를 사용해 급여 평균 값의 소수점 제거

-- 12
SELECT TO_CHAR(hire_date, 'YYYY') HIRE_YEAR,
       department_id,
       COUNT(*), SUM(salary), ROUND(AVG(salary),0)
FROM employees
WHERE ROUND(AVG(salary),0) >= 5000
GROUP BY TO_CHAR(hire_date, 'YYYY'), department_id
ORDER BY 1, 2;
--> 오류!!
--> 그룹 함수는 WHERE 절에서 사용 불가


-- 5. HAVING 절
--  · 집계 쿼리에서 집계 함수 반환 값에 대한 조건을 걸 때 사용
--  · 일반적인 조건WHERE 절, HAVING 절집계 쿼리에 대한 추가 조건 절
--  · 예) 한 반에서 과목별 평균 점수가 60점 이상인 과목을 조회
--          - 집계 쿼리로 평균 값 산출 : AVG(점수)
--          - WHERE AVG(점수) >= 60  -> X
--          - HAVING AVG(점수) >= 60 -> O
-- 13 오류 쿼리
SELECT TO_CHAR(hire_date, 'YYYY') HIRE_YEAR, department_id, COUNT(*), SUM(salary), ROUND(AVG(salary),0)
FROM employees
WHERE ROUND(AVG(salary),0) >= 5000
GROUP BY TO_CHAR(hire_date, 'YYYY'), department_id
ORDER BY 1, 2;

-- 14
SELECT TO_CHAR(hire_date, 'YYYY') HIRE_YEAR, department_id, COUNT(*), SUM(salary), ROUND(AVG(salary),0)
FROM employees
--WHERE ROUND(AVG(salary),0) >= 5000
GROUP BY TO_CHAR(hire_date, 'YYYY'), department_id
HAVING ROUND(AVG(salary),0) >= 5000
ORDER BY 1, 2;

-- 15
SELECT TO_CHAR(hire_date, 'YYYY') HIRE_YEAR, department_id, COUNT(*), SUM(salary), ROUND(AVG(salary),0)
FROM employees
GROUP BY TO_CHAR(hire_date, 'YYYY'), department_id
HAVING COUNT(*) > 1
ORDER BY 1, 2;


-- 6. DISTINCT
--  · SELECT DISTINCT expr1, expr2 ... FROM ...
--  · DISTINCT 뒤에 명시한 표현식(컬럼)의 고유한 값을 조회
--  · 집계 함수 없이 GROUP BY 절을 사용한 것과 동일한 효과
-- 16
SELECT job_id
FROM employees
GROUP BY job_id;

SELECT DISTINCT job_id
FROM employees;

-- 18
SELECT DISTINCT TO_CHAR(hire_date, 'YYYY') HIRE_YEAR, department_id
FROM employees
ORDER BY 1, 2;

----------------------------------------------------------
-- 8. Rollup과 Cube

-- Rollup : 소계(Sub Total)

    ·SELECT COL1, COL2, SUM(COL3)
        FROM TABLE1
       GROUP BY ROLLUP(COL1, COL2) ...
-- -> COL1에 대한 소계, COL1과 COL2의 계, 그리고 전체 합계 계산
-- ·ROLLUP에 명시한 표현식 수(콤마로 구분) + 1개를 Grouping 예) .... ROLLUP(col1, col2)
-- -> col1과 col2에 대한 합계, col1에 대한 합계, 전체 합계


-- 19
SELECT  substr(phone_number,1,3), JOB_ID, SUM(salary)
FROM EMPLOYEES
group by JOB_ID, substr(phone_number,1,3)
order by 1, 2;
--> jobID별 전화번호 앞자리별 salary소계

-- 20
SELECT  SUBSTR(phone_number,1,3), JOB_ID, SUM(salary)
FROM EMPLOYEES
GROUP BY  ROLLUP(substr(phone_number,1,3), JOB_ID)
;

-- ·Cube : 모든 가능한 조합에 대한 소계 (거의 안씀)
-- 21
SELECT  SUBSTR(phone_number,1,3), JOB_ID, SUM(salary)
FROM EMPLOYEES
GROUP BY  CUBE(substr(phone_number,1,3), JOB_ID)
;

--------------------------------------------------------------------------------------------

-- COVID19 관련 
-- 전체 건수 
SELECT COUNT(*)
  FROM COVID19;
  
-- 국가 수와 정보1
SELECT COUNTRY
  FROM COVID19
 GROUP BY COUNTRY;  
 
-- 국가 수와 정보2 
SELECT DISTINCT COUNTRY
  FROM COVID19;
  
-- 국가 수
SELECT COUNT(DISTINCT COUNTRY)
  FROM COVID19;
  
  
 select MIN(dates), MAX(dates)
 from covid19_test;
 
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
