*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_03
*&---------------------------------------------------------------------*
*& Column Tree 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_03.

DATA: go_tree  TYPE REF TO cl_gui_column_tree,
      gt_nodes TYPE treev_ntab,
      gs_node  TYPE treev_node.

START-OF-SELECTION.
  " [오류 분석]
  " - 기존 코드의 set_table_for_first_display( it_outtab = gt_items )는
  "   Column Tree API 사용 방식과 맞지 않아 컴파일/실행 오류 가능성이 큼.
  " [수정]
  " - 기본 동작이 안정적인 add_nodes 기반으로 단순화하여, 먼저 트리 구조 학습이 가능하도록 변경.
  CREATE OBJECT go_tree
    EXPORTING
      parent              = cl_gui_container=>default_screen
      node_selection_mode = cl_gui_column_tree=>node_sel_mode_single
    EXCEPTIONS
      OTHERS              = 1.

  IF sy-subrc <> 0.
    MESSAGE 'Column Tree 컨트롤 생성 실패' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  PERFORM build_nodes.

  go_tree->add_nodes(
    EXPORTING
      table_structure_name = 'TREEV_NODE'
      node_table           = gt_nodes ).

  cl_gui_cfw=>flush( ).
  WRITE: / 'Column Tree가 생성되었습니다.' .

FORM build_nodes.
  CLEAR gs_node.
  gs_node-node_key = 'ROOT'.
  gs_node-isfolder = abap_true.
  gs_node-text = '트리 학습 로드맵'.
  APPEND gs_node TO gt_nodes.

  CLEAR gs_node.
  gs_node-node_key = 'C1'.
  gs_node-relatkey = 'ROOT'.
  gs_node-relatship = cl_gui_simple_tree=>relat_last_child.
  gs_node-text = 'Simple Tree'.
  APPEND gs_node TO gt_nodes.

  CLEAR gs_node.
  gs_node-node_key = 'C2'.
  gs_node-relatkey = 'ROOT'.
  gs_node-relatship = cl_gui_simple_tree=>relat_last_child.
  gs_node-text = 'Column Tree'.
  APPEND gs_node TO gt_nodes.
ENDFORM.
