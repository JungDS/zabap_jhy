*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_02
*&---------------------------------------------------------------------*
*& [ Codex로 생성된 프로그램 ] Simple Tree 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_02.

DATA: go_tree  TYPE REF TO cl_gui_simple_tree,
      gt_nodes TYPE treev_ntab,
      gs_node  TYPE treev_node.

START-OF-SELECTION.
  CREATE OBJECT go_tree
    EXPORTING
      parent              = cl_gui_container=>default_screen
      node_selection_mode = cl_gui_simple_tree=>node_sel_mode_single.

  PERFORM build_nodes.

  go_tree->add_nodes(
    EXPORTING
      table_structure_name = 'TREEV_NODE'
      node_table           = gt_nodes ).

  cl_gui_cfw=>flush( ).
  WRITE: / '[ Codex로 생성된 프로그램 ] Simple Tree가 생성되었습니다.' .

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
