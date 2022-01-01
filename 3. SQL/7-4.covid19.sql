-- 데이터분석 시각화2
-- covid19_country 테이블 생성
CREATE TABLE covid19_country (
  countrycode                 VARCHAR2(10) NOT NULL, 
  countryname                 VARCHAR2(80) NOT NULL, 
  continent                   VARCHAR2(50), 
  population                  NUMBER,
  population_density          NUMBER,
  median_age                  NUMBER,
  aged_65_older               NUMBER,
  aged_70_older               NUMBER,
  hospital_beds_per_thousand  NUMBER,
  PRIMARY KEY (countrycode)    
);

-- covid19_data 테이블 생성
CREATE TABLE covid19_data (
  countrycode                 VARCHAR2(10) NOT NULL, 
  issue_date                  DATE        NOT NULL,  
  cases                       NUMBER, 
  new_cases_per_million       NUMBER, 
  deaths                      NUMBER, 
  icu_patients                NUMBER, 
  hosp_patients               NUMBER, 
  tests                       NUMBER, 
  reproduction_rate           NUMBER, 
  new_vaccinations            NUMBER, 
  stringency_index            NUMBER,
  PRIMARY KEY (countrycode, issue_date)   
);

-- covid19_data 테이블의 countrycode 값에 OWID로 시작되는 데이터 삭제
SELECT countrycode, COUNT(*)
  FROM covid19_data
 WHERE countrycode LIKE 'OWID%' 
 GROUP BY countrycode ;


DELETE covid19_data
 WHERE countrycode LIKE 'OWID%' ;

 SELECT COUNT(*)
   FROM covid19_data
  WHERE countrycode LIKE 'OWID%' ;

COMMIT;

-- covid19_data 테이블에서 숫자형 컬럼 NULL을 0으로 수정
UPDATE covid19_data
   SET cases = 0
 WHERE cases IS NULL;


UPDATE covid19_data
   SET cases                 = NVL(cases, 0)
      ,new_cases_per_million = NVL(new_cases_per_million, 0)
      ,deaths                = NVL(deaths, 0)
      ,icu_patients          = NVL(icu_patients, 0)
      ,hosp_patients         = NVL(hosp_patients, 0)
      ,tests                 = NVL(tests, 0)
      ,reproduction_rate     = NVL(reproduction_rate, 0)
      ,new_vaccinations      = NVL(new_vaccinations, 0)
      ,stringency_index      = NVL(stringency_index, 0);
      
COMMIT;      

-- 1.2020년 월별, 대륙별, 국가별 감염수
SELECT TO_CHAR(b.issue_date, 'YYYYMM') months,
       a.continent, a.countryname, 
       SUM(b.cases) 감염수 
  FROM covid19_country a
 INNER JOIN covid19_data b
    ON a.countrycode = b.countrycode
 WHERE TO_CHAR(b.issue_date, 'YYYY') = '2020'
 GROUP BY TO_CHAR(b.issue_date, 'YYYYMM'),
          a.continent, a.countryname
 ORDER BY 1, 2, 3; 


-- 2-1.2020년 월별, 대륙별, 국가별 감염수, 대륙기준 감염수 비율 
WITH covid1 AS (
SELECT TO_CHAR(b.issue_date, 'YYYYMM') months,
       a.continent, a.countryname, 
       SUM(b.cases) case_num       
  FROM covid19_country a
 INNER JOIN covid19_data b
    ON a.countrycode = b.countrycode
 WHERE TO_CHAR(b.issue_date, 'YYYY') = '2020'
 GROUP BY TO_CHAR(b.issue_date, 'YYYYMM'),
          a.continent, a.countryname
),
covid2 AS (
SELECT months, continent, countryname, 
       case_num,
       SUM(case_num) OVER (PARTITION BY months, continent) tot
  FROM covid1
)
SELECT months, continent, countryname, 
       case_num, tot, 
       DECODE(tot, 0, 0, ROUND(case_num / tot * 100,2)) rates
  FROM covid2 ;
  
-- 2-2.2020년 월별, 대륙별, 국가별 감염수, 대륙기준 감염수 비율   
WITH covid1 AS (
SELECT TO_CHAR(b.issue_date, 'YYYYMM') months,
       a.continent, a.countryname, 
       SUM(b.cases) case_num       
  FROM covid19_country a
 INNER JOIN covid19_data b
    ON a.countrycode = b.countrycode
 WHERE TO_CHAR(b.issue_date, 'YYYY') = '2020'
 GROUP BY TO_CHAR(b.issue_date, 'YYYYMM'),
          a.continent, a.countryname
)
SELECT months, continent, countryname, 
       case_num,
       ROUND(RATIO_TO_REPORT(case_num) OVER (PARTITION BY months, continent) * 100,2) rates
  FROM covid1
 ORDER BY 1, 2, 3;


