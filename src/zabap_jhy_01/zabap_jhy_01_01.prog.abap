*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_01_01
*&---------------------------------------------------------------------*
*& 변수 선언 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_01_01.


* Local 타입의 선언
TYPES ty_char3 TYPE c LENGTH 3.

* Local 타입으로 Parameter 선언 ( 이름 최대 길이 8자리 )
PARAMETERS pa_local TYPE ty_char3.
*PARAMETERS PA_LOCALA TYPE TY_CHAR3. <-- 오류 발생. 왜? PA_LOCALA 이 9자리 문자라서

* Global 타입으로 Parameter 선언 ( S_CARR_ID => ABAP Dictionary에 정의된 Data Element로 Global 타입으로 취급한다. )
PARAMETERS pa_globa TYPE s_carr_id.


* Gobal 타입으로 변수 선언
DATA gv_carrid1 TYPE scarr-carrid.

* LIKE 뒤에 작성한 변수와 똑같은 모양의 변수를 선언
DATA gv_carrid2 LIKE gv_carrid1.


* ABAP Dictionary에 정의된 Structure 타입으로 선언된 Dictionary Structure 변수 선언
TABLES scarr.

* ABAP Dictionary에 정의된 Structure 타입으로 선언된 Structure 변수 선언
DATA gs_scarr TYPE scarr.

* ABAP Dictionary에 정의된 Structure 타입의 특정 Component로 변수 선언
DATA gv_carrid TYPE scarr-carrid.


* ABAP Standard Type으로 변수 선언
DATA:
  gv_char TYPE c LENGTH 10,           " 10자리​ 문자
  gv_numc TYPE n LENGTH 4,            " 4자리 숫자형 문자​
  gv_pack TYPE p LENGTH 5 DECIMALS 2, " 실수( 정수 5자리 소수점 2자리 )
  gv_date TYPE d,                     " 날짜 (EX) 2024.01.18​
  gv_time TYPE t,                     " 시간 (EX) 12:30:26            ​
  gv_int  TYPE i.                     " 정수( 소수점 자릿수 없음 )



* Structure 변수의 Component를 직접 하나하나 구성하는 방법
DATA: BEGIN OF gs_my_str,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
      END OF gs_my_str.


* ABAP Dictionary에 정의된 정보로 Structure / Internal Table 변수 선언

DATA gs_scarr1 TYPE scarr. " Structure, Work Area
DATA gt_scarr1 LIKE TABLE OF gs_scarr1. " Itab​ ( Line Type => Structure )

DATA gt_scarr2 TYPE TABLE OF scarr. " Itab​ ( Line Type => Structure )
DATA gs_scarr2 LIKE LINE OF gt_scarr2. " Structure, Work Area​

DATA gt_scarr3 LIKE gt_scarr2. " Itab​ ( Line Type => Structure )
DATA gs_scarr3 LIKE LINE OF gt_scarr3. " Structure, Work Area​


* Data Element를 활용한 변수와 Internal Table 선언

DATA gv_carrname TYPE s_carrname. " Data Element, Work Area
DATA gt_carrname TYPE TABLE OF s_carrname. " Itab​ ( Line Type => Data Element )
