*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_09_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form SELECTED_DATA_RTN
*&---------------------------------------------------------------------*
FORM selected_data_rtn .

  REFRESH gt_sflight.
  REFRESH gt_display.
  REFRESH gt_display_del.

  PERFORM select_sflight.

  CHECK gv_error IS INITIAL.

  PERFORM make_display_data.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_SFLIGHT
*&---------------------------------------------------------------------*
FORM select_sflight.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE gt_sflight
    FROM sflight
   WHERE carrid IN so_carr.

  CHECK sy-subrc NE 0.

  " 검색된 데이터가 없습니다.
  MESSAGE s009 DISPLAY LIKE 'E'.
  gv_error = abap_on.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM make_display_data.

  LOOP AT gt_sflight INTO gs_sflight.

    CLEAR gs_display.
    MOVE-CORRESPONDING gs_sflight TO gs_display.

    PERFORM set_icon.
    PERFORM set_style.
    PERFORM set_color.

    APPEND gs_display TO gt_display.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ICON
*&---------------------------------------------------------------------*
FORM set_icon .

  " 이코노미 좌석이 만석이면 초록색 아니면 노란색
  IF gs_display-seatsmax EQ gs_display-seatsocc.
    gs_display-icon = icon_green_light.
  ELSE.
    gs_display-icon = icon_yellow_light.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_STYLE
*&---------------------------------------------------------------------*
FORM set_style .

  DATA lv_datum LIKE sy-datum.

  lv_datum = sy-datum + 10.

  REFRESH gt_style.

  " 10일 뒤의 비행일정만 항공기를 변경할 수 있다.
  IF gs_display-fldate GT lv_datum.
    CLEAR gs_style.

    gs_style-fieldname = 'PLANETYPE'.
    gs_style-style     = cl_gui_alv_grid=>mc_style_enabled.

    " gt_style 은 Sorted Table이므로, APPEND를 쓰면 안된다!!
    INSERT gs_style INTO TABLE gt_style.
  ELSE.
    " 그 외의 비행일정에 대한 항공기는 클릭해서 추가 정보를 볼 수 있도록 한다.
    CLEAR gs_style.

    gs_style-fieldname = 'PLANETYPE'.
    gs_style-style     = cl_gui_alv_grid=>mc_style_hotspot.

    " gt_style 은 Sorted Table이므로, APPEND를 쓰면 안된다!!
    INSERT gs_style INTO TABLE gt_style.
  ENDIF.

  gs_display-style[] = gt_style[].

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
FORM handle_toolbar
       USING po_object TYPE REF TO cl_alv_event_toolbar_set
             po_sender TYPE REF TO cl_gui_alv_grid.

* - BUTTON TYPE - BTYPE.
*  0 버튼(일반)
*  1 메뉴 및 기본 버튼
*  2 메뉴
*  3 분리자
*  4 라디오 버튼
*  5 체크박스
*  6 메뉴 엔트리

  CASE po_sender.
    WHEN go_grid.

      PERFORM add_button USING po_object:
      " BTYPE FUNC    ICON            INFO      TEXT      DISABLED
        '3'   space   space           space     space     abap_off, "분리자
        '0'   'TOTAL' icon_create     TEXT-bt1  TEXT-bt1  abap_off.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_BUTTON
*&---------------------------------------------------------------------*
FORM add_button
       USING po_object TYPE REF TO cl_alv_event_toolbar_set
             pv_btype
             pv_func
             pv_icon
             pv_info
             pv_text
             pv_disabled.

  DATA: ls_button TYPE stb_button,
        ls_btnmnu TYPE stb_btnmnu,

        lt_button TYPE ttb_button,
        lt_btnmnu TYPE ttb_btnmnu.

  CLEAR ls_button.
  ls_button-butn_type = pv_btype.
  ls_button-function  = pv_func.
  ls_button-icon      = pv_icon.
  ls_button-quickinfo = pv_info.
  ls_button-text      = pv_text.
  ls_button-disabled  = pv_disabled.

  APPEND ls_button TO po_object->mt_toolbar.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
FORM handle_user_command USING pv_ucomm   TYPE sy-ucomm
                               po_sender  TYPE REF TO cl_gui_alv_grid.

  REFRESH gt_rows.

