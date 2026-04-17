*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_07_04
*&---------------------------------------------------------------------*
*& ALV Grid 예제 ( Style )
*& STYLE <<-- 주로 사용하는 3가지 기능,
*&  1. 특정 필드를 수정 가능하게 만드는 기능
*&  2. 특정 필드를 버튼으로 만드는 기능
*&  3. 특정 필드만 Hotspot 으로 만드는 기능
*&---------------------------------------------------------------------*
*& SFLIGHT 의 비행일자가 오늘 이전인 경우 일정 취소 버튼이 보이지 않고,
*& SFLIGHT 의 비행일자가 오늘 이후인 경우 일정 취소 버튼이 보인다.
*& 관리자는 해당 버튼을 통해 비행일정을 취소할 수 있으며,
*& 취소버튼을 눌렀을 때는 해당 비행에 대해 정말 취소할 것인지 물어보는 팝업창 기능도 지원해야 한다.
*&---------------------------------------------------------------------*
REPORT zabap_jhy_07_04 MESSAGE-ID zabap_jhy_msg.


* 선언 관련된 Include => 직접 Double Click 해서 들어가 기입해야 한다.
INCLUDE zabap_jhy_07_04_top. " 전역변수 선언
INCLUDE zabap_jhy_07_04_scr. " Selection Screen
INCLUDE zabap_jhy_07_04_cls. " Class


* 구현 관련된 Include => 직접 Double Click 하지 않고, 주로 로직을 호출하는 문장을 통해 접근한다.
*                        예) PERFORM abc, MODULE abc_0100 등
INCLUDE zabap_jhy_07_04_pbo. " PBO
INCLUDE zabap_jhy_07_04_pai. " PAI
INCLUDE zabap_jhy_07_04_f01. " Subroutines


*  PARAMETERS pa_car  type scarr-carrid.  " dictionary 에서 참조
*  PARAMETERS pa_test type c.             " standard type 으로 선언

*--------------------------------------------------------------------*
* Include 에 대한 선언이 종료된 후 Program 로직을 구현한다.
*--------------------------------------------------------------------*
INITIALIZATION. " 가장 먼저 실행되는 로직

AT SELECTION-SCREEN OUTPUT. " Selection Screen 이 출력 전에 항상 호출되는 로직 구간
*  message 'at selection-screen output에서 보여주는 메세지다.' type 'S'.

AT SELECTION-SCREEN. " Selection Screen 이 출력 후에 사용자에 의해 특정 이벤트가
  " 발생한 후에 호출되는 로직 구간 ( 예: 실행버튼 또는 엔터 등 )
*  message 'at selection-screen에서 보여주는 메세지다.' type 'I'.

*at SELECTION-SCREEN on pa_test.
*  message 'at selection-screen 중 pa_test 필드 값에 대한 점검 과정이다.' type 'I'.

*at SELECTION-SCREEN on VALUE-REQUEST FOR pa_test.
*  message '언제 실행이 되는 걸까?' type 'I'.

START-OF-SELECTION. " AT SELECTION-SCREEN 의 로직이 완료가 되었는데,
  " 사용자가 실행버튼을 눌렀다면,
  " Selection Screen으로 복귀 하지 않고, 본 로직 구간을 실행한다.
*  message 'start-of-selection에서 보여주는 메세지다.' type 'I'.

  PERFORM select_data.        " GT_DATA 에 데이터가 생성되는 과정
  PERFORM make_display_data.  " GT_DATA 에서 GT_DISPLAY 로 옮기는 과정
  PERFORM display_data.       " GT_DISPLAY 의 데이터를 화면에 출력하는 과정