-- 3.2020년 한국의 월별 검사 수, 확진자 수, 확진율
SELECT TO_CHAR(issue_date, 'MM') months,
       SUM(tests) 검사수,
       SUM(cases) 확진자수,
       CASE WHEN SUM(tests) = 0 THEN 0
            ELSE ROUND(SUM(cases) /SUM(tests) * 100,2) 
       END 확진율
  FROM covid19_data
 WHERE countrycode = 'KOR'
   AND TO_CHAR(issue_date, 'YYYY') = '2020'
 GROUP BY TO_CHAR(issue_date, 'MM')
 ORDER BY 1;


-- 4-1.2020년 가장 많은 확진자가 나온 상위 5개 국가 정보
SELECT countryname, case_num
  FROM ( SELECT a.countryname, 
                SUM(b.cases) case_num
           FROM covid19_country a
          INNER JOIN covid19_data b
             ON a.countrycode = b.countrycode
          WHERE TO_CHAR(b.issue_date, 'YYYY') = '2020'
          GROUP BY a.countryname
          ORDER BY 2 DESC )
 WHERE ROWNUM <= 5
 ORDER BY 2 DESC;         
 
 
-- 4-2.2020년 가장 많은 확진자가 나온 상위 5개 국가 정보
SELECT countryname, case_num, seq
  FROM ( SELECT a.countryname, 
                SUM(b.cases) case_num,
                ROW_NUMBER() OVER (ORDER BY SUM(b.cases) DESC ) seq
           FROM covid19_country a
          INNER JOIN covid19_data b
             ON a.countrycode = b.countrycode
          WHERE TO_CHAR(b.issue_date, 'YYYY') = '2020'
          GROUP BY a.countryname
       )
 WHERE seq <= 5
 ORDER BY 3;
 
-- 4-3.2020년 가장 많은 확진자가 나온 상위 5개 국가 정보 
SELECT countryname, case_num
  FROM ( SELECT a.countryname, 
                SUM(b.cases) case_num
           FROM covid19_country a
          INNER JOIN covid19_data b
             ON a.countrycode = b.countrycode
          WHERE TO_CHAR(b.issue_date, 'YYYY') = '2020'
          GROUP BY a.countryname
        )
 ORDER BY 2 DESC
 FETCH FIRST 5 ROWS ONLY;
 
-- 5. 2020년 인구 대비 사망률이 높은 20개 국가는?
SELECT *
  FROM ( SELECT a.countryname, 
                MAX(a.population) popu,
                SUM(b.deaths) death_num,
                ROUND(DECODE(MAX(a.population),0,0, SUM(b.deaths) / MAX(a.population))*100,4) death_rate
           FROM covid19_country a
          INNER JOIN covid19_data b
             ON a.countrycode = b.countrycode
          WHERE TO_CHAR(b.issue_date, 'YYYY') = '2020'
          GROUP BY a.countryname
          ORDER BY 4 DESC 
       )
 WHERE ROWNUM <= 20 ;
 
-- 6. 2020년 국가별 확진자와 사망자의 월별 추이
CREATE OR REPLACE VIEW covid19_mon_v AS
WITH covid AS (
SELECT b.countryname,
       TO_CHAR(a.issue_date, 'MM') months,
       SUM(a.cases) case_num,
       SUM(a.deaths) death_num
  FROM covid19_data a
 INNER JOIN covid19_country b
    ON a.countrycode = b.countrycode
 GROUP BY b.countryname, TO_CHAR(a.issue_date, 'MM')
)
SELECT countryname, 
       '1.확진' gubun,
       SUM(CASE WHEN months = 01 THEN case_num ELSE 0 END) "01",
       SUM(CASE WHEN months = 02 THEN case_num ELSE 0 END) "02",
       SUM(CASE WHEN months = 03 THEN case_num ELSE 0 END) "03",
       SUM(CASE WHEN months = 04 THEN case_num ELSE 0 END) "04",
       SUM(CASE WHEN months = 05 THEN case_num ELSE 0 END) "05",
       SUM(CASE WHEN months = 06 THEN case_num ELSE 0 END) "06",
       SUM(CASE WHEN months = 07 THEN case_num ELSE 0 END) "07",
       SUM(CASE WHEN months = 08 THEN case_num ELSE 0 END) "08",
       SUM(CASE WHEN months = 09 THEN case_num ELSE 0 END) "09",
       SUM(CASE WHEN months = 10 THEN case_num ELSE 0 END) "10",
       SUM(CASE WHEN months = 11 THEN case_num ELSE 0 END) "11",
       SUM(CASE WHEN months = 12 THEN case_num ELSE 0 END) "12"
  FROM covid
 GROUP BY countryname
 UNION ALL