*-- 선택한 행들 가져오기
*  CALL METHOD po_sender->get_selected_rows
*    IMPORTING
*      et_index_rows = gt_rows[].

  CASE po_sender.
    WHEN go_grid.
      CASE pv_ucomm.
          " Toolbar 이벤트에서 추가한 버튼의 Function을 적는다.
        WHEN 'TOTAL'.
          " 이 버튼을 눌렀을 때 어떻게 작동할 것인지 구현한다.
          MESSAGE '버튼을 눌렀습니다.' TYPE 'I'.
      ENDCASE.
    WHEN OTHERS.
  ENDCASE.


ENDFORM. " handle_USER_COMMAND
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED
*&---------------------------------------------------------------------*
FORM handle_data_changed
       USING po_data_changed  TYPE REF TO cl_alv_changed_data_protocol
             pv_onf4          TYPE char01
             pv_onf4_before   TYPE char01
             pv_onf4_after    TYPE char01
             pv_ucomm         TYPE sy-ucomm
             po_sender        TYPE REF TO cl_gui_alv_grid.


  DATA: lt_ins_rows  TYPE lvc_t_moce,
        lt_del_rows  TYPE lvc_t_moce,
        ls_row       TYPE lvc_s_moce,

        lt_mod_cells TYPE lvc_t_modi,
        ls_cell      TYPE lvc_s_modi.

  DATA lv_error.


  DEFINE _modify_cell.
    CALL METHOD po_data_changed->modify_cell
      EXPORTING
        i_row_id    = &1
        i_fieldname = &2
        i_value     = &3.
  END-OF-DEFINITION.

  DEFINE _get_cell_value.
    CALL METHOD po_data_changed->get_cell_value
      EXPORTING
        i_row_id    = &1
        i_fieldname = &2
      IMPORTING
        e_value     = &3.
  END-OF-DEFINITION.

  DEFINE _add_error.
    lv_error = abap_on.
    CALL METHOD po_data_changed->add_protocol_entry
      EXPORTING
        i_msgid     = 'ZABAP_JHY_MSG'   " Message ID
        i_msgty     = 'E'               " Message Type
        i_msgno     = '000'             " Message No.
        i_msgv1     = &1                " Message Variable1
*        i_msgv2     =                  " Message Variable2
*        i_msgv3     =                  " Message Variable3
*        i_msgv4     =                  " Message Variable4
        i_fieldname = ls_cell-fieldname " Field Name
        i_row_id    = ls_cell-row_id    " RowID
*        i_tabix     =                  " Table Index
      .
  END-OF-DEFINITION.




  lt_ins_rows   = po_data_changed->mt_inserted_rows.
  lt_del_rows   = po_data_changed->mt_deleted_rows.
  lt_mod_cells  = po_data_changed->mt_mod_cells.



