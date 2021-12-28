-- 1. 서브쿼리 (Subquery) - 개요
--     · 일반적인 쿼리(메인, 주 쿼리) 안에 있는 또 다른 쿼리 -> 보조, 하위 쿼리 
--     · 메인 쿼리와 서브쿼리가 합쳐져 한 문장을 이룸
--     · 서브쿼리는 하나의 SELECT 문장으로, 괄호로 둘러싸인 형태
--     · 메인 쿼리 기준으로 여러 개의 서브 쿼리 사용 가능

--     1. 서브쿼리 (Subquery) - 종류
--     · 서브 쿼리 위치에 따라
--            - 스칼라 서브쿼리 (Scalar Subquery) - 인라인 뷰 (Inline View)
--            - 중첩 서브쿼리 (Nested Subquery)
--     · 메인쿼리와의 연관성
--            - 연관성 있는(Correlated) 서브쿼리 : 메인쿼리와 조인
--            - 연관성 없는(Noncorrealted) 서브쿼리 : 메인쿼리와 독립적
--     ·주로 서브쿼리 위치에 따른 분류를 사용

--     2. 스칼라 서브쿼리 (Scalar Subquery)
--     · 메인쿼리의 SELECT 절에 위치한 서브쿼리
--     · SELECT 절에서 마치 하나의 컬럼이나 표현식 처럼 사용
--     · 스칼라(Scalar) : 크기만 가지는 값, 양을 의미 (수학, 물리)
--     · 서브쿼리 수행 결과가 하나의 값이 되므로 스칼라 서브쿼리라고 함(?)
--     · 서브쿼리가 최종 반환하는 로우 수는 1개
--     · 서브쿼리가 최종 반환하는 컬럼이나 표현식도 1개
--     · 서브쿼리에 별칭(Alias)을 주는 것이 일반적 -> 하나의 컬럼 역할을 하므로
--     · 서브쿼리 내에서 메인 쿼리와 조인 가능
--            - 조인 하는 것이 일반적
--            - 조인을 안하면 여러 건이 조회될 가능성이 많음
--            - 조인을 한다는 것은 연관성 있는 서브쿼리란 뜻
--     · 다른 테이블에 있는 값을 가져올 때 사용 가능한 방법
--            - 스칼라 서브쿼리
--            - 조인(외부조인)
--            - 사용자 정의 함수 (get_dept_name – 3차시)
--     · 스칼라 서브쿼리나 사용자 정의 함수는 가급적 사용 자제 -> 성능 상 좋지 않음

-- 스칼라 서브쿼리 

-- 1 ·사용 예 – 부서명 가져오기
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.department_id, 
       ( SELECT b.department_name
           FROM departments b
          WHERE a.department_id = b.department_id ) dept_name
  FROM employees a
 ORDER BY 1;
--> 부서명 처럼 특정 코드 명칭을 가져올 때 스칼라 서브쿼리를 사용하는 경우가 많음 

-- 2
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.department_id, 
       ( SELECT b.department_name
           FROM departments b
       ) dept_name
  FROM employees a
 ORDER BY 1;
--> 부서명 전체를 가져오므로 오류 발생 

-- 3
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.department_id, 
       ( SELECT b.department_name, b.location_id
           FROM departments b
          WHERE a.department_id = b.department_id ) dept_name
  FROM employees a
 ORDER BY 1; 
--> 건수는 1건을 가져오지만, 두 개의 컬럼 값을 가져오므로 오류
 
-- 4
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_names, a.job_id
      ,( SELECT b.job_title || '(' || b.job_id || ')'
           FROM jobs b
          WHERE a.job_id = b.job_id ) job_names
FROM employees a
ORDER BY 1;
--> job_title, job_id 두 컬럼을 사용하지만, 문자열 연결 연산자로 결합되어 최종 반환 값은 1개

-- 5-1  조인
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.department_id, 
       b.department_name
  FROM employees a,
       departments b
 WHERE a.department_id = b.department_id   
 ORDER BY 1;

-- 5-2  스칼라 서브쿼리
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.department_id, 
       ( SELECT b.department_name
           FROM departments b
          WHERE a.department_id = b.department_id ) dept_name
  FROM employees a
 ORDER BY 1;
 --> 178번 사원은 조인에서는 누락, 서브쿼리에서는 조회됨
 --> 스칼라 서브쿼리는 성능상 좋지 않음, 따라서 과도한 사용은 자제
 
-- 5-3 외부조인
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.department_id,
       b.department_name
 FROM employees a
 LEFT JOIN departments b
  ON a.department_id = b.department_id
 ORDER BY 1;
--> 외부 조인(LEFT JOIN)을 사용하면 178번 사원이 누락되지 않음
 
-- 6
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       a.department_id, 
       ( SELECT b.department_name
           FROM departments b
          WHERE a.department_id = b.department_id 
       ) dept_name,
       ( SELECT d.country_name
           FROM departments b
               ,locations c
               ,countries d
          WHERE a.department_id = b.department_id 
            AND b.location_id = c.location_id
            AND c.country_id = d.country_id
        ) country_name
             
  FROM employees a
 ORDER BY 1;

