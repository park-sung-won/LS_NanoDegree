-- 1. WITH 절 or CTE (Common Table Expression)
--    · 서브쿼리의 일종
--    · WITH 절(clause)이라고도 하고 CTE 라고도 함
--    · 하나의 서브쿼리를 또 다른 서브쿼리에서 참조하여 재 사용 가능한 구문
--    · 오라클 11g 까지는 하나의 서브쿼리에서 다른 서브쿼리 참조 못했음
--          ->W ITH 절 사용
--          -> 오라클 12c 부터는 LATERAL 키워드 사용해 가능
--    · WITH절 구문
            WITH alias1 AS ( SELECT ...
                                FROM ... ),
                 alias2 AS ( SELECT ...
                                FROM ... ),
                 ....
                 alias_last AS (SELECT ...
                                FROM... )
            SELECT ...
               FROM alias_last
            ...;
--    · WITH 별칭 AS 다음에 서브쿼리 형태
--    · WITH은 한 번만 명시, 서브쿼리는 여러 개 사용 가능
--    · 최종 반환 결과는 마지막에 있는 메인 쿼리
--    · 서브쿼리 내에서 다른 서브쿼리 참조 가능
--          ->서브쿼리 내의 FROM 절에서 다른 서브쿼리 별칭을 기술해 인라인 뷰처럼 사용 가능
--    · 메인 쿼리에서는 FROM 절에서 서브쿼리 한 개, 혹은 여러 개의 서브쿼리 조인해 결과 조회 가능

-- 2. WITH 절 특징
--    · WITH 절은 내부적으로 TEMP 테이블 스페이스를 사용함
--          -> TEMP 테이블스페이스에 각 서브쿼리 결과를 담아두고 있음
--    · TEMP 테이블스페이스는 정렬 용도로 사용
--    · 과도한 WITH 절 사용 시, TEMP 테이블스페이스 공간을 점유해 성능에 좋지 않음
--    · 일반적인 경우에는 서브쿼리를 사용하고, 서브쿼리 사용이 수월치 않은 경우 WITH 절 사용

-- 다양한 유형의 서브쿼리 

SELECT last_name, employee_id
      ,salary + NVL(commission_pct, 0)
      ,job_id, e.department_id
  FROM employees e
      ,departments d
WHERE e.department_id = d.department_id
  AND salary + NVL(commission_pct,0) > ( SELECT salary + NVL(commission_pct,0)
                                           FROM employees
                                          WHERE last_name = 'Pataballa')
ORDER BY last_name, employee_id;


-- WITH 절
-- 1
WITH dept AS (
SELECT department_id, 
       department_name  dept_name
  FROM departments 
)
SELECT a.employee_id
      ,a.first_name || ' ' || a.last_name
  FROM employees a,
       dept b
 WHERE a.department_id = b.department_id
ORDER BY 1;       

 
-- 2
WITH dept_loc AS (
SELECT a.department_id, a.department_name dept_name,
       b.location_id, b.street_address, 
       b.city, b.country_id
  FROM departments a,
       locations b 
 WHERE a.location_id = b.location_id
),
cont AS (
SELECT b.department_id, b.dept_name, 
       b.street_address, b.city, a.country_name
  FROM countries a,
       dept_loc b
 WHERE a.country_id = b.country_id
)
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       b.dept_name, b.street_address,
       b.country_name
  FROM employees a,
       cont b
 WHERE a.department_id = b.department_id
 ORDER BY 1;       
        

-- 3
WITH emp_info AS (
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       b.department_id, b.department_name dept_name,
       c.street_address, c.city,
       d.country_name, e.region_name
  FROM employees a,
       departments b,
       locations c,
       countries d,
       regions e 
 WHERE a.department_id = b.department_id
   AND b.location_id   = c.location_id
   AND c.country_id    = d.country_id
   AND d.region_id     = e.region_id
)
SELECT *
  FROM emp_info
 ORDER BY 1;   


-- 4
WITH coun_sal AS (
SELECT c.country_id, SUM(a.salary) sal_amt
  FROM employees a,
       departments b,
       locations c
 WHERE a.department_id = b.department_id 
   AND b.location_id = c.location_id
GROUP BY c.country_id ),
mains AS (
SELECT b.country_name, a.sal_amt
  FROM coun_sal a,
       countries b
 WHERE a.country_id = b.country_id       
)
SELECT *
  FROM mains
 ORDER BY 1;     



-- 3. SQL 처리과정
--    · SQL 문장을 작성해 실행하면 오라클 내부에서 어떻게 처리될까?
--    · SQL 내부 처리 프로세스
--          - SQL Syntax Check
--          - SQL Semantic Check
--          - 가능한 여러 개의 실행계획(Execution Plan) 수립
--          - 최적의 실행계획을 선택 해 SQL 실행
--          - 실행 결과 반환

--    · Syntax Check : SQL 문장 검사 (오타 등)
--          예) select * form employees;
--             ORA-00923: FROM keyword not found where expected
--    · Semantic Check : 의미 검사, 객체 권한 검사
--          예) select * from hong;
--             ORA-00942: table or view does not exist
--    · Shared Pool Check : SQL문장에 ID 부여 등
--    · Optimization
--          - SQL 문장을 최적화 해 재작성
--          - 여러 개의 실행계획 생성
--    · Row Source Generation : 최적의 실행계획 선정
--    · Execution : 실행

