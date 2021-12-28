-- 서브쿼리 복습 

-- 1. 서브쿼리 (Subquery) - 개요
--    · 일반적인 쿼리(메인, 주 쿼리) 안에 있는 또 다른 쿼리 -> 보조, 하위 쿼리
--    · 메인 쿼리와 서브쿼리가 합쳐져 한 문장을 이룸
--    · 서브쿼리는 하나의 SELECT 문장으로, 괄호로 둘러싸인 형태
--    · 메인 쿼리 기준으로 여러 개의 서브 쿼리 사용 가능

-- 1. 서브쿼리 (Subquery) - 종류
--    · 서브 쿼리 위치에 따라
--      - 스칼라 서브쿼리 (Scalar Subquery)
--      - 인라인 뷰 (Inline View)
--      - 중첩 서브쿼리 (Nested Subquery)

-- 2. 스칼라 서브쿼리 (Scalar Subquery)
--    · 메인쿼리의 SELECT 절에 위치한 서브쿼리
--    · SELECT 절에서 마치 하나의 컬럼이나 표현식 처럼 사용
--    · 스칼라(Scalar) : 크기만 가지는 값, 양을 의미 (수학, 물리)
--    · 서브쿼리 수행 결과가 하나의 값이 되므로 스칼라 서브쿼리라고 함(?)
--    · 서브쿼리가 최종 반환하는 로우 수는 1개
--    · 서브쿼리가 최종 반환하는 컬럼이나 표현식도 1개
--    · 서브쿼리에 별칭(Alias)을 주는 것이 일반적 -> 하나의 컬럼 역할을 하므로
--    · 서브쿼리 내에서 메인 쿼리와 조인 가능
--      - 조인 하는 것이 일반적
--      - 조인을 안하면 여러 건이 조회될 가능성이 많음
--      - 조인을 한다는 것은 연관성 있는 서브쿼리란 뜻

-- 3. 인라인 뷰 (Inline View)
--    · 메인쿼리의 FROM 절에 위치
--    · 서브쿼리 자체가 마치 하나의 테이블 처럼 동작
--    · 서브쿼리가 최종 반환하는 로우와 컬럼, 표현식 수는 1개 이상 가능
--    · 서브쿼리에 대한 별칭(Alias)은 반드시 명시
--    · 메인쿼리와 조인조건은 메인 쿼리의 WHERE 절에서 처리가 일반적
--    · 인라인 뷰가 필요한 이유
--      - 기존 단일 테이블만 읽어서는 필요한 정보를 가져오기가 어려울 때
--          예, 특정 조건으로 집계한 결과와 조인 필요 시
--      - 인라인 뷰의 쿼리가 여러 테이블을 조인해 읽어오는 경우가 많음
--      - 복잡한 쿼리의 경우, 쿼리 작성을 좀 더 직관적으로 사용하기 위해
--    · LATERAL 키워드 사용 시 서브쿼리 내에서 조인 가능 -> 스칼라 서브쿼리처럼 동작
--      - 과거 서브쿼리 내에서는 메인 쿼리 참조가 불가능 (조인 불가)
--      - 12c 부터 추가된 기능
--      - 서브쿼리 앞에 LATERAL 명시할 경우 메인 쿼리 컬럼 참조 가능

-- 4. 중첩 서브쿼리 (Nested Subquery)
--    · 메인쿼리의 WHERE 절에 위치
--    · 서브쿼리가 조건절의 일부로 사용됨
--    · 서브쿼리 최종 반환 값과 메인쿼리 테이블의 특정 컬럼 값을 비교 시 사용
--    · 서브쿼리가 최종 반환하는 로우와 컬럼, 표현식 수는 1개 이상 가능
--    · 조건절의 일부이므로 서브쿼리에 대한 별칭(Alias) 사용 불가
--    · 서브쿼리 내에서 메인쿼리와 조인 가능
      

-- (1) 사원의 급여를 회사 전체 평균 급여와 해당 사원이 속한 부서 평균 급여와 비교하라

-- 부서별 평균 급여
SELECT department_id, ROUND(AVG(salary),0) dept_avg_sal
  FROM employees
 GROUP BY department_id
 ORDER BY 1;

-- 사원 테이블과 부서별 평균 급여 쿼리를 조인 ? 서브쿼리 사용
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_name, 
       a.department_id, 
       a.salary, b.dept_avg_sal
  FROM employees a,
       ( SELECT department_id,
                ROUND(AVG(salary),0) dept_avg_sal
           FROM employees
          GROUP BY department_id
       ) b   
 WHERE a.department_id = b.department_id
 ORDER BY 1;
 
-- 회사 전체 급여 평균도 서브쿼리로 추가 
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_name, 
       a.department_id, 
       a.salary, b.dept_avg_sal,   c.all_avg_sal
  FROM employees a,
       ( SELECT department_id,
                        ROUND(AVG(salary),0) dept_avg_sal
           FROM employees
          GROUP BY department_id    ) b
      ,( SELECT ROUND(AVG(salary),0) all_avg_sal
           FROM employees   ) c    
 WHERE a.department_id = b.department_id
 ORDER BY 1  ;
 

-- 회사 전체 급여 평균 서브쿼리는 단일 값을 반환하므로 스칼라 서브쿼리 형태로 사용 가능 
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_name, 
       a.department_id, 
       a.salary, b.dept_avg_sal, 
      ( SELECT ROUND(AVG(salary),0)
           FROM employees   ) all_avg_sal
