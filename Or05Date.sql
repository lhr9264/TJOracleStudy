/****************
파일명 : Or05Date.sql
날짜함수
설명 : 년, 월, 일, 시, 분, 초의 포맷으로 날짜형식을 지정하거나
    날짜를 계산할때 활용하는 함수들
****************/

/*
months_between () : 현재날짜와 기준날짜 사이의 개월수를 반환한다.
    형식] months_between(현재날짜, 기준날짜[과거날짜]);
*/
--2020년 1월 1일부터 지금까지 지난 개월수는???
select
    months_between(sysdate, '2020-01-01'),
    ceil(months_between(sysdate, '2020-01-01')) "올림처리",
    floor(months_between(sysdate, '2020-01-01')) "내림처리"
from dual;
--만약 "2020년 1월 1일" 문자열을 그대로 적용해서 계산하려면??
select
    months_between(sysdate, 
        to_date('2020년 01월 01일','yyyy"년 "mm"월 "dd"일"'))
from dual;

/*
퀴즈] employees 테이블에 입력된 직원들의 근속개월수를 계산하여 출력하시오
    단, 근속개월수의 오름차순으로 정렬하시오.
*/
select
    first_name, hire_date,
    months_between(sysdate, hire_date) "근속개월수1",
    trunc(months_between(sysdate, hire_date)) "근속개월수2"
from employees;
/* order by "근속개월수1" asc; */
order by trunc(months_between(sysdate, hire_date)) asc;
/* select 결과를 정렬하기 위해 order by를 사용할 때 컬럼명은 위와같이
2가지 형태로 기술할 수 있다.
방법1 : 계산식이 포함된 컬럼을 그대로 사용한다.
방법2 : 별칭을 사용한다. */

/*
last_day() : 해당월의 마지막 날짜를 반환한다.
*/
select last_day('22-04-03') from dual;--4월은 30일까지 있음
select last_day('24-02-01') from dual;--24년은 윤년이므로 20일 출력
select last_day('23-02-03') from dual;--보통은 28일 출력

select
    sysdate "오늘",
    sysdate-1 "어제",
    sysdate+1 "내일"
from dual;