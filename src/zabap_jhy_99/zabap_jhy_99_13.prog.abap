*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_13
*&---------------------------------------------------------------------*
*& 조건문(IF / CASE) 기초 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_13.

DATA gv_score  TYPE i VALUE 82.
DATA gv_status TYPE c LENGTH 1 VALUE 'A'.
DATA gv_grade  TYPE c LENGTH 2.
DATA gv_text   TYPE string.

START-OF-SELECTION.
  WRITE: / '===== IF / ELSEIF / ELSE ====='.
  WRITE: / '입력 점수:', gv_score.

  IF gv_score >= 90.
    gv_grade = 'A'.
  ELSEIF gv_score >= 80.
    gv_grade = 'B'.
  ELSEIF gv_score >= 70.
    gv_grade = 'C'.
  ELSE.
    gv_grade = 'F'.
  ENDIF.

  WRITE: / '평가 등급:', gv_grade.

  SKIP.
  WRITE: / '===== CASE ====='.
  WRITE: / '상태 코드:', gv_status.

  CASE gv_status.
    WHEN 'A'.
      gv_text = '정상 처리'.
    WHEN 'B'.
      gv_text = '검토 필요'.
    WHEN 'C'.
      gv_text = '보류 상태'.
    WHEN OTHERS.
      gv_text = '정의되지 않은 상태'.
  ENDCASE.

  WRITE: / '상태 설명:', gv_text.