-- 3. 인라인 뷰 (Inline View)
--     · 메인쿼리의 FROM 절에 위치
--     · 서브쿼리 자체가 마치 하나의 테이블 처럼 동작
--     · 서브쿼리가 최종 반환하는 로우와 컬럼, 표현식 수는 1개 이상 가능
--     · 서브쿼리에 대한 별칭(Alias)은 반드시 명시
--     · 메인쿼리와 조인조건은 메인 쿼리의 WHERE 절에서 처리가 일반적 
--     · 인라인 뷰가 필요한 이유
--            - 기존 단일 테이블만 읽어서는 필요한 정보를 가져오기가 어려울 때
--              예, 특정 조건으로 집계한 결과와 조인 필요 시
--            - 인라인 뷰의 쿼리가 여러 테이블을 조인해 읽어오는 경우가 많음
--            - 복잡한 쿼리의 경우, 쿼리 작성을 좀 더 직관적으로 사용하기 위해
--     · LATERAL 키워드 사용 시 서브쿼리 내에서 조인 가능 -> 스칼라 서브쿼리처럼 동작
--            - 과거 서브쿼리 내에서는 메인 쿼리 참조가 불가능 (조인 불가)
--            - 12c 부터 추가된 기능
--            - 서브쿼리 앞에 LATERAL 명시할 경우 메인 쿼리 컬럼 참조 가능

-- 인라인 뷰
-- 1
SELECT a.employee_id,
       a.first_name || a.last_name emp_name,
       a.department_id, 
       c.dept_name
FROM employees a,
    ( SELECT b.department_id,  **
             b.department_name  dept_name **
        FROM departments b  **
    ) c **
WHERE a.department_id = c.department_id ***
ORDER BY 1;
--> **   하나의 테이블 역할
--> ***  메인 쿼리의 WHERE 절에 조인 조건 기술

-- 2 
SELECT a.employee_id,
       a.first_name || a.last_name emp_name,
       a.department_id, 
       c.dept_name
FROM employees a,
    ( SELECT b.department_id, 
             b.department_name  dept_name
        FROM departments b
       WHERE a.department_id = b.department_id **
    ) c
ORDER BY 1; 
--> 오류.  ** 서브 쿼리 내에서 조인 조건 불가능  
-- 3 
SELECT a.employee_id,
       a.first_name || a.last_name emp_name,
       a.department_id, 
       c.dept_name
FROM employees a,
     LATERAL ( SELECT b.department_id, 
                      b.department_name  dept_name
                FROM departments b
               WHERE a.department_id = b.department_id **
             ) c
  ORDER BY 1;   
-->  **12c 이후 버전에서는 LATERAL 사용해 서브 쿼리 내에서 조인 조건 가능

-- 4
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       dept.department_name,
       loc.street_address, loc.city, loc.country_name
FROM employees a
   ,( SELECT *
        FROM departments b ) dept
   ,( SELECT l.location_id, l.street_address, 
             l.city, c.country_name
        FROM locations l,
             countries c
       WHERE l.country_id = c.country_id 
     ) loc
 WHERE a.department_id = dept.department_id
   AND dept.location_id = loc.location_id
 ORDER BY 1;   
             
             
-- 5
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       dept_loc.department_name,
       dept_loc.street_address, dept_loc.city, 
       reg.country_name, reg.region_name
FROM employees a
   ,( SELECT b.department_id, b.department_name,
             l.street_address, l.city, l.country_id
        FROM departments b,
             locations l
       WHERE b.location_id = l.location_id
     ) dept_loc
   ,( SELECT c.country_id, c.country_name,
             r.region_name
        FROM countries c,
             regions r
       WHERE c.region_id = r.region_id 
         AND c.country_id = dept_loc.country_id **
     ) reg
 WHERE a.department_id = dept_loc.department_id
 ORDER BY 1;
--> 오류. **dept_loc.country_id 컬럼 참조 불가능 
 
-- 6
SELECT a.employee_id,
       a.first_name || ' ' || a.last_name emp_name,
       dept_loc.department_name,
       dept_loc.street_address, dept_loc.city, 
       reg.country_name, reg.region_name
FROM employees a
   ,( SELECT b.department_id, b.department_name,
             l.street_address, l.city, l.country_id
        FROM departments b,
             locations l
       WHERE b.location_id = l.location_id
     ) dept_loc
   ,LATERAL ( SELECT c.country_id, c.country_name,
             r.region_name
        FROM countries c,
             regions r
       WHERE c.region_id = r.region_id 
         AND c.country_id = dept_loc.country_id **
     ) reg
 WHERE a.department_id = dept_loc.department_id
 ORDER BY 1; 
--> ** LATERAL 키워드 사용해 dept_loc.country_id 컬럼 참조 가능

-- 7
SELECT a.department_id, a.last_name, a.salary,
       k.department_id second_dept_id,
       k.avg_salary 
  FROM employees a,
      ( SELECT b.department_id, AVG(b.salary) avg_salary
          FROM employees b
         GROUP BY b.department_id
      ) k
 WHERE a.department_id = k.department_id     
