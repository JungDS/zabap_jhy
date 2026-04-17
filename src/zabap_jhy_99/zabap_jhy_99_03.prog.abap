*&---------------------------------------------------------------------*
*& Report ZABAP_JHY_99_03
*&---------------------------------------------------------------------*
*& [ Codex로 생성된 프로그램 ] Column Tree 예제
*&---------------------------------------------------------------------*
REPORT zabap_jhy_99_03.

DATA: go_tree    TYPE REF TO cl_gui_column_tree,
      gt_nodes   TYPE treev_ntab,
      gs_node    TYPE treev_node,
      gt_header  TYPE treev_hhdr,
      gs_header  TYPE treev_hhde,
      gt_items   TYPE STANDARD TABLE OF mtreeitm,
      gs_item    TYPE mtreeitm.

START-OF-SELECTION.
  CREATE OBJECT go_tree
    EXPORTING
      parent              = cl_gui_container=>default_screen
      node_selection_mode = cl_gui_column_tree=>node_sel_mode_single.

  PERFORM build_header.
  PERFORM build_nodes_items.

  go_tree->set_table_for_first_display(
    EXPORTING
      is_hierarchy_header = gs_header
    CHANGING
      it_outtab           = gt_items ).

  go_tree->add_nodes(
    EXPORTING
      table_structure_name = 'TREEV_NODE'
      node_table           = gt_nodes
      item_table           = gt_items ).

  cl_gui_cfw=>flush( ).
  WRITE: / '[ Codex로 생성된 프로그램 ] Column Tree가 생성되었습니다.' .

FORM build_header.
  gs_header-heading = '주제'.
  gs_header-width = 30.
  APPEND gs_header TO gt_header.
ENDFORM.

FORM build_nodes_items.
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

  CLEAR gs_item.
  gs_item-node_key = 'C1'.
  gs_item-item_name = '&Hierarchy'.
  gs_item-class = cl_gui_column_tree=>item_class_text.
  gs_item-alignment = cl_gui_column_tree=>align_auto.
  gs_item-text = '노드 중심'.
  APPEND gs_item TO gt_items.

  CLEAR gs_node.
  gs_node-node_key = 'C2'.
  gs_node-relatkey = 'ROOT'.
  gs_node-relatship = cl_gui_simple_tree=>relat_last_child.
  gs_node-text = 'Column Tree'.
  APPEND gs_node TO gt_nodes.

  CLEAR gs_item.
  gs_item-node_key = 'C2'.
  gs_item-item_name = '&Hierarchy'.
  gs_item-class = cl_gui_column_tree=>item_class_text.
  gs_item-alignment = cl_gui_column_tree=>align_auto.
  gs_item-text = '컬럼 추가'.
  APPEND gs_item TO gt_items.
ENDFORM.