FROM employees a,
       ( SELECT department_id,
                        ROUND(AVG(salary),0) dept_avg_sal
           FROM employees
          GROUP BY department_id    ) b
   WHERE a.department_id = b.department_id
 ORDER BY 1  ;
 
 
--(2) 가장 급여가 많은 사원과 가장 적은 사원 이름과 급여 구하기
 
SELECT MIN(salary) min_sal,
       MAX(salary) max_sal
  FROM employees;


SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.salary
  FROM employees a
 WHERE a.salary IN ( SELECT MIN(salary) min_sal,
                            MAX(salary) max_sal
                     FROM employees
                   );


SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.salary
  FROM employees a
 WHERE a.salary IN ( SELECT MIN(salary) min_sal                                                        
                     FROM employees
                   );


SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.salary
  FROM employees a
 WHERE a.salary IN ( SELECT MIN(salary) min_sal
                     FROM employees
                   )
    OR a.salary IN ( SELECT MAX(salary) min_sal
                     FROM employees
                   );
                   
                   
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.salary
  FROM employees a
 INNER JOIN ( SELECT MIN(salary) min_sal,
                     MAX(salary) max_sal
              FROM employees
            ) b
 ON a.salary = b.min_sal
 OR a.salary = b.max_sal;
                   

-- (3) 사원에 할당되지 않은 부서 정보 조회
SELECT *
  FROM departments 
 WHERE department_id NOT IN ( SELECT a.department_id
                              FROM employees a
                            ) ;
--> 결과 데이터가 하나도 나오지 않음
--> - 178, Kimberly Grant의 department_id 값이 NULL 이기 때문

SELECT *
  FROM departments a
 WHERE NOT EXISTS ( SELECT 1
                    FROM employees b
                    WHERE a.department_id = b.department_id
                   ) 
ORDER BY 1;

-- · department_id NOT IN ( 10, 20, 30, ..., NULL )
-- · NOT (department_id = 10 OR
--        department_id = 20 OR
--        ...
--        department_id = NULL )
-- · department_id <> 10 AND
--   department_id <> 20 AND ...
--   department_id <> NULL
-- · NULL 비교는 IS NULL, IS NOT NULL

-- (4) 입사 년도별 사원들의 급여 총액과  전년 대비 증가율을 구하라
-- 입사 년도별 사원들의 급여 총액
SELECT TO_CHAR(hire_date, 'YYYY') years, SUM(salary) sal
  FROM employees 
 GROUP BY TO_CHAR(hire_date, 'YYYY')
 ORDER BY 1;
-- -> (금년 금액 – 전년 금액 ) / 전년 금액 * 100
-- -> 금년도 ROW에서 전년 금액이 필요

-- 입사 년도별 사원들의 급여 총액과 전년 대비 증가율
SELECT ty.years, ty.sal, ly.years, ly.sal
  FROM ( SELECT TO_NUMBER(TO_CHAR(hire_date, 'YYYY')) years, 
                SUM(salary) sal
         FROM employees 
         GROUP BY TO_CHAR(hire_date, 'YYYY')
        ) ty
  LEFT JOIN ( SELECT TO_NUMBER(TO_CHAR(hire_date, 'YYYY')) years, 
                     SUM(salary) sal
                FROM employees 
               GROUP BY TO_CHAR(hire_date, 'YYYY')
            ) ly
    ON ty.years - 1 = ly.years
 ORDER BY 1; 


SELECT ty.years, ty.sal, NVL(ly.sal,0) pre_sal,
       CASE WHEN NVL(ly.sal,0) = 0 THEN 0
            ELSE ROUND((ty.sal - ly.sal) / ly.sal * 100,2)
       END rates
  FROM ( SELECT TO_NUMBER(TO_CHAR(hire_date, 'YYYY')) years, SUM(salary) sal
           FROM employees 
          GROUP BY TO_CHAR(hire_date, 'YYYY')
       ) ty
  LEFT JOIN 
       ( SELECT TO_NUMBER(TO_CHAR(hire_date, 'YYYY')) years, SUM(salary) sal
           FROM employees 
          GROUP BY TO_CHAR(hire_date, 'YYYY')
       ) ly
    ON ty.years - 1 = ly.years
 ORDER BY 1; 
 
 
 
WITH cte1 AS (
SELECT  TO_NUMBER(TO_CHAR(hire_date, 'YYYY')) years, SUM(salary) sal
  FROM employees 
  GROUP BY TO_CHAR(hire_date, 'YYYY')
),
cte2 AS (
SELECT a.years, a.sal, b.years y2, NVL(b.sal,0) pre_sal
  FROM cte1 a
 LEFT JOIN cte1 b 
   ON a.years - 1 = b.years
)
SELECT years, sal, pre_sal,
       CASE WHEN pre_sal = 0 THEN 0
            ELSE ROUND((sal - pre_sal) / pre_sal * 100,2)
       END rates
 FROM cte2
 ORDER BY 1;

-- 정리
--    · 서브쿼리는 메인쿼리에 포함된 독립적인 SELECT 문장으로 괄호로 둘러싸인 쿼리를 말한다.
--    · 스칼라 서브쿼리는 메인 쿼리의 SELECT 절에 위치한 서브쿼리이다.
--    · 인라인 뷰는 메인 쿼리의 FROM 절에 위치한 서브쿼리이다.
--    · 중첩 서브쿼리는 메인 쿼리의 WHERE 절에 위치해 조건절의 일부로 사용된다.
