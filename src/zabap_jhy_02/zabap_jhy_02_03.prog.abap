*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_02_03
*&---------------------------------------------------------------------*
*& 조건문 CASE 문 연습
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_02_03.


DATA GV_STR_1 TYPE STRING.  " 문자열 변수


GV_STR_1 = 'ABCD'.


CASE GV_STR_1.
  WHEN 'AB'.
    WRITE / 'GV_STR_1은 AB와 동일한 값을 가진다.'.
  WHEN 'ABC'.
    WRITE / 'GV_STR_1은 ABC와 동일한 값을 가진다.'.
  WHEN 'ABCD'.
    WRITE / 'GV_STR_1은 ABCD와 동일한 값을 가진다.'.
  WHEN 'ABCDE'.
    WRITE / 'GV_STR_1은 ABCDE와 동일한 값을 가진다.'.
  WHEN OTHERS.
    WRITE / 'GV_STR_1은 WHEN의 경우에 해당되지 않는다.'.
ENDCASE.


DATA GV_STR_2 TYPE STRING.
DATA GV_STR_3 TYPE STRING.

GV_STR_2 = 'BCD'.
GV_STR_3 = 'ABC'.

CASE 'ABC'.
  WHEN GV_STR_1.  " ABCD
    WRITE / 'ABC와 동일한 값을 가진 GV_STR_1'.
  WHEN GV_STR_2.  " BCD
    WRITE / 'ABC와 동일한 값을 가진 GV_STR_2'.
  WHEN GV_STR_3.  " ABC
    WRITE / 'ABC와 동일한 값을 가진 GV_STR_3'.
  WHEN OTHERS.
ENDCASE.
