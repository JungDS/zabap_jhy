*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_02_07
*&---------------------------------------------------------------------*
*& 반복문 WHILE 연습
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_02_07.


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

* SY-INDEX를 10으로 설정한다. 아래 WHILE문에서 SY-INDEX가 10보다 작을 때만 반복하도록 조건이 설정되어 있으나,
* 문제없이 작동한다.
SY-INDEX = 10.

WHILE SY-INDEX < 10. " 반복차수가 10 미만일 때만 진행한다. WHILE문 시작할 때 SY-INDEX가 1로 설정됨.
  GV_RESULT = PA_DAN * SY-INDEX.
  WRITE /1 PA_DAN.                  " 새로운 줄의 1번째 칸에 PA_DAN 을 출력
  WRITE    'X'.                     " 다음 순서에 'X' 문자를 출력
  WRITE    SY-INDEX.                " 다음 순서에 SY-INDEX 를 출력
  WRITE    '='.                     " 다음 순서에 '=' 문자를 출력
  WRITE    GV_RESULT.               " 다음 순서에 GV_RESULT를 출력
ENDWHILE.
