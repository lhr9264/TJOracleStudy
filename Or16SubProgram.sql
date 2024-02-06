/************
파일명 : Or16SubProgram.sql
서브프로그램
설명 : 저장프로시져, 함수 그리고 프로시져의 일종인 트리거를 학습
***************/

/*
서브프로그램(Sub Program)
-PL/SQL에서는 프로시져와 함수라는 두가지 유형의 서브프로그램이 있다.
-Select를 포함해서 다른 DML문을 이용하여 프로그래밍적인 요소를 통해
사용가능하다. 
-트리거는 프로시져의 일종으로 특정 테이블에 레코드의 변화가 있을경우
자동으로 실행된다. 
-함수는 쿼리문의 일부분으로 사용하기 위해 생성한다. 즉 외부 프로그램에서
호출하는 경우는 거의 없다.
-프로시저는 외부 프로그램에서 호출하기 위해 생성한다. 따라서 Java, 
JSP등에서 간단한 호출로 복잡한 쿼리를 실행할 수 있다. 
*/

/*
1.저장프로시저(Stored Procedure)
-프로시저는 return문이 없는 대신 out파라미터를 통해 값을 반환한다. 
-보안성을 높일 수 있고, 네트워크의 부하를 줄일 수 있다. 
형식] create [or replace] procedure 프로시저명 [( 
        매개변수 in 자료형, 매개변수 out 자료형
    )]
    is [변수선언]
    begin
        실행문장
    end;
    /
※ 파라미터 설정시 자료형만 명시하고, 크기는 명시하지 않는다.      
*/

/*
시나리오] 100번 사원의 급여를 select하여 출력하는 저장프로시저를 생성하시오.
*/ 
--프로시저 생성시 or replace는 추가하는것이 좋다. 
create or replace procedure pcd_emp_salary
is  
    /* PL/SQL에서는 declare절에 변수를 선언하지만, 프로시저에서는
    is절에 선언한다. 만약 변수가 필요없다면 생략할 수 있다. */
    --사원테이블의 급여 컬럼을 참조하는 참조변수로 생성 
    v_salary employees.salary%type;
begin   
    --100번 사원의 급여를 into를 통해 변수에 저장한다. 
    select salary into v_salary from employees 
        where employee_id=100;
    dbms_output.put_line('사원번호 100의 급여는 '||v_salary||'입니다');
end;
/  
--데이터사전에서 확인한다. 저장은 대문자로 되므로 변환함수를 이용한다. 
select * from user_source 
    where name like upper('%pcd_emp_salary%');  
--프로시저의 실행은 호스트환경에서 execute 명령을 이용한다.  
execute pcd_emp_salary;


/*
In파라미터를 사용한 프로시저 생성

시나리오] 사원의 이름을 매개변수로 받아서 사원테이블에서 레코드를 조회한후
해당사원의 급여를 출력하는 프로시저를 생성 후 실행하시오.
해당 문제는 in파라미터를 받은후 처리한다.
사원이름(first_name) : Bruce, Neena
*/ 
--프로시저 생성시 in파라미터를 설정한다. first_name을 참조하는 참조변수
--로 선언한다. 
create or replace procedure pcd_in_param_salary
    (param_name in employees.first_name%type) 
is 
    /* 변수는 is절에서 선언하고, 필요없는 경우 생략할 수 있다. */
    valSalary number(10);  
begin
    /* 인파라미터로 전달된 사원명을 조건으로 급여를 구한 후 변수에
    할당한다. 하나의 결과가 출력되므로 into를 select절에서 사용한다.*/
    select salary into valSalary
    from employees where first_name = param_name;
    --사원의 이름과 급여를 함께 출력한다.  
    dbms_output.put_line(param_name||'의 급여는 '|| valSalary 
        ||' 입니다');
end;
/   
--데이터사전에서 작성한 내용 확인 
select * from user_source 
    where name like upper('%pcd_in_param_salary%');  
--사원의 이름을 파라미터로 전달해서 프로시저를 호출한다. 
execute pcd_in_param_salary('Bruce');
execute pcd_in_param_salary('Neena');


/*
Out 파라미터를 사용하여 프로시저 생성

시나리오] 위 문제와 동일하게 사원명을 매개변수로 전달받아서 급여를 조회하는
프로시저를 생성하시오. 단, 급여는 out파라미터를 사용하여 반환후 출력하시오
*/ 
/* 두가지 형식의 파라미터를 정의한다. 일반변수, 참조변수를 각각 사용해서
선언하였다. 파라미터는 용도에 따라 in, out을 각각 명시한다. 파라미터
정의시에는 크기는 별도로 명시하지 않는다. */
create or replace procedure pcd_out_param_salary (        
    param_name in varchar2, 
    param_salary out employees.salary%type
) 
is  
    /* select한 결과를 out파라미터에 저장할 것이므로 별도의 변수가
    필요하지 않아 is 절은 비워둔다. 이와같이 변수선언은 생략할 수 있다.*/
