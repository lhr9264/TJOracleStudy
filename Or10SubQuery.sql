/*********************
파일명 : Or10SubQuery.sql
서브쿼리
설명 : 쿼리문안에 또 다른 쿼리문이 들어가는 형태의 select문
**********************/
/*
단일행 서브쿼리
    형식]
        select * from 테이블명 where 컬럼=(
            select 컬럼 from 테이블명 where 조건
        );
    ※ 괄호안의 서브쿼리는 반드시 하나의 결과를 인출해야한다.
*/

/*
시나리오] 사원테이블에서 전체사원의 평균급여보다 낮은 급여를 받는 사원들을 
추출하여 출력하시오.
    출력항목 : 사원번호, 이름, 이메일, 연락처, 급여
*/ 
/* 시나리오와 문맥상 맞는 쿼리문처럼 보이지만 그룹함수를 단일컬럼에
적용한 잘못된 쿼리문이므로 에러가 발생한다.  */
select * from employees where salary<avg(salary);
--1. 평균급여 구하기 : 6462
select round(avg(salary)) from employees;
--2. 앞에서 구한 값을 조건으로 평균급여보다 작은 직원을 인출한다. 
select * from employees where salary<6462;
--3. 1번과 2번을 합쳐서 하나의 서브쿼릴문으로 작성할수 있다.
select * from employees where salary<(
    select round(avg(salary)) from employees
);

/*
시나리오] 전체 사원중 급여가 가장적은 사원의 이름과 급여를 출력하는 
서브쿼리문을 작성하시오.
출력항목 : 이름1, 이름2, 이메일, 급여
*/
--최소급여를 확인
select min(salary) from employees;
--2100을 받는 직원을 확인한다.
select * from employees where salary=2100;
--2개의 쿼리문을 합쳐서 서브쿼리를 만든다.
select * from employees where salary=(
    select min(salary) from employees
);

/*
시나리오] 평균급여보다 많은 급여를 받는 사원들의 명단을 조회할수 있는 
서브쿼리문을 작성하시오.
출력내용 : 이름1, 이름2, 담당업무명, 급여
※ 담당업무명은 jobs 테이블에 있으므로 join해야 한다. 
*/
--평균급여 계산
select avg(salary) from employees;
--테이블을 조인하여 조건에 맞는 레코드 인출
select
    first_name, last_name, job_title
from employees 
    inner join jobs using(job_id)
where salary>6461.83;
--2개를 합쳐서 서브쿼리문으로 완성
select
    first_name, last_name, job_title, salary
from employees inner join jobs using(job_id)
where salary>(
    select avg(salary) from employees
);

/*
복수행 서브쿼리
형식] select * from 테이블명 where 컬럼 in(
            select 컬럼 from 테이블명 where 조건
        )
    ※ 괄호안의 서브쿼리는 2개 이상의 결과를 인출해야 한다. 
*/
/*
시나리오] 담당업무별로 가장 높은 급여를 받는 사원의 명단을 조회하시오.
    출력목록 : 사원아이디, 이름, 담당업무아이디, 급여
*/
--담당업무별로 가장 높은 급여를 확인한다. job_id를 그룹으로 묶어준다.
select job_id, max(salary)
from employees group by job_id;
/* 앞에서 나온 결과를 바탕으로 단순한 or 조건으로 쿼리를 작성해본다.
19개의 결과가 인출되었지만 너무 많으므로 4개만으로 결과를 확인해본다. */
select * from employees where
    (job_id='AD_PRES' and salary=24000) or
    (job_id='AD_VP' and salary=17000) or
    (job_id='IT_PROG' and salary=9000) or
    (job_id='FI_MGR' and salary=12008);
/* 2개의 쿼리를 하나의 서브쿼리문으로 합쳐준다. 2개의 컬럼을 이용해야
하므로 괄호로 묶은후 좌측과 우측을 1:1로 매칭시켜준다. */
select * from employees where
    (job_id, salary) in (
        select job_id, max(salary)
        from employees group by job_id
    );
    
/*
복수행 연산자 : any
    메인쿼리의 비교조건이 서브쿼리의 검색결과와 하나 이상
    일치하면 참이되는연산자. 즉 둘중 하나만 만족하면 해당 레코드를
    인출한다. 
*/

/*
시나리오] 전체 사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를
    받는 직원들을 인출하는 서브쿼리문을 작성하시오. 단 둘중 하나만
    만족하더라도 인출하시오. 
*/
--20번 부서의 급여를 확인한다.
select first_name, salary from employees 
    where department_id=20;
--결과를 단순한 or절로 작성한다.
select first_name, salary from employees 
    where salary>13000 or salary>6000;
/* 둘중 하나만 만족하면 되므로 복수행 연산자 any를 이용해서 서브쿼리를
만들면된다. 즉 6000 혹은 13000보다 큰 조건으로 쿼리문이 실행된다. */
select first_name, salary from employees 
    where salary > any (
        select salary from employees 
        where department_id=20
    );
    


----------------
select first_name, rownum from employees order by employee_id;

/*
rownum을 우리가 정렬한 순서대로 재부여하기 위해 서브쿼리를 사용한다.
from절에는 테이블이 들어와야 하지만, 아래의 서브쿼리에서는 사원의테이블의
전체레코드를 대상으로 하되 이름의 오름차순으로 정렬된 상태를 레코드를
가져오게 되므로 테이블을 대체할수 있게된다. 
*/

select first_name, rownum from
    (select * from employees order by first_name);

/*
이름을 기준으로 오름차순 정렬된 레코드에 rownum을 부여하였으므로
where절에 아래와 같은 조건을 통해 구간을 정해서 select 할수 있다.
비교연산자 대신 between절을 사용해도 된다.
*/
select * from
    (select first_name, rownum rNum from
        (select * from employees order by first_name) tb)
/* where rNum>=1 and rNum<=10; */
/* where rNum>=11 and rNum<=20;*/
where rNum between 21 and 30;
--JSP 수업에서 게시판 Paging시 다시 돌아온다--