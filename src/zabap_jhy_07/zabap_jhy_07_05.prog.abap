*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_07_05
*&---------------------------------------------------------------------*
*& ALV Grid 예제 ( Field Catalog 자동 구성 )
*&---------------------------------------------------------------------*
REPORT zabap_jhy_07_05 MESSAGE-ID zabap_jhy_msg.

* 선언 관련된 Include => 직접 Double Click 해서 들어가 기입해야 한다.
INCLUDE zabap_jhy_07_05_top. " 전역변수 선언
INCLUDE zabap_jhy_07_05_scr. " Selection Screen
INCLUDE zabap_jhy_07_05_cls. " Class

* 구현 관련된 Include => 직접 Double Click 하지 않고, 주로 로직을 호출하는 문장을 통해 접근한다.
*                        예) PERFORM abc, MODULE abc_0100 등
INCLUDE zabap_jhy_07_05_pbo. " PBO
INCLUDE zabap_jhy_07_05_pai. " PAI
INCLUDE zabap_jhy_07_05_f01. " Subroutines

*--------------------------------------------------------------------*
* ABAP Event 시작 *
*--------------------------------------------------------------------*
INITIALIZATION.

AT SELECTION-SCREEN.

START-OF-SELECTION.

* Selection Screen의 검색조건이 적용된 데이터만 가져오는 로직
  PERFORM select_data.

* 화면에 데이터를 출력하기 위해 Display 에 적재
  PERFORM make_display_data.

* 화면 0100을 출력
  PERFORM display_data.
