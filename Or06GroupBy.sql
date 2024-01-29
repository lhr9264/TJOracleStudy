/***************************
파일명 : Or06GroupBy.sql
그룹함수(select문 2번째)
설명 : 전체 레코드*로우)에서 통계적인 결과를 구하기
    위해 하나 이상의 렐코드를 그룹으로 묶어서 연산후
    결과를 반환하는 함수 혹은 쿼리문
****************************/
--사원테이블에서 담당업무 인출. 총107개가 인출된다.
select job_id from employees;
/*
distinct
-동일한 값이 있는 경우 중복된 레코드를 제거한 후 하나의 레코드만 가져와서
보여준다.
-순수한 하나의 레코드이므로 통계적인 값을 계산할 수 없다.
*/
select distinct job_id from employees;
/*
group by
-동일한 값이 있는 레코드를 하나의 그룹으로 묶어서 인출한다.
-보여지는건 하나의 레코드지만 다수의 레코드가 하나의 그룹으로 묶여진
결과이므로 통계적인 값을 계산할 수 있다.
-최대, 최소, 평균, 합산 등의 연산이 가능하다.
*/
select job_id from employees group by job_id;

--각 담당업무별 직원수는 몇명일까요??
select job_id, count(*) from employees group by job_id;
/* count() 함수를 통해 인출된 행의 갯수는 아래와 같이 일반적인 select문을
통해 검증할 수 있다. */
select * from employees where job_id='IT_PROG';--5개
select * from employees where job_id='SH_CLERK';--20개

/*
group by 절이 포함된 select문의 형식
    select
        컬럼1, 컬럼2 ... 혹은 전체(*)
    from
        테이블명
    where
        조건1 and 조건2 or 조건3식(물리적으로 존재하는 컬럼)
    group by
        레코드의 그룹화를 위한 컬럼명
    having
        그룹에서의 조건(논리적으로 생성된 컬럼)
    order by
        정렬을 위한 컬럼명과 정렬방식
*/

/*
sum() : 합게를 구할때 사용하는 함수
-number 타입의 컬럼에서만 사용할 수 있다.
-필드명이 필요한 경우 as를 이용해서 별칭을 부여할 수 있다.
*/
--전체직원의 급여의 합계를 출력하시오.
select
    sum(salary),
    to_char(sum(salary), '999,000')
from employees;

--10번 부서에 근무하는 사원들의 급여 합계는 얼마인지 출력하시오.  
select
    ltrim(to_char(sum(salary), '$999,999,000'))
from employees where department_id=10;

--sum()과 같은 그룹함수는 number 타입인컬럼에서만 사용할 수 있다.
select sum(first_name) from employees;--에러발생

/*
count() : 그룹화된 레코드의 갯수를 카운트할때 사용하는 함수.
*/
select count(*) from employees;
select count(employee_id) from employees;
/*
    count() 함수를 사용할때는 위 2가지 방법 모두 가능하지만
    *를 사용할것을 권장한다. 컬럼의 특성 혹은 데이터에 따른
    방해를 받지 않으므로 실행속도가 빠르다.
*/

/*
count() 함수의
    사용법1 : count(all 컬럼명)
        => 디폴트 사용법으로 컬럼 전체의 레코드를 기준으로 카운트한다.
    사용법2 : count(distinct 컬럼명)
        => 중복을 제거한 상태에서 카운트 한다.
*/
select
    count(job_id) "담당업무전체갯수1",
    count(all job_id) "담당업무전체갯수2",
    count(distinct job_id) "순수담당업무갯수"
from employees;

/*
avg() : 평균값을 구할때 사용하는 함수
*/
--전체사원의 평균급여는 얼마인지 출력하는 쿼리문을 작성하시오.
select
    count(*) "전체사원수",
    sum(salary) "사원급여의합",
    sum(salary)/count(*) "평균급여(직접계산)",
    trim(to_char(avg(salary), '990,000.00')) "숫자서식적용"
from employees;

