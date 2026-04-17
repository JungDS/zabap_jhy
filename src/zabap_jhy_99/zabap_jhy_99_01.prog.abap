*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_01
*&---------------------------------------------------------------------*
*& [ Codex로 생성된 프로그램 ] 엑셀 업로드/대량데이터 생성 샘플
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_01.

TABLES: ztjhy_99_bulk.

TYPES: BEGIN OF ty_upload,
         row_id       TYPE int4,
         student_name TYPE char40,
         department   TYPE char20,
         email        TYPE ad_smtpadr,
         score        TYPE int4,
       END OF ty_upload.

DATA: gt_upload TYPE STANDARD TABLE OF ty_upload,
      gs_upload TYPE ty_upload,
      gt_excel  TYPE STANDARD TABLE OF alsmex_tabline,
      gs_excel  TYPE alsmex_tabline.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
PARAMETERS: p_file TYPE rlgrap-filename,
            p_rows TYPE i DEFAULT 1000,
            p_del  AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  TEXT-t01 = '[ Codex로 생성된 프로그램 ] 업로드 옵션'.

START-OF-SELECTION.
  IF p_file IS INITIAL.
    PERFORM generate_dummy_data.
  ELSE.
    PERFORM upload_from_excel.
  ENDIF.

  IF gt_upload IS INITIAL.
    MESSAGE '생성/업로드된 데이터가 없습니다.' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  PERFORM save_data.

FORM generate_dummy_data.
  DATA: lv_idx TYPE i.

  DO p_rows TIMES.
    lv_idx = sy-index.
    gs_upload-row_id = lv_idx.
    gs_upload-student_name = |학생_{ lv_idx }|.
    gs_upload-department = |D{ ( lv_idx MOD 10 ) }|.
    gs_upload-email = |student{ lv_idx }@school.com|.
    gs_upload-score = ( lv_idx MOD 101 ).
    APPEND gs_upload TO gt_upload.
  ENDDO.
ENDFORM.

FORM upload_from_excel.
  FIELD-SYMBOLS: <ls_upload> TYPE ty_upload.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = p_file
      i_begin_col             = 1
      i_begin_row             = 2
      i_end_col               = 5
      i_end_row               = 50000
    TABLES
      intern                  = gt_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

  IF sy-subrc <> 0.
    MESSAGE '엑셀 업로드에 실패했습니다. 파일 경로/형식을 확인하세요.' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  LOOP AT gt_excel INTO gs_excel.
    AT NEW row.
      CLEAR gs_upload.
    ENDAT.

    CASE gs_excel-col.
      WHEN 1. gs_upload-row_id       = gs_excel-value.
      WHEN 2. gs_upload-student_name = gs_excel-value.
      WHEN 3. gs_upload-department   = gs_excel-value.
      WHEN 4. gs_upload-email        = gs_excel-value.
      WHEN 5. gs_upload-score        = gs_excel-value.
    ENDCASE.

    AT END OF row.
      APPEND gs_upload TO gt_upload.
    ENDAT.
  ENDLOOP.

  LOOP AT gt_upload ASSIGNING <ls_upload>.
    IF <ls_upload>-row_id IS INITIAL.
      <ls_upload>-row_id = sy-tabix.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM save_data.
  DATA: lt_db TYPE STANDARD TABLE OF ztjhy_99_bulk,
        ls_db TYPE ztjhy_99_bulk.

  IF p_del = abap_true.
    DELETE FROM ztjhy_99_bulk.
    COMMIT WORK.
  ENDIF.

  LOOP AT gt_upload INTO gs_upload.
    CLEAR ls_db.
    ls_db-mandt = sy-mandt.
    ls_db-row_id = gs_upload-row_id.
    ls_db-student_name = gs_upload-student_name.
    ls_db-department = gs_upload-department.
    ls_db-email = gs_upload-email.
    ls_db-score = gs_upload-score.
    ls_db-erdat = sy-datum.
    ls_db-erzet = sy-uzeit.
    ls_db-ernam = sy-uname.
    APPEND ls_db TO lt_db.
  ENDLOOP.

  MODIFY ztjhy_99_bulk FROM TABLE lt_db.

  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE |{ lines( lt_db ) }건이 저장되었습니다.| TYPE 'S'.
  ELSE.
    ROLLBACK WORK.
    MESSAGE 'DB 저장 중 오류가 발생했습니다.' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
