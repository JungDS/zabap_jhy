*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_19
*&---------------------------------------------------------------------*
*& CRUD 개념 예제 (Internal Table 기반)
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_19.

TYPES: BEGIN OF ty_student,
         student_id TYPE n LENGTH 8,   " 키(Key)
         student_nm TYPE c LENGTH 20,
         dept       TYPE c LENGTH 20,
       END OF ty_student.

DATA gt_student TYPE STANDARD TABLE OF ty_student WITH EMPTY KEY.
DATA gs_student TYPE ty_student.

START-OF-SELECTION.
  WRITE: / '===== 1) CREATE ====='.
  " CREATE: APPEND로 신규 행 추가
  gs_student-student_id = '20260001'. gs_student-student_nm = '김하나'. gs_student-dept = '회계'. APPEND gs_student TO gt_student.
  gs_student-student_id = '20260002'. gs_student-student_nm = '이둘'.   gs_student-dept = '물류'. APPEND gs_student TO gt_student.
  PERFORM display_all.

  SKIP.
  WRITE: / '===== 2) READ ====='.
  " READ: 키 기반 조회 (여기서는 student_id를 키처럼 사용)
  READ TABLE gt_student INTO gs_student WITH KEY student_id = '20260002'.
  IF sy-subrc = 0.
    WRITE: / '조회 성공 ->', gs_student-student_id, gs_student-student_nm, gs_student-dept.
  ELSE.
    WRITE: / '조회 실패: 해당 키 없음'.
  ENDIF.

  SKIP.
  WRITE: / '===== 3) UPDATE ====='.
  " UPDATE: 기존 행 변경 후 MODIFY
  READ TABLE gt_student INTO gs_student WITH KEY student_id = '20260002'.
  IF sy-subrc = 0.
    gs_student-dept = '생산'.
    MODIFY gt_student FROM gs_student INDEX sy-tabix.
  ENDIF.
  PERFORM display_all.

  SKIP.
  WRITE: / '===== 4) DELETE ====='.
  " DELETE: 키 조건으로 삭제
  DELETE gt_student WHERE student_id = '20260001'.
  PERFORM display_all.

  SKIP.
  WRITE: / '※ 실무에서는 Internal Table 대신 DB 테이블에 대해'.
  WRITE: / '  INSERT / SELECT / UPDATE / DELETE(Open SQL)를 수행하며,'.
  WRITE: / '  COMMIT WORK, LOCK, 권한, 예외 처리 등을 추가로 고려해야 합니다.'.

FORM display_all.
  DATA ls_student TYPE ty_student.

  LOOP AT gt_student INTO ls_student.
    WRITE: / ls_student-student_id, ls_student-student_nm, ls_student-dept.
  ENDLOOP.
ENDFORM.
