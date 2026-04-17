*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_07_03
*&---------------------------------------------------------------------*
*& ALV Grid 예제 ( Event )
*& SPFLI 테이블의 내용을 ALV로 화면에 출력하는 프로그램
*& [ 항공사, 항공편, 출발국가, 도착국가 ]가 Selection Screen의 검색조건이다.
*& 모든 화면의 입력필드는 SELECT-OPTIONS 로 선언한다.
*& 별도의 언급이 없으면 날짜만 NO-EXTENSION을 적용한다.
*&---------------------------------------------------------------------*
REPORT zabap_jhy_07_03 MESSAGE-ID zabap_jhy_msg.


* [ INCLUDE ], [ ABAP Event ] 순으로 Main Program에 기록한다.

* 선언 관련 Include
INCLUDE zabap_jhy_07_03_top. " 전역변수
INCLUDE zabap_jhy_07_03_scr. " Selection Screen
INCLUDE zabap_jhy_07_03_cls. " Local Class Definition & Implementation ( 정의 구현 )

* 구현 관련 Include
INCLUDE zabap_jhy_07_03_pbo. " Process Before Output
INCLUDE zabap_jhy_07_03_pai. " Process After Input
INCLUDE zabap_jhy_07_03_f01. " FORM Subroutines


********************************************************* Initialization
INITIALIZATION.

**************************************************** At Selection-screen
AT SELECTION-SCREEN.

***************************************************** Start-of-selection
START-OF-SELECTION.

  PERFORM SELECT_DATA.

  PERFORM MAKE_DISPLAY_DATA.

  PERFORM DISPLAY_DATA.

  " 여기까지가 START-OF-SELECTION의 로직으로 볼 수 있다.
  " 실제로 0100 화면이 끝난 이후 별도의 로직이 없기 때문
