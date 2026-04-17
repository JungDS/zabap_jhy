*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_09_01
*&---------------------------------------------------------------------*
*& Custom Container 예제 2
*&
*& Selection Screen을 Subscreen으로 구성한 후
*& Custom Container + ALV Grid 조합으로 결과를 출력하는 예제
*&
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_09_02.

* 선언 관련된 Include => 직접 Double Click 해서 들어가 기입해야 한다.
INCLUDE zabap_jhy_09_02_top. " 전역변수 선언
INCLUDE zabap_jhy_09_02_scr. " Selection Screen
INCLUDE zabap_jhy_09_02_cls. " Class

* 구현 관련된 Include => 직접 Double Click 하지 않고, 주로 로직을 호출하는 문장을 통해 접근한다.
*                        예) PERFORM abc, MODULE abc_0100 등
INCLUDE zabap_jhy_09_02_pbo. " PBO
INCLUDE zabap_jhy_09_02_pai. " PAI
INCLUDE zabap_jhy_09_02_f01. " Subroutines


********************************************************* Initialization
INITIALIZATION.
  PERFORM init_data.

**************************************************** At Selection-screen
AT SELECTION-SCREEN OUTPUT.
  PERFORM modify_screen_1000.

AT SELECTION-SCREEN.
  PERFORM user_command_1000.

***************************************************** Start-of-selection
START-OF-SELECTION.
*  PERFORM select_data.
*  PERFORM make_display_data.
  PERFORM display_data.
