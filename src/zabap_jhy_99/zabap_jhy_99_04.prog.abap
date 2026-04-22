*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_04
*&---------------------------------------------------------------------*
*& ALV Tree 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_04.

DATA: go_tree       TYPE REF TO cl_gui_alv_tree,
      gt_sflight    TYPE STANDARD TABLE OF sflight,
      gs_hierarchy  TYPE treev_hhdr.

START-OF-SELECTION.
  SELECT *
    FROM sflight
    INTO TABLE gt_sflight
    UP TO 100 ROWS.

  " [오류 분석/수정]
  " - 기존 코드는 데이터가 없을 때도 ALV Tree를 띄우려 하므로 학습 중 혼동 가능.
  " - 빈 데이터셋을 사전에 체크하여 메시지로 종료 처리.
  IF gt_sflight IS INITIAL.
    MESSAGE 'SFLIGHT 데이터가 없습니다.' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CREATE OBJECT go_tree
    EXPORTING
      parent = cl_gui_container=>default_screen
    EXCEPTIONS
      OTHERS = 1.

  IF sy-subrc <> 0.
    MESSAGE 'ALV Tree 컨트롤 생성 실패' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  gs_hierarchy-heading = 'Flight Hierarchy'.
  gs_hierarchy-width = 40.

  go_tree->set_table_for_first_display(
    EXPORTING
      is_hierarchy_header = gs_hierarchy
    CHANGING
      it_outtab           = gt_sflight ).

  cl_gui_cfw=>flush( ).
  WRITE: / 'ALV Tree가 생성되었습니다.' .
