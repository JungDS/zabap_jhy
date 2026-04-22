*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_02
*&---------------------------------------------------------------------*
*& Simple Tree 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_02.

DATA: go_tree  TYPE REF TO cl_gui_simple_tree,
      gt_nodes TYPE treev_ntab,
      gs_node  TYPE treev_node.

START-OF-SELECTION.
  " [오류 분석/수정]
  " - 기존 코드는 컨트롤 생성 실패 시 원인을 알기 어려웠음.
  " - 예외 처리 + 메시지를 추가해 학습 시 디버깅 포인트를 명확히 함.
  CREATE OBJECT go_tree
    EXPORTING
      parent              = cl_gui_container=>default_screen
      node_selection_mode = cl_gui_simple_tree=>node_sel_mode_single
    EXCEPTIONS
      OTHERS              = 1.

  IF sy-subrc <> 0.
    MESSAGE 'Simple Tree 컨트롤 생성 실패' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  PERFORM build_nodes.

  go_tree->add_nodes(
    EXPORTING
      table_structure_name = 'TREEV_NODE'
      node_table           = gt_nodes ).

  " [수정 이유]
  " - Control Framework 오류는 flush 시점에 발생하는 경우가 많아 명시적으로 호출.
  cl_gui_cfw=>flush( ).
  WRITE: / 'Simple Tree가 생성되었습니다.' .

FORM build_nodes.
  CLEAR gs_node.
  gs_node-node_key = 'ROOT'.
  gs_node-isfolder = abap_true.
  gs_node-text = '학생 기초예제'.
  APPEND gs_node TO gt_nodes.

  CLEAR gs_node.
  gs_node-node_key = 'N1'.
  gs_node-relatkey = 'ROOT'.
  gs_node-relatship = cl_gui_simple_tree=>relat_last_child.
  gs_node-text = 'ALV'.
  APPEND gs_node TO gt_nodes.

  CLEAR gs_node.
  gs_node-node_key = 'N2'.
  gs_node-relatkey = 'ROOT'.
  gs_node-relatship = cl_gui_simple_tree=>relat_last_child.
  gs_node-text = 'SmartForm'.
  APPEND gs_node TO gt_nodes.

  CLEAR gs_node.
  gs_node-node_key = 'N3'.
  gs_node-relatkey = 'ROOT'.
  gs_node-relatship = cl_gui_simple_tree=>relat_last_child.
  gs_node-text = 'E-Mail'.
  APPEND gs_node TO gt_nodes.
ENDFORM.
