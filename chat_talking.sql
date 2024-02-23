CREATE table chat_talking (
일련번호 number PRIMARY KEY,
대화명 varchar2(20),
대화내용 varchar(30),
입력날짜 date default sysdate);

select * from chat_talking;

create sequence chat_talk;

create or replace trigger chat
before insert on chat_talking
for each row
begin
    select chat_talk.nextval
    into :new.일련번호
    from dual;
end;
/