--영업팀(SALES)의 평균급여는 얼마인가요??
--1.부서테이블에서 영업팀의 부서번호가 무엇인지 확인한다.
select * from departments where department_name='SALES';
--컬럼 자체의 값을 대문자로 변환 후 쿼리의 조건으로 사용한다.
select * from departments where 
    upper(department_name)='SALES';--80번 부서 확인
--80번 부서에서 근무하는 직원들의 급여 평균을 구해 출력한다.
select trim(to_char(avg(salary), '$999,000.0'))
from employees where department_id=80;

/*
min(), max() : 최대값, 최소값을 찾을때 사용하는 함수
*/
--전체 사원중 급여가 가장 적은 직원은 누구인가요??
/* 아래 쿼리문은 에러가 발생된다. 그룹함수는 일반컬럼에 바로 사용할 수
없다. 이와 같은 경우에는 뒤에서 학습할 '서브쿼리'를 사용해야 한다.*/
select first_name, salary from employees where salary=min(salary);

--전체 사원중 가장 낮은 급여는 얼마인가요??
/* 물리적으로 존재하는 salary 컬럼중에서 가장 작은값을 찾는것은 아래와
같이 처리할 수 있다. */
select min(salary) from employees; -- 2100 인출

--따라서 2100불을 받는 직원을 찾으면 첫번째 질문을 해결할 수 있다. 
select first_name, salary from employees 
    where salary=2100;
    
--위 2개의 쿼리문을 합치면 아래와 같은 서브쿼리가 된다.
select first_name, last_name, salary from employees
    where salary=(select min(salary) from employees);
    
/*
group by절 : 여러개의 레코드를 하나의 그룹으로 그룹화하여 묶어진
    결과를 반환하는 쿼리문.
    ※ distinct 는 단순히 중복값을 제거함.
*/
--사원테이블에서 각 부서별 급여의 합계는 얼마인가요??
--IT 부서의 급여합계
select sum(salary) from employees where department_id=60;
--Finace 부서의 급여합계
select sum(salary) from employees where department_id=100;
/* 
1단계 : 부서가 많은경우 일일이 부서별로 확일할 수 없으므로 부서를 그룹화
    한다. 중복이 제거된 결과로 보이지만 동일한 레코드가 하나의 그룹으로
    합쳐진 결과가 인출된다.
*/
select department_id from employees group by department_id;
/*
2단계 : 각 부서별로 급여의 합계를 구할 수 있다. 
*/
select department_id, sum(salary), to_char(sum(salary),'$990,000')
from employees group by department_id;
/* 아래 쿼리문은 부서번호를 그룹으로 묶어서 결과를 인출하므로, 이름을
기술하면 에러가 발생된다. 각 레코드별로 서로 다른 이름이 저장되어 있으므로
그룹의 조건에 단일 컬럼을 사용할 수  없기때문이다. */
select department_id, first_name from employees
    group by department_id;--에러발생
    
/*
퀴즈] 사원테이블에서 각 부서별 사원수와 평균급여는 얼마인지 출력하는 
쿼리문을 작성하시오. 
출력결과 : 부서번호, 급여총합, 사원총합, 평균급여
출력시 부서번호를 기준으로 오름차순 정렬하시오. 
*/

select department_id ,
trim(to_char(sum(salary), '999,000'))"급여총합", 
count(*)"사원총합",
trim(to_char(avg(salary), '999,000'))"평균급여"
from employees group by department_id order by department_id;

/* 앞에서 사용했던 쿼리문을 아래와 같이 수정하면 에러가 발생한다.
group by 절에서 사용한 컬럼은 select절에서 사용할 수 있으나, 그 외의
단일 컬럼은 사용할 수 없다.
그룹화된 상태에서 특정 레코드 하나만 선택하는 것은 애매하기 때문이다. */
select department_id ,
trim(to_char(sum(salary), '999,000'))"급여총합", 
count(*)"사원총합",
trim(to_char(avg(salary), '999,000'))"평균급여"
first_name, last_name
from employees group by department_id order by department_id;