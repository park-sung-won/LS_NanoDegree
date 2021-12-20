-- 3-1

-- Q1. locations 테이블에는 전 세계에 있는 지역 사무소 주소 정보가 나와 있습니다. 각 국가별로 지역사무소가 몇 개나 되는지 찾는 쿼리를 작성해 보세요.

SELECT country_id, COUNT(*)
  FROM locations
 GROUP BY country_id
 ORDER BY country_id;
 
-- Q2. employees 테이블에서 년도에 상관 없이 분기별로 몇 명의 사원이 입사했는지 구하는 쿼리를 작성해 보세요.

SELECT TO_CHAR(hire_date, 'Q'), COUNT(*)
  FROM employees
 GROUP BY TO_CHAR(hire_date, 'Q')
 ORDER BY 1;

-- Q3. 다음 쿼리는 employees 테이블에서 job_id별로 평균 급여를 구한 것인데, 여기서 평균을 직접 계산하는 avg_salary1 이란 가상컬럼을 추가해 보세요.
      ( 평균 = 총 금액 / 사원수)
SELECT job_id, ROUND(AVG(salary),0) avg_salary
  FROM employees
 GROUP BY job_id
 ORDER BY 1;
-->
SELECT job_id, ROUND(AVG(salary),0) avg_salary,
 ROUND(SUM(salary) / COUNT(*), 0)
  FROM employees
 GROUP BY job_id
 ORDER BY 1;

-- Q4. COVID19_TEST 테이블에서 한국(ISO_CODE 값이 KOR)의 월별 코로나 확진자 수를 조회하는 문장을 작성하시오.

SELECT TO_CHAR(dates, 'YYYY-MM') MONTHS, SUM(new_cases)
  FROM covid19_test
 WHERE iso_code = 'KOR'
 GROUP BY TO_CHAR(dates, 'YYYY-MM')
 ORDER BY 1;