* DATA_CHANGED 이벤트에서는 GT_DISPLAY 에서 값을 가져오거나, GT_DISPLAY 에 직접 값을 전달해서는 안된다.


  " 변경한 비행기의 이코노미, 비즈니스, 퍼스트의 최대좌석수를 가져온다.
  IF gt_saplane IS INITIAL.
    SELECT planetype
           seatsmax
           seatsmax_b
           seatsmax_f
      FROM saplane
      INTO TABLE gt_saplane.
  ENDIF.

  CASE po_sender.
    WHEN go_grid.

      " 항공기 변경에 따른 데이터 유효성 점검
      LOOP AT lt_mod_cells INTO ls_cell.

        CASE ls_cell-fieldname.
          WHEN 'PLANETYPE'.

            " 새로 입력한 항공기 정보를 가져온다.
            READ TABLE gt_saplane INTO gs_saplane
                                  WITH TABLE KEY planetype = ls_cell-value.

            IF sy-subrc EQ 0.

              " 수정한 비행일정의 이코노미, 비즈니스, 퍼스트의 예약좌석수를 가져온다.
              CLEAR gs_display.
              _get_cell_value ls_cell-row_id: 'SEATSOCC'    gs_display-seatsocc,
                                              'SEATSOCC_B'  gs_display-seatsocc_b,
                                              'SEATSOCC_F'  gs_display-seatsocc_f.

              " 변경한 비행기의 이코노미 좌석수와 비교한다.
              IF gs_saplane-seatsmax LT gs_display-seatsocc.
                _add_error '이코노미 좌석수가 부족합니다.'.
              ENDIF.

              " 변경한 비행기의 비즈니스 좌석수와 비교한다.
              IF gs_saplane-seatsmax_b LT gs_display-seatsocc_b.
                _add_error '비즈니스 좌석수가 부족합니다.'.
              ENDIF.

              " 변경한 비행기의 퍼스트 좌석수와 비교한다.
              IF gs_saplane-seatsmax_f LT gs_display-seatsocc_f.
                _add_error '퍼스트 좌석수가 부족합니다.'.
              ENDIF.

            ELSE.

              _add_error '비행기의 좌석수가 없습니다..'.

            ENDIF.

          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
    WHEN OTHERS.
  ENDCASE.


  " 변경된 데이터가 오류가 있으면 출력 아니면, 변경된 데이터 기준으로 관련 정보 업데이트
  IF lv_error EQ abap_on.

    CALL METHOD po_data_changed->display_protocol
      EXPORTING
        i_optimize_columns = abap_on. " Optimize Columns

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED_FINISHED
*&---------------------------------------------------------------------*
FORM handle_data_changed_finished
       USING p_modified     TYPE char01
             pt_good_cells  TYPE lvc_t_modi
             po_sender      TYPE REF TO cl_gui_alv_grid.

  CHECK p_modified EQ abap_on.

  LOOP AT pt_good_cells INTO DATA(ls_cell).
    IF ls_cell-fieldname EQ 'PLANETYPE'.

      CLEAR gs_saplane.
      READ TABLE gt_saplane INTO gs_saplane WITH TABLE KEY planetype = ls_cell-value.

*      READ TABLE gt_display INTO gs_display INDEX ls_cell-row_id.
*      gs_display-seatsmax   = gs_saplane-seatsmax.
*      gs_display-seatsmax_b = gs_saplane-seatsmax_b.
*      gs_display-seatsmax_f = gs_saplane-seatsmax_f.
*      MODIFY gt_display FROM gs_display INDEX ls_cell-row_id.

      READ TABLE gt_display ASSIGNING FIELD-SYMBOL(<fs_display>) INDEX ls_cell-row_id.
      <fs_display>-seatsmax   = gs_saplane-seatsmax.
      <fs_display>-seatsmax_b = gs_saplane-seatsmax_b.
      <fs_display>-seatsmax_f = gs_saplane-seatsmax_f.

    ENDIF.
  ENDLOOP.

  gs_stable-row = abap_on.  " 새로고침 행 고정
  gs_stable-col = abap_on.  " 새로고침 열 고정

  CALL METHOD po_sender->refresh_table_display
    EXPORTING
      is_stable = gs_stable.   " With Stable Rows/Columns

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
FORM handle_hotspot_click USING ps_row_id     TYPE lvc_s_row
                                ps_column_id  TYPE lvc_s_col
                                ps_row_no     TYPE lvc_s_roid
                                po_sender     TYPE REF TO cl_gui_alv_grid.

  CASE po_sender.
    WHEN go_grid.

      CASE ps_column_id-fieldname.
        WHEN 'CONNID'.

          READ TABLE gt_display INTO gs_display INDEX ps_row_no-row_id.
          CHECK sy-subrc EQ 0.


          SELECT SINGLE *
            FROM spfli
           WHERE carrid EQ gs_display-carrid
             AND connid EQ gs_display-connid.

          IF sy-subrc EQ 0.
            CALL SCREEN 0200.
          ELSE.
            MESSAGE '검색된 항공편 정보가 없습니다.' TYPE 'S' DISPLAY LIKE 'W'.
          ENDIF.

        WHEN 'PLANETYPE'.

          READ TABLE gt_display INTO gs_display INDEX ps_row_no-row_id.
          CHECK sy-subrc EQ 0.

          SELECT SINGLE *
            FROM saplane
           WHERE planetype EQ gs_display-planetype.

          IF sy-subrc EQ 0.
            CALL SCREEN 0101 STARTING AT 10  05
                               ENDING AT 75  18.
          ELSE.
            MESSAGE '검색된 항공기 정보가 없습니다.' TYPE 'S' DISPLAY LIKE 'W'.
          ENDIF.

      ENDCASE.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
