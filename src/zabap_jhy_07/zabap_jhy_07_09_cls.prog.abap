*&---------------------------------------------------------------------*
*& Include          ZABAP_JHY_07_09_CLS
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
* Class LCL_EVENT_RECEIVER Definition
*---------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION.

  PUBLIC SECTION.
    METHODS:
      on_toolbar                FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object
                  e_interactive
                  sender,

      on_user_command           FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm
                  sender,

      on_data_changed           FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed
                  e_onf4
                  e_onf4_before
                  e_onf4_after
                  e_ucomm
                  sender,

      on_data_changed_finished  FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified
                  et_good_cells
                  sender,

      on_hotspot_click          FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id
                  e_column_id
                  es_row_no
                  sender,

      on_double_click           FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row
                  e_column
                  es_row_no
                  sender,

      on_f4                     FOR EVENT onf4 OF cl_gui_alv_grid
        IMPORTING e_fieldname
                  e_fieldvalue
                  es_row_no
                  er_event_data
                  et_bad_cells
                  e_display
                  sender.

  PRIVATE SECTION.

ENDCLASS.

*---------------------------------------------------------------------*
* Class LCL_EVENT_RECEIVER Implementation                             *
*---------------------------------------------------------------------*
CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD on_toolbar.
    PERFORM handle_toolbar USING e_object
                                 sender.
  ENDMETHOD.
  METHOD on_user_command  .
    PERFORM handle_user_command USING e_ucomm
                                      sender.
  ENDMETHOD.
  METHOD on_data_changed.
    PERFORM handle_data_changed USING er_data_changed
                                      e_onf4
                                      e_onf4_before
                                      e_onf4_after
                                      e_ucomm
                                      sender.
  ENDMETHOD.
  METHOD on_data_changed_finished.
    PERFORM handle_data_changed_finished USING e_modified
                                               et_good_cells
                                               sender.
  ENDMETHOD.
  METHOD on_hotspot_click.
    PERFORM handle_hotspot_click USING e_row_id
                                       e_column_id
                                       es_row_no
                                       sender.
  ENDMETHOD.
  METHOD on_double_click.
    PERFORM handle_double_click USING e_row
                                      e_column
                                      es_row_no
                                      sender.

  ENDMETHOD.
  METHOD on_f4.
    PERFORM handle_on_f4 USING e_fieldname
                               e_fieldvalue
                               es_row_no
                               er_event_data
                               et_bad_cells
                               e_display
                               sender.
  ENDMETHOD.

ENDCLASS.
