*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_09_01
*&---------------------------------------------------------------------*
*& Dialog Box Container 예제
*&
*& 개념: 별도 팝업 창 형태로 컨트롤 표시
*&
*& 대표 활용: 상세보기 팝업, 차트/미리보기 팝업, 도움말 팝업
*&
*& 예) ALV에서 더블클릭 시 팝업으로 상세 ALV 표시
*&
*&---------------------------------------------------------------------*
REPORT zabap_jhy_09_04.

* 선언 관련된 Include => 직접 Double Click 해서 들어가 기입해야 한다.
INCLUDE zabap_jhy_09_04_top. " 전역변수 선언
INCLUDE zabap_jhy_09_04_scr. " Selection Screen
INCLUDE zabap_jhy_09_04_cls. " Class

* 구현 관련된 Include => 직접 Double Click 하지 않고, 주로 로직을 호출하는 문장을 통해 접근한다.
*                        예) PERFORM abc, MODULE abc_0100 등
INCLUDE zabap_jhy_09_04_pbo. " PBO
INCLUDE zabap_jhy_09_04_pai. " PAI
INCLUDE zabap_jhy_09_04_f01. " Subroutines


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