FORM handle_double_click USING ps_row     TYPE lvc_s_row
                               ps_column  TYPE lvc_s_col
                               ps_row_no  TYPE lvc_s_roid
                               po_sender  TYPE REF TO cl_gui_alv_grid.

  CASE po_sender.
    WHEN go_grid.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_ON_F4
*&---------------------------------------------------------------------*
FORM handle_on_f4
       USING pv_fieldname   TYPE lvc_fname
             pv_fieldvalue  TYPE lvc_value
             ps_row_no      TYPE lvc_s_roid
             po_event_data  TYPE REF TO cl_alv_event_data
             pt_bad_cells   TYPE lvc_t_modi
             pv_display     TYPE char01
             po_sender      TYPE REF TO cl_gui_alv_grid.

  CASE po_sender.
    WHEN go_grid.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
FORM create_object_0100 .

*-- 1. Customer Container
  CREATE OBJECT go_container
    EXPORTING
      container_name = gc_container_name. "USER가 정의한 CONTAINER

  CREATE OBJECT go_grid
    EXPORTING
      i_parent = go_container.

*-- 2. Full Screen
*  CREATE OBJECT go_grid
*    EXPORTING
*      i_parent = cl_gui_container=>screen0.

*  cl_gui_container=>screen0 : Dummy for TOP Level 0 Screen Container


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT_0100
*&---------------------------------------------------------------------*
FORM set_alv_layout_0100.

  CLEAR gs_variant.
  gs_variant-report     = sy-repid.
  gv_save               = 'A'.

  CLEAR gs_layout.

  gs_layout-edit        = abap_off.
  gs_layout-zebra       = abap_on.

  CASE abap_on.
    WHEN ra_struc.
      gs_layout-cwidth_opt  = abap_on.
    WHEN ra_direc.
      gs_layout-cwidth_opt  = abap_off.
    WHEN ra_func.
      gs_layout-cwidth_opt  = abap_on.
  ENDCASE.

  gs_layout-sel_mode    = 'D'.     "A:복수행+Rowmark+셀단위 선택가능, B:단일행, C:복수행 , D:셀단위를 자유롭게 선택가능
  gs_layout-no_rowmark  = abap_off.

  gs_layout-no_rowins   = abap_on.  " 행 추가삭제 없음
  gs_layout-no_rowmove  = abap_on.  " 행 이동 없음
  gs_layout-no_toolbar  = abap_off.

  gs_layout-box_fname   = space.
  gs_layout-stylefname  = 'STYLE'.
  gs_layout-ctab_fname  = 'COLOR'.
  gs_layout-info_fname  = 'INFO'.

  " ALV Title
* gs_layout-grid_title  = text-t01.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_TOOLBAR_EXCLUDE_0100
*&---------------------------------------------------------------------*
FORM set_alv_toolbar_exclude_0100 .

  DATA: ls_exclude LIKE LINE OF gt_exclude.

  "-- DEFINE _SET_EX
  DEFINE _set_ex.
    ls_exclude = &1.
    APPEND ls_exclude TO gt_exclude.
  END-OF-DEFINITION.


  REFRESH: gt_exclude.

  _set_ex:
*   cl_gui_alv_grid=>mc_fc_find,
*   cl_gui_alv_grid=>mc_fc_sort_asc,
*   cl_gui_alv_grid=>mc_fc_sort_dsc,
*   cl_gui_alv_grid=>mc_mb_subtot,
*   cl_gui_alv_grid=>mc_mb_sum,

    cl_gui_alv_grid=>mc_fc_loc_copy_row,
*   cl_gui_alv_grid=>mc_fc_loc_append_row,
*   cl_gui_alv_grid=>mc_fc_loc_insert_row,
    cl_gui_alv_grid=>mc_fc_loc_move_row,
    cl_gui_alv_grid=>mc_fc_loc_delete_row,
    cl_gui_alv_grid=>mc_fc_loc_copy,
    cl_gui_alv_grid=>mc_fc_loc_cut,
    cl_gui_alv_grid=>mc_fc_loc_paste,
    cl_gui_alv_grid=>mc_fc_loc_paste_new_row,
