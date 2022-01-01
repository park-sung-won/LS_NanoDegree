-- fine dust 
-- fine_dust 테이블 생성
CREATE TABLE fine_dust (
    gu_name           VARCHAR2(50) NOT NULL,  -- 구 명
    mea_station       VARCHAR2(30) NOT NULL,  -- 측정소
    mea_date          DATE         NOT NULL,  -- 측정일자
    pm10              NUMBER,                 -- 미세먼지농도
    pm25              NUMBER                  -- 초미세먼지농도
);

ALTER TABLE fine_dust
ADD CONSTRAINTS fine_dust_pk PRIMARY KEY (gu_name, mea_station, mea_date);


-- fine_dust_standard 테이블 생성

CREATE TABLE fine_dust_standard (
    org_name          VARCHAR2(50) NOT NULL,  -- 기관명
    std_name          VARCHAR2(30) NOT NULL,  -- 미세먼지 기준
    pm10_start        NUMBER,                 -- 미세먼지농도(시작)
    pm10_end          NUMBER,                 -- 미세먼지농도(끝)
    pm25_start        NUMBER,                 -- 초미세먼지농도(시작)
    pm25_end          NUMBER                  -- 초미세먼지농도  (끝)  
);

ALTER TABLE fine_dust_standard
ADD CONSTRAINTS fine_dust_standard_pk PRIMARY KEY (org_name, std_name);


-- (1) 월간 미세먼지와 초미세먼지의 최소,최대,평균값 구하기

-- 월간 미세먼지 - 최소,최대,평균 1
SELECT TO_CHAR(a.mea_date, 'YYYY-MM') months
       ,ROUND(MIN(a.pm10),0) pm10_min
       ,ROUND(MAX(a.pm10),0) pm10_max
       ,ROUND(AVG(a.pm10),0) pm10_avg
       ,ROUND(MIN(a.pm25),0) pm25_min
       ,ROUND(MAX(a.pm25),0) pm25_max
       ,ROUND(AVG(a.pm25),0) pm25_avg
  FROM fine_dust a
 GROUP BY  TO_CHAR(mea_date, 'YYYY-MM')
 ORDER BY 1;
 
-- 월간 미세먼지 - 최소,최대,평균 2
SELECT TO_CHAR(a.mea_date, 'YYYY-MM') months
       ,ROUND(MIN(a.pm10),0) pm10_min
       ,ROUND(MAX(a.pm10),0) pm10_max
       ,ROUND(AVG(a.pm10),0) pm10_avg
       ,ROUND(MIN(a.pm25),0) pm25_min
       ,ROUND(MAX(a.pm25),0) pm25_max
       ,ROUND(AVG(a.pm25),0) pm25_avg
  FROM fine_dust a
 WHERE pm10 > 0
   AND pm25 > 0
 GROUP BY  TO_CHAR(mea_date, 'YYYY-MM')
 ORDER BY 1;
 
 

-- (2) 월 평균 미세먼지 현황

SELECT *
FROM fine_dust_standard;
 
 
-- 월 편균 미세먼지  
SELECT TO_CHAR(a.mea_date, 'YYYY-MM') months
       ,ROUND(AVG(a.pm10),0) pm10_avg
       ,ROUND(AVG(a.pm25),0) pm25_avg
  FROM fine_dust a
 WHERE pm10 > 0
   AND pm25 > 0
 GROUP BY  TO_CHAR(mea_date, 'YYYY-MM')
 ORDER BY 1;

-- 월 평균 미세먼지 현황
SELECT a.months
      ,a.pm10_avg
      ,( SELECT b.std_name
           FROM fine_dust_standard b
          WHERE b.org_name = 'WHO'
            AND a.pm10_avg BETWEEN b.pm10_start
                               AND b.pm10_end
       ) "미세먼지 상태"
      ,a.pm25_avg
      ,( SELECT b.std_name
           FROM fine_dust_standard b
          WHERE b.org_name = 'WHO'
            AND a.pm25_avg BETWEEN b.pm25_start
                               AND b.pm25_end
       ) "초미세먼지 상태"      
FROM ( -- 월평균 미세먼지 농도 서브쿼리
       SELECT TO_CHAR(a.mea_date, 'YYYY-MM') months
             ,ROUND(AVG(a.pm10),0) pm10_avg
             ,ROUND(AVG(a.pm25),0) pm25_avg
        FROM fine_dust a
       WHERE a.pm10 > 0
         AND a.pm25 > 0 
       GROUP BY TO_CHAR(mea_date, 'YYYY-MM')
     ) a
ORDER BY 1; 