--    · 최적의 실행계획이란 ?
--    · 내비게이션 시스템과 비슷함
--    · 여러 개의 실행계획을 세우고 그 중 가장 비용(Cost)이 낮은 계획을 선택해 실행
--          -> 가장 빨리 결과를 내는 실행계획을 선택

--    · 최적의 실행계획을 위해서는 테이블의 통계정보를 최신으로 갱신
--    · 통계정보 : 테이블의 로우 수, 블록 수 등 실행계획을 세우기 위한 기초 정보
--    · 같은 테이블에 100건, 10000건, 백만 건 있을 경우에 따라 통계정보 달라짐
--          - 조인 시, 어떤 테이블을 먼저 읽느냐에 따라 성능 차이 발생
--    · 내비게이션에서 현재 교통상황을 반영하면 경로가 달라지는 것과 유사

--    · 오라클 버전이 올라갈수록 실행계획을 잘 세우고 있음
--    · 실행계획을 잘 못 세웠을 경우, SQL 실행 계획을 조정해 성능을 향상 -> SQL 튜닝 (힌트 사용)
--    · 대부분의 경우, 튜닝 시 조인 방식과 순서를 변경

--    · 실행했던 SQL 이력 조회 (ORAUSER로 접속해 실행)
            SELECT *
              FROM V$SQL;
    
     
 
-- SQL 처리과정 
-- 1
WITH coun_sal AS ( /*+ gather_plan_statistics */
SELECT c.country_id, SUM(a.salary) sal_amt
  FROM employees a,
       departments b,
       locations c
 WHERE a.department_id = b.department_id 
   AND b.location_id = c.location_id
GROUP BY c.country_id ),
mains AS (
SELECT b.country_name, a.sal_amt
  FROM coun_sal a,
       countries b
 WHERE a.country_id = b.country_id       
)
SELECT *
  FROM mains
 ORDER BY 1;
 
 
-- 2
SELECT /*+ gather_plan_statistics */
       d.country_name, SUM(a.salary) sal_amt
  FROM employees a,
       departments b,
       locations c, 
       countries d
 WHERE a.department_id = b.department_id 
   AND b.location_id = c.location_id
   AND c.country_id = d.country_id
GROUP BY d.country_name
ORDER BY 1;

 
SELECT *
FROM V$SQL 
WHERE sql_text LIKE '%gather%'
;


select *
from table(dbms_xplan.display_cursor ( 'gx8yap8azwk86', null, 'ADVANCED ALLSTATS LAST'));


-- 3
SELECT /*+ gather_plan_statistics */
       -- hong123
       a.employee_id, 
       a.first_name || ' ' || a.last_name emp_name,
       b.department_id, b.department_name dept_name
  FROM employees a,
       departments b
 WHERE a.department_id = b.department_id      
 ORDER BY 1; 
 
SELECT * -- 9f725pnmu4zcq
FROM V$SQL 
WHERE sql_text LIKE '%hong123%'
; 
 
 
select *
from table(dbms_xplan.display_cursor ( '9f725pnmu4zcq', null, 'ADVANCED ALLSTATS LAST'));


-- 4. Top n Query
--          ·특정 컬럼 값을 기준으로 상위 n개, 혹은 하위 n개 로우를 조회하는 쿼리
--          ·MSSQL, MySQL 등은 기본 문법에서 제공
--          ·오라클 11g 까지는 제공하지 않았음
--             ->서브쿼리, ROWNUM 을 사용해 구현
--          ·오라클 12c 부터 기본 문법으로 제공

-- Top N Query
-- 1 
SELECT *
FROM ( SELECT a.employee_id,
              a.first_name || ' ' || a.last_name emp_name,
              a.salary
         FROM employees a
        ORDER BY a.salary DESC
     ) b
WHERE ROWNUM <= 5; 
-->  1. 서브쿼리에서 salary 값을 기준으로 내림차순 정렬
-->  2. rownum을 사용해 5건 이하만 조회

-- 2
SELECT *
FROM ( SELECT a.employee_id,
              a.first_name || ' ' || a.last_name emp_name,
              a.salary,
              ROW_NUMBER() OVER (ORDER BY a.salary DESC) ROW_SEQ
         FROM employees a
     ) b
WHERE ROW_SEQ <= 5;
--> 1. 서브쿼리에서 분석 함수를 사용해 salary 값을 기준으로 내림차순 순번 계산
--> 2. 계산한 순번을 사용해 5건 이하만 조회

-- 3
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.salary
  FROM employees a
 ORDER BY a.salary DESC
 FETCH FIRST 5 ROWS ONLY;
 
 
-- 4
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.salary
  FROM employees a
 FETCH FIRST 5 ROWS ONLY;
 
             
-- 5
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.salary
  FROM employees a
 ORDER BY a.salary DESC  
 FETCH FIRST 5 PERCENT ROWS ONLY;
 
 
-- 6
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.salary
  FROM employees a
 ORDER BY a.salary   
 FETCH FIRST 5 PERCENT ROWS ONLY;
 
-- 7
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.salary
  FROM employees a
 ORDER BY a.salary   
 FETCH FIRST 5 PERCENT ROWS WITH TIES;


