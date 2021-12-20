-- ANSI 조인 
-- 1.ANSI 내부조인
SELECT  a.employee_id    emp_id, 
        a.department_id  a_dept_id, 
        b.department_id   b_dept_id,
        b.department_name dept_name
   FROM employees a
  INNER JOIN departments b
     ON a.department_id = b.department_id 
  ORDER BY a.employee_id;

-- 2.ANSI 외부조인(LEFT)
SELECT a.employee_id    emp_id, 
       a.department_id  a_dept_id, 
       b.department_id b_dept_id,
       b.department_name dept_name
  FROM employees a
  LEFT OUTER JOIN departments b
    ON a.department_id = b.department_id 
 ORDER BY a.employee_id;

-- 3.ANSI 외부조인(RIGHT)
SELECT a.employee_id    emp_id, 
       a.department_id  a_dept_id, 
       b.department_id b_dept_id,
       b.department_name dept_name
  FROM employees a
 RIGHT OUTER JOIN departments b
    ON a.department_id = b.department_id 
 ORDER BY a.employee_id, b.department_id;

-- 4.오라클 외부조인 오류 문장 
SELECT a.employee_id    emp_id, 
       a.department_id  a_dept_id, 
       b.department_id b_dept_id,
       b.department_name dept_name
  FROM employees a, departments b
 WHERE a.department_id(+) = b.department_id(+)
 ORDER BY b.department_id;

-- 5. ANSI FULL OUTER 조인 
SELECT a.employee_id    emp_id, 
       a.department_id  a_dept_id, 
       b.department_id b_dept_id,
       b.department_name dept_name
  FROM employees a
  FULL OUTER JOIN departments b
    ON a.department_id = b.department_id 
 ORDER BY a.employee_id,
          b.department_id;

-- 6. ANSI 내부조인 
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_names, 
       a.job_id, b.job_id, b.job_title
  FROM employees a
  INNER JOIN jobs b
    ON a.job_id = b.job_id
 ORDER BY 1;

-- 7. ANSI 내부조인 
SELECT a.employee_id, a.first_name || ' ' || a.last_name emp_names, 
       b.job_title
      ,c.department_id ,c.department_name
  FROM employees a
  INNER JOIN jobs b
    ON a.job_id        = b.job_id
  INNER JOIN departments c
    ON a.department_id = c.department_id
 ORDER BY 1; 

-- 8. ANSI 내부조인과 WHERE 조건 
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_names, 
       a.job_id, b.job_id, b.job_title
      ,c.department_id ,c.department_name
  FROM employees a
  INNER JOIN jobs b
    ON a.job_id        = b.job_id
  INNER JOIN departments c
    ON a.department_id = c.department_id
 WHERE b.job_id = 'SH_CLERK'   
 ORDER BY 1;  
 
 
-- ANSI 외부조인
-- 1.ANSI 외부조인과 내부조인 
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_names, 
       c.department_id, c.department_name,
       d.location_id, d.street_address, d.city
  FROM employees a
  LEFT JOIN departments c
    ON a.department_id = c.department_id
 INNER JOIN locations d
    ON c.location_id   = d.location_id
 ORDER BY 1;
 
 
-- 2. ANSI LEFT 조인 
SELECT a.employee_id, 
       a.first_name || ' ' || a.last_name emp_names, 
       c.department_id, c.department_name,
       d.location_id, d.street_address, d.city
  FROM employees a
  LEFT JOIN departments c
    ON a.department_id = c.department_id
  LEFT JOIN locations d
    ON c.location_id   = d.location_id
 ORDER BY 1;


-- 3. Cartesian product
SELECT a.region_name, b.department_id, b.department_name 
  FROM regions a
      ,departments b
  WHERE 1=1;

-- CROSS JOIN
SELECT a.region_name, b.department_id, b.department_name 
FROM REGIONS a 
CROSS JOIN DEPARTMENTS b
where 1=1;
 

-- 4. 셀프조인
SELECT a.employee_id
      ,a.first_name || ' ' || a.last_name emp_name
      ,a.manager_id
      ,b.first_name || ' ' || b.last_name manager_name
 FROM employees a
     ,employees b
WHERE a.manager_id = b.employee_id
ORDER BY 1;

-- 5. ANSI 셀프조인
SELECT a.employee_id
      ,a.first_name || ' ' || a.last_name emp_name
      ,a.manager_id
      ,b.first_name || ' ' || b.last_name manager_name
 FROM employees a
 INNER JOIN employees b
    ON a.manager_id = b.employee_id
ORDER BY 1;
