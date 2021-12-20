-- 내부조인 

-- 1-0. 내부조인
SELECT  a.employee_id, 
        a.first_name, 
        a.department_id, 
        b.department_name
   FROM employees a, departments b
    WHERE a.department_id = b.department_id
    ORDER BY a.employee_id;
    
SELECT  a.employee_id, 
        a.first_name, a.last_name,
        a.department_id
   FROM employees a
    WHERE a.department_id IS NULL
    ORDER BY a.employee_id;    

-- 1-1. 내부조인
SELECT a.employee_id, a.first_name || ' ' || a.last_name emp_names, 
       a.job_id, b.job_id, b.job_title
  FROM employees a,
       jobs b
 WHERE a.job_id = b.job_id
 ORDER BY 1;
 
-- 1-2.내부조인 
SELECT a.employee_id, a.first_name || ' ' || a.last_name emp_names, 
       job_id, b.job_title
  FROM employees a,
       jobs b
 WHERE a.job_id = b.job_id
 ORDER BY 1; 
 
-- 1-3.내부조인
SELECT a.employee_id, a.first_name || ' ' || a.last_name emp_names, 
       a.job_id, b.job_id, job_title
  FROM employees a,
       jobs b
 WHERE a.job_id = b.job_id
 ORDER BY 1;  
 
-- 2.내부조인
SELECT a.employee_id, a.first_name || ' ' || a.last_name emp_names, 
       b.job_title,
       c.department_id ,c.department_name
  FROM employees a,
       jobs b,
       departments c
 WHERE a.job_id        = b.job_id
   AND a.department_id = c.department_id
 ORDER BY 1; 
 
-- 3.내부조인
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_names, 
       b.job_title, c.department_name,
       d.location_id, d.street_address, d.city, d.state_province
  FROM employees a,
       jobs b,
       departments c,
       locations d
 WHERE a.job_id        = b.job_id
   AND a.department_id = c.department_id
   AND c.location_id   = d.location_id 
 ORDER BY 1;  
 
-- 4.내부조인
SELECT a.employee_id 
      ,a.first_name || ' ' || a.last_name emp_names
      ,b.job_title ,c.department_name
      ,d.street_address, d.city
      ,e.country_name
  FROM employees a,
       jobs b,
       departments c,
       locations d,
       countries e
 WHERE a.job_id        = b.job_id
   AND a.department_id = c.department_id
   AND c.location_id   = d.location_id 
   AND d.country_id    = e.country_id
 ORDER BY 1;   
 
-- 5.내부조인
SELECT a.employee_id 
      ,a.first_name || ' ' || a.last_name emp_names
      ,b.job_title ,c.department_name
      ,d.street_address, d.city
      ,e.country_name ,f.region_name
  FROM employees a,
       jobs b,
       departments c,
       locations d,
       countries e,
       regions f
 WHERE a.job_id        = b.job_id
   AND a.department_id = c.department_id
   AND c.location_id   = d.location_id 
   AND d.country_id    = e.country_id
   AND e.region_id     = f.region_id
 ORDER BY 1;    
 

 
-- 외부조인
-- 1.외부조인
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_names, 
       b.department_id, b.department_name
  FROM employees a,
       departments b
 WHERE a.department_id = b.department_id(+)
 ORDER BY 1; 
 
-- 2.외부조인
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_names, 
       b.department_id, b.department_name
  FROM employees a,
       departments b
 WHERE a.department_id(+) = b.department_id
 ORDER BY 1; 
 
-- 3.외부조인
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_names, 
       c.department_id, c.department_name,
       d.location_id, d.street_address, d.city
  FROM employees a,
       departments c,
       locations d
 WHERE a.department_id = c.department_id(+)
   AND c.location_id   = d.location_id
 ORDER BY 1;
 
 
-- 4.외부조인
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_names, 
       c.department_id, c.department_name,
       d.location_id, d.street_address, d.city
  FROM employees a,
       departments c,
       locations d
 WHERE a.department_id = c.department_id(+)
   AND c.location_id   = d.location_id(+)
 ORDER BY 1;
