*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_09_01
*&---------------------------------------------------------------------*
*& Docking Container 예제
*&
*& 개념: 화면의 상/하/좌/우에 “도킹”되는 영역 제공
*&
*& 대표 활용: 고정 패널(요약/툴박스/검색조건) + 화면
*&
*& 예1) 상단 Docking에 “조건 요약/버튼” 표시, 화면 Custom에 ALV
*&
*& 예2) 좌측 Docking에 즐겨찾기 Tree, 본문 ALV
*&
*& Selection Screen을 Subscreen으로 구성한 후
*& Docking Container + ALV Grid 조합으로 결과를 출력하는 예제
*&
*&---------------------------------------------------------------------*
REPORT zabap_jhy_09_03.

* 선언 관련된 Include => 직접 Double Click 해서 들어가 기입해야 한다.
INCLUDE zabap_jhy_09_03_top. " 전역변수 선언
INCLUDE zabap_jhy_09_03_scr. " Selection Screen
INCLUDE zabap_jhy_09_03_cls. " Class

* 구현 관련된 Include => 직접 Double Click 하지 않고, 주로 로직을 호출하는 문장을 통해 접근한다.
*                        예) PERFORM abc, MODULE abc_0100 등
INCLUDE zabap_jhy_09_03_pbo. " PBO
INCLUDE zabap_jhy_09_03_pai. " PAI
INCLUDE zabap_jhy_09_03_f01. " Subroutines


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
