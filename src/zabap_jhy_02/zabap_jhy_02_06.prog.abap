*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_02_06
*&---------------------------------------------------------------------*
*& 반복문 DO 연습
*&---------------------------------------------------------------------*
REPORT zabap_jhy_02_06.

PARAMETERS pa_dan TYPE i.

" PA_DAN 이 2부터 9가 아닐 때
*IF NOT PA_DAN BETWEEN 2 AND 9.
IF pa_dan NOT BETWEEN 2 AND 9 .
  WRITE '구구단은 2부터 9까지만 입력이 가능합니다.'.
  " 로직 중단
  EXIT.
ENDIF.

" 여기에 있는 로직은, 위의 IF 조건에 해당되지 않는 경우
DATA gv_result TYPE i.
DO.
  gv_result = pa_dan * sy-index.
  WRITE /1 pa_dan.    " 새로운 줄의 1번째 칸에 PA_DAN 을 출력
  WRITE    'X'.       " 다음 순서에 'X' 문자를 출력
  WRITE    sy-index.  " 다음 순서에 SY-INDEX 를 출력
  WRITE    '='.       " 다음 순서에 '=' 문자를 출력
  WRITE    gv_result. " 다음 순서에 GV_RESULT를 출력

  IF sy-index EQ 9.
    EXIT.   " 반복차수가 9가 될 때 반복을 종료한다.
  ENDIF.
ENDDO.