*   cl_gui_alv_grid=>mc_fc_loc_undo,
*   cl_gui_alv_grid=>mc_fc_check,

*   cl_gui_alv_grid=>mc_fc_detail,
*   cl_gui_alv_grid=>mc_fc_filter,

    cl_gui_alv_grid=>mc_fc_graph,
    cl_gui_alv_grid=>mc_fc_html,
    cl_gui_alv_grid=>mc_fc_info,
*   cl_gui_alv_grid=>mc_fc_refresh,

*   cl_gui_alv_grid=>mc_fc_views,
*   cl_gui_alv_grid=>mc_fc_load_variant,
*   cl_gui_alv_grid=>mc_fc_print,
*   cl_gui_alv_grid=>mc_mb_variant,
*   cl_gui_alv_grid=>mc_mb_export,

    cl_gui_alv_grid=>mc_fc_view_crystal,
    cl_gui_alv_grid=>mc_fc_view_excel,
    cl_gui_alv_grid=>mc_fc_view_grid,
    cl_gui_alv_grid=>mc_fc_view_lotus,
    cl_gui_alv_grid=>mc_fc_expcrdata,
    cl_gui_alv_grid=>mc_fc_expcrdesig,
    cl_gui_alv_grid=>mc_fc_expcrtempl,
    cl_gui_alv_grid=>mc_fc_call_abc,
    cl_gui_alv_grid=>mc_fc_call_crbatch.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_SORT_0100
*&---------------------------------------------------------------------*
FORM set_alv_sort_0100 .

  REFRESH gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-group  = abap_on.
  gs_sort-subtot = abap_on.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-group  = abap_on.
  gs_sort-subtot = abap_on.
  APPEND gs_sort TO gt_sort.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT_0100
*&---------------------------------------------------------------------*
FORM set_alv_fieldcat_0100 .

  CASE abap_on.
    WHEN ra_struc.
      " 속성 변경이 필요한 일부 필드만 Field Catalog에 기록하는 방법
      PERFORM set_fieldcat_data.
    WHEN ra_direc.
      " 직접 Field Catalog를 만드는 방법
      PERFORM make_fieldcat_data.
    WHEN ra_func.
      " 함수로부터 구성된 Field Catalog를 가져와서 일부 속성을 변경하는 방법
      PERFORM get_fieldcat_data.
      PERFORM modify_fieldcat_data.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FIELDCAT_DATA
*&---------------------------------------------------------------------*
FORM set_fieldcat_data .

  REFRESH gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'ICON'.
  gs_fieldcat-coltext   = TEXT-f01. " 상태
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CONNID'.
  gs_fieldcat-hotspot   = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SEATSMAX'.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SEATSOCC'.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SEATSMAX_B'.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SEATSOCC_B'.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SEATSMAX_F'.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'SEATSOCC_F'.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FIELDCAT_DATA
*&---------------------------------------------------------------------*
FORM get_fieldcat_data .

  DATA: lt_fieldcat TYPE kkblo_t_fieldcat.

  REFRESH gt_fieldcat.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      i_callback_program     = sy-repid
*     i_tabname              = '' " 프로그램 내 data begin of ~ end of 로 만든 스트럭쳐 변수 등
      i_strucname            = 'ZSJHY_07_09' "ABAP DIC. 정의된 STRUCTURE
      i_bypassing_buffer     = abap_on
      i_inclname             = sy-repid
    CHANGING
      ct_fieldcat            = lt_fieldcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      OTHERS                 = 2.

  IF sy-subrc EQ 0.

    "-- Trasnfer LVC.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        it_fieldcat_kkblo = lt_fieldcat[]
      IMPORTING
        et_fieldcat_lvc   = gt_fieldcat[]
      EXCEPTIONS
        it_data_missing   = 1.
  ELSE.

    " Field Catalog 정보를 제대로 못가져 왔으므로,
    " 프로그램이 중단되도록 오류타입으로 메시지 출력
    MESSAGE 'Error Fieldcatalog merge!!' TYPE 'E'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_FIELDCAT_DATA
