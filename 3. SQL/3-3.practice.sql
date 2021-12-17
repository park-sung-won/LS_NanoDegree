-- 집계 쿼리 실습 
-- (1) 급여가 10000 이상인 사원의 평균 급여를 구하라

--  ·대상 테이블 : EMPLOYEES
--  ·급여가 10000 이상인 조건
--    -> salary >= 10000
--  ·평균 급여
--    -> AVG 집계 함수 사용
      
SELECT AVG(salary)
  FROM employees
 WHERE salary >= 10000;
 
SELECT ROUND(AVG(salary), 0)
  FROM employees
 WHERE salary >= 10000;

-- (2) 입사 월별 사원수를 구하라

--  ·대상 테이블 : EMPLOYEES
--  ·입사월
--    -> 입사일자인 hire_date 컬럼 가공 필요
--    -> TO_CHAR(hire_date, 'MM')
--  ·사원수
--    -> COUNT 집계 함수 사용

SELECT TO_CHAR(hire_date, 'MM'), COUNT(*)
  FROM employees
GROUP BY TO_CHAR(hire_date, 'MM')
ORDER BY 1;

-- 요일별 입사 사원수는? 
SELECT TO_CHAR(hire_date, 'day'), COUNT(*)
  FROM employees
GROUP BY TO_CHAR(hire_date, 'day')
ORDER BY 1;

SELECT TO_CHAR(hire_date, 'D'), COUNT(*)
  FROM employees
GROUP BY TO_CHAR(hire_date, 'D')
ORDER BY 1;
--> D =>  요일을 숫자로 표현. 일요일 = 1

-- (3) 이름이 동일한 사원과 동일인 수를 구하라

--  ·대상 테이블 : EMPLOYEES ·이름
--    -> first_name 컬럼
--  ·사원수
--    -> COUNT 집계 함수 사용
SELECT  *
  FROM employees
ORDER BY first_name;

SELECT first_name
      ,COUNT(*)
  FROM employees
 GROUP BY first_name
 ORDER BY first_name;
 
 
SELECT first_name
      ,COUNT(*)
  FROM employees
 GROUP BY first_name
 HAVING COUNT(*) > 1
 ORDER BY first_name;
 

  
-- 집합연산자 활용

-- (1) UNION (ALL)
--  · UNION 과 UNION ALL은 쓰임새가 같음 (중복 데이터 제거만 차이)
--  · 구조가 다른 여러 테이블에서 동일한 형태의 데이터를 추출하는 경우
--  ·컬럼을 로우 형태로 전환해 조회할 경우


-- 1.예산 대비 실적 
-- (1.1) UNION (ALL) – 계획 대비 실적

--  · 예산 테이블 (budget_table)
create table budget_table (
     yearmon      VARCHAR2(6),
     budget_amt   NUMBER     );
     
INSERT INTO budget_table values('201901', 1000);   
INSERT INTO budget_table values('201902', 2000);   
INSERT INTO budget_table values('201903', 1500);   
INSERT INTO budget_table values('201904', 3000);   
INSERT INTO budget_table values('201905', 1050);   

--  · 매출 테이블 (sale_table)
create table sale_table (
     yearmon      VARCHAR2(6),
     sale_amt     NUMBER     );
     
INSERT INTO sale_table values('201901', 900);   
INSERT INTO sale_table values('201902', 2000);   
INSERT INTO sale_table values('201903', 1000);   
INSERT INTO sale_table values('201904', 3100);   
INSERT INTO sale_table values('201905', 800);   

-- UNION (ALL) – 계획 대비 실적
SELECT yearmon, budget_amt, 0 sale_amt
  FROM budget_table
 UNION 
SELECT yearmon, 0 budget_amt, sale_amt
  FROM sale_table;
ORDER BY 1;
-->
201901	0	900
201901	1000	0
201902	0	2000
201902	2000	0
201903	0	1000
201903	1500	0
201904	0	3100
201904	3000	0
201905	0	800
201905	1050	0

