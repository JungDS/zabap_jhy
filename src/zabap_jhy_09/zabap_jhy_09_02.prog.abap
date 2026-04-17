*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_09_01
*&---------------------------------------------------------------------*
*& Custom Container 예제 2
*&
*& Selection Screen을 Subscreen으로 구성한 후
*& Custom Container + ALV Grid 조합으로 결과를 출력하는 예제
*&
*&---------------------------------------------------------------------*
REPORT zabap_jhy_09_02.

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
* 프로그램 최초 실행 시 1회 수행되는 이벤트
* Selection Screen이 출력되기 전에 초기값 설정 및 기본 데이터 준비
INITIALIZATION.
  PERFORM init_data.  " 초기값 세팅 (예: 기본 조회조건, Variant 초기화 등)

**************************************************** At Selection-screen
* Selection Screen이 그려지기 직전에 반복 호출되는 이벤트
* 화면 속성 변경 (활성/비활성, 숨김, 값 변경 등)에 사용
AT SELECTION-SCREEN OUTPUT.
  PERFORM modify_screen_1000.  " SCREEN 구조를 활용한 동적 화면 제어

* Selection Screen에서 사용자 액션 발생 시 실행
* (예: Enter, 버튼 클릭, 값 변경 후 검증 등)
AT SELECTION-SCREEN.
  PERFORM user_command_1000.  " 입력값 검증 및 사용자 명령 처리

***************************************************** Start-of-selection
START-OF-SELECTION.

* Selection Screen 입력 완료 후, 실제 로직이 시작되는 메인 이벤트
* 일반적으로 데이터 조회 및 화면 출력 로직을 수행
START-OF-SELECTION.

* 데이터 조회 (DB SELECT)
*  PERFORM select_data.

* 조회된 데이터를 화면 출력용 구조로 가공
*  PERFORM make_display_data.

* 실제 화면 출력 (ALV 등)
  PERFORM display_data.
