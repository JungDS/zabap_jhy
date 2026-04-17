*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_02_02
*&---------------------------------------------------------------------*
*& 조건문 CASE 문 연습 ( with Radio Button )
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_02_02.


PARAMETERS PA_RB1 RADIOBUTTON GROUP RBG1.
PARAMETERS PA_RB2 RADIOBUTTON GROUP RBG1.
PARAMETERS PA_RB3 RADIOBUTTON GROUP RBG1.



WRITE / '[CASE Before] 이 문장은 특정 조건과 관계없이 항상 실행된다.'.

SKIP.

CASE ABAP_ON.

  WHEN PA_RB1.
    WRITE / '[In CASE] 첫번째 라디오 버튼을 선택한 경우 이 구간의 문장이 실행된다.'.

  WHEN PA_RB2.
    WRITE / '[In CASE] 두번째 라디오 버튼을 선택한 경우 이 구간의 문장이 실행된다.'.

  WHEN PA_RB3.
    WRITE / '[In CASE] 세번째 라디오 버튼을 선택한 경우 이 구간의 문장이 실행된다.'.

ENDCASE.

SKIP.

WRITE / '[CASE After] 이 문장은 특정 조건과 관계없이 항상 실행된다.'.
