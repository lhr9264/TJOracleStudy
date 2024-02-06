/*
파일명 : Or13DCl.sql
DCL : Data Control Language(데이터 제어어)
사용자권한
설명 : 새로운 사용자계정을 생성하고 시스템권한을 부여하는 방법을 학습
*/

/*
[사용자 계정 생성 및 권한설정]
해당 부분은 DBA권한이 있는 최고관리자(sys, system)으로 접속한 후
실행해야한다.
새로운 사용자 계정이 생성된 후 접속 및 쿼리실행 테스트는 CMD(명령프롬포트)
에서 진행한다.
*/

/*
1] 사용자 계정 생성 및 암호설정
형식]
    create user 아이디 identified by 패스워드;
*/
/* 오라클 12c 이후부터는 일반 계정을 생성할때 접두어로 C##을 써야지만
계정이 정상적으로 생성된다. */
create user c##test_user1 identified by 1234;
/* 하지만 계정에 C##을 붙이는것은 조금 불편하므로 아래와 같이 session
을 변경하는 명령을 실행한 후 계정을 생성하면 접두어 없이 생성할 수 있다. */
alter session set "_ORACLE_SCRIPT"=true;

create user test_user1 identified by 1234;

/*
    계정 생성 직후 CMD에서 sqlplus 명령으로 접속을 시도해보면
    create session 권한이 없어 접속할 수 없닫는 에러메세지가 뜬다.
*/

/*
2] 생성된 사용자 계정에 권한 혹은 역할 부여
형식] grant 시스템권한1, 권한2 혹은 역할
        to 사용자계정
            [with grant 옵션]
*/
grant create session to test_user1;
/*
    create session 권한 부여 후 접속에는 성공했지만, 테이블은
    생성되지 않는다. 
*/
--테이블 생성권한 부여
grant create table to test_user1;
/*
    create table 권한 부여 후 테이블 생성 및 desc명령으로 스키마를
    확인할 수 있다.
*/

/*
3]암호변경
    alter user 사용자계정 identified by 변경할암호;
*/
alter user test_user1 identified by 4321;
/*
    exit 혹은 quit 명령을 통해 접속을 해제한 후 다시 접속하면 기존의
    암호로는 접속되지 않는다. 변경한 암호로 접속해야 한다.
*/
/*
4] Role(롤, 역할)을 통해 여러가지 권한을 동시에 부여하기
    : 여러 사용자가 다양한 권한을 효과적으로 관리할 수 있또록 관련된
    권한끼리 묶어놓은것을 말한다.
※ 우리는 실습을 위해 새롭게 생성한 계정에 connect, resource롤을 주로
부여한다.
*/
--두번째 계정 생성후 Role을 통해 권한을 부여한다.
--접속 및 테이블생성이 정상적으로 된다.
create user test_user2 identified by 1234;
--아래 2개의 Role은 오라클에서 기본적으로 제공된다.
grant connect, resource to test_user2;

/*
4-1] Role생성하기 : 사용자가 원하는 권한을 묶어 새로운 롤을 생성한다.
*/
create role my_role;

/*
4-2] Role에 권한 부여하기
*/
--새롭게 생성한 Role에 3가지 권한을 부여한다.
grant create session, create table, create view to my_role;
create user test_user3 identified by 1234;
--우리가 생성한 Role을 통해 권한을 부여한다.
grant my_role to test_user3;

/*
4-3] Role 삭제하기
*/
drop role my_role;
/*
    test_user3은 my_role을 통해 권한을 부여받았으므로 해당 Role을
    삭제하면 부여받았던 모든 권한이 회수(Revoke) 된다.
    즉, Role삭제후에는 접속할 수 없다.
*/

/*
5] 권한제거(회수)
    형식] revoke 권한 혹은 역할 from 사용자계정;
*/
revoke create session from test_user1;
/*
    접속권한 회수 후 접속을 시도하면 비밀번확 틀린경우에는 '부적합'
    에러가 발생하고, 비밀번호가 일치하면 create session권한이 없다고
    나온다.
*/

/*
6] 사용자 계정 삭제
    형식] drop user 사용자계정 [cascade];
※cascade를 명시하면 사용자계정과 관련된 모든 데이터베이스 스키마가
데이터사전으로 부터 삭제되고 모든 스키마 객체도 물리적으로 삭제된다.
*/
--현재 생성된 사용자 목록을 확인할 수 있는 데이터사전
select username from dba_users;
select * from dba_users where username='test_user2';
select * from dba_users where username like upper('%test%');

--계정을 삭제하면서 모든 물리적인 스키마까지 같이 삭제한다.
drop user test_user1 cascade;

/*
테이블 스페이스란?
    디스크 공간을 소비하는 테이블과 뷰, 그리고 그 밖의 다른 데이터베이스
    객체들이 저장되는 장소이다. 예를 들어 오라클을 최초로 설치하면
    hr계정의 데이터를 저장하는 user라는 테이블 스페이스가 자동으로
    생성된다.
*/
--테이블스페이스를 조회할 수 있는 데이터사전
desc dba_tablespaces;
--현재 오라클 시스템에는 총 5개의 테이블스페이스가 생성되어있다.
select tablespace_name, status, contents from dba_tablespaces;
--우리가 생성한 사용자 계정이 어떤 테이블스페이스를 사용하는지 조회
select username, default_tablespace from dba_users
where username in upper('test_user2');
--사용자에게 테이블스페이스를 할당한다. (2m은 2MB를 뜻한다)
alter user test_user2 quota 2m on users;
/*
    즉 test_user2 사용자가 users라는 테이블스페이스에 2Mb의
    공간을 사용할 수 있도록 권한을 부여하는것이다.
    CMD에서 insert 해보면 정상적으로 입력된다.
*/

select * from emp;
select * from emp_details_view;
select * from user_views;