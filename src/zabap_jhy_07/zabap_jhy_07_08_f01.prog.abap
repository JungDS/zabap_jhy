*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_07_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form INIT
*&---------------------------------------------------------------------*
FORM init .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_SCREEN_1000
*&---------------------------------------------------------------------*
FORM modify_screen_1000 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form USER_COMMAND_1000
*&---------------------------------------------------------------------*
FORM user_command_1000 .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
FORM select_data .

  CLEAR   gv_lines.
  REFRESH gt_carr.

  SELECT FROM scarr
         FIELDS *
         WHERE carrid   IN @s_carrid
           AND carrname IN @s_carrnm
           AND currcode IN @s_currcd
         INTO CORRESPONDING FIELDS OF TABLE @gt_carr.

  IF sy-subrc EQ 0.
    gv_lines = sy-dbcnt.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM make_display_data .


  SELECT FROM spfli FIELDS carrid, COUNT(*) AS count
         GROUP BY carrid
         INTO TABLE @DATA(lt_pfli_count).

  SORT lt_pfli_count BY carrid.

  REFRESH gt_display.

  LOOP AT gt_carr INTO gs_carr.

    CLEAR gs_display.
    MOVE-CORRESPONDING gs_carr TO gs_display.
    gs_display = CORRESPONDING #( gs_carr ).

    TRY.
        gs_display-count = lt_pfli_count[ carrid = gs_display-carrid ]-count.
      CATCH cx_sy_itab_line_not_found.
        gs_display-count = 0.
    ENDTRY.

    APPEND gs_display TO gt_display.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM display_data .

  IF gt_display[] IS INITIAL.
    " 데이터를 찾을 수 없습니다.
    MESSAGE s008 DISPLAY LIKE gc_msgty_warning.
  ELSE.
    " & 건의 데이터가 검색되었습니다.
    MESSAGE s006 WITH gv_lines.
    CALL SCREEN 0100.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT
*&---------------------------------------------------------------------*
FORM create_object .

  CREATE OBJECT go_container
    EXPORTING
      container_name = gc_custctrl_name " Name of the Screen CustCtrl Name to Link Container To
    EXCEPTIONS
      OTHERS         = 1.

  IF sy-subrc <> 0.
    MESSAGE ID      sy-msgid
            TYPE    sy-msgty
            NUMBER  sy-msgno
            WITH    sy-msgv1
                    sy-msgv2
                    sy-msgv3
                    sy-msgv4.
  ENDIF.

  CREATE OBJECT go_alv_grid
    EXPORTING
      i_parent = go_container " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

  IF sy-subrc <> 0.
    MESSAGE ID      sy-msgid
            TYPE    sy-msgty
            NUMBER  sy-msgno
            WITH    sy-msgv1
                    sy-msgv2
                    sy-msgv3
                    sy-msgv4.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT
*&---------------------------------------------------------------------*
FORM set_alv_layout .

  CLEAR gs_variant.
  CLEAR gs_layout.

  gs_variant-report  = sy-repid.
*  GS_VARIANT-handle  = ALV가 프로그램 안에 여러개 있을 때
  gv_save            = gc_variant_save_mode_all.

  gs_layout-sel_mode    = 'D'.
  gs_layout-cwidth_opt  = abap_on.
  gs_layout-zebra       = abap_on.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM set_alv_display_data .


  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
      i_structure_name              = 'SCARR'          " Internal Output Table Structure Name
      is_variant                    = gs_variant       " Layout
      i_save                        = gv_save          " Save Layout
      i_default                     = 'X'              " Default Display Variant
      is_layout                     = gs_layout        " Layout
    CHANGING
      it_outtab                     = gt_display       " Output Table
      it_fieldcatalog               = gt_fieldcat      " Field Catalog
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.

  IF sy-subrc <> 0.
    MESSAGE ID      sy-msgid
            TYPE    sy-msgty
            NUMBER  sy-msgno
            WITH    sy-msgv1
                    sy-msgv2
                    sy-msgv3
                    sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT
