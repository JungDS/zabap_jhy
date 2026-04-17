*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_01_05
*&---------------------------------------------------------------------*
*& Internal Table 선언 및 관련 문법 연습
*&---------------------------------------------------------------------*
REPORT zabap_jhy_01_05.


* Local Stuctured Type
* TS_STUDENT 라는 데이터 타입은 학생 정보를 다루기 위해 선언
TYPES: BEGIN OF ts_student,
         no     TYPE n LENGTH 03,
         name   TYPE c LENGTH 10,
         dept   TYPE c LENGTH 20,
         year   TYPE n LENGTH 04,
         gender TYPE c LENGTH 01,    " 성별: M,F
       END OF ts_student.

* Structure 변수 선언( 5칸 )
DATA gs_student TYPE ts_student.

* Internal Table 변수 선언
* 1. Local Structure Type를 이용해서 선언
DATA gt_student TYPE TABLE OF ts_student.

* 2. 먼저 선언한 Structure 변수를 이용해서 선언
DATA gt_stduent2 LIKE TABLE OF gs_student.


* Internal Table 사용법 연습
* 1. APPEND: Internal Table에 한 줄을 추가
CLEAR gs_student.
gs_student-no     = '001'.
gs_student-name   = '정훈영'.
gs_student-dept   = 'SAP'.
gs_student-year   = '2024'.
gs_student-gender = 'M'. " M:남자, F:여자

* Internal Table에 한 줄이 추가된다.
* APPEND 전: 0줄, 후: 1줄
APPEND gs_student TO gt_student.

CLEAR gs_student.
gs_student-no     = '002'.
gs_student-gender = 'F'.

* Internal Table에 한 줄이 추가된다.
* APPEND 전: 1줄, 후: 2줄
APPEND gs_student TO gt_student.

* 아래 문장 실행 시 강제로 Debugger 모드가 된다.
*BREAK-POINT.

CLEAR gs_student.
gs_student-no     = '003'.
gs_student-name   = '홍길동'.
gs_student-dept   = '의적'.
gs_student-year   = '1000'.
gs_student-gender = 'M'.

* Internal Table의 2번째로 GS_STUDENT를 삽입한다.
* 2번째 위치에 있던 기존 데이터는 3번째로 밀린다.
INSERT gs_student INTO gt_student INDEX 2.

* GT_STUDENT가 [ Standard Table ] 이면 APPEND와 동일하게 마지막 줄에 추가한다.
* GT_STUDENT가 [ Sorted Table   ] 이면 Key값을 비교해서 정렬기준에 따라 삽입한다.
INSERT gs_student INTO TABLE gt_student.



* Internal Table의 1번째 데이터를 GS_STUDENT에게 전달한다.
READ TABLE gt_student INTO gs_student INDEX 1.

* Structure변수인 GS_STUDENT 에서 Component NO 의 값만 '999'로 변경한다.
* Structure변수인 GS_STUDENT 에서 그 외의 Component는 변경되지 않는다.
gs_student-no = '999'.

* Internal Table의 3번째 데이터를 GS_STUDENT가 가진 값으로 변경한다.
MODIFY gt_student FROM gs_student INDEX 3.


SKIP 1.
FORMAT COLOR COL_GROUP INTENSIFIED OFF.
WRITE AT /(sy-linsz) 'Internal Table의 모든 데이터 출력' .
FORMAT RESET.


* Internal Table의 모든 데이터가 각각 한번씩 Loop 안의 문장들 차례대로 실행한다.
LOOP AT gt_student INTO gs_student.
  AT FIRST.
*   LOOP 의 첫번째 실행일 때만 실행된다.
    ULINE.
  ENDAT.

* 이 Loop 안의 문장이 실행될 때 GS_STUDENT는 Internal Table로부터 차례대로 실행되는 n번째의 데이터를 갖고 있다.
  WRITE : /01 '순번: ', (3) sy-tabix,
           13 '학번: ',     gs_student-no,
           33 '이름: ',     gs_student-name.

  AT LAST.
*   LOOP 의 마지막 실행일 때만 실행된다.
    ULINE.
  ENDAT.
ENDLOOP.


SKIP 1.
FORMAT COLOR COL_GROUP INTENSIFIED OFF.
WRITE AT /(sy-linsz) 'Internal Table에서 NAME이 ''둘리''인 데이터를 검색한 후 NAME 출력' .
FORMAT RESET.

* READ TABLE로 검색 시 실패하면, GS_STUDENT는 보유한 값 그대로 유지한다.
READ TABLE gt_student INTO gs_student WITH KEY name = '둘리'.
WRITE: / 'SY-SUBRC = ', sy-subrc.
WRITE: / 'GS_STUDENT-NAME = ', gs_student-name.


SKIP 1.
FORMAT COLOR COL_GROUP INTENSIFIED OFF.
WRITE AT /(sy-linsz) 'Internal Table에서 NAME이 ''둘리''인 데이터를 검색한 후 SY-SUBRC에 따라 로직 분기' .
FORMAT RESET.

CLEAR gs_student.
READ TABLE gt_student INTO gs_student WITH KEY name = '둘리'.
IF sy-subrc EQ 0.
  WRITE / '둘리를 만족하는 데이터를 찾았다.'.
ELSE.
  WRITE / '둘리를 만족하는 데이터를 못찾았다.'.
ENDIF.