begin   
    /* in파라미터는 where절의 조건으로 사용하고, select한 결과값은
    into절에서 out파라미터에 저장한다. 
    저장된 값은 프로시져 외부로 반환된다. */
    select salary into param_salary
    from employees where first_name = param_name;
end;
/  
--호스트환경에서 바인드 변수를 선언한다. variable로도 선언할 수 있다.
var v_salary varchar2(30);
/* 프로시저 호출시 각각의 파라미터를 사용한다. 특히 바인드변수는 :을
붙여야한다. out파라미터인 param_salary에 저장된 값이 v_salary로
전달된다. */ 
execute pcd_out_param_salary('Matthew', :v_salary); 
--프로시저 실행 후 out파라미터를 통해 전달된 값을 출력한다. 
print v_salary;

select * from employees where 1=1;
/* select절에 where을 생략하거나 1=1의 조건을 주면 참이 되므로 모든
레코드를 함께 복사한다. 만약 스키마(구조)만 복사하고 싶다면 1=0과 같이
부정의 조건을 기술하면된다. */



/* 업데이트 전의 상태 */

/*
시나리오] 사원번호와 급여를 매개변수로 전달받아 해당사원의 급여를 수정하고, 
실제 수정된 행의 갯수를 반환받아서 출력하는 프로시저를 작성하시오.
*/

/*
in파라미터는 사원번호와 수정할 급여를 입력받는다. out파라미터는 update가
적용된 행의 갯수를 반환한다.
*/
create or replace procedure pcd_update_salary
    (
        p_empid in number,
        p_salary in number,
        rCount out number
    )
is /* 추가적인 변수 선언이 필요없으므로 생략한다. */
begin
    --실제 업데이트를 처리하는 쿼리문으로 in파라미터를 통해 값을 설정한다. 
    update zcopy_employees
        set salary = p_salary
        where employee_id = p_empid;
        
    /*
    SQL%notfound : 쿼리 실행 후 적용된 행이 없을경우 true를 반환한다.
        found는 반대 경우르 반환한다.
    sql%rowcount : 쿼리 실행 후 실제 적용된 행의 갯수를 반환한다. 
    */
    if SQL%notfound then
        dbms_output.put_line(p_empid ||'은(는) 없는사원임다');
    else
        dbms_output.put_line(SQL%rowcount ||'명의 자료가 수정되씸');
        
        --실제 적용된 행의 갯수를 out파라미터를 통해 반환한다. 
        rCount := sql%rowcount;
    end if;
    /* 행의 변화가 있는 쿼리를 실행한 경우 반드시 commit을 해야 실제
    테이블에 적용되어 Oracle 외부에서 확인할 수 있다. */
    commit;
end;
/
--첫 실행시에는 결과 출력을 위해 반드시 실행해야 한다.

set serveroutput on;

--바인드변수 생성 후 프로시저의 반환값(out파라미터)을 저장 후 출력한다.
variable r_count number;
execute pcd_update_salary(100, 9999, :r_count);
print r_count; --1행 적용됨
--100번 사원의 급여를 확인한다. (결과 : 9999로 변경됨)
select * from zcopy_employees where employee_id=100;

variable r_count number;
execute pcd_update_salary(777, 7777, :r_count);
print r_count;--없는 사원이므로 0행 적용됨.

/*
2.함수
-사용자가 PL/SQL문을 사용하여 오라클에서 제공하는 내장함수와 같은 기능을
정의한 것이다.
-함수는 in파라미터만 사용할 수 있고, 반드시 바노한값의 자료형을 명시해야한다.
-프로시저는 여러개의 결과값을 얻어올 수 있지만, 함수는 반드시 하나의 값을
반환해야한다.
-함수는 쿼리문의 일부분으로 사용된다.
※ 파라미터와 반환타입을 명시할때 크기는 기술하지 않는다.
*/

/*
시나리오] 2개의 정수를 전달받아서 두 정수사이의 모든수를 더해서 결과를 반환하는 함수를 정의하시오.
실행예) 2, 7 -> 2+3+4+5+6+7 = ??
*/
--함수는 in파라미터만 있으므로 in은 주로 생략한다.
create or replace function calSumbEtween (
    num1 in number,
    num2 number
)
return 
    --함수는 반드시 반환값이 있으므로 반환타입을 명시해야한다.(필수)
    number
is 
    --반환값으로 사용할 변수 선언(선택사항이므로 필요없다면 생략가능)
    sumNum number;
begin
    sumNum := 0;
    --for루프문으로 숫자사이의 합을 계산한다.
    for i in num1 .. num2 loop
        sumNum := sumNum +1;
    end loop;
    --결과값을 반환한다.
    return sumNum;
