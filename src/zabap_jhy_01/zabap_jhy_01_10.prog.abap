*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_01_10
*&---------------------------------------------------------------------*
*& Structure 변수의 독특한 사용 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_01_10.

DATA: BEGIN OF gs_data,
        field1 TYPE char4,  " CHAR4  => Data Element
        field2 TYPE numc10, " NUMC10 => Data Element
        field3 TYPE char6,  " CHAR6  => Data Element
*        FIELD4 TYPE I,
      END OF gs_data.

gs_data-field1 = 'ABCD'.
gs_data-field2 = '1234567890'.
gs_data-field3 = '가나다'.

* Structure의 모든 Component의 타입이 문자열에 해당되면 하나의 변수처럼 취급이 가능하다.
WRITE: / 'GS_DATA =>', gs_data.

gs_data = '11112222222222333333'.

ULINE.

WRITE: / 'GS_DATA =>', gs_data.
WRITE: / 'GS_DATA-FIELD1 문자 4자리 =>', gs_data-field1.
WRITE: / 'GS_DATA-FIELD2 숫자형 문자 10자리 =>', gs_data-field2.
WRITE: / 'GS_DATA-FIELD3 문자 6자리 =>', gs_data-field3.
