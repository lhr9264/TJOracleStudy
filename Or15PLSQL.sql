/*
파일명 : Or15PLSQL.sql
PL/SQL
설명 : 오라클에서 제공하는 프로그래밍 언어
*/
/*
PL/SQL(Procedural Language)
    : 일반 프로그래밍 언어에서 가지고 있는 요소를 모두 가지고 있으며
    DB업무를 처리하기 위해 최적화된 언어이다.
*/

--HR계정에서 실습합니다.

--예제1] PL/SQL 맛보기
--화면상에 내용을 출력하고 싶을때 on으로 설정한다. off일때는 출력되지 않는다.
set serveroutput on;

declare --선언부 : 주로 변수를 선언한다.
    cnt number; --숫자타입으로 변수를 선언한다.
begin --실행부 : begin~end절 사이에 실행을 위한 로직을 기술한다.
    cnt := 10; -- 변수에 10을 대입한다. 대입연산자는 :=을 사용한다.
    cnt := cnt +1;
    dbms_output.put_line(cnt); --java의 println()과 동일하다.
end;
/
/*
    PL/SQL문장의 끝에는 반드시 /를 붙어야 하는데, 만약 없으면
    호스트환경으로 빠져나오지 못한다. 즉 PL/SQL문을 탈출하기 위해 필요하다.
    호스트환경이란 쿼리문을 입력하기 위한 SQL> 프롬포트가 있는 상태를
    말한다. 
*/

//시나리오] 사원테이블에서 사원번호가 120인 사원의 이름과 연락처를 출력하는 PL/SQL문을 작성하시오.

select * from employees where employee_id=120;
--시나리오 조건에 맞는 select문을 작성한다.
select concat(first_name||' ', last_name), phone_number
from employees where employee_id=120;

declare
    /* 선언부에서 변수를 선언할때는 테이블 생성시와 동일하게 선언한다.
    => 변수명 자료형(크기)
    단, 기존에 생성된 컬럼의 타입과 크기를 참조하여 선언하는게 좋다.
    아래 '이름'의 경우 2개의 컬럼이 합쳐진 상태이므로 조금 더 넉넉한
    크기로 설정해주는것이 좋다. */
    empName varchar2(50);
    empPhone varchar2(30);
begin
    /* 실행부 : select 절에서 가져온 결과를 선언부에서 선언한 변수에
        1:1로 대입하여 값을 저장한다. 이때 into를 사용한다. */
    select
        concat(concat(first_name,' '), last_name),
        phone_number
    into
        empName, empPhone
    from employees
    where employee_id=120;
    
    dbms_output.put_line(empName ||' '|| empPhone);
end;
/
--예제3] 참조변수1(하나의 컬럼 참조)
/*
    참조변수 : 특정 테이블의 컬럼을 참조하는 변수로써 동일한 자료형과
        크기로 선언하고 싶을때 사용한다.
        형식] 테이블명.컬럼명%type
            => 테이블의 '하나'의 컬럼만을 참조한다.
*/

/*
시나리오] 부서번호 10인 사원의 사원번호, 급여, 부서번호를 가져와서 아래 변수에 대입후 화면상에 출력하는 
PL/SQL문을 작성하시오. 단, 변수는 기존테이블의 자료형을 참조하는 '참조변수'로 선언하시오.
*/
--시나리오의 조건에 맞는 select문을 작성한다.
select employee_id, salary, department_id from employees
    where department_id=10;
    
declare
    --사원테이블의 특정 컬럼의 타입과 크기를 그대로 참조하는 변수로 선언한다.
    empNo employees.employee_id%type; --NUMBER(6,0)
    empSal employees.salary%type; --NUMBER(8,2)
    deptId employees.department_id%type; --NUMBER(4,0)과 동일하게 선언된다.
begin
    --select절의 into를 통해 변수에 값을 할당한다.
    select employee_id, salary, department_id
        into empNo, empSal, deptId
    from employees
    where department_id=10;
    
    dbms_output.put_line(empNo ||' '|| empSal ||' '|| deptId);
end;
/

//예제4] 참조변수2(전체컬럼을 참조)
/*
시나리오] 사원번호가 100인 사원의 레코드를 가져와서 
emp_row변수에 전체컬럼을 저장한 후 화면에 다음 정보를 출력하시오.
단, emp_row는 사원테이블이 전체컬럼을 저장할 수 있는 참조변수로 선언해야한다. 
출력정보 : 사원번호, 이름, 이메일, 급여
*/

declare
    /* 사원테이블의 전체컬럼을 참조하는 참조변수로 선언한다. 이때 테이블명
    뒤에 %rowtype을 붙여 선언한다. */
    emp_row employees%rowtype;
begin
    /* 와일드카드 *를 통해 얻어온 전체컬럼을 변수 emp_row에 한꺼번에
    저장할 수 있다. */
    select *
        into emp_row
    from employees where employee_id=100;
    /* emp_row에는 전체컬럼의 정보가 저장되므로 출력시 변수명.컬럼명
    형태로 기술해야 한다. */
    dbms_output.put_line(emp_row.employee_id ||' '||
                    emp_row.first_name ||' '||
                    emp_row.email ||' '||
                    emp_row.salary);
end;
/