ORDER BY a.department_id;     
-->  1. 부서별 평균 급여를 서브쿼리에서 구한 뒤
-->  2. 사원 급여와 부서 평균 급여를 같이 조회


-- 4. 중첩 서브쿼리 (Nested Subquery)
--     · 메인쿼리의 WHERE 절에 위치
--     · 서브쿼리가 조건절의 일부로 사용됨
--     · 서브쿼리 최종 반환 값과 메인쿼리 테이블의 특정 컬럼 값을 비교 시 사용
--     · 서브쿼리가 최종 반환하는 로우와 컬럼, 표현식 수는 1개 이상 가능
--     · 조건절의 일부이므로 서브쿼리에 대한 별칭(Alias) 사용 불가
--     · 서브쿼리 내에서 메인쿼리와 조인 가능
          
-- 중첩 서브쿼리
-- 1
SELECT *
  FROM departments 
 WHERE department_id IN ( SELECT department_id
                            FROM employees
                        ) ;
--> 1. employees 테이블에 있는 department_id 조회
--> 2. departments 테이블에서 이 서브쿼리에서 반환하는 값이 포함된 건만 조회

-- 2
SELECT *
  FROM departments a
 WHERE EXISTS ( SELECT  1
                  FROM employees b
                 WHERE a.department_id = b.department_id 
              ) ;
-->1. 서브쿼리 내에서 employees와 departments 테이블 조인
-->2. EXISTS 연산자는 존재하는지를 체크
-->3. 이미 체크를 했으니 서브쿼리의 SELECT 절에는 아무 거나 명시 
--> SELECT  1 에서 1은 아무 의미 없음. 0,a 아무거나 써도 됨. 대신 아무것도 없으면 

-- 3
SELECT *
  FROM departments a
 WHERE EXISTS ( SELECT 'A'
                  FROM employees b
                 WHERE a.department_id = b.department_id
                   AND b.salary > 10000 );
--> 1. 서브쿼리 내에서 employees와 departments 테이블 조인
--> 2. 조인 조건 외에 급여값이 10000 보다 큰 조건 추가
--> 3. 결국 급여가 10000 초과인 사원이 속한 부서 정보가 조회됨

-- 4                   
SELECT employee_id,
       first_name || ' ' || last_name emp_name,
       job_id, 
       salary
  FROM employees 
 WHERE (job_id, salary ) IN ( SELECT job_id, min_salary
                                FROM jobs)
ORDER BY 1;                            
--> 1. job_id, salary 두 값을 동시에 비교
--> 2. job_id별 최소 급여를 받는 사원이 조회됨

-- 5
SELECT last_name, employee_id
      ,salary + NVL(commission_pct, 0) tot_salary
      ,job_id, e.department_id
  FROM employees e
      ,departments d
WHERE e.department_id = d.department_id
  AND salary + NVL(commission_pct,0) > ( SELECT salary + NVL(commission_pct,0)
                                           FROM employees
                                          WHERE last_name = 'Pataballa')
ORDER BY last_name, employee_id;
-->  Pataballa란 사원의 salary와 commission_pct 합보다 큰 사원 조회

-- 6
SELECT department_id, employee_id, last_name, salary
  FROM employees a
 WHERE salary > (SELECT AVG(salary)
                   FROM employees b
                  WHERE a.department_id = b.department_id)
ORDER BY department_id;
-->  1. employees 테이블에서 자신이 속한 부서의 평균 급여보다 많이 받는 사원 조회

-- 6-1
SELECT department_id, employee_id, last_name, salary
  FROM employees a
ORDER BY department_id;
-- 6-2
SELECT department_id, AVG(salary)
  FROM employees b
 GROUP BY department_id
 ORDER BY 1;



------------------------------------------------------------
-- 5. 세미 조인 (Semi Join)
--     · 두 번째 테이블에 있는 로우와 조건이 맞는 첫 번째 테이블의 로우 반환
--     · 메인쿼리와중첩서브쿼리를사용할때사용하는조인
--     · WHERE 절에서 EXISTS 연산자를 사용

-- 세미조인
-- 2. Exists 연산자 사용                            
SELECT *
  FROM employees a
 WHERE EXISTS ( SELECT 0
                 FROM job_history  b
                WHERE a.employee_id = b.employee_id)
 ORDER BY 1;                                           


-- 6. 안티 조인 (Anti Join)
--     · 세미 조인에서 NOT 연산자 사용하는 조인 
--     · 서브쿼리와의 조인조건에 부합하지 않는 건을 조회

-- 안티조인
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name
  FROM employees a
 WHERE a.employee_id NOT IN ( SELECT employee_id
                                FROM job_history )
 ORDER BY 1;
-->  1. job_history에 없는 사원 조회
--> 2. 결국 직급 변경이 없는 사원만 조회

SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name
  FROM employees a
 WHERE NOT EXISTS ( SELECT 0
                      FROM job_history  b
                     WHERE a.employee_id = b.employee_id)
 ORDER BY 1; 
--> 1. job_history에 없는 사원 조회
--> 2. 결국 직급 변경이 없는 사원만 조회
