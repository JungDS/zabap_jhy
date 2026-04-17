*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_02_04
*&---------------------------------------------------------------------*
*& 반복문 DO n Times 연습
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_02_04.

PARAMETERS PA_DAN TYPE I.

" PA_DAN 이 2부터 9가 아닐 때
*IF NOT PA_DAN BETWEEN 2 AND 9.
IF PA_DAN NOT BETWEEN 2 AND 9 .
  WRITE '구구단은 2부터 9까지만 입력이 가능합니다.'.
  " 로직 중단
  EXIT.
ENDIF.

" 여기에 있는 로직은, 위의 IF 조건에 해당되지 않는 경우
DATA GV_RESULT TYPE I.
DO 9 TIMES.
  GV_RESULT = PA_DAN * SY-INDEX.
  WRITE /1 PA_DAN.    " 새로운 줄의 1번째 칸에 PA_DAN 을 출력
  WRITE    'X'.       " 다음 순서에 'X' 문자를 출력
  WRITE    SY-INDEX.  " 다음 순서에 SY-INDEX 를 출력
  WRITE    '='.       " 다음 순서에 '=' 문자를 출력
  WRITE    GV_RESULT. " 다음 순서에 GV_RESULT를 출력
ENDDO.