*&---------------------------------------------------------------------*
FORM set_alv_fieldcat .

  DATA ls_fieldcat LIKE LINE OF gt_fieldcat.

  REFRESH gt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CARRID'.
  ls_fieldcat-coltext   = '항공사ID'(f01).
  ls_fieldcat-just      = gc_text_align_center.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CARRNAME'.
  ls_fieldcat-coltext   = '항공사명'(f02).
  ls_fieldcat-emphasize = gc_color_green_light.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'CURRCODE'.
  ls_fieldcat-coltext   = '통화코드'(f03).
  ls_fieldcat-just      = gc_text_align_center.
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'URL'.
  ls_fieldcat-coltext   = '웹페이지'(f04).
  APPEND ls_fieldcat TO gt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'COUNT'.
  ls_fieldcat-col_pos   = 6.
  ls_fieldcat-no_zero   = abap_on.
  ls_fieldcat-emphasize = gc_color_yellow_light.
  ls_fieldcat-coltext   = '항공편 수'(f05).
  APPEND ls_fieldcat TO gt_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_double_click
*&---------------------------------------------------------------------*
FORM handle_double_click
    USING ps_row    TYPE lvc_s_row
          ps_column TYPE lvc_s_col
          po_sender TYPE REF TO cl_gui_alv_grid.

* 합계 라인 같은 ALV에서 만들어낸 데이터인지 점검한다.
* ROWTYPE 이 비어있다면, ALV에게 전달한 순수한 데이터(GT_DISPLAY) 라는 뜻
  CHECK ps_row-rowtype IS INITIAL.

  READ TABLE gt_display INTO gs_display INDEX ps_row-index.

* READ TABLE 문법이 정상적으로 실행되었는지 점검
* GT_DISPLAY에서 특정 행번호를 찾아서 GS_DISPLAY로 전달되었다
  CHECK sy-subrc EQ 0.

  data lt_index_rows type lvc_t_row.

  lt_index_rows = value #( ( ps_row ) ).

* 선택한 행 선택
  go_alv_grid->set_selected_rows( it_index_rows = lt_index_rows ).


  SELECT FROM spfli FIELDS *
         WHERE carrid EQ @gs_display-carrid
         INTO TABLE @gt_pfli.

  REFRESH gt_display_pfli.

  LOOP AT gt_pfli INTO DATA(ls_pfli).

    APPEND INITIAL LINE TO gt_display_pfli
           ASSIGNING FIELD-SYMBOL(<fs_display_pfli>).
    <fs_display_pfli> = CORRESPONDING #( ls_pfli ).

  ENDLOOP.

  IF go_docking_container IS INITIAL.
    PERFORM create_object_docking.
    PERFORM set_alv_layout_docking.
    PERFORM set_alv_fieldcat_docking.
    PERFORM set_alv_event_dockding.
    PERFORM set_alv_display_data_docking.

*   현재 화면 새로고침
    LEAVE SCREEN.
  ELSE.

*   옵션 재설정 : 제목, 열넓이 최적화
    go_alv_grid_pfli->get_frontend_layout( IMPORTING es_layout = gs_layout ).
    gs_layout-grid_title = gs_display-carrid && ' 항공사의 항공편 정보'(t02).
    gs_layout-cwidth_opt = abap_on.
    go_alv_grid_pfli->set_frontend_layout( EXPORTING is_layout = gs_layout ).

    go_alv_grid_pfli->refresh_table_display( ).

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_DOCKING
*&---------------------------------------------------------------------*
FORM create_object_docking .

  CREATE OBJECT go_docking_container
    EXPORTING
      repid     = sy-repid " Report to Which This Docking Control is Linked
      dynnr     = sy-dynnr " Screen to Which This Docking Control is Linked
      side      = cl_gui_docking_container=>dock_at_bottom " Side to Which Control is Docked
      extension = 200      " Control Extension
    EXCEPTIONS
      OTHERS    = 1.

  CREATE OBJECT go_alv_grid_pfli
    EXPORTING
      i_parent = go_docking_container " Parent Container
    EXCEPTIONS
      OTHERS   = 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_layout_docking
