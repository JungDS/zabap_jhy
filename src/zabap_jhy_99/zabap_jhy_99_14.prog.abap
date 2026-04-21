*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_14
*&---------------------------------------------------------------------*
*& 반복문(DO / WHILE / LOOP AT) 기초 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_14.

DATA gv_sum_do    TYPE i VALUE 0.
DATA gv_sum_while TYPE i VALUE 0.
DATA gv_num       TYPE i VALUE 1.

DATA gt_numbers TYPE STANDARD TABLE OF i WITH EMPTY KEY.
DATA gv_line    TYPE i.
DATA gv_sum_tab TYPE i VALUE 0.

START-OF-SELECTION.
  WRITE: / '===== DO 반복 ====='.
  " DO: 횟수가 정해진 반복
  DO 10 TIMES.
    " CONTINUE: 현재 반복의 아래 로직을 건너뛰고 다음 반복으로 이동
    IF sy-index = 5.
      CONTINUE.
    ENDIF.

    gv_sum_do = gv_sum_do + sy-index.

    " EXIT: 반복문 즉시 종료
    IF sy-index = 8.
      EXIT.
    ENDIF.
  ENDDO.
  WRITE: / 'DO 합계 결과(5는 제외, 8에서 종료):', gv_sum_do.

  SKIP.
  WRITE: / '===== WHILE 반복 ====='.
  " WHILE: 조건이 참인 동안 반복
  WHILE gv_num <= 10.
    gv_sum_while = gv_sum_while + gv_num.
    gv_num = gv_num + 1.
  ENDWHILE.
  WRITE: / 'WHILE 합계 결과(1~10):', gv_sum_while.

  SKIP.
  WRITE: / '===== LOOP AT 반복 ====='.
  APPEND 3 TO gt_numbers.
  APPEND 6 TO gt_numbers.
  APPEND 9 TO gt_numbers.
  APPEND 12 TO gt_numbers.

  LOOP AT gt_numbers INTO gv_line.
    " CHECK: 조건이 거짓이면 현재 LOOP pass를 중단하고 다음 pass로 이동
    CHECK gv_line <= 10.
    gv_sum_tab = gv_sum_tab + gv_line.
    WRITE: / '현재 값:', gv_line, '누적:', gv_sum_tab.
  ENDLOOP.

  SKIP.
  WRITE: / '반복 흐름 비교: DO=횟수 기반, WHILE=조건 기반, LOOP AT=내부테이블 기반'.
