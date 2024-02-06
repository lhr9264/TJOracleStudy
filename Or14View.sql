/*
파일명 : Or14View.sql
view(뷰)
설명 : View는 테이블로부터 생성된 가상의 테이블로 물리적으로는 존재하지
    않고 논리적으로 존재하는 테이블이다.
*/

--hr계정에서 실습합니다.

/*
뷰의 생성
형식] create [or replace] view 뷰의 이름 [(컬럼1, 컬럼2,...)]
     as
     select * from 테이블명 where 조건
     혹은 join이 있는 select문
     group by가 추가된 select문 등..
*/

/*
시나리오] hr계정의 사원테이블에서 담당업무가 ST_CLERK인 사원의 정보를
        조회할 수 있는 View를 생성하시오.
        출력항목 : 사원아이디, 이름, 직무아이디, 입사일, 부서아이디
*/
--1.시나리오의 조건대로 select문을 생성한다.
select
    employee_id, first_name, job_id, hire_date, department_id
from employees where job_id='ST_CLERK';
--2.뷰 생성하기
create view view_employees
as
    select
        employee_id, first_name, job_id, hire_date, department_id
    from employees where job_id='ST_CLERK';
--3.뷰 실행하기
select * from view_employees;
--4.데이터사전에서 확인하기(생성시 사용한 쿼리문이 그대로 저장된다)
select * from user_views;

/*
뷰 수정하기
    : 뷰 생성 문장에 or replace 만 추가하면된다.
    해당 뷰가 존재하면 수정되고, 망냑 존재하지 않으면 새롭게 생성된다.
    따라서 최초로 뷰를 생성할때부터 사용해도 무방하다.
*/

/*
시나리오] 앞에서 생성한 뷰를 다음과 같이 수정하시오.
    기존 컬럼인 employee_id, first_name, job_id, hire_date,
    department_id를
    id, fname, jobid, hdate, deptid 로 수정하여 뷰를 생성하시오.
*/
create or replace view view_employees
    (id, fname, jobid, hdate, deptid)
as
    select
        employee_id, first_name, job_id, hire_date,department_id
    from employees where job_id='ST_CLERK';
select * from view_employees;
/*
    뷰 생성시 기존테이블의 컬럼명을 변경해서 출력하고 싶다면 위와같이
    변경할 컬럼명을 뷰이름 뒤에 소괄호로 명시해주면 된다.
*/

/*
퀴즈] 담당업무 아이디가 ST_MAN인 사원의 사원번호, 이름, 이메일, 매니져아이디를
    조회할 수 있도록 생성하시오.
    뷰의 컬럼명은 e_id, name, email, m_id로 지정한다. 단, 이름은 
    first_name과 last_name이 연결된 형태로 출력하시오.
	뷰명 : emp_st_man_view
*/
--문제의 조건대로 select문 작성
select
    employee_id, concat(first_name||' ', last_name), email,
    manager_id
from employees where job_id='ST_MAN';
--뷰 생성시 컬럼에 대한 별칭 지정
create or replace view emp_st_man_view (e_id, name, email, m_id)
as
    select
    employee_id, concat(first_name||' ', last_name), email,
    manager_id
from employees where job_id='ST_MAN';
--뷰 확인
select * from emp_st_man_view;

/*
퀴즈] 사원번호, 이름, 연봉을 계산하여 출력하는 뷰를 생성하시오.
컬럼의 이름은 emp_id, l_name, annual_sal로 지정하시오.
연봉계산식 -> (급여+(급여*보너스율))*12
뷰이름 : v_emp_salary
단, 연봉은 세자리마다 컴마가 삽입되어야 한다. 
*/
--select문 작성
select
    employee_id, last_name,
    trim(to_char((salary+(salary*nvl(commission_pct, 0)))*12,'999,000'))
from employees;
--뷰로 생성
/* 생성시 연산식이 추가되어 논리적으로 컬럼이 추가되는 경우에는 반드시
별칭으로 컬럼명을 명시해야한다. 그렇지 않으면 에러가 발생한다. */
create or replace view v_emp_salary (emp_id, l_name, annual_sal)
as
select 
    employee_id, last_name,
    trim(to_char((salary+(salary*nvl(commission_pct, 0)))*12,'999,000'))
from employees;
select * from v_emp_salary;

/*
-조인을 통한 View 생성
시나리오] 사원테이블과 부서테이블, 지역테이블을 조인하여 다음 조건에 맞는 
뷰를 생성하시오.
출력항목 : 사원번호, 전체이름, 부서번호, 부서명, 입사일자, 지역명
뷰의명칭 : v_emp_join
뷰의컬럼 : empid, fullname, deptid, deptname, hdate, locname
컬럼의 출력형태 : 
	fullname => first_name+last_name 
	hdate => 0000년00월00일
    locname => XXX주의 YYY (ex : Texas주의 Southlake)	
*/
--1.select문을 작성한다.
select
    employee_id, first_name||' '||last_name,
    department_id, department_name,
    to_char(hire_date, 'yyyy"년"mm"월"dd"일"'),
    state_province||'주 의'||city
from employees
    inner join departments using(department_id)
    inner join locations using(location_id);
--2.View 생성하기
create or replace view v_emp_join
    (empid, fullname, deptid, deptname, hdate, locname)
as
select
    employee_id, first_name||' '||last_name,
    department_id, department_name,
    to_char(hire_date, 'yyyy"년"mm"월"dd"일"'),
    state_province||'주 의'||city
from employees
    inner join departments using(department_id)
    inner join locations using(location_id);
--3.복잡한 쿼리문을 view를 통해 간단히 조회할 수 있다.
select * from v_emp_join;
