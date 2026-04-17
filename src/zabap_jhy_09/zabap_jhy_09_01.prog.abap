*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_09_01
*&---------------------------------------------------------------------*
*& Custom Container 예제
*&
*& 개념: Dynpro의 “Custom Control” 영역에 컨트롤을 올리는 기본 컨테이너
*&
*& 대표 활용: ALV Grid / Tree / HTML Viewer / Picture / Chart 등 거의 모든 컨트롤의 베이스
*&
*& 예) 화면 0100에 Custom Control 1개 만들어 ALV Grid 표시
*&
*&---------------------------------------------------------------------*
REPORT zabap_jhy_09_01 MESSAGE-ID zabap_jhy_msg.

* 선언 관련된 Include => 직접 Double Click 해서 들어가 기입해야 한다.
INCLUDE zabap_jhy_09_01_top. " 전역변수 선언
INCLUDE zabap_jhy_09_01_scr. " Selection Screen
INCLUDE zabap_jhy_09_01_cls. " Class

* 구현 관련된 Include => 직접 Double Click 하지 않고, 주로 로직을 호출하는 문장을 통해 접근한다.
*                        예) PERFORM abc, MODULE abc_0100 등
INCLUDE zabap_jhy_09_01_pbo. " PBO
INCLUDE zabap_jhy_09_01_pai. " PAI
INCLUDE zabap_jhy_09_01_f01. " Subroutines


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
  PERFORM select_data.
  PERFORM make_display_data.
  PERFORM display_data.
