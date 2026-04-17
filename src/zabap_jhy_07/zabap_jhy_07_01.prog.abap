*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_07_01
*&---------------------------------------------------------------------*
*& ALV Grid 예제 1
*&---------------------------------------------------------------------*
REPORT zabap_jhy_07_01.

* SCARR 의 항공사를 조건을 입력받는 SELECTION SCREEN을 만들고,
* 해당 조건을 기준으로 데이터를 조회하여 ALV 로 출력해라.

INCLUDE zabap_jhy_07_01_top. " 전역변수
INCLUDE zabap_jhy_07_01_scr. " Selection Screen
*INCLUDE zabap_jhy_07_01_cls. " Local Class ( ALV Event )
INCLUDE zabap_jhy_07_01_pbo. " Process Before Output
INCLUDE zabap_jhy_07_01_pai. " Process After Input
INCLUDE zabap_jhy_07_01_f01. " FORM Subroutines

INITIALIZATION.

AT SELECTION-SCREEN.

START-OF-SELECTION.

  PERFORM select_data.

  PERFORM display_data.
