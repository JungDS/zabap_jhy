*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_01_00
*&---------------------------------------------------------------------*
*& Local Type 과 Global Type 비교
*&---------------------------------------------------------------------*
REPORT zabap_jhy_01_00.

* 문자 1자리를 다루는 Local Type을 선언했다.
TYPES ty_char1 TYPE c.

* Local Type을 이용해 변수를 선언했다.
PARAMETERS p_c_by_l TYPE ty_char1.


* 한 줄 간격 두기
SELECTION-SCREEN SKIP.


* Data Element XFELD를 이용해 변수를 선언했다.
* XFELD 는 문자 1자리를 취급하는 Data Element다.
PARAMETERS p_c_by_g TYPE xfeld.


* 한 줄 간격 두기
SELECTION-SCREEN SKIP.


PARAMETERS p_carrid TYPE s_carr_id.
