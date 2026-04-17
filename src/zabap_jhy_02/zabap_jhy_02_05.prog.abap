*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_02_05
*&---------------------------------------------------------------------*
*& 반복문 DO n Times 연습 ( 출력 넓이 조정 버전 )
*&---------------------------------------------------------------------*
REPORT ZABAP_JHY_02_05.


* 구구단의 단수를 입력받는 Parameter를 만든다.
* 단수는 1자리만 입력받도록 N 타입 1자리로 선언한다.
PARAMETERS PA_DAN TYPE N LENGTH 1.

IF NOT PA_DAN BETWEEN 2 AND 9.
  WRITE / '단수는 2부터 9사이의 값을 입력하세요.'.
  EXIT. " 여기서 EXIT는 프로그램의 중단을 의미한다.
ENDIF.

DATA GV_RESULT TYPE I. " 단 * 배수 = 결과를 보관할 변수
DO.
  " SY-INDEX는 반복횟수가 기록된 시스템 변수
  " 반복 1회차 = 1, 반복 2회차 = 2 ...
  GV_RESULT = PA_DAN * SY-INDEX.

  WRITE : /03(1) PA_DAN,
           06(1) '*',
           09(1) SY-INDEX LEFT-JUSTIFIED,
           12(1) '=',
           15(2) GV_RESULT RIGHT-JUSTIFIED no-sign.

  IF SY-INDEX EQ 9. " EQ 는 '='와 동일한 뜻
    EXIT. " 여기서 EXIT는 반복의 중단을 의미한다.
  ENDIF.
ENDDO.
