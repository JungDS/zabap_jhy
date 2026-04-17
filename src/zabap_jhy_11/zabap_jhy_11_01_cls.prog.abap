*&---------------------------------------------------------------------*
*& Include          ZTJHY_JHY_11_01_CLS
*&---------------------------------------------------------------------*

*--------------------------------------------------------------------*
* CLASS (Definition) LCL_EVENT_HANDLER
*--------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS:

*--------------------------------------------------------------------*
      on_data_changed
*--------------------------------------------------------------------*
        FOR EVENT data_changed
        OF cl_gui_alv_grid
        IMPORTING er_data_changed
                  sender,

*--------------------------------------------------------------------*
      on_close
*--------------------------------------------------------------------*
        FOR EVENT close
        OF cl_gui_dialogbox_container
        IMPORTING sender,

*--------------------------------------------------------------------*
      on_sapevent
*--------------------------------------------------------------------*
        FOR EVENT sapevent
        OF cl_gui_html_viewer
        IMPORTING action        " TYPE C
                  frame         " TYPE C
                  getdata       " TYPE C
                  postdata      " TYPE CNHT_POST_DATA_TAB
                  query_table   " TYPE CNHT_QUERY_TABLE
                  sender.

ENDCLASS.


*--------------------------------------------------------------------*
* CLASS (Implementation) LCL_EVENT_HANDLER
*--------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_data_changed.

    PERFORM handle_data_changed USING er_data_changed
                                      sender.

  ENDMETHOD.

  METHOD on_close.

    __free: go_html_popup,
            go_dialog.

  ENDMETHOD.

  METHOD on_sapevent.

    CASE action.
      WHEN 'POSTAL'.
        LOOP AT query_table INTO DATA(ls_query).
          CASE ls_query-name.
            WHEN 'zonecode'.
              ztjhy_shop-pstcd = condense( ls_query-value ).
            WHEN 'addr1'.
              ztjhy_shop-street = condense( ls_query-value ).
            WHEN 'addr2'.
              ztjhy_shop-building = condense( ls_query-value ).
          ENDCASE.
        ENDLOOP.

        CASE sender.
          WHEN go_html.
            perform show_html_0120.
          WHEN go_html_popup.
            lcl_event_handler=>on_close( go_dialog ).
        ENDCASE.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
