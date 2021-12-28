1. Jobs 테이블에는 min_salary와 max_salary란 컬럼이 있는데, 이는 해당 job_id에 대한 최소와 최대급여 금액을 담고 있습니다. Jobs 테이블과 employees 테이블을 조인하고 사원의 급여가 최소와 최대급여 금액을 벗어난 사원이 있는지 조회하는 쿼리를 작성해 보세요.

-->
SELECT a.employee_id, a.first_name || ' ' || a.last_name emp_names
 FROM employees a,
      jobs b
 WHERE a.job_id = b.job_id
  AND a.salary NOT BETWEEN b.min_salary AND b.max_salary
 ORDER BY 1;
     
2. 아래 외부조인 문장을 실행하면 내부조인을 한 것과 결과가 같습니다. 왜 이런 결과가 나왔는지 설명해 보세요.
SELECT a.employee_id, a.first_name || ' ' || a.last_name emp_names, b.*
 FROM employees a,
      job_history b
 WHERE a.employee_id(+) = b.employee_id
 ORDER BY 1;
-->
a쪽 테이블 조인조건에 (+)가 붙어 있으므로 b, 즉 job_history 테이블쪽 데이터 중 조인조건에 부합하지
않는 데이터가 조회되어야 합니다.
그런데 job_history 테이블에 있는 employee_id 값은 모두 employees 테이블에 존재하므로 내부조인을 한 것과 같은 결과가 조회되는 것입니다.

3. 실습시간 마지막에 배웠던 셀프조인의 경우 사번이 100번인 Steven King은 조회되지 않습니다. 그 이유는 뭘까요?
-->
사번이 100번인 Steven King의 경우 manager_id 값이 null 이라서 조인조건에서 누락되어 조회되지 않습니다.

4. 실습시간 마지막에 배웠던 셀프조인에서 누락된 사번이 100번인 Steven King 까지 조회되도록 쿼리를 작성해 보세요.
-->
SELECT a.employee_id
    ,a.first_name || ' ' || a.last_name emp_name
    ,a.manager_id
    ,b.first_name || ' ' || b.last_name manager_name
 FROM employees a
 LEFT JOIN employees b
  ON a.manager_id = b.employee_id
ORDER BY 1;

5. Quiz 1-2-6번 문제인 EMPLOYEES 테이블에서 FIRST_NAME이 'David'이고 급여가 6000이상인 사람이 속한 부서가 위치한 도시를 찾는 쿼리를 3문장이 아닌 1문장으로 작성해 보세요.
-->
SELECT a.employee_id, a.first_name, a.last_name, a.salary, b.department_name, c.city
 FROM employees a,
    departments b,
    locations c
WHERE a.first_name = 'David'
  AND a.salary > 6000
  AND a.department_id = b.department_id
  AND b.location_id = c.location_id ;
  
6. ORDERS, CUSTOMERS, STORES, STAFFS 테이블을 조인해 2018년 1월 주문 내역에 대해 다음 결과처럼 조회하는 쿼리를 작성해 보세요.
-->
SELECT a.order_id , a.order_date
    ,b.first_name || ' ' || b.last_name customer_name
    ,c.store_name
    ,d.first_name || ' ' || d.last_name staff_name
FROM orders a,
    customers b,
    stores c,
    staffs d
WHERE a.order_date BETWEEN TO_DATE('2018-01-01','YYYY-MM-DD')
      AND TO_DATE('2018-01-31','YYYY-MM-DD')
      AND a.customer_id = b.customer_id
      AND a.store_id = c.store_id
      AND a.staff_id = d.staff_id
ORDER BY 2;

7. ORDERS, ORDER_ITEMS 테이블을 조인해 2018년 월별 주문금액 합계를 조회하는 쿼리를 ANSI 조인으로 작성해 보세요. (주문금액 = order_items 의 quantity * list_price)
-->
SELECT TO_CHAR(a.order_date, 'YYYY-MM') months ,SUM(b.quantity * b.list_price) order_amt
FROM ORDERS A
INNER JOIN ORDER_ITEMS B
ON A.ORDER_ID = B.ORDER_ID
WHERE a.order_date BETWEEN TO_DATE('2018-01-01','YYYY-MM-DD')
AND TO_DATE('2018-12-31','YYYY-MM-DD') GROUP BY TO_CHAR(a.order_date, 'YYYY-MM')
ORDER BY 1;
