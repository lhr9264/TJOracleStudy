/**************************






***************************/


--현재 접속한 계정에 생성된 테이블, 뷰의 목록을 보여준다.
select * from tab;
--이와같이 테이블이 없는 경우에는 쿼리에러가 발생한다.
select * from tjoeun;
/*
 Dual테이블
 : 하나의 행으로 결과를 출력하기 위해 제공되는 테이블로 오라클에서
 자동으로 생성되는 논리적 테이블이다.
 varchar2(1)로 정의된 dummy라는 단 하나의 컬럼으로 구성되어있다.
 */
desc dual;
select * from dual;

/*
 abs() : 절대값 구하기
 */
 select abs(12000) from dual;
 select abs(-9000) from dual;
 select abs(salary) "급여의절대값" from employees;
 
 /*
 trunc() : 소수점을 특정자리수에서 잘라낼때 사용하는 함수
        형식 : trunc(컬럼명 혹은 값, 소수점이하자리수)
            두번째 인자가
                양수일때 : 주어진 숫자만큼 소수점을 표현
                없을때 : 정수부만 표현. 즉 소수점 아래부분은 버림
                음수일때 : 정수부를 숫자만큼 잘라 나머지를 0으로 채움
  */
 select trunc(12345.12345, 2) from dual;
 select trunc(12345.12345) from dual;
 select trunc(12345.12345, -2) from dual;
 --금액이라면 원단위 절삭과 같은 형태로 사용할수 있다.
 
 --버림과 올림을 하여 0, 1이 인출됨
 select round(0.123), round(0.543) from dual;
 /*
 첫번째항목 : 소수이하 6자리까지 표현하므로 7을 올림처리
 두번째항목 : 소수이하 4자리까지 표현하므로 1을 버림처리   
 */
 
 
 
 
 /*
 mod() : 나머지를 구하는 함수
 power() : 거듭제곱을 구하는 함수
 sqrt() : 제곱근(루트)을 구하는 함수
 */
 select mod(99, 4) "99를 4로 나눈 나머지" from dual;
 select power(2, 10) "2의 10승" from dual;
 select sqrt(49) "49의 제곱근" from dual;