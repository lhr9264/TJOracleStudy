/******
파일명 : Or01SelectBaic.sql
처음으로 실행해보는 질의어(SQL문 혹은 Query문)
개발자들 사이에서는 '시퀄'이라고 표현하기도 한다.
설명 : select, where 등 가장 기본적인 dql문 사용해보기
******/

/*
SQL Developer에서 주석 사용하기
    블럭단위주석 : 자바와 동일하다
    라인단위주석 : -- 실행문장. 하이픈 2개를 연속으로 작성한다.
 */
 
 --select문 : 테이블에 저장된 레코드를 조회하는 SQL문으로 DQL문에 해당 
 /* 
 형식]
    select 컬럼1, 컬럼2, ... 혹은 *
    from 테이블명
    where 조건1 and 조건2 or 조건3
    order by 정렬할컬럼 asc(오름차순), desc(내림차순)
 */
 --사원테이블에 저장된 모든 레코드를 대상으로 모든 컬럼을 조회
 select * from employees;
 --쿼리문은 대소문자를 구분하지 않는다.
 SELECT * FROM employees;
 
 /*
 컬렴명을 지정해서 조회하고 싶은 컬럼만 조회한다.
 => 사원번호, 이름, 이메일, 부서번호만 조회하시오.
  */
 select employye_id, first_name, last_name, emial
 from employees;
 
 /* 테이블의 구조와 컬럼별 자료형 및 크기를 출려해준다. 즉 테이블의
 스키마(구조)를 알수있다. */
 desc employees; --하나의 쿼리문이 끝날때 ;을 반드시 기술해야한다.
 
 /*
 컬럼이 숫자형(number)인 경우 산술연산이 가능하다.
 -> 100불 인상된 직원의 급여를 조회하시오.
  */
 select employee_id, first_name, salary, salary+100
 from employees;
 
 --number(숫자) 타입의 컬럼끼리도 연산할 수 있다.
 select employee_id, first_name, salary, salary+commission_pct
 from employees;
 
 /*
 AS(얄리아스) : 테이블 혹은 컬럼에 별칭(별명)을 부여할때 사용한다.
    내가 원하는 이름(영문,한글)으로 변경한 후 출력할 수 있다.
    활용법] 급여+성과급율 => SalComm 과 같은 형태로 별칭을 부여한다.
 */
 
 --별칭은 한글로 기술할 수 있다.
 select first_name, salary, salary+100 as "급여 100증가"
 from employees;
 --하지만 영문으로 기술하는것을 권장한다.
  select first_name, salary, commission_pct,
  salary+(salary*commission_pct) as SalComm
 from employees;
 --as는 생략할 수 있다.
 select employee_id "사원아이디", first_name "이름", last_name "성"
 from employees where first_name='William';
 
 /* 오라클은 기본적으로 대소문자를 구분하지 않는다. 예약어의 경우 대소문자
 구분없이 상용할 수 있다.*/
 SELECT employee_id "사원아이디", first_name "이름", last_name "성"
 from employees WHERE first_name='William';
 
 /* 단, 레코드인 경우 대소문자를 구분한다. 따라서 아래 SQL문을 실행하면
 아무런 결과도 인출되지 않는다. */
 select employee_id "사원아이디", first_name "이름", last_name "성"
 from employees where first_name='WILLIAM';
 
 /* where절을 이용해서 조건에 맞는 레코드 인출하기
 -> last_name이 Smith인 레코드를 출력하시오. */
 select * from employees where last_name='Smith';
 
  select * from employees where last_name='Smith' and salsary=8000;
  select * from employees where last_name='Smith' and salsary='8000';
  select * from employees where last_name=Smith and salsary=8000;
  
 /*
 비교연산자를 통한 쿼리문 작성
 : 이상, 이하와 같은 조건에 >, <=와 같은 비교연산자를 사용할 수 있다.
 날짜인 경우 이전, 이후와 같은 조건도 가능하다.
 */
 --급여가 5000미만인 사원의 저옵를 추출하시오.
 select * from employees where salary<5000;
 --입사일이 04년 1월 01일 이후인 사원 정보를 추출하시오
 select * from employees where hire_date>='04/01/01';
 
 /*
 in연산자
 : or 연산자와 같이 하나의 컬럼에 여러개의 값으로 조건을 걸고싶을때
 사용한다.
    => 급여가 4200, 6400, 8000인 사원의 정보를 추출하시오
 */
 
 --방법1 : or를 사용한다. 이때 컬럼명을 반복적으로 기술해야 하므로 불편한다.
 select * from employees where salary=4200 or salary=6400
    or salary=8000;


 --방법2 : in을 사용하면 컬럼명은 한번만 기술해도 되므로 편리하다.
 select * from employees where salary in (4200, 6400, 8000);
 
 /*
 not연산자
 : 해당조건이 아닌 레코드를 추출한다.
 -> 부서번호가 50이 아닌 사원정보를 조회하는 SQL문을 작성하시오
  */
  
  select * from employees where department_id<>50;
  
  select * from employees where not (department_id=50);
  
  select * from employees where department_id!=50;

 /*
 between and 연산자
    :컬럼의 구간을 정해 검색할때 사용한다.
    => 급여가 4000~8000 사이의 사원을 인출하시오.
 */
 --방법1
 select * from employees where salary>=4000 and salary<=8000;
 --방법2
 select * from employees where salary between 4000 and 8000;
 
 /*
 distinct
 : 컬럼에서 중복되는 레코드를 제거할때 사용한다.
 특정 조건으로 select했을때 하나의 컬럼에서 중복되는 값이 있는경우
 중복값을 제거한 후 결과를 출력 할 수 있다.
 -> 담당업무 아이디를 중복을 제거한 경우 출력하시오
 */
 --전체 사원에 대한 담당업무명이 인출됨
 select job_id from employees;
 --중복이 제거되어 19개의 담당업무명이 인출된다.
 select distinct job_id from employees;
 
 /*
 like연산자
    : 특정 키워드를 통한 문자열을 검색할때 사용한다.
    형식] 컬럼명 like '%검색어%'
    와일드카드 사용법
        % : 모든 문자 혹은 문자열을 대체한다.
        Ex) D로 시작되는 단어 : D% => Da, Dae, Daewoo
        Z로 끝나는 단어 : %Z => aZ, abxZ
        C가 포함되는 단어 : %C% -> aCb, abCde, Vitamin-C
    _ : 언더바는 하나의 문자를 대체한다.
    EX) D로 시작하는 3글자의 단어 : D__ -> Dab , Ddd, Dxy
        A가 중간에 들어가는 3글자의 단어 : _A_ -> aAa, xAy
 */
 --first_name이 'D'로 시작되는 직원을 검색하시오.
 select * from employees where first_name like 'D%';
 --first_name의 세번째문자가 a인 직원을 추출하시오.
 select * from employees where first_name like '__a%';
 --first_name에서 y로 끝나는 직원을 추출하시오.
 select * from employees where first_name like '%y';
 --전화번호에 1344가 포함된 직원 전체를 인출하시오.
 select * from employees where phone_number like '%1344%';
 
 /*
 레코드 정렬하기(Sorting)
    오름차순 정렬 : order by 컬럼명 asc (혹은 생략가능)
    내림차순 정렬 : order by 컬럼명 desc
    
    2개 이상의 컬럼으로 정호렬해야 할 경우 콤마로 구분해서 정렬한다.
    단, 이때 먼저 입력한 컬럼으로 정렬된 상태에서 두번째 컬럼이 정렬된다.
 */
 /*
 사원정보 테이블에서 급여가 낮은 순서에서 높은 순서로 인출되도록 정렬하여
 조회하시오.
 출력할컬럼 : 이름, 급여, 이메일, 전화번호
 */
 select first_name, salary, email, phone_number from employees
 order by salary asc;
 
 /*
 부서번호를 내림차순으로 정렬한 후 해당 부서에서 낮은 급여를 받는 직원이
 먼저 출력되도록 하는 SQL문을 작성하시오.
 출력항목 : 사원번호, 이름, 성, 급여, 부서번
 */
 
 select
 from employees_id, first_name, last_name, salary, department_id
 order by department_id desc, salary src;
 
 /*
 is null ghrdms is not null
    : 값이 null이거나 null이 아닌 레코드 가져오기.
    컬럼중 null값을 허용하는 경우 값을 입력하지 않으면 null값이
    되는데 이를 대상으로 select할때 사용한다.
 */
 
 --보너스율이 없는 사원을 조회하시오
 select * from employees where commission_pct is null;
 --영업사원이면서 급여가 8000이상인 사원을 조회하시오
 select * from employees where salary>=8000
    and commission_pct is not null;
    
 /*
 1. 덧셈 연산자를 이용하여 모든 사원에 대해서 $300의 급여인상을
 계산한우 이름, 급여, 인상된 급여를 출력하시오 */
 
 --기존 레코드 확인하기
 select * from emp;
 --300불 인상된 급여 포함해서 select하기
 select ename, sal, sal+300 from emp;
 
 /* 2. 사원의 이름, 급여 연봉을 수입이 많은것부터
 작은순으로 출력하시오. 연봉은 월급에 12를 곱한후 &100을
 더해서 계산하시오.
 */
 select ename, sal, sal*12+100 as "연봉"
 from emp order by sal desc;
 
 select ename, sal, sal*12+100 as "연봉"
 from emp order by "연봉" desc;
 
 /* 
 5. 급여가 2000에서 3000사이에 포함되지 않는 사원의
 이름과 급여를 출력하시오.
 */
 select ename, sal
 from emp where not (sal>=2000 and sal<=3000);
 
 select ename, sal
 from emp where not (sal between 2000 and 3000);
 
 /*
 6. 입사일이 81년 2월 20일 부터 81년 5우러 1일 사이인 사원의
 이름, 담당업무, 입사일을 출력하시오. */
 select ename, job, hiredate
 from emp where hiredate>='81/02/20' and hiredate<='81/05/01';
 
 select ename, job, hiredate
 from emp where hiredate between '81/02/20' and '81/05/01';
 
 /*
 시나리오] 사원테이블에서 영업사원의  
  */
 --1. 영업사원을 찾아 인출한다. (영업사원의 job_id는 SA_XX로 되어있다.)
 select * from employees where job_id like 'SA_%';
 --(영업사원은 커미션을 받기때문에 값이 입력되어있다.)
 select * from employees where commission_pct is not null;
 

