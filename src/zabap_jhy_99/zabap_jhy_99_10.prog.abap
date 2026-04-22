*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_10
*&---------------------------------------------------------------------*
*& 변수 / 상수 기초 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_10.

"-----------------------------------------------------------------------
" [학습 포인트]
" 1) DATA로 변경 가능한 변수 선언
" 2) CONSTANTS로 변경 불가능한 상수 선언
" 3) 문자/숫자/날짜/시간 타입의 기본 사용
" 4) 문자열 연결 연산자(&&) 사용
" 5) 값이 변경되면서 출력이 달라지는 흐름 이해
"-----------------------------------------------------------------------

" 문자형 변수
DATA gv_student_name TYPE c LENGTH 20 VALUE '홍길동'.
" 숫자형 변수
DATA gv_score        TYPE i VALUE 80.
" 날짜/시간 변수 (시스템 날짜/시간으로 초기화)
DATA gv_today        TYPE d VALUE sy-datum.
DATA gv_now          TYPE t VALUE sy-uzeit.
" 문자열 변수 (가변 길이 문자열)
DATA gv_message      TYPE string.

" 상수 선언: 한 번 정하면 변경할 수 없음
CONSTANTS gc_class_name TYPE c LENGTH 20 VALUE 'ABAP 초급반'.
CONSTANTS gc_bonus      TYPE i VALUE 5.

START-OF-SELECTION.
  WRITE: / '===== [초기 값] ====='.
  WRITE: / '학생명:', gv_student_name.
  WRITE: / '반명(상수):', gc_class_name.
  WRITE: / '점수:', gv_score.
  WRITE: / '날짜:', gv_today.
  WRITE: / '시간:', gv_now.

  " 문자열 연결: && 연산자를 사용해 문장을 만든다.
  gv_message = gv_student_name && '님의 현재 점수는 ' && gv_score && '점 입니다.'.
  WRITE: / gv_message.

  SKIP.
  WRITE: / '===== [값 변경 후] ====='.

  " 변수는 변경 가능하므로 새로운 값을 대입한다.
  gv_score = gv_score + gc_bonus.
  gv_student_name = '김초급'.

  gv_message = gv_student_name && '님의 보너스 반영 점수는 ' && gv_score && '점 입니다.'.

  WRITE: / '학생명(변경):', gv_student_name.
  WRITE: / '점수(변경):', gv_score.
  WRITE: / gv_message.