end;
/
--실행방법1 : 쿼리문의 일부로 사용한다.(주로 사용하는 방법)
select calSumBetween(1,10) from dual;

--실행방법2 : 바인드변수를 통한 실행명령으로 주로 디버깅용으로 사용됨.
var hapText varchar2(30);
execute : hapText := calSumBetween(1,100);
print hapText;

--데이터사전에서 확인하기
select * from user_source where name=upper('calSumBetween');

/*
퀴즈] 주민번호를 전달받아서 성별을 판단하는 함수를 정의하시오.
999999-1000000 -> '남자' 반환
999999-2000000 -> '여자' 반환
단, 2000년 이후 출생자는 3이 남자, 4가 여자임.
함수명 : findGender()
*/

/* 이 함수는 주민번호를 문자형태로 받아서 성별을 판단한다.
함수는 in파라미터만 사용할 수 있으므로 In은 생략할수 있다. */
create or replace function findGender (juminNum varchar2)
/* 성별을 판단한 후 '남자' 혹은 '여자'를 반환하므로 반환타입은 문자형으로
선언한다. */
return varchar2
is
--주민번호에서 성별에 해당하는 문자를 잘라 저장할 변수
    genderTxt varchar2(1);
    
    returnVal varchar2(10);
begin
    --주민번호에서 성별에 해당하는 부분을 잘라낸다.
    genderTxt := substr(juminNum,8,1);
    --잘라낸 문자를 통해 성별을 판단한다.
    if genderTxt='1' then
        returnVal := '남자';
    elsif genderTxt='2' then
        returnVal := '여자';
    elsif genderTxt='3' then
        returnVal := '남자';
    elsif genderTxt='4' then
        returnVal := '여자';
    else 
        returnVal := '입력오류';
    end if;
    
    --함수는 반드시 반환값이 있어야한다.
    return returnVal;
end;
/
select findGender('999999-1000000') from dual;
select findGender('999999-2000000') from dual;
select findGender('999999-3000000') from dual;
select findGender('999999-4000000') from dual;
select findGender('999999-5000000') from dual;

/*
시나리오] 사원의이름(first_name)을 매개변수로 전달받아서  
부서명(department_name)을 반환하는 함수를 작성하시오.
함수명 : func_deptName */

--1단계(내부조인을 이용한 쿼리문 작성)
select
    first_name, last_name, department_id, department_name
from employees inner join jepartments using(department_id)
where first_name='Nancy';--Diana

--2단계 : 함수 작성
create or replace function func_deptName (
    param_name varchar2 /* 사원의 이름을 인파라미터로 설정 */
)
return
    /* 부서명을 반환해야 하므로 문자형으로 반환타입 지정 */
    varchar2
is
    /* 반환값을 저장할 변수로 부서테이블의 부서명 컬럼을 참조하는 변수로
    설정 */
    return_deptname departments.department_name%type;
begin
    /* 앞서 작성한 Join쿼리문에서 부서명만 인출할 수 있도록 수정한 후
    into절에서 반환할 변수에 저장한다. */
    select
        department_name into return_deptname
    from employees inner join departments using(department_id)
    where first_name=param_name;
    --부서명을 반환한다.
    return return_deptname;
end;
/

select func_deptname('Nancy') from dual;--Finance 반환
select func_deptname('Diana') from dual;--IT 반환

/*
3. 트리거(Trigger)
    : 자동으로 실행되는 프로시저로 직접 실행은 불가능하다.
    주로 테이블에 입력된 레코드의 변화가 있을때 자동으로 실행된다.
*/
/* 트리거 실습을 위해 HR계정의 부서 테이블을 아래와 같이 2개 복사한다.
original 테이블은 레코드까지 모두 복사하고, backup 테이블은 스키마만
복사한다. */
create table trigger_dept_original
as
select * from departments;

create table trigger_dept_backup
as
select * from departments where 1=0;
--복사 후 레코드 확인하기
select * from trigger_dept_original;--27개 
select * from trigger_dept_backup;--0개 

/* 
예제 1] trig_dept_backup

시나리오] 테이블에 새로운 데이터가 입력되면 해당 데이터를 백업테이블에 저장하는
트리거를 작성해보자.
*/

create trigger tring_dept_backup
    /* 타이밍 : 이벤트 발생 전과 후를 표현한다. */
    after
    /* 이벤트 : insert, update, delete와 같은 쿼리 실행시 발생된다.*/
    INSERT
    --트리거를 적용할 테이블명
    on trigger_dept_original
    /* 행단위 트리거를 정의한다. 즉 하나의 행이 변화할때마다 트리거가
    수행된다. 만약 문장(테이블)단위 트리거로 정의하고 싶다면, 해당
    문장을 생략하면된다. 이 경우에는 쿼리를 한번 실행하면 트리거도
    딱 한번만 실행된다. */
    for each row