*&---------------------------------------------------------------------*
FORM set_alv_layout_docking .

  CLEAR gs_variant.
  CLEAR gs_layout.

  gs_variant-report = sy-repid.
  gs_variant-handle = 'DOCK'.   " 두번째 ALV를 구별하기 위한 명칭
  gv_save = 'A'.

  gs_layout-sel_mode = 'D'.
  gs_layout-cwidth_opt = abap_on.
  gs_layout-grid_title = gs_display-carrid && ' 항공사의 항공편 정보'(t02).
  gs_layout-zebra = abap_on.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_fieldcat_docking
*&---------------------------------------------------------------------*
FORM set_alv_fieldcat_docking .

  REFRESH gt_fieldcat_pfli.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_display_data_docking
*&---------------------------------------------------------------------*
FORM set_alv_display_data_docking .

  go_alv_grid_pfli->set_table_for_first_display(
    EXPORTING
      i_structure_name = 'SPFLI'          " Internal Output Table Structure Name
      is_variant       = gs_variant       " Layout
      i_save           = gv_save          " Save Layout
      i_default        = 'X'              " Default Display Variant
      is_layout        = gs_layout        " Layout
    CHANGING
      it_outtab        = gt_display_pfli  " Output Table
      it_fieldcatalog  = gt_fieldcat_pfli " Field Catalog
    EXCEPTIONS
      OTHERS           = 1
  ).

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_EVENT
*&---------------------------------------------------------------------*
FORM set_alv_event .

  IF go_event_handler IS INITIAL.
    go_event_handler = NEW #( ).
  ENDIF.

  SET HANDLER go_event_handler->on_double_click FOR go_alv_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_toolbar
*&---------------------------------------------------------------------*
FORM handle_toolbar USING po_object TYPE REF TO cl_alv_event_toolbar_set
                           po_sender TYPE REF TO cl_gui_alv_grid.

  CASE po_sender.

    WHEN go_alv_grid.

    WHEN go_alv_grid_pfli.

      DATA ls_button LIKE LINE OF po_object->mt_toolbar.

      ls_button = VALUE #( butn_type = 3 ).
      APPEND ls_button TO po_object->mt_toolbar.

      ls_button = VALUE #( function = gc_toolbar_button_fc_close
                           icon     = icon_close
                           text     = '닫기'(l01)
      ).
      APPEND ls_button TO po_object->mt_toolbar.

    WHEN OTHERS.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_user_command
*&---------------------------------------------------------------------*
FORM handle_user_command USING pv_ucomm LIKE sy-ucomm
                                po_sender TYPE REF TO cl_gui_alv_grid.

  CASE po_sender.

    WHEN go_alv_grid.
    WHEN go_alv_grid_pfli.

      CASE pv_ucomm.
        WHEN gc_toolbar_button_fc_close.
          PERFORM close_docking_container.
      ENDCASE.

    WHEN OTHERS.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CLOSE_DOCKING_CONTAINER
*&---------------------------------------------------------------------*
FORM close_docking_container .

* Container와 ALV를 없앨 때는 생성과정의 역순으로 진행한다.

  IF go_alv_grid_pfli IS NOT INITIAL.
    go_alv_grid_pfli->free( ).
  ENDIF.

  IF go_docking_container IS NOT INITIAL.
    go_docking_container->free( ).
  ENDIF.

  FREE go_alv_grid_pfli.
  FREE go_docking_container.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_event_dockding
*&---------------------------------------------------------------------*
FORM set_alv_event_dockding .

  IF go_event_handler IS INITIAL.
    go_event_handler = NEW #( ).
  ENDIF.

  SET HANDLER go_event_handler->on_toolbar FOR go_alv_grid_pfli.
  SET HANDLER go_event_handler->on_user_command FOR go_alv_grid_pfli.

ENDFORM.
