*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_02_00
*&---------------------------------------------------------------------*
*& 입력필드로 입력받고 출력하기
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_02_00.

PARAMETERS PA_NUM TYPE I.

DATA GV_RESULT TYPE I.

MOVE PA_NUM TO GV_RESULT.

ADD 1 TO GV_RESULT.

WRITE 'Your input:'.
WRITE PA_NUM.

NEW-LINE.

WRITE 'Result:    '.
WRITE GV_RESULT.