*&---------------------------------------------------------------------*
FORM modify_fieldcat_data .

  DATA: lv_text TYPE lvc_s_fcat-coltext.

  "--- Change Fieldcat.
  LOOP AT gt_fieldcat INTO gs_fieldcat.
    CLEAR: lv_text.

    "-- 공통으로 적용할 옵션
    gs_fieldcat-col_opt = abap_on.

    "-- 필드별로 적용할 옵션
    CASE gs_fieldcat-fieldname.
      WHEN 'CONNID'.
        gs_fieldcat-hotspot = abap_on.
      WHEN 'FLDATE'.
        lv_text = '텍스트를 직접 지정한 비행일자'.

      WHEN 'SEATSMAX'   OR 'SEATSOCC'   OR
           'SEATSMAX_B' OR 'SEATSOCC_B' OR
           'SEATSMAX_F' OR 'SEATSOCC_F'.
        gs_fieldcat-do_sum = abap_on.

      WHEN OTHERS.
*       GS_FIELDCAT-NO_OUT = ABAP_ON.
    ENDCASE.

    "--
    IF lv_text IS NOT INITIAL.
      gs_fieldcat-coltext = lv_text.
      gs_fieldcat-seltext = lv_text.
    ENDIF.

    MODIFY gt_fieldcat FROM gs_fieldcat.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fieldcat_data
*&---------------------------------------------------------------------*
FORM make_fieldcat_data.

  REFRESH gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 1.
  gs_fieldcat-fieldname = 'ICON'.
  gs_fieldcat-coltext   = TEXT-f01. " 상태
  gs_fieldcat-icon      = abap_on.
  gs_fieldcat-outputlen = 4.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 2.
  gs_fieldcat-fieldname = 'CARRID'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'CARRID'.           " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = '항공사 ID'(f02).   " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 3.
  gs_fieldcat-key       = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 3.
  gs_fieldcat-fieldname = 'CONNID'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'CONNID'.           " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = '항공편 번호'(f03). " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 4.
  gs_fieldcat-key       = abap_on.
  gs_fieldcat-hotspot   = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 4.
  gs_fieldcat-fieldname = 'FLDATE'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'FLDATE'.           " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = '비행일자'(f04).    " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 10.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 5.
  gs_fieldcat-fieldname = 'PRICE'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'PRICE'.            " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = '가격'(f05).        " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 10.
  gs_fieldcat-cfieldname = 'CURRENCY'.        " 금액은 통화코드 필드를 지정해야 한다.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 6.
  gs_fieldcat-fieldname = 'PAYMENTSUM'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'PAYMENTSUM'.       " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = '합계금액'(f06).    " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 12.
  gs_fieldcat-cfieldname = 'CURRENCY'.        " 금액은 통화코드 필드를 지정해야 한다.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 7.
  gs_fieldcat-fieldname = 'CURRENCY'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'CURRENCY'.         " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = '통화'(f07).        " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 5.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 8.
  gs_fieldcat-fieldname = 'PLANETYPE'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'PLANETYPE'.        " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = '항공기'(f08).      " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 10.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 9.
  gs_fieldcat-fieldname = 'SEATSMAX'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'SEATSMAX'.         " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = 'eco 좌석수'(f09).  " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 5.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 10.
  gs_fieldcat-fieldname = 'SEATSOCC'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'SEATSOCC'.         " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = 'eco 예약수'(f10).  " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 5.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 11.
  gs_fieldcat-fieldname = 'SEATSMAX_B'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'SEATSMAX_B'.       " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = 'biz 좌석수'(f11).  " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 5.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 12.
  gs_fieldcat-fieldname = 'SEATSOCC_B'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'SEATSOCC_B'.       " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = 'biz 예약수'(f12).  " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 5.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 13.
  gs_fieldcat-fieldname = 'SEATSMAX_F'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'SEATSMAX_F'.       " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = '1st 좌석수'(f13).  " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 5.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-col_pos   = 14.
  gs_fieldcat-fieldname = 'SEATSOCC_F'.
  gs_fieldcat-ref_table = 'ZSJHY_07_09'.
