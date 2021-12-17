-- 집합쿼리 - 집합연산자 

-- 1. 집합 쿼리
--  · 집합 연산자를 사용한 쿼리
--  · 하나의 SELECT 문장이 반환한 결과를 한 집합으로 보고, 한 개 이상의 SELECT 문장이 집합 연산자로 연결된 형태
--  · 여러 개의 SELECT 문이 연결되어 최종적으로는 하나의 결과 집합이 만들어짐
SELECT ...
  FROM ...
 WHERE ...
 집합연산자
SELECT ...
  FROM ...
 WHERE ...
 집합연산자
...
-- <제한사항>
--  · 각 SELECT 절의 컬럼 수, 데이터 타입은 동일
--  · 최종 반환되는 컬럼 명은 맨 첫 SELECT 절의 컬럼 이름을 따름
--  · ORDER BY 절은 맨 마지막 SELECT 문장에서만 붙일 수 있음

-- 2. 집합 연산자
--  · 집합 쿼리는 집합 연산자를 사용해 SELECT 문장을 연결하는 형태
--  · UNION, UNION ALL, INTERSECT, MINUS 4개 연산자 존재
--  · 집합 연산자는 수학의 집합 개념과 유사
--  · 각 SELECT 문이 반환하는 결과를 하나의 집합으로 보고 집합 연산자를 통해 연결

-- 2. 집합 연산자 - UNION
--  ·두 집합의 모든 원소를 가져오는 합집합 개념
SELECT col1
  FROM Tbl_A
UNION
SELECT col1
  FROM Tbl_B
ORDER BY 1;
--  · 두 문장의 SELECT 절에 명시하는 컬럼 수, 데이터 타입은 동일해야 함
--  · 조회된 결과의 컬럼명은 첫 번째 SELECT 문장의 컬럼명으로 보임
--  · ORDER BY 절은 맨 마지막에 붙일 수 있음 (생략 가능)
--  · 각 결과 집합에서 조회된 중복 값은 1번만 조회됨

-- 2. 집합 연산자 – UNION ALL
--  · UNION과 동일하나 중복 값도 모두 조회됨
--  · 나머지 내용은 UNION 과 동일

-- 2. 집합 연산자 - INTERSECT
--  · 두 집합의 공통 원소를 가져오는 교집합 개념 (Distinct Row)

-- 2. 집합 연산자 - MINUS
--  · 선두 집합 에만 있는 원소를 가져오는 차집합 개념 (Distinct Row)
--  · 먼저 명시한 SELECT 문의 결과 집합이 기준 (Distinct Row)

 

-- A 집합 
SELECT job_id
  FROM employees
 WHERE 1=1
   AND salary BETWEEN 2000 and 5000
 ORDER BY job_id;
 
SELECT DISTINCT job_id
  FROM employees
 WHERE 1=1
   AND salary BETWEEN 2000 and 5000
 ORDER BY job_id;
--> AD_ASST, IT_PROG, PU_CLERK, SH_CLERK, ST_CLERK 

-- B 집합    
SELECT job_id
  FROM employees
 WHERE 1=1   
   AND salary BETWEEN 5001 AND 6000
 ORDER BY job_id;
--> IT_PROG, MK_REP, ST_MAN 
 
-- UNION
-- A집합
SELECT job_id
  FROM employees
 WHERE 1=1
   AND salary BETWEEN 2000 and 5000
 UNION
-- B집합
SELECT job_id
  FROM employees
 WHERE 1=1   
   AND salary BETWEEN 5001 AND 6000
 ORDER BY job_id;
 
 
-- UNION 오류 -- 결과 열 수 불일치 
SELECT job_id, salary
  FROM employees
 WHERE 1=1
   AND salary BETWEEN 2000 and 5000
 UNION 
SELECT job_id
  FROM employees
 WHERE 1=1   
   AND salary BETWEEN 5001 AND 6000
 ORDER BY job_id;
--> 컬럼 개수와 데이터 유형이 같아야함. (같은 컬럼일 필요는 없음)
 
 
-- UNION 오류 -- 결과 열의 데이텨형 불일치 
SELECT job_id, salary
  FROM employees
 WHERE 1=1
   AND salary BETWEEN 2000 and 5000
 UNION 
SELECT job_id, phone_number
  FROM employees
 WHERE 1=1   
   AND salary BETWEEN 5001 AND 6000
 ORDER BY job_id; 
--> Salary는 NUMBER 형, phone_number 는 문자형 => 데이터 형 불일치
 

-- UNION 오류 -- 문장오류는 없으나 의미상 오류인 쿼리 
SELECT job_id, salary
  FROM employees
 WHERE 1=1
   AND salary BETWEEN 2000 and 5000
 UNION 
SELECT job_id, department_id
  FROM employees
 WHERE 1=1   
   AND salary BETWEEN 5001 AND 6000
 ORDER BY job_id;
--> 구문 오류는 없으나, 의미상 오류
--> salary, department_id는 NUMBER 형이나 데이터 성격이 다름
 
 
-- UNION ALL
SELECT job_id
  FROM employees
 WHERE 1=1
   AND salary BETWEEN 2000 and 5000
 UNION ALL
SELECT job_id
  FROM employees
 WHERE 1=1   
   AND salary BETWEEN 5001 AND 6000
 ORDER BY job_id; 
 
 
-- INTERSECT 
SELECT job_id
  FROM employees
 WHERE 1=1
   AND salary BETWEEN 2000 and 5000
 INTERSECT
SELECT job_id
  FROM employees
 WHERE 1=1   
   AND salary BETWEEN 5001 AND 6000
 ORDER BY job_id;  
 

-- MINUS
-- A - B
SELECT job_id
  FROM employees
 WHERE 1=1
   AND salary BETWEEN 2000 and 5000
 MINUS
SELECT job_id
  FROM employees
 WHERE 1=1   
   AND salary BETWEEN 5001 AND 6000
 ORDER BY job_id;  
 
-- B - A 
SELECT job_id
  FROM employees
 WHERE 1=1   
   AND salary BETWEEN 5001 AND 6000 
 MINUS
SELECT job_id
  FROM employees
 WHERE 1=1
   AND salary BETWEEN 2000 and 5000
 ORDER BY job_id;

