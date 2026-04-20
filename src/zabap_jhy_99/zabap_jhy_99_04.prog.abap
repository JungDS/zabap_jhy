*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_04
*&---------------------------------------------------------------------*
*& ALV Tree 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_04.

DATA: go_tree TYPE REF TO cl_gui_alv_tree,
      gt_sflight TYPE STANDARD TABLE OF sflight,
      gs_hierarchy TYPE treev_hhdr.

START-OF-SELECTION.
  SELECT *
    FROM sflight
    INTO TABLE gt_sflight
    UP TO 100 ROWS.

  CREATE OBJECT go_tree
    EXPORTING
      parent = cl_gui_container=>default_screen.

  gs_hierarchy-heading = 'Flight Hierarchy'.
  gs_hierarchy-width = 40.

  go_tree->set_table_for_first_display(
    EXPORTING
      is_hierarchy_header = gs_hierarchy
    CHANGING
      it_outtab           = gt_sflight ).

  go_tree->frontend_update( ).
  cl_gui_cfw=>flush( ).

  WRITE: / 'ALV Tree가 생성되었습니다.' .