* gs_fieldcat-ref_field = 'SEATSOCC_F'.       " FIELDNAME과 동일하면
  gs_fieldcat-ref_field = space.              " 공백으로 대체 가능
  gs_fieldcat-coltext   = '1st 예약수'(f14).  " 명칭을 변경하고 싶으면
  gs_fieldcat-outputlen = 5.
  gs_fieldcat-do_sum    = abap_on.
  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REGIST_ALV_EVENT_0100
*&---------------------------------------------------------------------*
FORM regist_alv_event_0100 USING po_grid TYPE REF TO cl_gui_alv_grid.

  CHECK po_grid IS BOUND.

* REGISTER EVENT
  CALL METHOD po_grid->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified.
*
  CALL METHOD po_grid->set_ready_for_input
    EXPORTING
      i_ready_for_input = 1.

*-- GO_EVENT_RECEIVER
  IF go_event_receiver IS INITIAL.
    CREATE OBJECT go_event_receiver.
  ENDIF.

* Handler Event
  SET HANDLER:
    go_event_receiver->on_toolbar                 FOR ALL INSTANCES,
    go_event_receiver->on_user_command            FOR ALL INSTANCES,
    go_event_receiver->on_data_changed            FOR ALL INSTANCES,
    go_event_receiver->on_data_changed_finished   FOR ALL INSTANCES,
    go_event_receiver->on_hotspot_click           FOR ALL INSTANCES,
    go_event_receiver->on_double_click            FOR ALL INSTANCES,
    go_event_receiver->on_f4                      FOR ALL INSTANCES.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_GRID_0100
*&---------------------------------------------------------------------*
FORM display_alv_grid_0100 .

  " ALV 객체에 출력을 위한 데이터 설정

  DATA lv_structure_name TYPE dd02l-tabname.

  IF ra_struc EQ abap_on.
    lv_structure_name = 'ZSJHY_07_09'.
  ENDIF.

  CALL METHOD go_grid->set_table_for_first_display
    EXPORTING
      i_structure_name              = lv_structure_name " Internal Output Table Structure Name
      is_variant                    = gs_variant        " Layout
      i_save                        = gv_save           " Save Layout
      i_default                     = 'X'               " Default Display Variant
      is_layout                     = gs_layout         " Layout
      it_toolbar_excluding          = gt_exclude        " Excluded Toolbar Standard Functions
    CHANGING
      it_outtab                     = gt_display        " Output Table
      it_fieldcatalog               = gt_fieldcat       " Field Catalog
      it_sort                       = gt_sort           " Sort Criteria
    EXCEPTIONS
      invalid_parameter_combination = 1 " Wrong Parameter
      program_error                 = 2 " Program Errors
      too_many_lines                = 3 " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