-- UNION (ALL) – 계획 대비 실적
SELECT yearmon, 
       SUM(budget_amt) budget, 
       SUM(sale_amt) sale,
       ROUND(SUM(sale_amt) / SUM(budget_amt),2) * 100 rates
  FROM ( SELECT yearmon, budget_amt, 0 sale_amt
                FROM budget_table
                UNION 
                SELECT yearmon, 0 budget_amt, sale_amt
                FROM sale_table
              )   
  GROUP BY yearmon
  ORDER BY 1;
-->
201901	1000	900	90
201902	2000	2000	100
201903	1500	1000	67
201904	3000	3100	103
201905	1050	800	76


-- (1.2) UNION (ALL) – 컬럼을 로우로 
CREATE TABLE test_score (
    years     VARCHAR2(4),    -- 년도
    gubun     VARCHAR2(20),   -- 구분(중간,기말)
    korean    NUMBER,         -- 국어점수
    english   NUMBER,         -- 영어점수
    math      NUMBER );       -- 수학점수
    
INSERT INTO test_score VALUES ('2019', '중간고사', 92, 87, 67);
INSERT INTO test_score VALUES ('2019', '기말고사', 88, 80, 91);


SELECT years, gubun, '국어' subject, korean score FROM test_score
UNION ALL
SELECT years, gubun, '영어' subject, english score FROM test_score
UNION ALL
SELECT years, gubun, '수학' subject, math score FROM test_score
ORDER BY 2 desc;
-->
2019	중간고사	국어	92
2019	중간고사	영어	87
2019	중간고사	수학	67
2019	기말고사	영어	80
2019	기말고사	수학	91
2019	기말고사	국어	88

-- (1.3) INTERSECT

--> locations 테이블에서 city와 state_province 값이 같은 값 조회
SELECT *
FROM locations;

SELECT state_province dup_loc_name
  FROM locations
INTERSECT
SELECT city
  FROM locations
ORDER BY 1;  
-->
Oxford
Sao Paulo
Utrecht


SELECT state_province, city
  FROM locations 
 WHERE state_province = city
ORDER BY 1;
-->
Oxford	Oxford
Sao Paulo	Sao Paulo
Utrecht	Utrecht


-- 보너스 문제
-- · GROUPBYMULTIPLY 테이블 생성
create table GROUPBYMULTIPLY (
  department_name  VARCHAR2(100),
  num_data         NUMBER 
);
-- · GROUPBYMULTIPLY 테이블 데이터 입력
insert into groupbymultiply values ('dept1', 10);
insert into groupbymultiply values ('dept1', 20);
insert into groupbymultiply values ('dept1', 30);
insert into groupbymultiply values ('dept2', 5);
insert into groupbymultiply values ('dept2', 7);
insert into groupbymultiply values ('dept2', 40);
insert into groupbymultiply values ('dept3', 69);
insert into groupbymultiply values ('dept3', 71);
insert into groupbymultiply values ('dept3', 12);

commit;

-- ·GROUPBYMULTIPLY 테이블 조회
SELECT *
FROM groupbymultiply;

-- · GROUPBYMULTIPLY 테이블 집계
SELECT department_name,
        SUM(num_data)
FROM groupbymultiply
GROUP BY department_name
ORDER BY 1 ;

-- · GROUPBYMULTIPLY 테이블 문제
-- Department_name 별로 num_data 컬럼 값을 더하는 것이 아니라 곱한 결과를 조회하는 쿼리를 작성하시오.

--    · SUM 함수는 값을 모두 더함
--    · 곱하기를 더하기로 변환이 필요
--    · 로그의 덧셈 공식
--    · 로그 덧셈 -> exp 함수를 사용해 변환

-- · GROUPBYMULTIPLY 테이블 집계
SELECT department_name
      ,EXP(SUM(LN(num_data))) multiply_result
FROM groupbymultiply
WHERE 1=1
GROUP BY department_name
ORDER BY 1;
