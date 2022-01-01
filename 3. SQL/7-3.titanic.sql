-- 3. 타이타닉 분석 
CREATE TABLE titanic2 AS
SELECT passengerid
      ,CASE WHEN survived = 0 THEN '사망' ELSE '생존' end survived
      ,TO_CHAR(pclass) || '등급' pclass  ,name
      ,DECODE(sex, 'male','남성', 'female','여성', '없음') gender
      ,age, sibsp ,parch  ,ticket ,fare  ,cabin
      ,CASE embarked WHEN 'C' THEN '프랑스-셰르부르'
                     WHEN 'Q' THEN '아일랜드-퀸즈타운'
                     WHEN 'S' THEN '영국-사우샘프턴'
                     ELSE ''
      END embarked
FROM titanic
ORDER BY 1;


-- (1-1) 성별 생존/사망자 수 
SELECT gender, survived, COUNT(*) cnt
  FROM titanic2
 GROUP BY gender, survived
 ORDER BY 1, 2;

-- (1-2) 성별 생존/사망자 수와 비율
SELECT gender, survived, cnt, 
              ROUND(cnt / SUM(cnt) OVER ( PARTITION BY gender ORDER BY gender),2) 비율
  FROM ( SELECT gender, survived, count(*) cnt
           FROM titanic2
          GROUP BY gender, survived
       ) t ;


--(2-1) 등급별 생존/사망자 수 

SELECT pclass, survived, COUNT(*) cnt
  FROM titanic2
 GROUP BY pclass, survived
 ORDER BY 1, 2;

-- (2-2) 등급별 생존/사망자 수와 비율

SELECT pclass, survived, cnt, 
       ROUND(cnt / SUM(cnt) OVER ( PARTITION BY pclass ORDER BY pclass),2) 비율
  FROM ( SELECT pclass, survived, count(*) cnt
           FROM titanic2
          GROUP BY pclass, survived
       ) t ;
       
       
-- (3) 연령대별 생존/사망자 수 
SELECT CASE WHEN age BETWEEN 1  AND 9 THEN '(1)10대 이하'
            WHEN age BETWEEN 10 AND 19 THEN '(2)10대'
            WHEN age BETWEEN 20 AND 29 THEN '(3)20대'
            WHEN age BETWEEN 30 AND 39 THEN '(4)30대'
            WHEN age BETWEEN 40 AND 49 THEN '(5)40대'
            WHEN age BETWEEN 50 AND 59 THEN '(6)50대'
            WHEN age BETWEEN 60 AND 69 THEN '(7)60대'
            ELSE '(8)70대 이상'
        END ages 
       ,survived, COUNT(*)
  FROM titanic2
 GROUP BY CASE WHEN age BETWEEN 1  AND 9 THEN '(1)10대 이하'
               WHEN age BETWEEN 10 AND 19 THEN '(2)10대'
               WHEN age BETWEEN 20 AND 29 THEN '(3)20대'
               WHEN age BETWEEN 30 AND 39 THEN '(4)30대'
               WHEN age BETWEEN 40 AND 49 THEN '(5)40대'
               WHEN age BETWEEN 50 AND 59 THEN '(6)50대'
               WHEN age BETWEEN 60 AND 69 THEN '(7)60대'
               ELSE '(8)70대 이상'
           END
          ,survived
ORDER BY 1,2; 


SELECT age
  FROM titanic2
 ORDER BY 1 DESC;

SELECT age
  FROM titanic2
 ORDER BY 1;


SELECT CASE WHEN age BETWEEN 0  AND 9  THEN '(1)10대 이하'
            WHEN age BETWEEN 10 AND 19 THEN '(2)10대'
            WHEN age BETWEEN 20 AND 29 THEN '(3)20대'
            WHEN age BETWEEN 30 AND 39 THEN '(4)30대'
            WHEN age BETWEEN 40 AND 49 THEN '(5)40대'
            WHEN age BETWEEN 50 AND 59 THEN '(6)50대'
            WHEN age BETWEEN 60 AND 69 THEN '(7)60대'
            ELSE '(8)70대 이상'
        END ages 
       ,survived, COUNT(*)
  FROM titanic2
 WHERE age IS NOT NULL -- NULL 제거  
 GROUP BY CASE WHEN age BETWEEN 1  AND 9  THEN '(1)10대 이하'
               WHEN age BETWEEN 10 AND 19 THEN '(2)10대'
               WHEN age BETWEEN 20 AND 29 THEN '(3)20대'
               WHEN age BETWEEN 30 AND 39 THEN '(4)30대'
               WHEN age BETWEEN 40 AND 49 THEN '(5)40대'
               WHEN age BETWEEN 50 AND 59 THEN '(6)50대'
               WHEN age BETWEEN 60 AND 69 THEN '(7)60대'
               ELSE '(8)70대 이상'
           END
          ,survived
ORDER BY 1,2; 



SELECT CASE WHEN age BETWEEN 0  AND 9  THEN '(1)10대 이하'
            WHEN age BETWEEN 10 AND 19 THEN '(2)10대'
            WHEN age BETWEEN 20 AND 29 THEN '(3)20대'
            WHEN age BETWEEN 30 AND 39 THEN '(4)30대'
            WHEN age BETWEEN 40 AND 49 THEN '(5)40대'
            WHEN age BETWEEN 50 AND 59 THEN '(6)50대'
            WHEN age BETWEEN 60 AND 69 THEN '(7)60대'
            WHEN age >= 70             THEN '(8)70대 이상'
            ELSE '(9)알수없음'
        END ages 
       ,survived, COUNT(*)
  FROM titanic2
 GROUP BY CASE WHEN age BETWEEN 1  AND 9  THEN '(1)10대 이하'
               WHEN age BETWEEN 10 AND 19 THEN '(2)10대'
               WHEN age BETWEEN 20 AND 29 THEN '(3)20대'
               WHEN age BETWEEN 30 AND 39 THEN '(4)30대'
               WHEN age BETWEEN 40 AND 49 THEN '(5)40대'
               WHEN age BETWEEN 50 AND 59 THEN '(6)50대'
               WHEN age BETWEEN 60 AND 69 THEN '(7)60대'
               WHEN age >= 70             THEN '(8)70대 이상'
               ELSE '(9)알수없음'
           END
          ,survived
ORDER BY 1,2; 


-- (5) 형제,배우자 수별 부모자식수별 생존/사망자 수

SELECT sibsp, parch, survived, count(*)
  FROM titanic2
 GROUP BY sibsp, parch, survived
 ORDER BY 1, 2, 3;
 
-- titanic Graph Query
SELECT gender, survived, COUNT(*) cnt
  FROM titanic2
 GROUP BY gender, survived;


SELECT pclass, survived, count(*)
  FROM titanic2
GROUP BY pclass, survived
ORDER BY pclass, survived;


SELECT sibsp, survived, count(*)
  FROM titanic2
 GROUP BY sibsp, survived
 ORDER BY 1, 2;
 
 
SELECT parch, survived, count(*)
  FROM titanic2
 GROUP BY parch, survived
 ORDER BY 1, 2;