*  go_grid->get_frontend_fieldcatalog(
**    IMPORTING
**      et_fieldcatalog =                  " Field Catalog
*  ).
*
*  GO_GRID->set_frontend_fieldcatalog( it_fieldcatalog =  ).
*
*  GO_GRID->refresh_table_display( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form REFRESH_GRID_0100
*&---------------------------------------------------------------------*
FORM refresh_grid_0100 USING po_grid TYPE REF TO cl_gui_alv_grid.

  CHECK po_grid IS BOUND.

  gs_stable-row = abap_on. "Row
  gs_stable-col = abap_on. "column

  CALL METHOD po_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = space.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECKED_SAVED_DATA
*&---------------------------------------------------------------------*
FORM checked_saved_data .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form POPUP_TO_CONFIRM
*&---------------------------------------------------------------------*
FORM popup_to_confirm.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar       = '팝업 제목'
      text_question  = '팝업 내용'
*     TEXT_BUTTON_1  = 'Ja'(001)
*     ICON_BUTTON_1  = ' '
*     TEXT_BUTTON_2  = 'Nein'(002)
*     ICON_BUTTON_2  = ' '
*     DEFAULT_BUTTON = '1'
*     DISPLAY_CANCEL_BUTTON = 'X'
*     START_COLUMN   = 25
*     START_ROW      = 6
    IMPORTING
      answer         = gv_answer
    EXCEPTIONS
      text_not_found = 1
      OTHERS         = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_DATA_RTN
*&---------------------------------------------------------------------*
FORM save_data_rtn .

  DATA: lv_message TYPE string.

  TRY.

      " ~~ INSERT or UPDATE or MODIFY 문법 ~~

      " 위 문법 중 하나를 사용한 뒤

      IF sy-subrc EQ 0.
        COMMIT WORK.

        " 메시지 클래스 or Text Symbol 사용!
        MESSAGE '성공적으로 저장하였습니다.' TYPE 'S'.
      ELSE.

        RAISE EXCEPTION TYPE cx_sy_open_sql_db
          EXPORTING
            sqlmsg = 'SY-SUBRC가 0이 아니므로, OpenSQL 문법이 정상적으로 처리되지 않음'.
      ENDIF.

    CATCH cx_sy_open_sql_db INTO DATA(lx_open_sql).
      ROLLBACK WORK.

      lv_message = lx_open_sql->get_text( ).
      MESSAGE lv_message TYPE 'S' DISPLAY LIKE 'E'.

  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_COLOR
*&---------------------------------------------------------------------*
FORM set_color .

  REFRESH gt_color.

  " 이코노미 잔여석이 20자리 이내라면 ( 단, 매진인 경우는 제외 )
  " 비지니스 잔여석이 10자리 이내라면 ( 단, 매진인 경우는 제외 )
  " 퍼스트   잔여석이  5자리 이내라면 ( 단, 매진인 경우는 제외 )
  " 해당 예약석만 연한 노란색 배경으로 색칠한다.

  " 이코노미 예약석 색상처리
  IF gs_display-seatsmax EQ gs_display-seatsocc.
    CLEAR gs_color.
    gs_color-fname = 'SEATSOCC'.
    gs_color-color-col = 5.
    gs_color-color-int = 0.
    gs_color-color-inv = 0.
    APPEND gs_color TO gt_color.

  ELSEIF gs_display-seatsmax - gs_display-seatsocc BETWEEN 1 AND 20.
    CLEAR gs_color.
    gs_color-fname = 'SEATSOCC'.
    gs_color-color-col = 3.
    gs_color-color-int = 0.
    gs_color-color-inv = 0.
    APPEND gs_color TO gt_color.

  ENDIF.

  " 비지니스 예약석 색상처리
  IF gs_display-seatsmax_b EQ gs_display-seatsocc_b.
    CLEAR gs_color.
    gs_color-fname = 'SEATSOCC_B'.
    gs_color-color-col = 5.
    gs_color-color-int = 0.
    gs_color-color-inv = 0.
    APPEND gs_color TO gt_color.

  ELSEIF gs_display-seatsmax_b - gs_display-seatsocc_b BETWEEN 1 AND 10.
    CLEAR gs_color.
    gs_color-fname = 'SEATSOCC_B'.
    gs_color-color-col = 3.
    gs_color-color-int = 0.
    gs_color-color-inv = 0.
    APPEND gs_color TO gt_color.
  ENDIF.

  " 퍼스트 예약석 색상처리
  IF gs_display-seatsmax_f EQ gs_display-seatsocc_f.
    CLEAR gs_color.
    gs_color-fname = 'SEATSOCC_F'.
    gs_color-color-col = 5.
    gs_color-color-int = 0.
    gs_color-color-inv = 0.
    APPEND gs_color TO gt_color.
  ELSEIF gs_display-seatsmax_f - gs_display-seatsocc_f BETWEEN 1 AND 5.
    CLEAR gs_color.
    gs_color-fname = 'SEATSOCC_F'.
    gs_color-color-col = 3.
    gs_color-color-int = 0.
    gs_color-color-inv = 0.
    APPEND gs_color TO gt_color.
  ENDIF.


  " 해당 라인의 색상정보를 GS_DISPLAY에 기록
  gs_display-color[] = gt_color[].


  " 비행일자가 이번 달인 라인은 연한 주황색
  IF gs_display-fldate(6) EQ sy-datum(6).
    gs_display-info = 'C700'.
  ENDIF.


ENDFORM.