--2.커미션을 계산하여 이름과 함께 출력한다.
select
    first_name, salary, commission_pct, salary+(salary*commisson_pct)
from employees where job_id like 'SA_%';
--3. 커미션을 소수점 1자리까지만 금액 계산하기    
 select
    first_name, salary, trunc(commission_pct,1) salary+(salary*trunc(commission_pct,1))
 from employees where job_id like 'SA_%';
--4. 계산식이 포함된 컬럼명에 별칭을 부여한다.
 select
    first_name, salary, trunc(commission_pct,1) as comm_pct,
    salary+(salary*trunc(commission_pct,1)) totalSalary
 from employees where job_id like 'SA_%';
 
 /*
 소수점 관련함수
    ceil() : 소수점 이하를 무조건 올림처리
    floor() : 무조건 버림 처리
    round(값, 자리수) : 반올림 처리
    두번째 인자가
        없는경우 : 소수점 첫번째 자리가 5이상이면 올림, 미만이면 버림
        있는경우 : 숫자만큼 소수점이 표현되므로 그 다음수가 5이상이면
        올림, 미만이만 버림 
 */
 select ceil(32.8) from dual;
 select ceil(32.2) from dual; --둘다 33 인출    
 
 select floor(32.8) from dual;
 select floor(32.2) from dual;--둘다 32 인출
 
 select round(0.123), round(0.543) from dual;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