begin
    if Inserting then
        dbms_output.put_line('insert 트리거 발생됨');
        
        /* 새로운 레코드가 입력되었으므로 임시테이블 :new에 저장되고
        해당 렐코드를 통해 backup 테이블에 입력할 수 있다.
        이와 같은 임시테이블은 행단위 트리거에서만 사용할 수 있다. */
        insert into trigger_dept_backup
        values (
            :new.department_id,
            :new.department_name,
            :new.manager_id,
            :new.location_id
        );
    end if;
end;
/
--original 테이블에 3개의 레코드 삽입 
insert into trigger_dept_original values (300, '개발팀', 10, 100);
insert into trigger_dept_original values (310, '전산팀', 20, 100);
insert into trigger_dept_original values (320, '행정팀', 30, 100);
--각 테이블의 레코드 확인
select * from trigger_dept_original order by department_id desc;
select * from trigger_dept_backup;

/*
예제2] trig_dept_delete

시나리오] 원본테이블에서 레코드가 삭제되면 백업테이블의 레코드도 같이
삭제되는 트리거를 작성해보자.
*/

create or replace trigger trig_dept_delete
    /* original 테이블의 레코드가 삭제된 후 행단위로 트리거를 적용한다. */
    after
    delete
    on trigger_dept_original
    for each row
begin
    dbms_output.put_line('delete 트리거 발생됨');
    /* 레코드가 삭제된 이후 이벤트가 발생되어 트리거가 호출되므로
    :old 임시테이블을 사용한다. */
    if deleting then
        delete from trigger_dept_backup
            where department_id = :old.department_id;
    end if;
end;
/
--300번 부서 삭제
delete from trigger_dept_original where department_id=300;
--각 테이블에서 함께 삭제된것을 확인할 수 있다.
select * from trigger_dept_original;
select * from trigger_dept_backup;

/*
예제3] trigger_update_test

For each row 옵션에 따른 트리거 실행횟수 테스트
생성1
    : 오리지널 테이블에 업데이틍 이후 행단위로 발생되는 트리거 생성
*/

create or replace trigger tirgger_update_test
    after update
    on trigger_dept_original
    for each row
begin
    /* 업데이트 이벤트가 감지되면 backup 테이블의 레코드를 입력한다. */
    if updating then
        dbms_output.put_line ('update 트리거발생됨');
        /* 기존의 데이터가 업데이트 된 이후 :old를 사용했으므로
        기존 데이터가 백업 테이블에 입력된다. */
        insert into trigger_dept_backup
        values (
            :old.department_id,
            :old.department_name,
            :old.manager_id,
            :old.location_id
        );
    end if;
end;
/
--5개의 레코드를 인출할 수 있는 조건을 만든다.
select * from trigger_dept_original
    where department_id between 10 and 50;
--위 조건을 그대로 적용하여 update한다.(5개의 레코드가 업데이트된다.)
update trigger_dept_original set department_name='부서일괄변경'
    where department_id between 10 and 50;
--원본테이블에서 5개의 레코드가 업데이트 된것을 확인한다.
select * from trigger_dept_original;
--백업테이블에는 업데이트 되기전의 데이터가 5개 입력된다.
select * from trigger_dept_backup;
/*
    즉, 행단위 트리거에서는 적용된 행의 갯수만큼 트리거가 실행된다.
*/
/*
생성2 : 오리지날 테이블에 업데이트 이후 테이블(문장) 단위로 발생하는
    트리거 생성
*/
create or replace trigger tirgger_update_test
    after update
    on trigger_dept_original
    /* 오리지날 테이블의 레코드를 업데이트 한 후 테이블 단위로
    트리거가 실행되므로 무조건 한번만 트리거가 실행된다. 즉 테이블단위로
    트리거를 만들고 싶다면 아래 옵션을 제거하면 된다. */
    /* for each row */
begin
    if updating then
        dbms_output.put_line ('update 트리거발생됨');
        insert into trigger_dept_backup
        /* 테이블 단위 트리거에서는 :new 혹은 :old 와 같은
        임시테이블을 사용할 수 없다. 따라서 아래와 같이 임의의
        값을 입력해야한다. */
        values (
            999, to_char(sysdate, 'yy-mm-dd hh24:mi:ss'), 10, 100)
        );
    end if;
end;
/
update trigger_dept_original set department_name='부서변경2'
    where department_id between 60 and 100;
--원본테이블에서 5개의 레코드가 업데이트 된것을 확인한다.
select * from trigger_dept_original;
--백업테이블에는 딱 1개의 레코드만 입력된다.
select * from trigger_dept_backup;
/*
    즉 테이블 단위 트리거에서는 적용된 행의 갯수에 상관없이
    트리거는 한번만 실행된다. 
*/