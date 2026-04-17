*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_03_04
*&---------------------------------------------------------------------*
*& Selection Screen User Command 연습
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_03_04.


TABLES SSCRFIELDS.

* TEXT-T01: 선택 조건
SELECTION-SCREEN BEGIN OF BLOCK BLOCK_01 WITH FRAME TITLE TEXT-T01.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 01(10) TEXT-L01. " Text Symbol L01(현재 시간)로 문자열 출력
    SELECTION-SCREEN COMMENT 20(10) GV_TIME.  " 변수 GV_TIME가 생성되면서    문자열 출력
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN PUSHBUTTON /20(10) TEXT-L02 USER-COMMAND COMM1.  " L02: 'A' 를 출력
  SELECTION-SCREEN PUSHBUTTON  40(10) TEXT-L03 USER-COMMAND COMM2.  " L03: 'B' 를 출력
  SELECTION-SCREEN PUSHBUTTON /40(20) TEXT-L04 USER-COMMAND COMM3.  " L04: 화면 1100을 출력

SELECTION-SCREEN END OF BLOCK BLOCK_01.

SELECTION-SCREEN BEGIN OF SCREEN 1100.
  SELECTION-SCREEN PUSHBUTTON  01(10) TEXT-L05 USER-COMMAND COMM4.  " L05: 닫기
SELECTION-SCREEN END OF SCREEN 1100.



* 설명: 프로그램이 실행되면, 가장 먼저 호출되는 이벤트
* 용도: Selection Screen의 초기값 설정
INITIALIZATION.

* 설명: Selection Screen이 출력될 때마다 그 직전에 호출되는 이벤트
* 용도: Selection Screen의 화면 속성 변경이나 출력하고 싶은 부분의 변경, 화면이 출력되기 전에 처리해야하는 로직 등
AT SELECTION-SCREEN OUTPUT.
  WRITE SY-UZEIT TO GV_TIME. " GV_TIME에게 SY-UZEIT의 값을 출력하여 기록

* 설명: Selection Screen에서 사용자에 의해 Enter, Button Click 등으로 User Command 값이 SSCRFIELDS와 SY에 기록될 때 호출되는 이벤트
* 용도: Selection Screen의 입력값 점검이나 버튼에 따른 작동로직 정의 등
AT SELECTION-SCREEN.
  CASE SY-DYNNR.
    WHEN '1000'.
      PERFORM USER_COMMAND_1000.
    WHEN '1100'.
      PERFORM USER_COMMAND_1100.
  ENDCASE.


START-OF-SELECTION.

  WRITE / 'SELECTION SCREEN에서 실행 버튼을 통해 실행됨'.


*&---------------------------------------------------------------------*
*& Form USER_COMMAND_1000
*&---------------------------------------------------------------------*
FORM USER_COMMAND_1000 .

* Selection Screen의 User Command 값이 SY-UCOMM         에 기록되는가??
* Selection Screen의 User Command 값이 SSCRFIELDS-UCOMM 에 기록되는가??
* 왜 SY-UCOMM 이 아니라 SSCRFIELDS-UCOMM 을 사용하는가?

* 하나의 변수의 값을 기준으로 다수의 값과 비교할 때 CASE 문이 효율적이다.
  CASE SSCRFIELDS-UCOMM.
    WHEN 'COMM1'.
      MESSAGE 'A' TYPE 'I'.
    WHEN 'COMM2'.
      MESSAGE 'B' TYPE 'I'.
    WHEN 'COMM3'.
      CALL SELECTION-SCREEN 1100 STARTING AT 30 5.    " 팝업 위치 지정(Columns / Rows)
      IF SY-SUBRC EQ 0.
        MESSAGE '1100 화면에서 실행되었습니다.' TYPE 'I'.
      ELSE.
        MESSAGE '1100 화면에서 취소되었습니다.' TYPE 'I'.
      ENDIF.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form USER_COMMAND_1100
*&---------------------------------------------------------------------*
FORM USER_COMMAND_1100 .

* 하나의 변수의 값을 기준으로 다수의 값과 비교할 때 CASE 문이 효율적이다.
  CASE SSCRFIELDS-UCOMM.
    WHEN 'COMM4'. " 이 USER-COMMAND는 1100 화면의 버튼이 가지고 있다.
      MESSAGE '닫기 버튼을 눌렀습니다.' TYPE 'I'.
      LEAVE TO SCREEN 0.  " 이전화면으로 이동 ( 즉, 팝업창 출력 전 화면 )
  ENDCASE.

ENDFORM.
