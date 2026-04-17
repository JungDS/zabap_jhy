*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_07_07
*&---------------------------------------------------------------------*
*& ALV Grid 예제 2-2 ( 2xClick + Dock. Container )
*&---------------------------------------------------------------------*
REPORT zabap_jhy_07_07 MESSAGE-ID zabap_jhy_msg.

* 선언 관련된 Include => 직접 Double Click 해서 들어가 기입해야 한다.
INCLUDE zabap_jhy_07_07_top. " 전역변수 선언
INCLUDE zabap_jhy_07_07_scr. " Selection Screen
INCLUDE zabap_jhy_07_07_cls. " Class

* 구현 관련된 Include => 직접 Double Click 하지 않고, 주로 로직을 호출하는 문장을 통해 접근한다.
*                        예) PERFORM abc, MODULE abc_0100 등
INCLUDE zabap_jhy_07_07_pbo. " PBO
INCLUDE zabap_jhy_07_07_pai. " PAI
INCLUDE zabap_jhy_07_07_f01. " Subroutines


********************************************************* Initialization
INITIALIZATION.
  PERFORM init.

**************************************************** At Selection-screen
AT SELECTION-SCREEN OUTPUT.
  PERFORM modify_screen_1000.

AT SELECTION-SCREEN.
  PERFORM user_command_1000.

***************************************************** Start-of-selection
START-OF-SELECTION.
  PERFORM select_data.
  PERFORM make_display_data.
  PERFORM display_data.