SELECT countryname, 
       '2.사망' gubun,
       SUM(CASE WHEN months = 01 THEN death_num ELSE 0 END) "01",
       SUM(CASE WHEN months = 02 THEN death_num ELSE 0 END) "02",
       SUM(CASE WHEN months = 03 THEN death_num ELSE 0 END) "03",
       SUM(CASE WHEN months = 04 THEN death_num ELSE 0 END) "04",
       SUM(CASE WHEN months = 05 THEN death_num ELSE 0 END) "05",
       SUM(CASE WHEN months = 06 THEN death_num ELSE 0 END) "06",
       SUM(CASE WHEN months = 07 THEN death_num ELSE 0 END) "07",
       SUM(CASE WHEN months = 08 THEN death_num ELSE 0 END) "08",
       SUM(CASE WHEN months = 09 THEN death_num ELSE 0 END) "09",
       SUM(CASE WHEN months = 10 THEN death_num ELSE 0 END) "10",
       SUM(CASE WHEN months = 11 THEN death_num ELSE 0 END) "11",
       SUM(CASE WHEN months = 12 THEN death_num ELSE 0 END) "12"
  FROM covid 
 GROUP BY countryname
 ORDER BY 1, 2 ;
 
 
SELECT *
FROM covid19_mon_v;
 
 
 
-- 시각화 query 
-- 1. 전 기간 가장 많은 사망자를 낸 상위 10개 국가 현황 조회
%sql
SELECT *
  FROM ( SELECT b.countryname,
                SUM(a.deaths) death_num
           FROM covid19_data a
          INNER JOIN covid19_country b
             ON a.countrycode = b.countrycode
          GROUP BY b.countryname
          ORDER BY 2 DESC
       )
 WHERE ROWNUM <= 10
 
-- 2. 전 기간 사망자 상위 10개 국가의 확진자와 사망자 현황 조회
%sql
SELECT *
  FROM ( SELECT b.countryname,
                SUM(a.deaths) death_num,
                SUM(a.cases) case_num
           FROM covid19_data a
          INNER JOIN covid19_country b
             ON a.countrycode = b.countrycode
          GROUP BY b.countryname
          ORDER BY 2 DESC
       )
 WHERE ROWNUM <= 10
 
 
-- 3. 한국의 월별 확진자 현황
%sql
SELECT TO_CHAR(issue_date, 'YYYY-MM') months,
       SUM(cases) 확진자수
  FROM covid19_data
 WHERE countrycode = 'KOR'
 GROUP BY TO_CHAR(issue_date, 'YYYY-MM')
 ORDER BY 1
 
 
-- 4.사망자 상위 5개 국가의 월별 사망자 현황
%sql
WITH covid1 AS (
SELECT a.countrycode, 
       SUM(a.deaths) death_num
  FROM covid19_data a
 GROUP BY a.countrycode
 ORDER BY 2 DESC
),
covid2 AS (
SELECT *
  FROM covid1
 WHERE ROWNUM <= 5 )
SELECT b.countryname,
       TO_CHAR(a.issue_date, 'YYYY-MM') months,
       SUM(a.deaths) death_num
  FROM covid19_data a
 INNER JOIN covid19_country b
    ON a.countrycode = b.countrycode
 WHERE EXISTS ( SELECT 1
                  FROM covid2 c
                 WHERE a.countrycode = c.countrycode)
 GROUP BY b.countryname, TO_CHAR(a.issue_date, 'YYYY-MM')
 ORDER BY 2
 
 
-- ETC
SELECT b.countryname,
       SUM(a.cases) cases_num
  FROM covid19_data a
 INNER JOIN covid19_country b
    ON a.countrycode = b.countrycode
 GROUP BY b.countryname;
 
 
 
