*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_03_09
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_03_09.


SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-T01. " " Frame 생성 + 제목 TEXT-T01( Selection Option )
  PARAMETERS PA_X TYPE C.
  SELECTION-SCREEN COMMENT /1(50) TEXT-M01. " 안내! 입력필드에는 'X' 이외 값은 오류입니다.
  SELECTION-SCREEN SKIP.

  PARAMETERS PA_1 TYPE C.
  SELECTION-SCREEN COMMENT /1(50) TEXT-M02. " 안내! 입력필드에는 '1' 이외 값은 오류입니다.
  SELECTION-SCREEN SKIP.

  PARAMETERS PA_2 TYPE C.
  SELECTION-SCREEN COMMENT /1(50) TEXT-M03. " 안내! 입력필드에는 '2' 이외 값은 오류입니다.
  SELECTION-SCREEN SKIP.

SELECTION-SCREEN END OF BLOCK B01.

PARAMETERS PA_Y1 TYPE C.
PARAMETERS PA_Y2 TYPE C.

SELECT-OPTIONS SO_Z1 FOR PA_Y1.
SELECT-OPTIONS SO_Z2 FOR PA_Y1.

*--------------------------------------------------------------------*
* AT SELECTION-SCREEN.                                         : Selection Screen의 입력값 점검
* AT SELECTION-SCREEN ON BLOCK [블록명].                       : Selection Screen 특정 블록의 입력값 점검
* AT SELECTION-SCREEN ON RADIOBUTTON GROUP [라디오버튼그룹명]. : Selection Screen 특정 라디오버튼그룹의 입력값 점검
* AT SELECTION-SCREEN ON [PARAMETER명].                        : Selection Screen 특정 PARAMETERS의 입력값 점검
* AT SELECTION-SCREEN ON [SELECT-OPTIONS명].                   : Selection Screen 특정 SELECT-OPTIONS의 입력값 점검
*--------------------------------------------------------------------*
AT SELECTION-SCREEN ON PA_X.

* PA_X 에 대한 점검
  CHECK PA_X NE 'X'.

* PA_X는 X만 허용됩니다.
  MESSAGE TEXT-E01 TYPE 'E'.


AT SELECTION-SCREEN ON PA_1.

* PA_1 에 대한 점검
  CHECK PA_1 NE '1'.

* PA_1는 1만 허용됩니다.
  MESSAGE TEXT-E02 TYPE 'E'.


AT SELECTION-SCREEN ON PA_2.

* PA_2 에 대한 점검
  CHECK PA_2 NE '2'.

* PA_2는 2만 허용됩니다.
  MESSAGE TEXT-E03 TYPE 'E'.

*--------------------------------------------------------------------*
* START-OF-SELECTION.
*--------------------------------------------------------------------*
START-OF-SELECTION.

* 정상적으로 프로그램이 실행되었습니다.
  MESSAGE TEXT-M04 TYPE 'I'.
